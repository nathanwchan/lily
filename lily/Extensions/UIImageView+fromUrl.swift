//
//  UIImageView+fromUrl.swift
//  lily
//
//  Created by Nathan Chan on 9/14/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import UIKit

extension UIImageView {
    public func image(fromUrl urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Couldn't create URL from \(urlString)")
            return
        }
        let theTask = URLSession.shared.dataTask(with: url) { data, response, _ in
            if let response = data {
                DispatchQueue.main.async {
                    self.image = UIImage(data: response)
                }
            }
        }
        theTask.resume()
    }
}
