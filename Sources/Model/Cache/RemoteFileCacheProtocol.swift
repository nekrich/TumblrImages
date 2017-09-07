//
//  RemoteFileCacheProtocol.swift
//  TumblrImages
//
//  Created by Vitalii Budnik on 9/7/17.
//  Copyright © 2017 Vitalii Budnik. All rights reserved.
//

import Foundation

internal protocol RemoteFileCacheProtocol {
	
	/// Returns new file cache instance.
	///
	/// - Parameter cacheDir: Directory where cached files will be stored.
	init(cacheDir: URL?)
	
	/// Returns `URL` to locally stored copy of file if it was cached before.
	/// Otherwise return `nil`.
	///
	/// - Parameter remoteURL: `URL` of the remote file.
	/// - Returns: `URL` to locally stored copy of file if it was cached before.
	/// Otherwise return `nil`.
	func cachedImageFileFor(remoteURL: URL) -> URL?
	
	/// Returns `URL` of _persistent_ file in a cache dir.
	///
	/// - Parameters:
	///   - temporaryURL: `URL` to temporary file location.
	///   - remoteURL: origin `URL`.
	/// - Returns: `URL` of _persistent_ file in a cache dir.
	/// - Throws: an error in cases of failure moving file from temporary to cache folder.
	/// - Note: This method **moves** file from `temporaryURL` location.
	func saveImageFile(
		at temporaryURL: URL,
		downloadedFrom remoteURL: URL) throws
		-> URL
	
}
