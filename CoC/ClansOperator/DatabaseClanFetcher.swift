//
//  DatabaseClanFetcher.swift
//  CoC
//
//  Created by Robin Somlette on 19-Dec-2016.
//  Copyright © 2016 Samsao. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import RxRealm

final class DatabaseClanFetcher: ClanFetcher {

	// MARK: Properties

	private let database: Database

	// MARK: Initialization

	init(database: Database = DatabaseManager()) {
		self.database = database
	}

	// Methods

	func get(name: String) -> Observable<[Clan]> {
		// Do something
		let predicate = NSPredicate(format: "name CONTAINS '\(name)'")
		guard let clans = database.fetchObjects(Clan.self, filter: predicate) else { return Observable<[Clan]>.empty() }
		return Observable.arrayFrom(clans)
	}

	func save(clans: [Clan]) -> Observable<[Clan]> {
		return Observable<[Clan]>.create({ [weak self] (observer) -> Disposable in
			clans.forEach({ (clan) in
				self?.database.update(object: clan)
			})

			observer.onNext(clans)
			observer.onCompleted()
			return Disposables.create()
		})

	}
}
