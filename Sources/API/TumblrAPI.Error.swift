//
//  TumblrAPI.Error.swift
//  TumblrImages
//
//  Created by Vitalii Budnik on 9/7/17.
//  Copyright © 2017 Vitalii Budnik. All rights reserved.
//

import Foundation

extension TumblrAPI {
	
	enum Error: Swift.Error, LocalizedError {
		
		case cantBuildURL
		case noDataInResponse
		case responseIsNotAValidDictionary
		case noResponseKey
		case tumblrError([TumblrError])
		
		var errorDescription: String? {
			switch self {
			case .cantBuildURL,
			     .noDataInResponse,
			     .responseIsNotAValidDictionary,
			     .noResponseKey:
				
				let key = String(describing: self)
					.appending(".Description")
				
				return key
					.localized(using: String(reflecting: type(of: self)))
				
			case let .tumblrError(tumblrError):
				return tumblrError.first?.errorDescription
			}
		}
		
		var failureReason: String? {
			switch self {
			case .cantBuildURL,
			     .noDataInResponse,
			     .responseIsNotAValidDictionary,
			     .noResponseKey:
				
				let key = String(describing: self)
					.appending(".FailureReason")
				
				return key
					.localized(using: String(reflecting: type(of: self)))
				
			case let .tumblrError(tumblrError):
				return tumblrError.first?.failureReason
			}
		}
	}
	
}

extension TumblrAPI.Error {
	
	struct TumblrError: Swift.Error, LocalizedError {
		
		let title: String
		let detail: String
		
		init?(json: [String : String]) {
			guard
				let title = json["title"],
				let detail = json["detail"]
				else {
					return nil
			}
			self.init(title: title, detail: detail)
		}
		
		init(title: String, detail: String) {
			self.title = title
			self.detail = detail
		}
		
		var errorDescription: String? {
			return title
		}
		
		var failureReason: String? {
			return detail
		}
		
	}
	
}
