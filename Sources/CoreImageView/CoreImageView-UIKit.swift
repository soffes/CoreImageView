#if canImport(UIKit)
import CoreImage
import GLKit
import UIKit

public class CoreImageView: GLKView {

    // MARK: - Properties

    var ciImage: CIImage? {
        didSet {
            setNeedsDisplay()
        }
    }

    private let ciContext: CIContext

    // MARK: - Initializers

    public convenience init() {
        self.init(frame: .zero, context: EAGLContext(api: .openGLES2)!)
    }

    public override init(frame: CGRect, context: EAGLContext) {
        ciContext = CIContext(eaglContext: context, options: [
            .workingColorSpace: NSNull()
        ])

        super.init(frame: frame, context: context)

        backgroundColor = .black
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View

    public override func draw(_ rect: CGRect) {
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))

        if let backgroundColor = (backgroundColor?.cgColor).flatMap(CIColor.init) {
            var pixelBounds = bounds
            pixelBounds.origin.x *= contentScaleFactor
            pixelBounds.origin.y *= contentScaleFactor
            pixelBounds.size.width *= contentScaleFactor
            pixelBounds.size.height *= contentScaleFactor

            let colorImage = CIImage(color: backgroundColor).cropped(to: pixelBounds)
            ciContext.draw(colorImage, in: pixelBounds, from: colorImage.extent)
        }

        guard var image = ciImage else {
            return
        }

        image = image.transformed(by: CGAffineTransform(scaleX: 1, y: -1))
        image = image.transformed(by: CGAffineTransform(translationX: 0, y: image.extent.height))

        ciContext.draw(image, in: pixelImageRectForBounds(bounds), from: image.extent)
    }

    // MARK: - Configuration

    func imageRectForBounds(_ bounds: CGRect) -> CGRect {
        var rect = bounds

        if let ciImage = ciImage {
            rect = rect.aspectFit(ciImage.extent.size)
        }

        return rect
    }

    private func pixelImageRectForBounds(_ bounds: CGRect) -> CGRect {
        var rect = imageRectForBounds(bounds)

        rect.origin.x *= contentScaleFactor
        rect.origin.y *= contentScaleFactor
        rect.size.width *= contentScaleFactor
        rect.size.height *= contentScaleFactor

        return rect
    }
}
#endif