import AppKit

@main
struct ClipMiniMain {
    static func main() {
        let app = NSApplication.shared
        let delegate = AppController()
        app.delegate = delegate
        app.run()
    }
}
