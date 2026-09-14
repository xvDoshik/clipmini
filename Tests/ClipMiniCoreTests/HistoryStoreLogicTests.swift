import ClipMiniCore
import Foundation

enum HistoryStoreLogicTests {
    static func runAll() -> [String] {
        var failures: [String] = []
        func expect(_ condition: Bool, _ message: String) {
            if !condition { failures.append(message) }
        }

        var items: [ClipItem] = []
        items = HistoryStoreLogic.push(ClipItem(text: "hello"), into: items)
        items = HistoryStoreLogic.push(ClipItem(text: "hello"), into: items)
        expect(items.count == 1, "dedupe consecutive")

        items = []
        for i in 0 ..< 40 {
            items = HistoryStoreLogic.push(ClipItem(text: "item-\(i)"), into: items)
        }
        expect(items.count == HistoryStoreLogic.maxItems, "limit 30")
        expect(items.first?.text == "item-39", "newest after bulk")

        items = []
        items = HistoryStoreLogic.push(ClipItem(text: "first"), into: items)
        items = HistoryStoreLogic.push(ClipItem(text: "second"), into: items)
        expect(items[0].text == "second" && items[1].text == "first", "newest first")

        return failures
    }
}

@main
struct ClipMiniCoreTestRunner {
    static func main() {
        let failures = HistoryStoreLogicTests.runAll()
        if failures.isEmpty {
            print("All tests passed")
        } else {
            for f in failures {
                fputs("FAIL: \(f)\n", stderr)
            }
            exit(1)
        }
    }
}
