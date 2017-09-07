//
//  ImagePreviewViewController.swift
//  TumblrImages
//
//  Created by Vitalii Budnik on 9/7/17.
//  Copyright © 2017 Vitalii Budnik. All rights reserved.
//

import Foundation
import UIKit

internal class ImagePreviewViewController: UIViewController {
	
	@IBOutlet private weak var imageView: UIImageView!
	@IBOutlet private weak var spinner: UIActivityIndicatorView!
	var image: UIImage? {
		didSet {
			if isViewLoaded {
				imageView.image = image
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		imageView.image = image
		if image != .none {
			spinner.stopAnimating()
		}
	}
	
	func loadImage(
		at url: URL,
		with loader: ImagesDownloadManagerProtocol)
	{
		image = .none
		if isViewLoaded {
			spinner.startAnimating()
		}
		loader.fetchImage(at: url) { [weak self] (result) in
			if self?.isViewLoaded ?? false {
				self?.spinner.stopAnimating()
			}
			self?.image = result.value
			if result.isFailure {
				self?.showError(result.error!)
			}
		}
		
	}
	
	private func showError(_ error: Error) {
		
		let error = error as NSError
		
		let message = error.localizedRecoverySuggestion ?? error.localizedFailureReason
		let alert = UIAlertController(title: error.localizedDescription,
		                              message: message,
		                              preferredStyle: .alert)
		
		alert.addAction(UIAlertAction(title: "CLOSE".localized(),
		                              style: .cancel,
		                              handler: .none))
		
		present(alert, animated: true, completion: .none)
		
	}
	
}
