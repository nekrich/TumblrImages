//
//  APISourceProtocol.swift
//  TumblrImages
//
//  Created by Vitalii Budnik on 9/7/17.
//  Copyright © 2017 Vitalii Budnik. All rights reserved.
//

import Foundation

internal protocol APISourceProtocol {
	
	var hostname: String { get }
	var `protocol`: String { get }
	var apiPath: String { get }
	var apiURL: URL { get }
	
	init?(`protocol`: String, hostname: String, apiPath: String)
	
}

extension APISourceProtocol {
	
	var apiURL: URL {
		return URL(string: `protocol`
			.appending("://")
			.appending(hostname))!
			.appendingPathComponent(apiPath)
	}
	
}
