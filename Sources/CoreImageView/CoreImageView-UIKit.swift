#if canImport(UIKit)
import CoreImage
import GLKit
import UIKit

open class CoreImageView: GLKView {

    // MARK: - Properties

    open var image: CIImage? {
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

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View

    open override func draw(_ rect: CGRect) {
        precondition(Thread.isMainThread)

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

        guard let image = image else {
            return
        }

        ciContext.draw(image, in: pixelImageRectForBounds(bounds), from: image.extent)
    }

    // MARK: - Configuration

    open func imageRectForBounds(_ bounds: CGRect) -> CGRect {
        var rect = bounds

        if let image = image {
            rect = rect.aspectFit(image.extent.size)
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
