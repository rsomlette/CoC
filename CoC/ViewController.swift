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
	}


	private func setupRx() { // TODO: Handle error
		latestSearch.observeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background)) //TODO: work more on the task priority.
			.flatMapLatest({ (search) -> Observable<Response> in
				return self.provider.request(service: APIService.Clans(search: search))
			})
			.mapObject(ClanContainer.self)
			.flatMapLatest { Observable<List<Clan>>.just($0.items) }
			.bindTo(tableView.rx.items(cellIdentifier: String(describing: UITableViewCell.self), cellType: UITableViewCell.self)) { row, element, cell in
				cell.textLabel?.text = element.name
			}
			.addDisposableTo(disposeBag)

	}

}
