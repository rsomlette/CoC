//
//  Clan.swift
//  CoC
//
//  Created by Robin Somlette on 2016-12-09.
//  Copyright © 2016 Samsao. All rights reserved.
//

import Foundation
import Mapper
import RealmSwift

final class Clan: Object, Mappable {

	private(set) dynamic var tag: String = ""
	private(set) dynamic var name: String = ""
	private(set) dynamic var clanLevel: Int = 0
	private(set) dynamic var clanPoints: Int = 0
	private(set) dynamic var members: Int = 0


	//MAPPER
	convenience init(map: Mapper) throws {
		self.init()
		try tag = map.from("tag")
		try name = map.from("name")
		try clanLevel = map.from("clanLevel")
		try clanPoints = map.from("clanPoints")
		try members = map.from("members")
	}
}
