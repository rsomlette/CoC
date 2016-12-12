//
//  APIService.swift
//  CoC
//
//  Created by Robin Somlette on 2016-12-09.
//  Copyright © 2016 Samsao. All rights reserved.
//

import Foundation
import Moya

private extension String {
	var URLEscapedString: String {
		return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
	}
}

enum APIService {
	case Clans(search: String)
}

extension APIService: TargetType {
	var baseURL: URL { return URL(string: "https://api.clashofclans.com/v1")! }

	var path: String {
		switch self {
		case .Clans: return "/clans"
		}
	}

	var method: Moya.Method {
		return .get
	}

	var parameters: [String: Any]? {
		switch self {
		case .Clans(let search): return ["name": search]
		}
	}

	var sampleData: Data {
		switch self {
		case .Clans: return stubbedResponse(filename: "Clans")
		}
	}

	var task: Task {
		switch self {
		default: return .request
		}
	}
}

fileprivate func stubbedResponse(filename: String) -> Data! {
    @objc class TestClass: NSObject {}

    let bundle = Bundle(for: TestClass.self)
    let path = bundle.path(forResource: filename, ofType: "json")!
    return NSData(contentsOfFile: path) as Data!
}
