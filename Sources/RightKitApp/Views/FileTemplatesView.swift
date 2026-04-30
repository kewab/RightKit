import SwiftUI

struct FileTemplatesView: View {
    @ObservedObject var viewModel: AppViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 26) {
                HeaderView(
                    icon: "doc.badge.plus",
                    accent: Color(red: 0.40, green: 0.84, blue: 0.95),
                    title: viewModel.strings.templatesTab,
                    subtitle: viewModel.strings.templatesSubtitle
                )

                AppPanel {
                    VStack(spacing: 0) {
                        headerRow

                        Divider().overlay(Color.white.opacity(0.08))

                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.fileTemplates) { template in
                                FileTemplateRow(
                                    template: template,
                                    strings: viewModel.strings,
                                    isEnabled: viewModel.isTemplateEnabled(template),
                                    onToggle: { isEnabled in
                                        viewModel.setTemplateEnabled(isEnabled, for: template)
                                    }
                                )

                                Divider().overlay(Color.white.opacity(0.05))
                            }
                        }
                    }
                }

                HStack(spacing: 12) {
                    Button(viewModel.strings.addTemplateFile) {}
                        .buttonStyle(AppCapsuleButtonStyle())
                        .disabled(true)

                    roundedSymbolButton("minus")
                        .disabled(true)

                    roundedSymbolButton("questionmark")
                        .disabled(true)

                    Spacer()

                    Button(viewModel.strings.finderMenuTroubleshooting) {}
                        .buttonStyle(.plain)
                        .foregroundStyle(Color(red: 0.15, green: 0.54, blue: 0.98))

                    Button(viewModel.strings.resetDefaults) {
                        viewModel.resetTemplates()
                    }
                    .buttonStyle(AppCapsuleButtonStyle())
                }

                HStack(spacing: 120) {
                    Toggle(isOn: Binding(
                        get: { viewModel.showMenuIcons },
                        set: { viewModel.setShowMenuIcons($0) }
                    )) {
                        Text(viewModel.strings.showIcons)
                    }
                    .toggleStyle(.checkbox)
                    .foregroundStyle(.white.opacity(0.92))

                    Toggle(isOn: Binding(
                        get: { viewModel.openNewFileAfterCreate },
                        set: { viewModel.setOpenNewFileAfterCreate($0) }
                    )) {
                        Text(viewModel.strings.openFileAfterCreate)
                    }
                    .toggleStyle(.checkbox)
                    .foregroundStyle(.white.opacity(0.92))

                    Toggle(isOn: Binding(
                        get: { viewModel.playSoundAfterCreate },
                        set: { viewModel.setPlaySoundAfterCreate($0) }
                    )) {
                        Text(viewModel.strings.playPromptSound)
                    }
                    .toggleStyle(.checkbox)
                    .foregroundStyle(.white.opacity(0.92))
                }

                HStack {
                    Spacer()
                    Text(viewModel.statusMessage)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.white.opacity(0.58))
                }
            }
            .padding(.horizontal, 36)
            .padding(.vertical, 34)
        }
    }

    private var headerRow: some View {
        HStack(spacing: 0) {
            headerCell(viewModel.strings.enabledColumnTitle, width: 120)
            headerCell(viewModel.strings.iconColumnTitle, width: 112)
            headerCell(viewModel.strings.displayNameColumnTitle, width: 1, alignment: .leading)
            headerCell(viewModel.strings.suffixColumnTitle, width: 140)
            headerCell(viewModel.strings.mainMenuColumnTitle, width: 140)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(Color.white.opacity(0.03))
    }

    private func headerCell(_ title: String, width: CGFloat, alignment: Alignment = .center) -> some View {
        Text(title)
            .font(.system(size: 16, weight: .bold))
            .foregroundStyle(.white.opacity(0.94))
            .frame(maxWidth: width == 1 ? .infinity : width, alignment: alignment)
    }

    private func roundedSymbolButton(_ symbol: String) -> some View {
        Button {} label: {
            Image(systemName: symbol)
                .font(.system(size: 17, weight: .bold))
                .frame(width: 44, height: 44)
        }
        .buttonStyle(AppSmallSquareButtonStyle())
    }
}

private struct FileTemplateRow: View {
    let template: NewFileTemplate
    let strings: RightKitStrings
    let isEnabled: Bool
    let onToggle: (Bool) -> Void

    var body: some View {
        HStack(spacing: 0) {
            Toggle("", isOn: Binding(
                get: { isEnabled },
                set: onToggle
            ))
            .toggleStyle(.checkbox)
            .labelsHidden()
            .frame(width: 120)

            Image(nsImage: RightKitIconProvider.templateIcon(for: template, size: 32))
                .resizable()
                .interpolation(.high)
                .frame(width: 32, height: 32)
                .frame(width: 112)

            Text(strings.templateTitle(for: template))
                .font(.system(size: 19, weight: .semibold))
                .foregroundStyle(.white.opacity(0.86))
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(template.fileExtension)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.72))
                .frame(width: 140)

            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.white.opacity(0.07))
                .frame(width: 34, height: 34)
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color.white.opacity(0.04), lineWidth: 1)
                )
                .frame(width: 140)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
    }
}
