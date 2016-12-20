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
	private let network: Network

	// MARK: Initialization

	required init(decoratedFetcher: ClanFetcher, databaseFetcher: ClanFetcher = DatabaseClanFetcher(), network: Network = Network()) {
		self.decoratedFetcher = decoratedFetcher
		self.databaseFetcher = databaseFetcher
		self.network = network
	}

	// MARK: Fetcher

	func get(name: String) -> Observable<List<Clan>> {
	
	}



}
