import SwiftUI

struct GeneralSettingsView: View {
    @ObservedObject var viewModel: AppViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AppSectionTitle(
                    title: viewModel.strings.launchAndDisplayTitle,
                    systemImage: "rocket.fill",
                    accent: AppTheme.accent
                )

                AppPanel {
                    HStack(alignment: .top, spacing: 24) {
                        Toggle(isOn: Binding(
                            get: { viewModel.showMenuIcons },
                            set: { viewModel.setShowMenuIcons($0) }
                        )) {
                            Text(viewModel.strings.showMenuBarIcon)
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .toggleStyle(.checkbox)
                        .foregroundStyle(AppTheme.primaryText)

                        Spacer()

                        VStack(alignment: .leading, spacing: 18) {
                            labeledPicker(
                                title: viewModel.strings.languageLabel,
                                accent: AppTheme.secondaryText
                            ) {
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
                                .frame(width: 220)
                            }

                            labeledPicker(
                                title: viewModel.strings.scopeLabel,
                                accent: AppTheme.secondaryText
                            ) {
                                HStack(spacing: 8) {
                                    Picker("", selection: .constant(0)) {
                                        Text(viewModel.strings.systemDiskScope).tag(0)
                                    }
                                    .labelsHidden()
                                    .pickerStyle(.menu)
                                    .frame(width: 220)

                                    Button {} label: {
                                        Image(systemName: "questionmark.circle.fill")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundStyle(AppTheme.tertiaryText)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                }

                AppSectionTitle(
                    title: viewModel.strings.triggerMethodsTitle,
                    systemImage: "hand.tap.fill",
                    accent: AppTheme.accent
                )

                AppPanel {
                    VStack(spacing: 22) {
                        triggerMethodRow(
                            index: 1,
                            title: viewModel.strings.triggerMethodOne,
                            control: AnyView(
                                Picker("", selection: .constant(0)) {
                                    Text("Shift").tag(0)
                                }
                                .labelsHidden()
                                .pickerStyle(.menu)
                                .frame(width: 180)
                            )
                        )

                        triggerMethodRow(
                            index: 2,
                            title: viewModel.strings.triggerMethodTwo,
                            control: AnyView(EmptyView())
                        )

                        triggerMethodRow(
                            index: 3,
                            title: viewModel.strings.triggerMethodThree,
                            control: AnyView(EmptyView())
                        )
                    }
                }

                AppSectionTitle(
                    title: viewModel.strings.permissionsTitle,
                    systemImage: "key.fill",
                    accent: AppTheme.accent
                )

                AppPanel {
                    VStack(alignment: .leading, spacing: 30) {
                        Text(viewModel.strings.permissionsDescription)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(AppTheme.primaryText)

                        HStack {
                            Button(viewModel.strings.watchPermissionGuide) {}
                                .buttonStyle(.plain)
                                .foregroundStyle(AppTheme.accent)

                            Spacer()

                            Button(viewModel.strings.permissionSetupGuide) {
                                viewModel.copyFinderActivationCommand()
                            }
                            .buttonStyle(.plain)
                            .foregroundStyle(AppTheme.accent)
                        }
                    }
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

    private func labeledPicker<Content: View>(
        title: String,
        accent: Color,
        @ViewBuilder content: () -> Content
    ) -> some View {
        HStack(spacing: 12) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(accent)
                .frame(width: 96, alignment: .trailing)
            content()
        }
    }

    private func triggerMethodRow(
        index: Int,
        title: String,
        control: AnyView
    ) -> some View {
        HStack(spacing: 14) {
            Toggle("", isOn: .constant(false))
                .toggleStyle(.checkbox)
                .labelsHidden()

            Text("\(index). \(title)")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(AppTheme.primaryText)

            control

            Spacer()

            Button(viewModel.strings.viewHowToUse) {}
                .buttonStyle(.plain)
                .foregroundStyle(AppTheme.accent)
        }
    }
}

struct AppCapsuleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(configuration.isPressed ? AppTheme.secondaryText : AppTheme.primaryText)
            .padding(.horizontal, 18)
            .frame(height: 40)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(configuration.isPressed ? AppTheme.hoverFill : Color.white.opacity(0.78))
            )
            .overlay {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(AppTheme.divider, lineWidth: 1)
            }
    }
}

struct AppSmallSquareButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(configuration.isPressed ? AppTheme.secondaryText : AppTheme.primaryText)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(configuration.isPressed ? AppTheme.hoverFill : Color.white.opacity(0.78))
            )
            .overlay {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(AppTheme.divider, lineWidth: 1)
            }
    }
}
