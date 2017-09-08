//
//  ImagesListViewController.swift
//  TumblrImages
//
//  Created by Vitalii Budnik on 9/7/17.
//  Copyright © 2017 Vitalii Budnik. All rights reserved.
//

import Foundation
import UIKit

internal class ImagesListViewController: UIViewController {
	
	fileprivate enum SegueIdentifier: String {
		case showImagePreview
	}
	
	private typealias DataSourceType = TubmlrImagesDataSource
	private typealias ImageLoader = ImagesDownloadManager
	
	@IBOutlet private weak var tableView: UITableView!
	@IBOutlet private weak var searchBar: UISearchBar!
	@IBOutlet fileprivate private(set) weak var stateView: ControllerStateView!
	
	private var dataSource: DataSourceType? {
		didSet {
			tableView.dataSource = dataSource
			tableView.reloadData()
		}
	}
	
	fileprivate let imageLoader: ImagesDownloadManagerProtocol = ImageLoader()
	
	override func awakeFromNib() {
		super.awakeFromNib()
		title = "Images list".localized()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.dataSource = self.dataSource
		
		configureTableView()
		
		stateView.state = .statusText("Enter tag to search".localized())
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if let selectedRowIndexPath = tableView.indexPathForSelectedRow {
			tableView.deselectRow(at: selectedRowIndexPath,
			                      animated: animated)
		}
		
	}
	
	private func configureTableView() {
		
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 62.0
		
		tableView.sectionHeaderHeight = UITableViewAutomaticDimension
		tableView.estimatedSectionHeaderHeight = 0.0
		
		tableView.sectionFooterHeight = UITableViewAutomaticDimension
		tableView.estimatedSectionFooterHeight = 0.0
		
		DataSourceType.registerCells(for: tableView)
		
	}
	
	private func hideStateView() {
		UIView.animate(withDuration: 0.3,
		               animations: {
										self.stateView.alpha = 0.0
		},
		               completion: { (_) in
			self.view.sendSubview(toBack: self.stateView)
		})
	}
	
	private func showStateView() {
		self.stateView.alpha = 0.0
		self.view.bringSubview(toFront: stateView)
		UIView.animate(withDuration: 0.3) {
			self.stateView.alpha = 1.0
		}
	}
	
	fileprivate func dowloadPosts(tagged tag: String) {
		
		stateView.state = .loading
		showStateView()
		dataSource = .none
		TumblrAPI.default().fetchImagesInfo(tagged: tag) { [weak self] (result) in
			guard let posts = result.value
				else {
					self?.stateView.state = .error(result.error!)
					self?.showStateView()
					return
			}
			self?.dataSource = DataSourceType(posts: posts)
			if posts.isEmpty {
				self?.stateView.state = .empty
				self?.showStateView()
			} else {
				self?.stateView.state = .statusText("One moment, please...".localized())
				self?.hideStateView()
			}
		}
		
	}
	
	// MARK: Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if
			let imagePreviewController = segue.destination as? ImagePreviewViewController,
			let indexPath = sender as? IndexPath
		{
			let data = dataSource!.data(at: indexPath)
			imagePreviewController.loadImage(at: data.url,
			                                 with: imageLoader)
		}
	}
	
}

// MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
	
	func tableView(
		_ tableView: UITableView,
		willDisplay cell: UITableViewCell,
		forRowAt indexPath: IndexPath)
	{
		
		guard let cell = cell as? PostWithImageTableViewCell
			else {
				return
		}
		
		cell.loadURL(using: self.imageLoader)
		
	}
	
	func tableView(
		_ tableView: UITableView,
		didSelectRowAt indexPath: IndexPath)
	{
		performSegue(withIdentifier: SegueIdentifier.showImagePreview.rawValue,
		             sender: indexPath)
	}
	
}

// MARK: - UISearchBarDelegate

extension ImagesListViewController: UISearchBarDelegate {
	
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		searchBar.setShowsCancelButton(false, animated: true)
	}
	
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		searchBar.setShowsCancelButton(true, animated: true)
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let tag = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines)
			else {
				return
		}
		dowloadPosts(tagged: tag)
		searchBar.resignFirstResponder()
	}
	
}
