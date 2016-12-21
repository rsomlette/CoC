//
//  NetworkClanFetcher.swift
//  CoC
//
//  Created by Robin Somlette on 19-Dec-2016.
//  Copyright © 2016 Samsao. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import Moya
import Moya_ObjectMapper
import RxRealm
import RxCocoa

final class NetworkClanFetcher: ClanFetcher {

	private let network: Network
	lazy var clans: Driver<[Clan]> = self.get(name: "")
	
	init(network: Network = Network()) {
		self.network = network
	}

	func get(name: String) -> Driver<[Clan]> {
		return network.request(service: APIService.Clans(search: name))
					.observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
					.mapObject(ClanContainer.self)
					.catchError { _ in return Observable.never() }
					.flatMapLatest { Observable.just($0.items.toArray()) } // TODO: Maybe a better way?
					.asDriver(onErrorJustReturn: [])
	}

	func save(clans: [Clan]) -> Observable<[Clan]> {
		return Observable.empty()
	}
}
