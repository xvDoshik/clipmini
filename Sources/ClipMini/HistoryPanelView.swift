import ClipMiniCore
import SwiftUI

struct HistoryPanelView: View {
    @ObservedObject var store: HistoryStore
    var onSelect: (Int) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("ClipMini")
                    .font(.headline)
                Spacer()
                Text("⌘⇧V · ⌘1–3")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)

            Divider()

            if store.items.isEmpty {
                Text("No clips yet")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        ForEach(Array(store.items.enumerated()), id: \.element.id) { index, item in
                            Button {
                                onSelect(index)
                            } label: {
                                HStack(alignment: .top, spacing: 10) {
                                    if index < 3 {
                                        Text("\(index + 1)")
                                            .font(.system(.caption, design: .rounded).weight(.bold))
                                            .frame(width: 22, height: 22)
                                            .background(Circle().fill(Color.accentColor.opacity(0.25)))
                                    } else {
                                        Text("·")
                                            .frame(width: 22)
                                            .foregroundStyle(.tertiary)
                                    }
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(item.text)
                                            .lineLimit(2)
                                            .multilineTextAlignment(.leading)
                                            .foregroundStyle(.primary)
                                        Text(item.createdAt, style: .relative)
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer(minLength: 0)
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            Divider().padding(.leading, 46)
                        }
                    }
                }
            }
        }
        .frame(width: 380, height: 320)
        .background(.regularMaterial)
    }
}
