//
//  ImageMediaItem.swift
//  FenceApp
//
//  Created by t2023-m0067 on 11/15/23.
//

import UIKit
import MessageKit

class ImageMediaItem: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize

    init(image: UIImage) {
        self.image = image
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }
}
