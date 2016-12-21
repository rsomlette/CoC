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

final class NetworkClanFetcher: ClanFetcher {

	let network: Network
	
	init(network: Network = Network()) {
		self.network = network
	}

	func get(name: String) -> Observable<[Clan]> {
		return network.request(service: APIService.Clans(search: name))
					.mapObject(ClanContainer.self)
					.flatMapLatest { Observable.just($0.items.toArray()) } // TODO: Maybe a better way?
	}

	func save(clans: [Clan]) -> Observable<[Clan]> {
		return Observable.empty()
	}
}
