import AppKit
import CoreImageView

final class ViewController: NSViewController {

    // MARK: - Properties

    @IBOutlet private var imageView: CoreImageView!

    // MARK: - NSViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        let image = NSImage(named: "test")!
        imageView.ciImage = CIImage(cgImage: image.cgImage(forProposedRect: nil, context: nil, hints: nil)!)
    }
}
