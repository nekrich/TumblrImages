//
//  TumblrAPISource.swift
//  TumblrImages
//
//  Created by Vitalii Budnik on 9/7/17.
//  Copyright © 2017 Vitalii Budnik. All rights reserved.
//

import Foundation

internal struct TumblrAPISource: APISourceProtocol {
	
	let hostname: String
	let `protocol`: String
	let apiPath: String
	
	init?(`protocol`: String, hostname: String, apiPath: String) {
		
		guard URL(string: `protocol`
			.appending("://")
			.appending(hostname)) != .none
			else {
				return nil
		}
		
		self.protocol = `protocol`
		self.hostname = hostname
		self.apiPath = apiPath
		
	}
	
}
