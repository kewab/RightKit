import SwiftUI

struct GeneralSettingsView: View {
    @ObservedObject var viewModel: AppViewModel

    var body: some View {
        SettingsPage(
            title: viewModel.strings.generalSettingsTitle,
            subtitle: viewModel.strings.generalSettingsSubtitle,
            iconStyle: .general
        ) {
            SettingsGroup(title: viewModel.strings.launchAndDisplayTitle) {
                SettingsToggleRow(
                    title: viewModel.strings.showMenuBarIcon,
                    isOn: Binding(
                        get: { viewModel.showMenuIcons },
                        set: { viewModel.setShowMenuIcons($0) }
                    )
                )

                SettingsDivider()

                SettingsPickerRow(title: viewModel.strings.languageLabel) {
                    Picker("", selection: Binding(
                        get: { viewModel.language },
                        set: { viewModel.setLanguage($0) }
                    )) {
                        ForEach(AppLanguage.allCases) { language in
                            Text(language.displayName).tag(language)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.menu)
                }

                SettingsDivider()

                SettingsPickerRow(title: viewModel.strings.scopeLabel) {
                    Text(viewModel.strings.systemDiskScope)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(AppTheme.secondaryText)
                }
            }

            SettingsGroup(title: viewModel.strings.triggerMethodsTitle) {
                TriggerMethodRow(
                    title: viewModel.strings.triggerMethodOne,
                    helpTitle: viewModel.strings.viewHowToUse,
                    control: AnyView(
                        Picker("", selection: .constant(0)) {
                            Text("Shift").tag(0)
                        }
                        .labelsHidden()
                        .pickerStyle(.menu)
                    )
                )

                SettingsDivider()

                TriggerMethodRow(
                    title: viewModel.strings.triggerMethodTwo,
                    helpTitle: viewModel.strings.viewHowToUse,
                    control: AnyView(EmptyView())
                )

                SettingsDivider()

                TriggerMethodRow(
                    title: viewModel.strings.triggerMethodThree,
                    helpTitle: viewModel.strings.viewHowToUse,
                    control: AnyView(EmptyView())
                )
            }

            SettingsGroup(title: viewModel.strings.permissionsTitle) {
                VStack(alignment: .leading, spacing: 12) {
                    Text(viewModel.strings.permissionsDescription)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(AppTheme.secondaryText)
                        .padding(.horizontal, 16)
                        .padding(.top, 16)

                    HStack(spacing: 12) {
                        Button(viewModel.strings.watchPermissionGuide) {}
                            .buttonStyle(AppCapsuleButtonStyle())

                        Button(viewModel.strings.permissionSetupGuide) {
                            viewModel.copyFinderActivationCommand()
                        }
                        .buttonStyle(AppCapsuleButtonStyle())

                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
            }

            HStack {
                Spacer()
                Text(viewModel.statusMessage)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(AppTheme.tertiaryText)
            }
            .padding(.top, 2)
        }
    }
}

private struct SettingsToggleRow: View {
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

private struct SettingsPickerRow<Control: View>: View {
    let title: String
    let control: Control

    init(title: String, @ViewBuilder control: () -> Control) {
        self.title = title
        self.control = control()
    }

    var body: some View {
        HStack(spacing: 12) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(AppTheme.primaryText)
            Spacer()
            control
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(AppTheme.secondaryText)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

private struct TriggerMethodRow: View {
    let title: String
    let helpTitle: String
    let control: AnyView

    var body: some View {
        HStack(spacing: 12) {
            Toggle("", isOn: .constant(false))
                .labelsHidden()
                .disabled(true)

            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(AppTheme.primaryText)

            Spacer()

            control

            Button(helpTitle) {}
                .buttonStyle(AppCapsuleButtonStyle())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}
