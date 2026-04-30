import SwiftUI

struct FileTemplatesView: View {
    @ObservedObject var viewModel: AppViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HeaderView(
                title: viewModel.strings.templatesTitle,
                subtitle: viewModel.strings.templatesSubtitle
            )

            List(viewModel.fileTemplates) { template in
                HStack(spacing: 12) {
                    Image(systemName: "doc")
                        .foregroundStyle(.secondary)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.strings.templateTitle(for: template))
                            .font(.headline)
                        Text(viewModel.strings.untitledFilename(for: template))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text(".\(template.fileExtension)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }
            .listStyle(.inset)

            HStack {
                Button {
                    viewModel.resetTemplates()
                } label: {
                    Label(viewModel.strings.resetDefaults, systemImage: "arrow.counterclockwise")
                }

                Spacer()

                Text(viewModel.statusMessage)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(24)
    }
}
