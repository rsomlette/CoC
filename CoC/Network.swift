//
//  Network.swift
//  CoC
//
//  Created by Robin Somlette on 12-Dec-2016.
//  Copyright © 2016 Samsao. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RealmSwift
import Moya_ObjectMapper
//import Moya_ModelMapper


struct Network {

	static func request(service: APIService) -> Observable<Response> {
		return RxMoyaProvider<APIService>(endpointClosure: endpointClosure, plugins: [plugins])
			.request(service)
			.debug("Moya")
	}
}

public let plugins = NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)

let endpointClosure = { (target: APIService) -> Endpoint<APIService> in
	let url = target.baseURL.appendingPathComponent(target.path).absoluteString
	var headers = ["Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiIsImtpZCI6IjI4YTMxOGY3LTAwMDAtYTFlYi03ZmExLTJjNzQzM2M2Y2NhNSJ9.eyJpc3MiOiJzdXBlcmNlbGwiLCJhdWQiOiJzdXBlcmNlbGw6Z2FtZWFwaSIsImp0aSI6ImIyYzZkYjU2LWQ4OTItNDIyYi05NDg1LTM2YzAyZjcyODZmYSIsImlhdCI6MTQ4MTI1NTg4Nywic3ViIjoiZGV2ZWxvcGVyL2EyNWY2ZjY2LWI1ZDctZmJjNi1kODkwLWI1MTI1NTJmMzJkZCIsInNjb3BlcyI6WyJjbGFzaCJdLCJsaW1pdHMiOlt7InRpZXIiOiJkZXZlbG9wZXIvc2lsdmVyIiwidHlwZSI6InRocm90dGxpbmcifSx7ImNpZHJzIjpbIjE4NC4xNjEuMTgzLjk0Il0sInR5cGUiOiJjbGllbnQifV19.DVGN9r5uHqRUVocbBx05rbf2P4QvhkeF_8LF2ggaXqvBZhDbzSRnWlRk9SxeFpXVyHWr4C2jmmxEyViUzaYY7w"]

	var endpoint: Endpoint<APIService> = Endpoint<APIService>(url: url, sampleResponseClosure: {
		.networkResponse(200, target.sampleData)
	}, method: target.method, parameters: target.parameters, parameterEncoding: URLEncoding.default, httpHeaderFields: headers)

//	endpoint = endpoint.adding(newParameterEncoding: JSONEncoding())
	return endpoint
}

private func JSONResponseDataFormatter(_ data: Data) -> Data {
	do {
		let dataAsJSON = try JSONSerialization.jsonObject(with: data)
		let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
		return prettyData
	} catch {
		return data //fallback to original data if it cant be serialized
	}
}
