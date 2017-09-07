//
//  PostWithImageTableViewCell.swift
//  TumblrImages
//
//  Created by Vitalii Budnik on 9/7/17.
//  Copyright © 2017 Vitalii Budnik. All rights reserved.
//

import UIKit

internal class PostWithImageTableViewCell: UITableViewCell {
	
	class var nib: UINib {
		return UINib(nibName: String(describing: self),
		             bundle: Bundle(for: self))
	}
	
	@IBOutlet private weak var postWithImageView: PostWithImageView!
	
	override func prepareForReuse() {
		super.prepareForReuse()
		self.url = .none
		self.post = .none
		postWithImageView.updateImageURL(.none, downloader: .none)
	}
	
	private var url: URL?
	private var post: PostWithImagesURLsProtocol?
	func setImageURL(_ url: URL, andPost post: PostWithImagesURLsProtocol) {
		self.url = url
		self.post = post
	}
	
	func loadURL(using imagesDownloader: ImagesDownloadManagerProtocol) {
		postWithImageView.updateImageURL(url, downloader: imagesDownloader)
	}
	
}
