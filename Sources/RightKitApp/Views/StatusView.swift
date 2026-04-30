import SwiftUI

struct GeneralSettingsView: View {
    @ObservedObject var viewModel: AppViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                HeaderView(
                    icon: "gearshape.fill",
                    accent: Color(red: 0.13, green: 0.69, blue: 0.98),
                    title: viewModel.strings.generalSettingsTitle,
                    subtitle: viewModel.strings.generalSettingsSubtitle
                )

                AppSectionTitle(
                    title: viewModel.strings.launchAndDisplayTitle,
                    systemImage: "rocket.fill",
                    accent: Color(red: 0.98, green: 0.33, blue: 0.43)
                )

                AppPanel {
                    HStack(alignment: .top, spacing: 24) {
                        Toggle(isOn: Binding(
                            get: { viewModel.showMenuIcons },
                            set: { viewModel.setShowMenuIcons($0) }
                        )) {
                            Text(viewModel.strings.showMenuBarIcon)
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .toggleStyle(.checkbox)
                        .foregroundStyle(.white.opacity(0.92))

                        Spacer()

                        VStack(alignment: .leading, spacing: 18) {
                            labeledPicker(
                                title: viewModel.strings.languageLabel,
                                accent: .white.opacity(0.86)
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
                                accent: Color(red: 1.0, green: 0.90, blue: 0.14)
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
                                            .foregroundStyle(.white.opacity(0.66))
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
                    accent: Color(red: 0.17, green: 0.67, blue: 0.98)
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
                    accent: Color(red: 1.0, green: 0.68, blue: 0.25)
                )

                AppPanel {
                    VStack(alignment: .leading, spacing: 30) {
                        Text(viewModel.strings.permissionsDescription)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.82))

                        HStack {
                            Button(viewModel.strings.watchPermissionGuide) {}
                                .buttonStyle(.plain)
                                .foregroundStyle(Color(red: 0.15, green: 0.54, blue: 0.98))

                            Spacer()

                            Button(viewModel.strings.permissionSetupGuide) {
                                viewModel.copyFinderActivationCommand()
                            }
                            .buttonStyle(.plain)
                            .foregroundStyle(Color(red: 0.15, green: 0.54, blue: 0.98))
                        }
                    }
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

    private func labeledPicker<Content: View>(
        title: String,
        accent: Color,
        @ViewBuilder content: () -> Content
    ) -> some View {
        HStack(spacing: 12) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
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
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white.opacity(0.88))

            control

            Spacer()

            Button(viewModel.strings.viewHowToUse) {}
                .buttonStyle(.plain)
                .foregroundStyle(Color(red: 0.15, green: 0.54, blue: 0.98))
        }
    }
}

struct AppCapsuleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .bold))
            .foregroundStyle(.white.opacity(configuration.isPressed ? 0.7 : 0.94))
            .padding(.horizontal, 18)
            .frame(height: 46)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.white.opacity(configuration.isPressed ? 0.08 : 0.12))
            )
    }
}

struct AppSmallSquareButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.white.opacity(configuration.isPressed ? 0.7 : 0.9))
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.white.opacity(configuration.isPressed ? 0.08 : 0.10))
            )
    }
}
