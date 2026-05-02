import SwiftUI

struct FileTemplatesView: View {
    @ObservedObject var viewModel: AppViewModel

    var body: some View {
        SettingsPage(
            title: viewModel.strings.templatesTitle,
            subtitle: viewModel.strings.templatesSubtitle,
            iconStyle: .newFile
        ) {
            SettingsGroup(title: viewModel.strings.templatesTab) {
                ForEach(Array(viewModel.fileTemplates.enumerated()), id: \.element.id) { index, template in
                    TemplateRow(
                        template: template,
                        strings: viewModel.strings,
                        isEnabled: viewModel.isTemplateEnabled(template),
                        onToggle: { isEnabled in
                            viewModel.setTemplateEnabled(isEnabled, for: template)
                        }
                    )

                    if index < viewModel.fileTemplates.count - 1 {
                        SettingsDivider()
                    }
                }
            }

            SettingsGroup(title: viewModel.strings.launchAndDisplayTitle) {
                TemplateToggleRow(
                    title: viewModel.strings.showIcons,
                    isOn: Binding(
                        get: { viewModel.showMenuIcons },
                        set: { viewModel.setShowMenuIcons($0) }
                    )
                )

                SettingsDivider()

                TemplateToggleRow(
                    title: viewModel.strings.openFileAfterCreate,
                    isOn: Binding(
                        get: { viewModel.openNewFileAfterCreate },
                        set: { viewModel.setOpenNewFileAfterCreate($0) }
                    )
                )

                SettingsDivider()

                TemplateToggleRow(
                    title: viewModel.strings.playPromptSound,
                    isOn: Binding(
                        get: { viewModel.playSoundAfterCreate },
                        set: { viewModel.setPlaySoundAfterCreate($0) }
                    )
                )
            }

            HStack(spacing: 10) {
                Button(viewModel.strings.resetDefaults) {
                    viewModel.resetTemplates()
                }
                .buttonStyle(AppCapsuleButtonStyle())

                Button(viewModel.strings.finderMenuTroubleshooting) {}
                    .buttonStyle(AppCapsuleButtonStyle())

                Spacer()

                Text(viewModel.statusMessage)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(AppTheme.tertiaryText)
            }
            .padding(.top, 2)
        }
    }
}

private struct TemplateRow: View {
    let template: NewFileTemplate
    let strings: RightKitStrings
    let isEnabled: Bool
    let onToggle: (Bool) -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(nsImage: RightKitIconProvider.templateIcon(for: template, size: 24))
                .resizable()
                .interpolation(.high)
                .frame(width: 24, height: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(strings.templateTitle(for: template))
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(AppTheme.primaryText)
                Text(".\(template.fileExtension)")
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .foregroundStyle(AppTheme.tertiaryText)
            }

            Spacer()

            Toggle("", isOn: Binding(get: { isEnabled }, set: onToggle))
                .labelsHidden()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}

private struct TemplateToggleRow: View {
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 12) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(AppTheme.primaryText)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}
