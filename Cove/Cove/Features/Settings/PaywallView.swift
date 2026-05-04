import SwiftUI
import StoreKit

struct PaywallView: View {
    @State private var purchaseManager = PurchaseManager()
    @State private var selectedTier: SubscriptionTier = .plus

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                header
                tierPicker
                featuresList
                subscribeButton
                terms
            }
            .padding(20)
        }
        .background(Color.coveBackground)
        .navigationTitle("Cove Premium")
        .tint(.coveTeal)
    }

    private var header: some View {
        VStack(spacing: 12) {
            Image(systemName: "crown.fill")
                .font(.system(size: 48))
                .foregroundStyle(Color.coveWarning.gradient)

            Text("Unlock Cove Premium")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.coveTextPrimary)

            Text("More features, more privacy, more freedom")
                .font(.subheadline)
                .foregroundStyle(.coveTextSecondary)
        }
    }

    private var tierPicker: some View {
        HStack(spacing: 12) {
            TierCard(tier: .plus, isSelected: selectedTier == .plus) {
                selectedTier = .plus
            }
            TierCard(tier: .pro, isSelected: selectedTier == .pro) {
                selectedTier = .pro
            }
        }
    }

    private var featuresList: some View {
        VStack(alignment: .leading, spacing: 12) {
            let features = selectedTier == .plus ? plusFeatures : proFeatures
            ForEach(features, id: \.self) { feature in
                HStack(spacing: 10) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.coveTeal)
                    Text(feature)
                        .font(.subheadline)
                        .foregroundStyle(.coveTextPrimary)
                }
            }
        }
        .padding(16)
        .background(Color.coveSurface1)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var subscribeButton: some View {
        VStack(spacing: 8) {
            Button {
                Task {
                    if let product = purchaseManager.products.first(where: { $0.id.contains(selectedTier == .plus ? "plus" : "pro") && $0.id.contains("yearly") }) {
                        _ = await purchaseManager.purchase(product)
                    }
                }
            } label: {
                Text("Subscribe to Cove \(selectedTier == .plus ? "Plus" : "Pro")")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.coveTeal)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Button {
                Task { await purchaseManager.restorePurchases() }
            } label: {
                Text("Restore Purchases")
                    .font(.caption)
                    .foregroundStyle(.coveTeal)
            }
        }
    }

    private var terms: some View {
        VStack(spacing: 4) {
            Text("7-day free trial, then \(selectedTier == .plus ? "$34.99" : "$69.99")/year")
                .font(.caption)
                .foregroundStyle(.coveTextSecondary)
            Text("Cancel anytime in Settings > Subscriptions")
                .font(.caption2)
                .foregroundStyle(.coveTextSecondary)
        }
    }
}

enum SubscriptionTier {
    case plus
    case pro
}

struct TierCard: View {
    let tier: SubscriptionTier
    let isSelected: Bool
    let action: () -> Void

    private var plusFeatures: [String] {
        ["Voice rooms (25 users)", "100 communities", "25GB storage", "Screen sharing", "HD video (720p)", "Custom emoji & stickers"]
    }
    private var proFeatures: [String] {
        ["Unlimited voice rooms", "Unlimited communities", "100GB storage", "4K video calls", "AI noise cancellation", "Real-time translation"]
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(tier == .plus ? "Plus" : "Pro")
                    .font(.headline)
                    .foregroundStyle(isSelected ? .coveTeal : .coveTextSecondary)

                Text(tier == .plus ? "$3.99" : "$7.99")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.coveTextPrimary)

                Text("/month")
                    .font(.caption)
                    .foregroundStyle(.coveTextSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(isSelected ? Color.coveTeal.opacity(0.1) : Color.coveSurface1)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.coveTeal : Color.clear, lineWidth: 2)
            }
        }
    }
}

private let plusFeatures = [
    "Voice rooms (up to 25 users)",
    "Join up to 100 communities",
    "25GB file upload storage",
    "Screen sharing",
    "HD video calls (720p)",
    "Custom emoji & stickers",
    "Voice message transcription",
    "Priority support"
]

private let proFeatures = [
    "Unlimited voice room users",
    "Unlimited communities",
    "100GB file upload storage",
    "4K video calls",
    "Server banner & themes",
    "Voice room recording",
    "AI noise cancellation",
    "Real-time message translation",
    "Early access to new features"
]
