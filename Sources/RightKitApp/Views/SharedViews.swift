import SwiftUI

struct HeaderView: View {
    let icon: String?
    let accent: Color
    let title: String
    let subtitle: String

    init(
        icon: String? = nil,
        accent: Color = Color(red: 0.97, green: 0.36, blue: 0.45),
        title: String,
        subtitle: String
    ) {
        self.icon = icon
        self.accent = accent
        self.title = title
        self.subtitle = subtitle
    }

    var body: some View {
        HStack(alignment: .top, spacing: 18) {
            if let icon {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [accent, accent.opacity(0.72)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                }
                .frame(width: 40, height: 40)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 38, weight: .bold))
                    .foregroundStyle(.white.opacity(0.95))
                Text(subtitle)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(.white.opacity(0.62))
            }
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.white.opacity(0.62))
            Spacer()
            Text(value)
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(.white.opacity(0.9))
        }
        .padding(.vertical, 8)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.white.opacity(0.08))
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
            .padding(26)
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(Color.black.opacity(0.20))
            )
            .overlay {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(Color.white.opacity(0.05), lineWidth: 1)
            }
    }
}

struct AppSectionTitle: View {
    let title: String
    let systemImage: String
    let accent: Color

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 11, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [accent, accent.opacity(0.74)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                Image(systemName: systemImage)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
            }
            .frame(width: 38, height: 38)

            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white.opacity(0.94))
        }
    }
}
