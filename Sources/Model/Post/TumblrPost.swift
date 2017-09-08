//
//  TumblrPost.swift
//  TumblrImages
//
//  Created by Vitalii Budnik on 9/7/17.
//  Copyright © 2017 Vitalii Budnik. All rights reserved.
//

import Foundation

internal struct TumblrPost: PostWithImagesURLsProtocol {
	
	let originalImagesURLsString: [String]
	
	init?(json: [String : Any]) {
		
		guard
			let allPhotosJSON = json["photos"] as? [[String : Any]]
			else {
				return nil
		}
		
		let photosJSON = allPhotosJSON.flatMap { (photo) -> [String : Any]? in
			if let originalSizes = photo["original_size"] as? [String : Any] {
				return originalSizes
			}
			guard let altSizes = photo["alt_sizes"] as? [[String : Any]]
				else {
					return .none
			}
			var maxWidth = 0
			var maxPoto: [String : Any]? = .none
			altSizes.forEach { (altSizePhoto) in
				guard let width = altSizePhoto["width"] as? Int
					else {
						return
				}
				if width > maxWidth {
					maxWidth = width
					maxPoto = altSizePhoto
				}
			}
			return maxPoto
		}
		let urls: [String] = photosJSON.flatMap { $0["url"] as? String }
		
		self.originalImagesURLsString = urls
		
	}
	
}
