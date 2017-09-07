//
//  PostWithImageView.swift
//  TumblrImages
//
//  Created by Vitalii Budnik on 9/7/17.
//  Copyright © 2017 Vitalii Budnik. All rights reserved.
//

import UIKit

internal class PostWithImageView: UIView, NibOwnerLoadable {

	override func awakeFromNib() {
		super.awakeFromNib()
		loadNibContent()
	}
	
	@IBOutlet private weak var imageView: UIImageView!
	@IBOutlet private weak var spinner: UIActivityIndicatorView!
	
	private var url: URL?
	
	func updateImageURL(_ url: URL?, downloader: ImagesDownloadManagerProtocol!) {
		
		guard let url = url
			else {
				imageView.image = .none
				spinner.stopAnimating()
				return
		}
		
		defer {
			imageView.image = .none
			spinner.startAnimating()
		}
		
		downloader.fetchImage(at: url) { [weak self] (result) in
			guard url == self?.url
				else {
					return
			}
			self?.spinner.stopAnimating()
			self?.imageView.image = result.value?.scaled(to: 300.0)
		}
		
		self.url = url
		
	}
	
}
