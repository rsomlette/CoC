//
//  ClanContainer.swift
//  CoC
//
//  Created by Robin Somlette on 2016-12-09.
//  Copyright © 2016 Samsao. All rights reserved.
//

import Foundation
//import Mapper
import ObjectMapper
import RealmSwift

final class ClanContainer: Mappable {

	private(set) var items = List<Clan>()

	//MAPPER
//	convenience init(map: Mapper) throws {
//		self.init()
//		try items = map.from("items", transformation: Transform.transformToList<Clan>()) //, transformation: Transform
//	}

	//Object MAPPER
	required convenience init?(map: Map) {
		self.init()
	}

	func mapping(map: Map) {
		items <- (map["items"], transformation: RealmListTransform<Clan>())
	}


}
