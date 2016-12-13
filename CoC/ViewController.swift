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
//	var tempFetcher: TempFetcher!

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
//		provider = RxMoyaProvider<APIService>(endpointClosure: endpointClosure)
////		provider = RxMoyaProvider<APIService>()
//		tempFetcher = TempFetcher(provider: provider, clanName: latestSearch)
//
//		tempFetcher.trackClans().subscribe(onNext: { print($0)
//		}, onError: { (error) in
//			print(error)
//		}, onCompleted: {
//			print("Completed")
//		}, onDisposed: {
//			print("Disposed")
//		}).addDisposableTo(disposeBag)
//
//		searchBar.delegate = self
//
		latestSearch.debug("latesthe").flatMapLatest { (search) -> Observable<Response> in
			return Network.request(service: APIService.Clans(search: search))
		}.subscribe(onNext: { (response) in
			print(response)
		}, onError: { (error) in
			debugPrint(error)
		}, onCompleted: {
			debugPrint("Completed")
		}, onDisposed: {
			debugPrint("Disposed")
		}).addDisposableTo(disposeBag)


//		tempFetcher.findClans(search: searchBar.text ?? "").debug().subscribe().addDisposableTo(disposeBag)
//		tempFetcher.trackClans()
//			.bindTo(tableView.rx.items(cellIdentifier: String(describing: UITableViewCell.self), cellType: UITableViewCell.self))
//			{ row, element, cell in
//				cell.textLabel?.text = element.name
//			}.addDisposableTo(disposeBag)

		tableView.rx.itemSelected.subscribe { (indexPath) in
			if self.searchBar.isFirstResponder  {
				self.view.endEditing(true)
			}
			}.addDisposableTo(disposeBag)
	}

//	fileprivate let endpointClosure = { (target: APIService) -> Endpoint<APIService> in
//		let url = target.baseURL.appendingPathComponent(target.path).absoluteString
//		var endpoint: Endpoint<APIService> = Endpoint<APIService>(url: url, sampleResponseClosure: {
//			.networkResponse(200, target.sampleData)
//		}, method: target.method, parameters: target.parameters)
//
//		var headers = ["Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiIsImtpZCI6IjI4YTMxOGY3LTAwMDAtYTFlYi03ZmExLTJjNzQzM2M2Y2NhNSJ9.eyJpc3MiOiJzdXBlcmNlbGwiLCJhdWQiOiJzdXBlcmNlbGw6Z2FtZWFwaSIsImp0aSI6ImEyMWMzNDhmLTc1ODYtNGE1Ny04NzliLTYwZjg3NmUzNjRmZiIsImlhdCI6MTQ4MTMwMjU1OSwic3ViIjoiZGV2ZWxvcGVyL2EyNWY2ZjY2LWI1ZDctZmJjNi1kODkwLWI1MTI1NTJmMzJkZCIsInNjb3BlcyI6WyJjbGFzaCJdLCJsaW1pdHMiOlt7InRpZXIiOiJkZXZlbG9wZXIvc2lsdmVyIiwidHlwZSI6InRocm90dGxpbmcifSx7ImNpZHJzIjpbIjE4NC4xNjEuMTguMTUzIl0sInR5cGUiOiJjbGllbnQifV19.YpHq4SJJbMddb_zMrjnFRJd50_wvTw3S_trGIq4GiR6AqLe55GdfFFC9w1e1uCkwLrujONc06faxoznCuhbmhQ"]
//
//		endpoint = endpoint.adding(newParameterEncoding: JSONEncoding())
//		return endpoint.adding(newHTTPHeaderFields: headers)
//	}

}

extension ViewController: UISearchBarDelegate {
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

	}
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//		tempFetcher.findClans(search: searchBar.text ?? "").debug().subscribe().addDisposableTo(disposeBag)
	}
}

