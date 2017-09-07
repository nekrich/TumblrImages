//
//  TubmlrImagesDataSource.swift
//  TumblrImages
//
//  Created by Vitalii Budnik on 9/7/17.
//  Copyright © 2017 Vitalii Budnik. All rights reserved.
//

import Foundation
import UIKit

internal class TubmlrImagesDataSource: NSObject {
	
	class var cellIdentifier: String {
		return "TubmlrImagesCell"
	}
	
	typealias StoredData = (post: PostWithImagesURLsProtocol, url: URL)
	
	fileprivate let data: [StoredData]
	
	init(posts: [PostWithImagesURLsProtocol]) {
		self.data = posts
			.reduce([(PostWithImagesURLsProtocol, URL)]()) { (result, post) -> [(PostWithImagesURLsProtocol, URL)] in
				var result = result
				post.originalImagesURLsString.forEach {
					if let url = URL(string: $0) {
						result.append((post, url))
					}
				}
				return result
		}
		super.init()
	}
	
	@nonobjc
	class func registerCells(for tableView: UITableView) {
		tableView.register(PostWithImageTableViewCell.nib, forCellReuseIdentifier: self.cellIdentifier)
	}
	
	@nonobjc
	class func registerCells(for collectionView: UICollectionView) {
		
	}
	
	func data(at indexPath: IndexPath) -> StoredData {
		return data[indexPath.row]
	}
	
}

// MARK: - UITableViewDataSource

extension TubmlrImagesDataSource: UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(
		_ tableView: UITableView,
		numberOfRowsInSection section: Int)
		-> Int
	{
		switch section {
		case 0:
			return data.count
		default:
			return 0
		}
	}
	
	func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath)
		-> UITableViewCell
	{
		
		let cell = tableView.dequeueReusableCell(withIdentifier: type(of: self).cellIdentifier) as! PostWithImageTableViewCell
		
		let data = self.data(at: indexPath)
		cell.setImageURL(data.url, andPost: data.post)
		
		return cell
		
	}
	
}

//// MARK: - UICollectionViewDataSource
//
//extension TubmlrImagesDataSource: UICollectionViewDataSource {
//	
//	func numberOfSections(in collectionView: UICollectionView) -> Int {
//		return 1
//	}
//	
//	func collectionView(
//		_ collectionView: UICollectionView,
//		numberOfItemsInSection section: Int)
//		-> Int
//	{
//		switch section {
//		case 0:
//			return data.count
//		default:
//			return 0
//		}
//	}
//	
//	func collectionView(
//		_ collectionView: UICollectionView,
//		cellForItemAt indexPath: IndexPath)
//		-> UICollectionViewCell
//	{
//		return UICollectionViewCell()
//	}
//	
//}
