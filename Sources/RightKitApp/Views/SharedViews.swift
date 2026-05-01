import AppKit
import SwiftUI

enum AppTheme {
    static let background = Color(red: 245 / 255, green: 245 / 255, blue: 247 / 255)
    static let panelFill = Color.white.opacity(0.72)
    static let sidebarFill = Color.white.opacity(0.58)
    static let primaryText = Color(nsColor: .labelColor)
    static let secondaryText = Color(nsColor: .secondaryLabelColor)
    static let tertiaryText = Color(nsColor: .tertiaryLabelColor)
    static let accent = Color(red: 0 / 255, green: 122 / 255, blue: 255 / 255)
    static let divider = Color.black.opacity(0.08)
    static let subtleDivider = Color.black.opacity(0.05)
    static let shadow = Color.black.opacity(0.08)
    static let hoverFill = Color.black.opacity(0.035)
    static let selectedFill = accent.opacity(0.12)
    static let selectedStroke = accent.opacity(0.22)
}

struct AppFloatingToolbar: View {
    let title: String
    let subtitle: String
    let language: String
    let status: String

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(AppTheme.primaryText)

                Text(subtitle)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(AppTheme.secondaryText)
                    .lineLimit(2)
            }

            Spacer(minLength: 16)

            HStack(spacing: 8) {
                AppToolbarBadge(systemImage: "globe", text: language)
                AppToolbarBadge(systemImage: "checkmark.circle.fill", text: status, tint: AppTheme.accent)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(AppTheme.panelFill)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        )
        .overlay {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(AppTheme.divider, lineWidth: 1)
        }
        .shadow(color: AppTheme.shadow, radius: 18, y: 10)
    }
}

struct AppToolbarBadge: View {
    let systemImage: String
    let text: String
    var tint: Color = AppTheme.primaryText

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(tint)

            Text(text)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(AppTheme.primaryText)
                .lineLimit(1)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule(style: .continuous)
                .fill(Color.white.opacity(0.88))
        )
        .overlay {
            Capsule(style: .continuous)
                .stroke(AppTheme.divider, lineWidth: 1)
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 12) {
            Text(label)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(AppTheme.secondaryText)

            Spacer()

            Text(value)
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(AppTheme.primaryText)
        }
        .padding(.vertical, 10)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(AppTheme.subtleDivider)
                .frame(height: 1)
        }
    }
}

struct AppPanel<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(AppTheme.panelFill)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            )
            .overlay {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(AppTheme.divider, lineWidth: 1)
            }
            .shadow(color: AppTheme.shadow, radius: 16, y: 8)
    }
}

struct AppSectionTitle: View {
    let title: String
    let systemImage: String
    let accent: Color

    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(accent.opacity(0.12))
                Image(systemName: systemImage)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(accent)
            }
            .frame(width: 28, height: 28)

            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(AppTheme.primaryText)
        }
    }
}
