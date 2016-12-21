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
//import RxAlamofire
//import ObjectMapper
import Moya_ObjectMapper
//import Moya_ModelMapper
//import Alamofire
import RxRealm



class ViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var searchBar: UISearchBar!

	let disposeBag = DisposeBag()
	var provider: Network! // need to keep a reference to the network. will be implemented in the fetcher's init.
	var clanFetcher: ClanFetcher!
//	var tempFetcher: TempFetcher!

	var latestSearch: Observable<String> {
		return searchBar.rx
			.text.orEmpty
			.filter { $0.characters.count > 2 }
			.throttle(0.5, scheduler: MainScheduler.instance)
			.distinctUntilChanged()
	}


	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		setupRx()
//		self.tempFetcher = TempFetcher()
		provider = Network()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
		clanFetcher = ClanFetcherDecorator(decoratedFetcher: NetworkClanFetcher())
	}


	private func setupRx() { // TODO: Handle error
		latestSearch.subscribeOn(MainScheduler.instance) //TODO: work more on the task priority. ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background)
			.flatMapLatest({ [weak self](search) -> Driver<[Clan]> in
				guard let `self` = self else { return Driver.never() }
				return self.clanFetcher.get(name: search)
			})
			.observeOn(MainScheduler.instance)
			.asDriver(onErrorJustReturn: [])
			.drive(tableView.rx.items(cellIdentifier: String(describing: UITableViewCell.self), cellType: UITableViewCell.self)) { row, element, cell in
				cell.textLabel?.text = element.name
				cell.detailTextLabel?.text = "\(element.members) members"
			}
			.addDisposableTo(disposeBag)

	}

}
