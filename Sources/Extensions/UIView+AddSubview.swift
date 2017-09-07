//
//  UIView+AddSubview.swift
//  TumblrImages
//
//  Created by Vitalii Budnik on 9/7/17.
//  Copyright © 2017 Vitalii Budnik. All rights reserved.
//

import UIKit

extension UIView {
	
	func addSubviewAndLayouts(_ subview: UIView) {
		self.addSubview(subview)
		subview.translatesAutoresizingMaskIntoConstraints = false
		addEqualSizeLayoutConstraints(for: subview, relatedTo: self)
	}
	
	private func addEqualSizeLayoutConstraints(
		for subview: UIView,
		relatedTo superview: UIView)
	{
		[NSLayoutAttribute](arrayLiteral: .top,
		                    .leading,
		                    .bottom,
		                    .trailing)
			.forEach { (attribute) in
				let constraint = NSLayoutConstraint(item: subview,
				                                    attribute: attribute,
				                                    relatedBy: .equal,
				                                    toItem: superview,
				                                    attribute: attribute,
				                                    multiplier: 1,
				                                    constant: 0.0)
				self.addConstraint(constraint)
		}
	}
	
}
