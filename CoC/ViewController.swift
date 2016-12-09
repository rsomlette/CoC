//
//  ViewController.swift
//  CoC
//
//  Created by Robin Somlette on 2016-12-09.
//  Copyright © 2016 Samsao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya
import RealmSwift

class ViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var searchBar: UISearchBar!

	let disposeBag = DisposeBag()
	var provider: RxMoyaProvider<APIService>!
	var tempFetcher: TempFetcher!

	var latestSearch: Observable<String> {
		return searchBar.rx
			.text.orEmpty
			.throttle(0.5, scheduler: MainScheduler.instance)
			.distinctUntilChanged()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		setupRx()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	private func setupRx() {
		provider = RxMoyaProvider<APIService>()

		tempFetcher = TempFetcher(provider: provider, clanName: latestSearch)

		tempFetcher.trackClans().map { return Observable.from($0.items) }
			.bindTo(tableView.rx.items(cellIdentifier: String(describing: UITableViewCell.self), cellType: UITableViewCell.self))
			{ row, element, cell in
				cell.textLabel?.text = element.name
			}.addDisposableTo(disposeBag)

		tableView.rx.itemSelected.subscribe { (indexPath) in
			if self.searchBar.isFirstResponder  {
				self.view.endEditing(true)
			}
			}.addDisposableTo(disposeBag)
	}

}

