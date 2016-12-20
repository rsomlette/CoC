//
//  ClanFetcherProtocol.swift
//  CoC
//
//  Created by Robin Somlette on 19-Dec-2016.
//  Copyright © 2016 Samsao. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

protocol ClanFetcher {
	func get(name: String) -> Observable<List<Clan>>
}
