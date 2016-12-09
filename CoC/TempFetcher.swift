//
//  TempFetcher.swift
//  CoC
//
//  Created by Robin Somlette on 2016-12-09.
//  Copyright © 2016 Samsao. All rights reserved.
//

import Foundation
import Moya
import Moya_ModelMapper
import RxOptional
import RxSwift

struct TempFetcher {

	let provider: RxMoyaProvider<APIService>
	let clanName: Observable<String>

	func trackClans() -> Observable<ClanContainer> {

		return clanName.observeOn(MainScheduler.instance)
			.flatMapLatest { search -> Observable<ClanContainer> in
				return self.findClans(search: search)
			}
	}

	func findClans(search: String) -> Observable<ClanContainer> {
		return self.provider
			.request(APIService.Clans(search: search))
			.debug()
			.mapObject(type: ClanContainer.self)
	}

//	func findRepository(name: String) -> Observable<Repository?> {
//		return self.provider
//			.request(APIService.Repo(fullName: name))
//			.debug()
//			.mapObjectOptional(type: Repository.self)
//	}
}
