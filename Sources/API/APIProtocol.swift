//
//  APIProtocol.swift
//  TumblrImages
//
//  Created by Vitalii Budnik on 9/7/17.
//  Copyright © 2017 Vitalii Budnik. All rights reserved.
//

import Foundation

internal protocol APIProtocol {
	
	associatedtype PostInfo: PostWithImagesURLsProtocol
	
	var apiSource: APISourceProtocol { get }
	
	func fetchImagesInfo(
		tagged tag: String,
		comletionHandler: ((Result<[PostInfo]>) -> Void)?)
	
}
