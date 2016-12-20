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

	func get(name: String, provider: RxMoyaProvider<APIService>) -> Observable<List<Clan>> {
		provider.request(service: APIService.Clans(search: name))
			.mapObject(ClanContainer.self)
			.flatMapLatest { Observable<List<Clan>>.just($0.items) }
	}
}
