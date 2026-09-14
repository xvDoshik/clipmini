import Combine
import Foundation

public final class HistoryStore: ObservableObject {
    @Published public private(set) var items: [ClipItem] = []

    private let fileURL: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    public init(appSupportSubpath: String = "ClipMini/history.json") {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let dir = base.appendingPathComponent("ClipMini", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("history.json")
        load()
    }

    public func append(text: String, kind: ClipKind = .text) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let preview = trimmed.count > 4000 ? String(trimmed.prefix(4000)) : trimmed
        let item = ClipItem(text: preview, kind: kind)
        items = HistoryStoreLogic.push(item, into: items)
        save()
    }

    public func item(at index: Int) -> ClipItem? {
        guard index >= 0, index < items.count else { return nil }
        return items[index]
    }

    public func clear() {
        items = []
        save()
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        items = (try? decoder.decode([ClipItem].self, from: data)) ?? []
    }

    private func save() {
        guard let data = try? encoder.encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
