import SwiftUI

extension View {
    func coveCard() -> some View {
        self
            .padding(16)
            .background(Color.coveSurface1)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    func coveInput() -> some View {
        self
            .padding(12)
            .background(Color.coveSurface2)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    func coveButton(style: CoveButtonStyle = .primary) -> some View {
        self.buttonStyle(CoveButtonStyleWrapper(style: style))
    }

    func iPadMaxWidth() -> some View {
        self.frame(maxWidth: 720).frame(maxWidth: .infinity)
    }
}

enum CoveButtonStyle {
    case primary
    case secondary
    case destructive
}

struct CoveButtonStyleWrapper: ButtonStyle {
    let style: CoveButtonStyle

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(style == .primary ? .white : .primary)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }

    @ViewBuilder
    private var background: some View {
        switch style {
        case .primary:
            Color.coveTeal
        case .secondary:
            Color.coveSurface2
        case .destructive:
            Color.coveDanger
        }
    }
}
