//
//  File.swift
//  
//
//  Created by User on 14.03.2021.
//

import Foundation
import MessageKit
import UIKit

public struct ImageMediaItem: MediaItem {
    public var url: URL?
    public var image: UIImage?
    public var placeholderImage: UIImage
    public var size: CGSize
    public var data: Data

    public init(data: Data) {
        self.data = data
        self.image = UIImage(data: data)
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }
}
