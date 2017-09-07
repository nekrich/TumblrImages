//
//  PostWithImageURLProtocol.swift
//  TumblrImages
//
//  Created by Vitalii Budnik on 9/7/17.
//  Copyright © 2017 Vitalii Budnik. All rights reserved.
//

import Foundation

internal protocol PostWithImagesURLsProtocol {
	
	/// Array of string representing absolute URLs to the original images contained in post.
	var originalImagesURLsString: [String] { get }
	
}
