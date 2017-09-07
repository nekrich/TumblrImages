//
//  ImagesDownloadManagerProtocol.swift
//  TumblrImages
//
//  Created by Vitalii Budnik on 9/7/17.
//  Copyright © 2017 Vitalii Budnik. All rights reserved.
//

import Foundation
import class UIKit.UIImage

internal protocol ImagesDownloadManagerProtocol {
	
	@discardableResult
	func fetchImage(
		at url: URL,
		completionHandler: @escaping (Result<UIImage>) -> Void)
		-> URLSessionDownloadTask?
	
}
