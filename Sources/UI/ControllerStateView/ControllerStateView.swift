//
//  ControllerStateView.swift
//  TumblrImages
//
//  Created by Vitalii Budnik on 9/7/17.
//  Copyright © 2017 Vitalii Budnik. All rights reserved.
//

import Foundation
import UIKit

internal class ControllerStateView: UIView, NibOwnerLoadable {
	
	@IBOutlet private weak var statusLabel: UILabel!
	@IBOutlet private weak var spinner: UIActivityIndicatorView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		loadNibContent()
		configureState()
	}
	
	enum State {
		case empty
		case error(Error)
		case loading
		case statusText(String)
	}
	
	var state: State = .empty {
		didSet {
			configureState()
		}
	}
	
	private func configureState() {
		switch state {
		case .empty:
			statusLabel.text = "No items to display"
			spinner.stopAnimating()
			break
		case let .error(error):
			spinner.stopAnimating()
			var text = error.localizedDescription.appending("\n")
			if let error = error as? LocalizedError {
				if let failureReason = error.failureReason {
					text.append(failureReason)
					text.append("\n")
				}
				if let recoverySuggestion = error.recoverySuggestion {
					text.append("\n")
					text.append(recoverySuggestion)
				}
			}
			statusLabel.text = text.trimmingCharacters(in: .whitespacesAndNewlines)
			break
		case .loading:
			spinner.startAnimating()
			statusLabel.text = "Loading, please wait"
			break
		case let .statusText(statusText):
			spinner.stopAnimating()
			statusLabel.text = statusText
			break
		}
	}
	
}
