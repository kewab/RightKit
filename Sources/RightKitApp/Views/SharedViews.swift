import SwiftUI

enum AppTheme {
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.74)
    static let tertiaryText = Color.white.opacity(0.52)
    static let accent = Color(red: 0.24, green: 0.62, blue: 1.0)

    static let windowTop = Color(red: 0.125, green: 0.125, blue: 0.14)
    static let windowBottom = Color(red: 0.095, green: 0.095, blue: 0.11)

    static let sidebarPanelFill = Color(red: 0.16, green: 0.16, blue: 0.18).opacity(0.94)
    static let sidebarPanelBorder = Color.white.opacity(0.10)
    static let searchFieldFill = Color.white.opacity(0.07)
    static let searchFieldBorder = Color.white.opacity(0.10)

    static let detailPanelFill = Color(red: 0.18, green: 0.18, blue: 0.20).opacity(0.96)
    static let detailPanelBorder = Color.white.opacity(0.10)

    static let groupFill = Color.white.opacity(0.05)
    static let groupStroke = Color.white.opacity(0.08)
    static let rowHover = Color.white.opacity(0.06)
    static let rowPressed = Color.white.opacity(0.09)
    static let divider = Color.white.opacity(0.08)
    static let selectedFill = Color.white.opacity(0.10)
}

enum SidebarIconStyle {
    case general
    case newFile
    case favorites

    var symbol: String {
        switch self {
        case .general:
            "gearshape.2.fill"
        case .newFile:
            "document.badge.plus.fill"
        case .favorites:
            "folder.fill.badge.star"
        }
    }

    var gradient: [Color] {
        switch self {
        case .general:
            [Color(red: 0.71, green: 0.73, blue: 0.78), Color(red: 0.55, green: 0.58, blue: 0.63)]
        case .newFile:
            [Color(red: 0.31, green: 0.72, blue: 1.0), Color(red: 0.13, green: 0.50, blue: 0.95)]
        case .favorites:
            [Color(red: 0.42, green: 0.80, blue: 1.0), Color(red: 0.20, green: 0.61, blue: 1.0)]
        }
    }
}

struct SidebarIcon: View {
    let style: SidebarIconStyle

    var body: some View {
        RoundedRectangle(cornerRadius: 9, style: .continuous)
            .fill(
                LinearGradient(
                    colors: style.gradient,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay {
                Image(systemName: style.symbol)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .stroke(Color.white.opacity(0.18), lineWidth: 1)
            }
            .frame(width: 28, height: 28)
    }
}

struct AppWindowBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [AppTheme.windowTop, AppTheme.windowBottom],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Circle()
                .fill(Color(red: 0.19, green: 0.26, blue: 0.42).opacity(0.34))
                .blur(radius: 140)
                .frame(width: 520, height: 520)
                .offset(x: 360, y: -280)

            Circle()
                .fill(Color(red: 0.18, green: 0.20, blue: 0.28).opacity(0.26))
                .blur(radius: 120)
                .frame(width: 460, height: 460)
                .offset(x: -360, y: 320)
        }
    }
}

struct SettingsPage<Content: View>: View {
    let title: String
    let subtitle: String
    let iconStyle: SidebarIconStyle
    let content: Content

    init(
        title: String,
        subtitle: String,
        iconStyle: SidebarIconStyle,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.iconStyle = iconStyle
        self.content = content()
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                HStack(alignment: .top, spacing: 12) {
                    SidebarIcon(style: iconStyle)
                        .frame(width: 34, height: 34)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.system(size: 34, weight: .bold))
                            .foregroundStyle(AppTheme.primaryText)
                        Text(subtitle)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(AppTheme.secondaryText)
                    }
                    Spacer()
                }
                .padding(.bottom, 6)

                content
            }
            .padding(22)
        }
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(AppTheme.detailPanelFill)
                .overlay {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(AppTheme.detailPanelBorder, lineWidth: 1)
                }
        )
    }
}

struct SettingsGroup<Content: View>: View {
    let title: String?
    let content: Content

    init(
        title: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let title {
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(AppTheme.tertiaryText)
                    .textCase(.uppercase)
                    .tracking(0.7)
            }

            VStack(spacing: 0) {
                content
            }
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(AppTheme.groupFill)
                    .overlay {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(AppTheme.groupStroke, lineWidth: 1)
                    }
            )
        }
    }
}

struct SettingsDivider: View {
    var body: some View {
        Rectangle()
            .fill(AppTheme.divider)
            .frame(height: 1)
    }
}

struct SettingsEmptyState: View {
    let title: String
    let subtitle: String
    let systemImage: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: systemImage)
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(AppTheme.tertiaryText)
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(AppTheme.primaryText)
            Text(subtitle)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(AppTheme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 36)
    }
}

struct AppCapsuleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(AppTheme.primaryText)
            .padding(.horizontal, 16)
            .frame(height: 34)
            .background(
                RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .fill(configuration.isPressed ? AppTheme.rowPressed : AppTheme.rowHover)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .stroke(AppTheme.groupStroke, lineWidth: 1)
            }
    }
}

struct AppSmallSquareButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(AppTheme.primaryText)
            .frame(width: 32, height: 32)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(configuration.isPressed ? AppTheme.rowPressed : AppTheme.rowHover)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(AppTheme.groupStroke, lineWidth: 1)
            }
    }
}
