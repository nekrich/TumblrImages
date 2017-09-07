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
			let photosJSON = json["photos"] as? [[String : Any]]
			else {
				return nil
		}
		
		let orignalsJSON = photosJSON.flatMap { $0["original_size"] as? [String : Any] }
		let urls: [String] = orignalsJSON.flatMap { $0["url"] as? String }
		
		self.originalImagesURLsString = urls
		
	}
	
}
