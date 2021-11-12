//
//  ImageHelpers.swift
//  PhotoLogin
//
//  Created by Johann Garces on 11/9/21.
//

import Foundation
import UIKit

class ImageHelpers {

    static func prepareSelfieToSquare(_ image: CGImage) -> UIImage {
        let ciImage = CIImage(cgImage: image)
        let rotatedImage = ciImage.oriented(.right)
        let cropped = rotatedImage.cropped(to: CGRect(x: 0, y: 0, width: image.width, height: image.width))
        return UIImage(ciImage: cropped)
    }
    
}
