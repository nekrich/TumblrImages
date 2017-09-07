//
//  NibOwnerLoadable.swift
//  TumblrImages
//
//  Created by Vitalii Budnik on 9/7/17.
//  Copyright © 2017 Vitalii Budnik. All rights reserved.
//

import UIKit

internal protocol NibOwnerLoadable: class {
	
	static var nib: UINib { get }
	
}

extension NibOwnerLoadable {
	
	static var nib: UINib {
		return UINib(nibName: String(describing: self),
		             bundle: Bundle(for: self))
	}
	
}

extension NibOwnerLoadable where Self: UIView {
	/**
	Adds content loaded from the nib to the end of the receiver's list of subviews and adds constraints automatically.
	*/
	func loadNibContent() {
		Self.nib.instantiate(withOwner: self, options: nil).forEach {
			guard let nibSubview = $0 as? UIView
				else {
					return
			}
			addSubviewAndLayouts(nibSubview)
		}
	}
	
}
