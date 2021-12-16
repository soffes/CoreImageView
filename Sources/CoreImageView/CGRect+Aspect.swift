import CoreGraphics

extension CGRect {
    func aspectFit(_ aspectRatio: CGSize) -> CGRect {
        let size = self.size.aspectFit(aspectRatio)
        var origin = self.origin
        origin.x += (self.size.width - size.width) / 2.0
        origin.y += (self.size.height - size.height) / 2.0
        return CGRect(origin: origin, size: size)
    }
}
