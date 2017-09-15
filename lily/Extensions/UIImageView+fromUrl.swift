//
//  UIImageView+fromUrl.swift
//  lily
//
//  Created by Nathan Chan on 9/14/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import UIKit

extension UIImageView {
    public func image(fromUrl urlString: String, readjustFrameSize: Bool = false) {
        guard let url = URL(string: urlString) else {
            print("Couldn't create URL from \(urlString)")
            return
        }
        let theTask = URLSession.shared.dataTask(with: url) { data, response, _ in
            if let response = data {
                DispatchQueue.main.async {
                    self.image = UIImage(data: response)
//                    let c = NSLayoutConstraint(item: self, attribute: .width,
//                                               relatedBy: .equal,
//                                               toItem: self, attribute: .height,
//                                               multiplier: aspectRatio, constant: 0)
//                    // a priority above fitting size level and below low
//                    c.priority = (UILayoutPriorityDefaultLow + UILayoutPriorityFittingSizeLevel) / 2.0
//                    self.addConstraint(c)
                    
                    if readjustFrameSize {
                        guard let image = self.image else { return }
                        
                        let aspectRatio = image.size.width / image.size.height
                        
                        self.frame.size = CGSize(width: self.frame.width, height: self.frame.width / aspectRatio)
                    }
                }
            }
        }
        theTask.resume()
    }
}
