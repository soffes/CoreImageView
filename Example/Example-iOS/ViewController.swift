import CoreImageView
import UIKit

final class ViewController: UIViewController {

    // MARK: - Properties

    private let imageView = CoreImageView()

    // MARK: - UIViewController

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

        let image = UIImage(named: "test")!
        imageView.ciImage = CIImage(cgImage: image.cgImage!)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}
