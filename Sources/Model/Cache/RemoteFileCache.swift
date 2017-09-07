//
//  RemoteFileCache.swift
//  TumblrImages
//
//  Created by Vitalii Budnik on 9/7/17.
//  Copyright © 2017 Vitalii Budnik. All rights reserved.
//

import Foundation

internal final class RemoteFileCache: RemoteFileCacheProtocol {
	
	private let cacheDir: URL
	private let cleanCacheOnDeinit: Bool
	
	required convenience init(cacheDir: URL?) {
		self.init(cacheDir: cacheDir, cleanCacheOnDeinit: true)
	}
	
	init(cacheDir: URL? = .none, cleanCacheOnDeinit: Bool = true) {
		self.cacheDir = cacheDir ?? FileManager.default.imagesCacheDirectory()
		self.cleanCacheOnDeinit = true
	}
	
	deinit {
		if cleanCacheOnDeinit {
			cachedFiles.values.forEach {
				try? FileManager.default.removeItem(at: $0)
			}
		}
	}
	
	private var cachedFiles: [URL : URL] = [:]
	
	final func cachedImageFileFor(remoteURL: URL) -> URL? {
		
		guard
			let fileURL = cachedFiles[remoteURL],
			FileManager.default.fileExists(at: fileURL)
			else {
				return .none
		}
		
		return fileURL
		
	}
	
	final func saveImageFile(
		at temporaryURL: URL,
		downloadedFrom remoteURL: URL) throws
		-> URL
	{
		
		guard cachedFiles[remoteURL] == .none // already cached
			else {
				return cachedFiles[remoteURL]!
		}
		
		/// Unice filename.
		let filename = FileManager.default.uniqueFileName(at: cacheDir,
		                                                  with: remoteURL.pathExtension)
		
		try FileManager.default.moveItem(at: temporaryURL, to: filename)
		
		cachedFiles[remoteURL] = filename // save info
		
		return filename
		
	}
	
}
