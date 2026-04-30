import SwiftUI

struct StatusView: View {
    @ObservedObject var viewModel: AppViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HeaderView(
                title: viewModel.strings.statusTitle,
                subtitle: viewModel.strings.statusSubtitle
            )

            InfoRow(label: viewModel.strings.appGroup, value: AppGroup.identifier)
            InfoRow(label: viewModel.strings.favoriteDirectoriesCount, value: "\(viewModel.favoriteDirectories.count)")
            InfoRow(label: viewModel.strings.fileTemplatesCount, value: "\(viewModel.fileTemplates.count)")
            InfoRow(label: viewModel.strings.cutItemsCount, value: "\(viewModel.cutPasteState?.sourcePaths.count ?? 0)")

            ExtensionSetupView(viewModel: viewModel)

            Picker(viewModel.strings.languageLabel, selection: Binding(
                get: { viewModel.language },
                set: { viewModel.setLanguage($0) }
            )) {
                ForEach(AppLanguage.allCases) { language in
                    Text(language.displayName).tag(language)
                }
            }
            .pickerStyle(.segmented)

            HStack {
                Button {
                    viewModel.reload()
                } label: {
                    Label(viewModel.strings.reloadSharedState, systemImage: "arrow.clockwise")
                }

                Button {
                    viewModel.clearCutPasteState()
                } label: {
                    Label(viewModel.strings.clearCutState, systemImage: "xmark.circle")
                }
                .disabled(viewModel.cutPasteState == nil)

                Spacer()
            }

            Spacer()
        }
        .padding(24)
    }
}

private struct ExtensionSetupView: View {
    @ObservedObject var viewModel: AppViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HeaderView(
                title: viewModel.strings.finderExtensionSetupTitle,
                subtitle: viewModel.strings.finderExtensionSetupSubtitle
            )

            Text(viewModel.strings.finderExtensionSetupStep1)
            Text(viewModel.strings.finderExtensionSetupStep2)
            Text(viewModel.strings.finderExtensionSetupStep3)
            Text(viewModel.strings.finderExtensionSetupStep4)

            HStack {
                Button {
                    viewModel.copyFinderActivationCommand()
                } label: {
                    Label(viewModel.strings.copyFinderActivationCommand, systemImage: "terminal")
                }

                Spacer()
            }

            Text(viewModel.strings.finderExtensionSetupFootnote)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(.quaternary.opacity(0.25), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}
