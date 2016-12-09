//
//  ClanContainer.swift
//  CoC
//
//  Created by Robin Somlette on 2016-12-09.
//  Copyright © 2016 Samsao. All rights reserved.
//

import Foundation
import Mapper
import RealmSwift

final class ClanContainer: Mappable {

	private(set) var items = [Clan]()

	//MAPPER
	convenience init(map: Mapper) throws {
		self.init()
		try items = map.from("items")
	}
}
