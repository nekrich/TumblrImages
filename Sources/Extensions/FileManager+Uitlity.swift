//
//  FileManager+Uitlity.swift
//  TumblrImages
//
//  Created by Vitalii Budnik on 9/7/17.
//  Copyright © 2017 Vitalii Budnik. All rights reserved.
//

import Foundation

extension FileManager {
	
	private func objectExists(
		at url: URL,
		isDirectory: Bool,
		removeIfExistsAndTypeIsWrong: Bool)
		-> Bool
	{
		var existingObjectIsDirectory: ObjCBool = ObjCBool(false)
		let objectExists: Bool
		
		if fileExists(atPath: url.path, isDirectory: &existingObjectIsDirectory) {
			if existingObjectIsDirectory.boolValue != isDirectory { // if isDirectory != existingFile.isDirectory
				if removeIfExistsAndTypeIsWrong {
					do {
						try removeItem(at: url) // remove object
					} catch {
						print("Error")
					}
				}
				objectExists = false
			} else { // exists
				objectExists = true
			}
		} else { // Not exists
			objectExists = false
		}
		
		return objectExists
		
	}
	
	func directoryExists(
		at url: URL,
		removeIfExistsAndTypeIsWrong: Bool = false)
		-> Bool
	{
		return objectExists(at: url,
		                    isDirectory: true,
		                    removeIfExistsAndTypeIsWrong: removeIfExistsAndTypeIsWrong)
	}
	
	func fileExists(
		at url: URL,
		removeIfExistsAndTypeIsWrong: Bool = false)
		-> Bool
	{
		return objectExists(at: url,
		                    isDirectory: false,
		                    removeIfExistsAndTypeIsWrong: removeIfExistsAndTypeIsWrong)
	}
	
	func imagesCacheDirectory() -> URL {
		let cacheURL = self.urls(for: .cachesDirectory,
		                         in: .userDomainMask)
			.last!
		
		let imageCacheURL = cacheURL.appendingPathComponent("Images",
		                                                    isDirectory: true)
		if !directoryExists(at: imageCacheURL, removeIfExistsAndTypeIsWrong: true) {
			do {
				try createDirectory(at: imageCacheURL,
			                     withIntermediateDirectories: false,
			                     attributes: [:])
				return imageCacheURL
			} catch {
				print(error)
				return cacheURL
			}
		} else {
			return imageCacheURL
		}
		
	}
	
	func uniqueFileName(at directory: URL, with pathExtension: String) -> URL {
		let uuid = UUID()
		let uniqueFileName = uuid.uuidString
			.appending(".")
			.appending(pathExtension)
		let fileURL = directory.appendingPathComponent(uniqueFileName,
		                                               isDirectory: false)
		if fileExists(at: fileURL) {
			return self.uniqueFileName(at: directory, with: pathExtension)
		} else {
			return fileURL
		}
	}
	
	var cacheFolderURL: URL {
		
		return imagesCacheDirectory()
		
	}
	
}
