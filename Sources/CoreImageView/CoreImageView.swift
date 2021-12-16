#if canImport(AppKit)
import AppKit
#else
import UIKit
#endif

import MetalKit

open class CoreImageView: MTKView {

    // MARK: - Properties

    open var ciImage: CIImage? {
        didSet {
            setNeedsDisplay(bounds)
            invalidateIntrinsicContentSize()
        }
    }

    private var ciContext: CIContext?
    private var commandQueue: MTLCommandQueue?

    // MARK: - Initializers

    public override init(frame: CGRect = .zero, device: MTLDevice? = nil) {
        super.init(frame: frame, device: device)
        initialize()
    }

    @available(*, unavailable)
    public required init(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    // MARK: - View

    open override var intrinsicContentSize: CGSize {
        guard var size = ciImage?.extent.size else {
#if canImport(AppKit)
            return CGSize(width: NSView.noIntrinsicMetric, height: NSView.noIntrinsicMetric)
#else
            return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
#endif
        }

#if canImport(AppKit)
        let scale = window?.backingScaleFactor
#else
        let scale = window?.screen.scale
#endif

        if let scale = scale {
            size.width /= scale
            size.height /= scale
        }

        return size
    }

    open override func draw(_ rect: CGRect) {
        guard var image = ciImage else {
            return
        }

        let device: MTLDevice

        if let currentDevice = self.device {
            device = currentDevice
        } else {
            guard let systemDevice = MTLCreateSystemDefaultDevice() else {
                assertionFailure("Missing MTLDevice")
                return
            }

            device = systemDevice
            self.device = device
        }

        let commandQueue: MTLCommandQueue
        if let currentCommandQueue = self.commandQueue {
            commandQueue = currentCommandQueue
        } else {
            guard let queue = device.makeCommandQueue() else {
                assertionFailure("Missing MTLDevice")
                return
            }

            commandQueue = queue
            self.commandQueue = commandQueue
        }

        let ciContext: CIContext
        if let currentContext = self.ciContext {
            ciContext = currentContext
        } else {
            ciContext = CIContext(mtlDevice: device, options: [
                .workingColorSpace: NSNull()
            ])

            self.ciContext = ciContext
        }

        guard let commandBuffer = commandQueue.makeCommandBuffer() else {
            assertionFailure("Failed to create command buffer")
            return
        }

        guard let drawable = currentDrawable else {
            print("Failed to get current drawable")
            return
        }

        let texture = drawable.texture

        // TODO: No idea why this is only required on the simulator and not macOS or an iOS device
#if targetEnvironment(simulator)
        // Transform to unflipped
        image = image.transformed(by: CGAffineTransform(scaleX: 1, y: -1))
        image = image.transformed(by: CGAffineTransform(translationX: 0, y: image.extent.height))
#endif

        // Aspect fit
        let textureBounds = CGRect(x: 0, y: 0, width: texture.width, height: texture.height)
        let rect = imageRectForBounds(textureBounds)
        image = image.transformed(by: CGAffineTransform(scaleX: rect.width / image.extent.width,
                                                        y: rect.height / image.extent.height))
        image = image.transformed(by: CGAffineTransform(translationX: rect.origin.x, y: rect.origin.y))

        // Draw
        let colorSpace = image.colorSpace ?? CGColorSpaceCreateDeviceRGB()
        ciContext.render(image, to: texture, commandBuffer: commandBuffer, bounds: textureBounds,
                         colorSpace: colorSpace)

        commandBuffer.present(drawable)
        commandBuffer.commit()
    }

#if canImport(AppKit)
    open override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        invalidateIntrinsicContentSize()
    }
#else
    open override func didMoveToWindow() {
        super.didMoveToWindow()
        invalidateIntrinsicContentSize()
    }
#endif

    // MARK: - Configuration

    open func imageRectForBounds(_ bounds: CGRect) -> CGRect {
        var rect = bounds

        if let image = ciImage {
            rect = rect.aspectFit(image.extent.size)
        }

        return rect
    }

    // MARK: - Private

    private func initialize() {
#if canImport(AppKit)
        wantsLayer = true
        layer?.isOpaque = false
        layer?.backgroundColor = .clear
#elseif canImport(UIKit)
        backgroundColor = .clear
#endif

        clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1)
        framebufferOnly = false
        enableSetNeedsDisplay = true
        isPaused = true
    }
}
