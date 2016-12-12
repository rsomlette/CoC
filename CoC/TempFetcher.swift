//
//  TempFetcher.swift
//  CoC
//
//  Created by Robin Somlette on 2016-12-09.
//  Copyright © 2016 Samsao. All rights reserved.
//

import Foundation
import Moya
//import Moya_ModelMapper
import Moya_ObjectMapper
import RxOptional
import RxSwift

struct TempFetcher {

	let provider: RxMoyaProvider<APIService>
	let clanName: Observable<String>
	let disposeBag = DisposeBag()

	func trackClans() -> Observable<[Clan]> {
		return Observable<[Clan]>.create({ (observer) -> Disposable in

			self.clanName.observeOn(MainScheduler.instance)
				.flatMapLatest { search -> Observable<Any> in
					return self.findClans(search: search).map
				}.flatMapLatest { data -> _ in// (data) -> Clan in
					guard let data = data as? ClanContainer else { return Observable.empty() }
					guard let clans = data.items else { return Observable.empty() }
					observer.onNext(clans)
					return O

				}

			return Disposables.create()
		})
	}

	func findClans(search: String) -> Observable<ClanContainer> {
		return Observable<ClanContainer>.create({ (observer) -> Disposable in
			self.provider
				.request(APIService.Clans(search: search))
				.debug()

//				.mapArrayOptional(ClanContainer.self)
				.do(onNext: { (element) in
					let data = try element.mapObject(ClanContainer.self)
					observer.onNext(data)
				}, onError: { (error) in
					observer.onError(error)
				}, onCompleted: {
					observer.onCompleted()
				})
//				.mapJSON()
//				.flatMapLatest({ (data) -> Observable<ClanContainer> in
//					guard let data = data as? ClanContainer else { return Observable<ClanContainer>.error(NetworkError.invalidNetwork) }
//					observer.onNext(data)
//
//				})
//			.map { (response) -> Response in
//				observer.onNext(response.data as? ClanContainer ?? nil)
//				return response
//			}
			return Disposables.create()
//				.subscribe({ (event) in
//					switch event {
//					case .next(let element): return observer.onNext(element.mapObject(ClanContainer.self))
//					case .error(let error): return observer.onError(error)
//					case .completed: return observer.onCompleted()
//					}
//				})
		})
//			self.provider
//			.request(APIService.Clans(search: search))
//			.debug()
////			.subscribe({ (event) in
////				switch event {
////					case .next
////				}
////			})
//			.subscribe(onNext: { (response) in
//				dump(response)
//			}, onError: { (error) in
//				print(error)
//			}, onCompleted: { 
//				print("Completed")
//			}, onDisposed: { 
//				print("Disposed")
//			}).addDisposableTo(disposeBag)
////			.debug()
////			.mapObject(type: ClanContainer.self)
//		return Observable<ClanContainer>.error(NetworkError.invalidNetwork)
	}

//	func findRepository(name: String) -> Observable<Repository?> {
//		return self.provider
//			.request(APIService.Repo(fullName: name))
//			.debug()
//			.mapObjectOptional(type: Repository.self)
//	}
}
