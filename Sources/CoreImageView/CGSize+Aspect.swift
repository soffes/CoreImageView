import CoreGraphics

extension CGSize {
    func aspectFit(_ aspectRatio: CGSize) -> CGSize {
        let widthRatio = (width / aspectRatio.width)
        let heightRatio = (height / aspectRatio.height)
        var size = self
        if widthRatio < heightRatio {
            size.height = width / aspectRatio.width * aspectRatio.height
        } else if heightRatio < widthRatio {
            size.width = height / aspectRatio.height * aspectRatio.width
        }
        return CGSize(width: ceil(size.width), height: ceil(size.height))
    }
}
