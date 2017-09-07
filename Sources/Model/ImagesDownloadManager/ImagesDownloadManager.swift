//
//  ImagesDownloadManager.swift
//  TumblrImages
//
//  Created by Vitalii Budnik on 9/7/17.
//  Copyright © 2017 Vitalii Budnik. All rights reserved.
//

import Foundation
import class UIKit.UIImage

internal class ImagesDownloadManager: ImagesDownloadManagerProtocol {
	
	let cache: RemoteFileCacheProtocol
	let session: URLSession
	
	private var activeTasks: [URL : URLSessionDownloadTask] = [:]

	init(
		cache: RemoteFileCacheProtocol = RemoteFileCache(),
		session: URLSession = URLSession.shared)
	{
		self.session = session
		self.cache = RemoteFileCache()
	}
	
	deinit {
		activeTasks.values.forEach {
			$0.cancel { (_) in }
		}
	}
	
	enum Error: Swift.Error {
		case cantSaveFile(Swift.Error)
		case noFileURLWasReturnedByDownloadTask
		case downloadedFileIsNotAnImage
	}
	
	private func downloadImage(
		at remoteURL: URL,
		completionHandler: @escaping (Result<UIImage>) -> Void)
		-> URLSessionDownloadTask
	{
		
		let handler: (Result<UIImage>) -> Void = { [weak self] result in
			DispatchQueue.main.async {
				self?.activeTasks[remoteURL] = .none
				completionHandler(result)
			}
		}
		
		let cache = self.cache
		
		let task = session.downloadTask(with: remoteURL) { [cache] (fileURL, _, error) in
			guard error == nil
				else {
					handler(.failure(error!))
					return
			}
			
			guard let fileURL = fileURL
				else {
					handler(.failure(Error.noFileURLWasReturnedByDownloadTask))
					return
			}
			
			let constantURL: URL
			do {
			 constantURL = try cache.saveImageFile(at: fileURL,
			                                       downloadedFrom: remoteURL)
			} catch {
				handler(.failure(Error.cantSaveFile(error)))
				return
			}
			
			guard let image = UIImage(contentsOfFile: constantURL.path)
				else {
					handler(.failure(Error.downloadedFileIsNotAnImage))
					return
			}
			
			handler(.success(image))
			
		}
		
		DispatchQueue.main.async {
			self.activeTasks[remoteURL] = task
		}
		
		task.resume()
		
		return task
		
	}
	
	@discardableResult
	func fetchImage(
		at url: URL,
		completionHandler: @escaping (Result<UIImage>) -> Void)
		-> URLSessionDownloadTask?
	{
		
		if let imageFile = cache.cachedImageFileFor(remoteURL: url) {
			DispatchQueue.main.async {
				completionHandler(.success(UIImage(contentsOfFile: imageFile.path)!))
			}
			return .none
		}
		
		return downloadImage(at: url, completionHandler: completionHandler)
		
	}
	
}
