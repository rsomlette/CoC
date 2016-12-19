//
//  TempFetcher.swift
//  CoC
//
//  Created by Robin Somlette on 2016-12-09.
//  Copyright © 2016 Samsao. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RealmSwift

struct TempFetcher {

	let network = Network()
	let disposeBag = DisposeBag()

	func trackClans(name: String) -> Observable<List<Clan>> {
		return findRepository(name: name)
			.flatMapLatest({ (clans) -> Observable<List<Clan>> in
				Observable<List<Clan>>.just(clans.items)
			})
	}

	private func findRepository(name: String) -> Observable<ClanContainer> {
		return network.request(service: APIService.Clans(search: name))
			.debug()
			.mapObject(ClanContainer.self)
	}
}
