//
//  TumblrAPI.swift
//  TumblrImages
//
//  Created by Vitalii Budnik on 9/7/17.
//  Copyright © 2017 Vitalii Budnik. All rights reserved.
//

import Foundation

internal struct TumblrAPI: APIProtocol {
	
	static func `default`() -> TumblrAPI {
		let source = TumblrAPISource(protocol: "https",
		                             hostname: "api.tumblr.com",
		                             apiPath: "v2")!
		return TumblrAPI(apiKey: "CcEqqSrYdQ5qTHFWssSMof4tPZ89sfx6AXYNQ4eoXHMgPJE03U",
		                 apiSource: source)
	}
	
	struct ResponseMetadata {
		
		let status: Int
		let message: String
		
		init?(json: [String : Any]) {
			guard
				let status = json["status"] as? Int,
				let message = json["msg"] as? String
				else {
					return nil
			}
			self.status = status
			self.message = message
		}
		
	}
	
	let apiSource: APISourceProtocol
	let apiKey: String
	init(apiKey: String, apiSource: TumblrAPISource? = .none) {
		self.apiKey = apiKey
		self.apiSource = apiSource ?? TumblrAPISource(protocol: "https",
		                                              hostname: "api.tumblr.com",
		                                              apiPath: "v2")!
	}
	
	private func buildURL(
		to path: String,
		with parameters: [String : String])
		-> URL?
	{
		
		let taskURL = apiSource.apiURL.appendingPathComponent(path)
		
		let queryItems: [URLQueryItem] = parameters.map { (key: String, value: String) -> URLQueryItem in
			URLQueryItem(name: key, value: value)
		}
		
		var urlComponents = URLComponents(url: taskURL,
		                                  resolvingAgainstBaseURL: true)!
		urlComponents.queryItems = queryItems
		
		guard let destinationURL = urlComponents.url
			else {
				return .none
		}
		
		return destinationURL
		
	}
	
	private func requestForImages(tagged tag: String) -> URLRequest? {
		
		let parameters: [String : String] = ["api_key" : self.apiKey,
		                                     "tag": tag]
		guard let url = buildURL(to: "tagged", with: parameters)
			else {
				return .none
		}
		
		let urlRequest: URLRequest = URLRequest(url: url)
		
		return urlRequest
		
	}
	
	func fetchImagesInfo(
		// swiftlint:disable:previous function_body_length
		tagged tag: String,
		comletionHandler: ((Result<[TumblrPost]>) -> Void)?)
	{
		
		let handler: (Result<[TumblrPost]>) -> Void = { (result) in
			if let comletionHandler = comletionHandler {
				DispatchQueue.main.async {
					comletionHandler(result)
				}
			}
		}
		
		guard let urlRequest = requestForImages(tagged: tag)
			else {
				handler(.failure(Error.cantBuildURL))
				return
		}
		
		let task = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
			
			guard error == nil
				else {
					handler(.failure(error!))
					return
			}
			
			guard let data = data
				else {
					handler(.failure(Error.noDataInResponse))
					return
			}
			
			let responseDataAny: Any
			do {
				responseDataAny = try JSONSerialization.jsonObject(with: data,
				                                        options: [.allowFragments])
			} catch {
				handler(.failure(error))
				return
			}
			
			guard let json = responseDataAny as? [String : Any]
				else {
					handler(.failure(Error.responseIsNotAValidDictionary))
					return
			}
			
			if
				let metaJSON = json["meta"] as? [String : Any],
				let metadata = ResponseMetadata(json: metaJSON),
				metadata.status < 200 || metadata.status > 299
			{
				if let errorsJSON = json["errors"] as? [[String : String]] {
					let errors = errorsJSON
						.flatMap { Error.TumblrError(json: $0) }
					handler(.failure(Error.tumblrError(errors)))
				} else {
					let tumblrError = Error.TumblrError(title: "", detail: "")
					handler(.failure(Error.tumblrError([tumblrError])))
				}
				return
			}
			
			guard let response = json["response"] as? [[String : Any]]
				else {
					handler(.failure(Error.noResponseKey))
					return
			}
			
			let tumblrPosts: [TumblrPost] = response.flatMap { TumblrPost(json: $0) }
			
			if tumblrPosts.count != response.count {
				print("Some of resulting posts can't be parsed")
			}
			
			handler(.success(tumblrPosts))
			
		}
		
		task.resume()
		
	}
	
}
