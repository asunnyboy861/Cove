import SwiftUI

extension ShapeStyle where Self == Color {
    static var coveTeal: Color { Color(red: 0.051, green: 0.580, blue: 0.533) }
    static var coveSuccess: Color { Color(red: 0.063, green: 0.725, blue: 0.506) }
    static var coveWarning: Color { Color(red: 0.961, green: 0.620, blue: 0.043) }
    static var coveDanger: Color { Color(red: 0.937, green: 0.267, blue: 0.267) }
    static var coveMuted: Color { Color(red: 0.420, green: 0.447, blue: 0.502) }
    static var coveBackground: Color { Color.adaptive(light: Color(red: 1, green: 1, blue: 1), dark: Color(red: 0.059, green: 0.059, blue: 0.059)) }
    static var coveSurface1: Color { Color.adaptive(light: Color(red: 0.976, green: 0.980, blue: 0.984), dark: Color(red: 0.102, green: 0.102, blue: 0.102)) }
    static var coveSurface2: Color { Color.adaptive(light: Color(red: 0.953, green: 0.957, blue: 0.965), dark: Color(red: 0.145, green: 0.145, blue: 0.145)) }
    static var coveSurface3: Color { Color.adaptive(light: Color(red: 0.898, green: 0.906, blue: 0.918), dark: Color(red: 0.188, green: 0.188, blue: 0.188)) }
    static var coveTextPrimary: Color { Color.adaptive(light: Color(red: 0.067, green: 0.094, blue: 0.153), dark: Color(red: 0.961, green: 0.961, blue: 0.961)) }
    static var coveTextSecondary: Color { Color.adaptive(light: Color(red: 0.420, green: 0.447, blue: 0.502), dark: Color(red: 0.612, green: 0.639, blue: 0.686)) }
}

extension Color {
    static func adaptive(light: Color, dark: Color) -> Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
    }
}
