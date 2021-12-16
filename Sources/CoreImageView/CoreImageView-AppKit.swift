#if canImport(AppKit)
import AppKit
import QuartzCore

open class CoreImageView: NSView {

    // MARK: - Properties

    open var image: CIImage? {
        didSet {
            setNeedsDisplay(bounds)
            invalidateIntrinsicContentSize()
        }
    }

    // MARK: - Initializers

    public override init(frame: NSRect) {
        super.init(frame: frame)
        initialize()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    // MARK: - View

    open override var intrinsicContentSize: CGSize {
        guard var size = image?.extent.size else {
            return CGSize(width: NSView.noIntrinsicMetric, height: NSView.noIntrinsicMetric)
        }

        if let scale = window?.backingScaleFactor {
            size.width /= scale
            size.height /= scale
        }

        return size
    }

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

    open override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        invalidateIntrinsicContentSize()
    }

    // MARK: - Configuration

    open func imageRectForBounds(_ bounds: CGRect) -> CGRect {
        var rect = bounds

        if let image = image {
            rect = rect.aspectFit(image.extent.size)
        }

        return rect
    }

    // MARK: - Private

    private func initialize() {
        wantsLayer = true
    }
}
#endif
