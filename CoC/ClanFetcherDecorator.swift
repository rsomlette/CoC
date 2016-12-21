//
//  ClanFetcherDecorator.swift
//  CoC
//
//  Created by Robin Somlette on 19-Dec-2016.
//  Copyright © 2016 Samsao. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

final class ClanFetcherDecorator: ClanFetcher {

	// MARK: Properties

	private var databaseFetcher: ClanFetcher
	private var decoratedFetcher: ClanFetcher
	private let disposeBag = DisposeBag()

	// MARK: Initialization

	required init(decoratedFetcher: ClanFetcher, databaseFetcher: ClanFetcher = DatabaseClanFetcher()) {
		self.decoratedFetcher = decoratedFetcher
		self.databaseFetcher = databaseFetcher
	}

	// MARK: Fetcher

	func get(name: String) -> Observable<[Clan]> {
		decoratedFetcher.get(name: name)
				.flatMapLatest { [weak self] (clans) -> Observable<[Clan]> in
					guard let `self` = self else { return Observable.error(NetworkError.invalidNetwork(code: 0, message: "Self is not there")) }
					return self.databaseFetcher.save(clans: clans)
				}.subscribe()
				.addDisposableTo(disposeBag)

		return databaseFetcher.get(name: name)
	}

	func save(clans: [Clan]) -> Observable<[Clan]> {
		return Observable.error(NetworkError.invalidNetwork(code: 0, message: "Save is not implemented"))
	}

}
