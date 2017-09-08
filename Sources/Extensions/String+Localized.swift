//
//  String+Localized.swift
//  TumblrImages
//
//  Created by Vitalii Budnik on 9/8/17.
//  Copyright © 2017 Vitalii Budnik. All rights reserved.
//

import Foundation

extension String {
	
	func localized(
		using tableName: String = "Localized",
		in bundle: Bundle = .main,
		value: String? = .none,
		comment: String = "")
		-> String
	{
		return NSLocalizedString(self,
		                         tableName: tableName,
		                         bundle: bundle,
		                         value: value ?? self,
		                         comment: comment)
	}
	
}
