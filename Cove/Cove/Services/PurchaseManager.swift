import SwiftUI
import StoreKit

@Observable
final class PurchaseManager {
    var products: [Product] = []
    var purchasedProductIDs: Set<String> = []
    var isPlusSubscriber: Bool = false
    var isProSubscriber: Bool = false

    private let productIDs = [
        "com.zzoutuo.Cove.plus.monthly",
        "com.zzoutuo.Cove.plus.yearly",
        "com.zzoutuo.Cove.pro.monthly",
        "com.zzoutuo.Cove.pro.yearly"
    ]

    init() {
        Task { await loadProducts() }
    }

    func loadProducts() async {
        do {
            products = try await Product.products(for: productIDs)
            await updatePurchaseStatus()
        } catch {
            print("Failed to load products: \(error)")
        }
    }

    func purchase(_ product: Product) async -> Bool {
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    await updatePurchaseStatus()
                    await transaction.finish()
                    return true
                case .unverified:
                    return false
                }
            case .pending, .userCancelled:
                return false
            @unknown default:
                return false
            }
        } catch {
            print("Purchase failed: \(error)")
            return false
        }
    }

    func restorePurchases() async {
        try? await AppStore.sync()
        await updatePurchaseStatus()
    }

    private func updatePurchaseStatus() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                purchasedProductIDs.insert(transaction.productID)
            }
        }
        isPlusSubscriber = purchasedProductIDs.contains { $0.contains("plus") }
        isProSubscriber = purchasedProductIDs.contains { $0.contains("pro") }
    }
}
