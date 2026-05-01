import SwiftUI

struct FileTemplatesView: View {
    @ObservedObject var viewModel: AppViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AppSectionTitle(
                    title: viewModel.strings.templatesTitle,
                    systemImage: "doc.badge.plus",
                    accent: AppTheme.accent
                )

                AppPanel {
                    VStack(spacing: 0) {
                        headerRow

                        Divider().overlay(AppTheme.divider)

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

                                Divider().overlay(AppTheme.subtleDivider)
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
                        .foregroundStyle(AppTheme.accent)

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
                    .foregroundStyle(AppTheme.primaryText)

                    Toggle(isOn: Binding(
                        get: { viewModel.openNewFileAfterCreate },
                        set: { viewModel.setOpenNewFileAfterCreate($0) }
                    )) {
                        Text(viewModel.strings.openFileAfterCreate)
                    }
                    .toggleStyle(.checkbox)
                    .foregroundStyle(AppTheme.primaryText)

                    Toggle(isOn: Binding(
                        get: { viewModel.playSoundAfterCreate },
                        set: { viewModel.setPlaySoundAfterCreate($0) }
                    )) {
                        Text(viewModel.strings.playPromptSound)
                    }
                    .toggleStyle(.checkbox)
                    .foregroundStyle(AppTheme.primaryText)
                }

                HStack {
                    Spacer()
                    Text(viewModel.statusMessage)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(AppTheme.secondaryText)
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 12)
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
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.45))
    }

    private func headerCell(_ title: String, width: CGFloat, alignment: Alignment = .center) -> some View {
        Text(title)
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(AppTheme.secondaryText)
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
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(AppTheme.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(template.fileExtension)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(AppTheme.secondaryText)
                .frame(width: 140)

            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(isEnabled ? AppTheme.accent.opacity(0.12) : Color.black.opacity(0.03))
                .frame(width: 30, height: 30)
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(isEnabled ? AppTheme.accent.opacity(0.18) : AppTheme.divider, lineWidth: 1)
                )
                .overlay {
                    if isEnabled {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(AppTheme.accent)
                    }
                }
                .frame(width: 140)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}
