//
//  UIImage+Scale.swift
//  TumblrImages
//
//  Created by Vitalii Budnik on 9/7/17.
//  Copyright © 2017 Vitalii Budnik. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
	
	private func scaled(to size: CGSize) -> UIImage? {
		UIGraphicsBeginImageContext(size)
		self.draw(in: CGRect(origin: .zero, size: size))
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return newImage
	}
	
	func scaled(to width: CGFloat) -> UIImage? {
		
		if self.size.width < width {
			return self
		}
		
		let scaleFactor = width / self.size.width
		
		let height = self.size.height * scaleFactor
		
		return self.scaled(to: CGSize(width: width, height: height))
		
	}
	
}
