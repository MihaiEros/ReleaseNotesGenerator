//
//  Helper.swift
//  ReleaseNotesGenerator
//
//  Created by Mihai Eros on 12.01.2023.
//

import Cocoa

final class Helper: NSObject {
    
    /// Cache
    private struct Cache {
        static var dropImage: NSImage?
    }
    
    /// Generated Images
    @objc dynamic public class var imageOfDrop: NSImage {
        if let dropImage = Cache.dropImage {
            return dropImage
        }
        
        Cache.dropImage = NSImage(size: NSSize(width: 120,
                                               height: 120), flipped: false) { _ in
            Helper.drawDropTxt()
            return true
        }
        
        return Cache.dropImage!
    }
    
    @objc(DrapanddropResizingBehavior)
    public enum ResizingBehavior: Int {
        case aspectFit /// The content is proportionally resized to fit into the target rectangle.
        case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
        case stretch /// The content is stretched to match the entire target rectangle.
        case center /// The content is centered in the target rectangle, but it is NOT resized.
        
        public func apply(rect: NSRect, target: NSRect) -> NSRect {
            if rect == target || target == NSRect.zero {
                return rect
            }
            
            var scales = NSSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)
            
            switch self {
            case .aspectFit:
                scales.width = min(scales.width, scales.height)
                scales.height = scales.width
            case .aspectFill:
                scales.width = max(scales.width, scales.height)
                scales.height = scales.width
            case .stretch:
                break
            case .center:
                scales.width = 1
                scales.height = 1
            }
            
            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }
}
