import SwiftUI

struct FileTemplatesView: View {
    @ObservedObject var viewModel: AppViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HeaderView(
                title: "New File Templates",
                subtitle: "The first version ships with a fixed minimal template set."
            )

            List(viewModel.fileTemplates) { template in
                HStack(spacing: 12) {
                    Image(systemName: "doc")
                        .foregroundStyle(.secondary)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(template.title)
                            .font(.headline)
                        Text(template.suggestedFilename)
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
                    Label("Reset Defaults", systemImage: "arrow.counterclockwise")
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
