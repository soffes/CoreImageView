#if canImport(AppKit)
import AppKit
import QuartzCore

open class CoreImageView: NSView {

    // MARK: - Properties

    open var image: CIImage? {
        didSet {
            setNeedsDisplay(bounds)
        }
    }

    // MARK: - Initializers

    public override init(frame: NSRect) {
        super.init(frame: frame)
        wantsLayer = true
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        wantsLayer = true
    }

    // MARK: - View

    open override func draw(_ rect: CGRect) {
        guard let context = NSGraphicsContext.current?.cgContext, let image = image else {
            return
        }

        let options: [CIContextOption: Any] = [
            .useSoftwareRenderer: false,
            .workingColorSpace: NSNull()
        ]

        let ciContext = CIContext(cgContext: context, options: options)
        ciContext.draw(image, in: imageRectForBounds(bounds), from: image.extent)
    }

    // MARK: - Configuration

    open func imageRectForBounds(_ bounds: CGRect) -> CGRect {
        var rect = bounds

        if let image = image {
            rect = rect.aspectFit(image.extent.size)
        }

        return rect
    }
}
#endif
