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
	var provider: RxMoyaProvider<APIService>!
	var tempFetcher: TempFetcher!

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
		self.tempFetcher = TempFetcher()
		provider = RxMoyaProvider<APIService>(endpointClosure: endpointClosure, plugins: [plugins])
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
	}


	private func setupRx() {
		latestSearch.observeOn(MainScheduler.instance)
			.flatMapLatest({ (search) -> Observable<Response> in
				return self.provider.request(APIService.Clans(search: search))
//				return Network.request(service: APIService.Clans(search: search))
			})
			.mapObject(ClanContainer.self)
			.flatMapLatest { Observable<List<Clan>>.just($0.items) }
			.bindTo(tableView.rx.items(cellIdentifier: String(describing: UITableViewCell.self), cellType: UITableViewCell.self)) { row, element, cell in
				cell.textLabel?.text = element.name
			}
			.addDisposableTo(disposeBag)


		// Here we tell table view that if user clicks on a cell,
		// and the keyboard is still visible, hide it
//		tableView.rx
//
//			.subscribeNext { indexPath in
//				if self.searchBar.isFirstResponder() == true {
//					self.view.endEditing(true)
//				}
//			}
//			.addDisposableTo(disposeBag)

	}

}
