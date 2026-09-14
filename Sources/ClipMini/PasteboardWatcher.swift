import AppKit
import ClipMiniCore
import Foundation

final class PasteboardWatcher {
    private var timer: Timer?
    private var lastChangeCount = NSPasteboard.general.changeCount
    var onCapture: ((String, ClipKind) -> Void)?

    func start() {
        stop()
        lastChangeCount = NSPasteboard.general.changeCount
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.tick()
        }
        RunLoop.main.add(timer!, forMode: .common)
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    private func tick() {
        let pb = NSPasteboard.general
        let count = pb.changeCount
        guard count != lastChangeCount else { return }
        lastChangeCount = count

        if let types = pb.types?.map(\.rawValue), PasteboardRules.shouldIgnore(typeNames: types) {
            return
        }

        if let string = pb.string(forType: .string), !string.isEmpty {
            onCapture?(string, .text)
            return
        }

        if pb.data(forType: .png) != nil || pb.data(forType: .tiff) != nil {
            onCapture?("[Image]", .image)
        }
    }
}
