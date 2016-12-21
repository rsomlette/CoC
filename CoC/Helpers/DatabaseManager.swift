//
//  DatabaseHelper.swift
//  CoC
//
//  Created by Kenza Iraki on 2016-11-14.
//  Copyright © 2016 Samsao. All rights reserved.
//

import Foundation
import RealmSwift

protocol Database {
	func create(object: Object)
	func update(object: Object)
	func update<T: Object>(_ type: T.Type, values: [String: Any?])
//	func delete(object: Object)
	func fetchObjects<T: Object>(_ type: T.Type, filter: NSPredicate?) -> Results<T>?
	func fetchObject<T: Object>(_ type: T.Type) -> T?
	func fetchObject<T: Object>(type: T.Type, id: Any) -> T?
	func deleteAll()
}

final class DatabaseManager: Database {
	typealias Data = Object

	private let realm = try? Realm()

	func create(object: Data) {
		do {
			try realm?.write {
				realm?.add(object)
			}
		} catch {
			// TODO: handle error ⚠️
		}
	}

	func update(object: Data) {
		do {
			try realm?.write {
				realm?.add(object, update: true)
			}
		} catch {
			// TODO: handle error ⚠️
		}
	}

	func update<T: Object>(_ type: T.Type, values: [String: Any?]) {
		do {
			try realm?.write {
				realm?.create(type, value: values, update: true)
			}
		} catch {
			// TODO: handle error ⚠️
		}
	}

//	func delete(object: Data) {
//		do {
//			try realm?.write {
//				// TODO: this is HOTFIX 🔥 should be a protocol that all objects conforms to
//				if let data = object as? FlightDetail {
//					for subObjects in data.cascadeDelete() {
//						if let sub = subObjects {
//							realm?.delete(sub)
//						}
//					}
//				}
//				realm?.delete(object)
//			}
//		} catch {
//			// TODO: handle error ⚠️
//		}
//	}

	func deleteAll() {
		do {
			try realm?.write {
				realm?.deleteAll()
			}
		} catch {
			// TODO: handle error ⚠️
		}
	}

	func fetchObjects<T: Object>(_ type: T.Type, filter: NSPredicate?) -> Results<T>? {
		if let filter = filter {
			return realm?.objects(type).filter(filter)
		} else {
			return realm?.objects(type)
		}
	}

	func fetchObject<T: Object>(_ type: T.Type) -> T? {
		return realm?.objects(type).first
	}

	func fetchObject<T: Object>(type: T.Type, id: Any) -> T? {
		return realm?.object(ofType: type, forPrimaryKey: id)
	}
}
