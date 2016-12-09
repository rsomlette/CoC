//
//  RealmListTransform.swift
//  CoC
//
//  Created by Robin Somlette on 2016-12-09.
//  Copyright © 2016 Samsao. All rights reserved.
//

import UIKit
import RealmSwift
import Mapper
//import ObjectMapper

//
//extension Transform {
//
//	public static func toList<T>() -> (_ object: Any) throws -> List<T> where T: Mappable
//	{
//		return { object in
//			guard let objects = object as? [String: Any] else {
//				throw MapperError.convertibleError(value: object, type: [Dictionary].self)
//			}
//
//			var result = List<T>()
//			for entry in objects {
//				let model = try T(map: Mapper(JSON: entry))
//				result.append(model)
//			}
////			var dictionary: [U: T] = [:]
////			for object in objects {
////				let model = try T(map: Mapper(JSON: object))
////				dictionary[getKey(model)] = model
////			}
//
//			return result
//		}
//	}
//}
//

//
//
//class RealmListTransform<T: Object>: TransformType where T: Mappable {
//
//	typealias Object = List<T>
//	typealias JSON = [[String: Any]]
//
//	let mapper = Mapper<T>()
//
//	func transformFromJSON(_ value: Any?) -> List<T>? {
//		let result = List<T>()
//		if let tempArr = value as? [Any] {
//			for entry in tempArr {
//				let mapper = Mapper<T>()
//				let model: T = mapper.map(JSONObject: entry)!
//				result.append(model)
//			}
//		}
//		return result
//	}
//
//	func transformToJSON(_ value: Object?) -> JSON? {
//		var results = [[String: Any]]()
//		if let value = value {
//			for obj in value {
//				let json = mapper.toJSON(obj)
//				results.append(json)
//			}
//		}
//		return results
//	}
//}
