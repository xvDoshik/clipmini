import Foundation

public enum ClipKind: String, Codable, Sendable {
    case text
    case image
}

public struct ClipItem: Identifiable, Codable, Equatable, Sendable {
    public let id: UUID
    public let text: String
    public let createdAt: Date
    public let kind: ClipKind

    public init(id: UUID = UUID(), text: String, createdAt: Date = Date(), kind: ClipKind = .text) {
        self.id = id
        self.text = text
        self.createdAt = createdAt
        self.kind = kind
    }
}

public enum HistoryStoreLogic {
    public static let maxItems = 30

    public static func push(_ item: ClipItem, into items: [ClipItem]) -> [ClipItem] {
        var next = items
        if let first = next.first, first.text == item.text, first.kind == item.kind {
            return next
        }
        next.insert(item, at: 0)
        if next.count > maxItems {
            next.removeLast(next.count - maxItems)
        }
        return next
    }
}
