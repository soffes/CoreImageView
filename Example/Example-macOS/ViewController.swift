import AppKit
import CoreImageView

final class ViewController: NSViewController {

    // MARK: - Properties

    private let imageView = CoreImageView()

    // MARK: - NSViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let image = NSImage(named: "test")!
        imageView.image = CIImage(cgImage: image.cgImage(forProposedRect: nil, context: nil, hints: nil)!)
    }
}
