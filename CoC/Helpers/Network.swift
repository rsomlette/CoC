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



// TODO: Organize this
struct Constants {
	static let samsaoKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiIsImtpZCI6IjI4YTMxOGY3LTAwMDAtYTFlYi03ZmExLTJjNzQzM2M2Y2NhNSJ9.eyJpc3MiOiJzdXBlcmNlbGwiLCJhdWQiOiJzdXBlcmNlbGw6Z2FtZWFwaSIsImp0aSI6ImEyMWMzNDhmLTc1ODYtNGE1Ny04NzliLTYwZjg3NmUzNjRmZiIsImlhdCI6MTQ4MTMwMjU1OSwic3ViIjoiZGV2ZWxvcGVyL2EyNWY2ZjY2LWI1ZDctZmJjNi1kODkwLWI1MTI1NTJmMzJkZCIsInNjb3BlcyI6WyJjbGFzaCJdLCJsaW1pdHMiOlt7InRpZXIiOiJkZXZlbG9wZXIvc2lsdmVyIiwidHlwZSI6InRocm90dGxpbmcifSx7ImNpZHJzIjpbIjE4NC4xNjEuMTguMTUzIl0sInR5cGUiOiJjbGllbnQifV19.YpHq4SJJbMddb_zMrjnFRJd50_wvTw3S_trGIq4GiR6AqLe55GdfFFC9w1e1uCkwLrujONc06faxoznCuhbmhQ"

	static let houseKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiIsImtpZCI6IjI4YTMxOGY3LTAwMDAtYTFlYi03ZmExLTJjNzQzM2M2Y2NhNSJ9.eyJpc3MiOiJzdXBlcmNlbGwiLCJhdWQiOiJzdXBlcmNlbGw6Z2FtZWFwaSIsImp0aSI6ImIyYzZkYjU2LWQ4OTItNDIyYi05NDg1LTM2YzAyZjcyODZmYSIsImlhdCI6MTQ4MTI1NTg4Nywic3ViIjoiZGV2ZWxvcGVyL2EyNWY2ZjY2LWI1ZDctZmJjNi1kODkwLWI1MTI1NTJmMzJkZCIsInNjb3BlcyI6WyJjbGFzaCJdLCJsaW1pdHMiOlt7InRpZXIiOiJkZXZlbG9wZXIvc2lsdmVyIiwidHlwZSI6InRocm90dGxpbmcifSx7ImNpZHJzIjpbIjE4NC4xNjEuMTgzLjk0Il0sInR5cGUiOiJjbGllbnQifV19.DVGN9r5uHqRUVocbBx05rbf2P4QvhkeF_8LF2ggaXqvBZhDbzSRnWlRk9SxeFpXVyHWr4C2jmmxEyViUzaYY7w"
}


struct Network {

	var provider: RxMoyaProvider<APIService>

	init(provider: RxMoyaProvider<APIService> = RxMoyaProvider<APIService>(endpointClosure: endpointClosure, plugins: [logger, activityPlugin])) {
		self.provider = provider
	}

	func request(service: APIService) -> Observable<Response> {
		return provider
			.request(service)
			.observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
			.do(onError: { (error) in
				debugPrint(error)
			})
			.flatMapLatest({ (response) -> Observable<Response> in
				switch response.statusCode {
				case 200...299:	return Observable<Response>.just(response)
				case 300...399:	return Observable<Response>.error(NetworkError.invalidNetwork(code: response.statusCode, message: String(data: response.data, encoding: String.Encoding.utf8)  ?? "No Message"))
				case 400...499:	return Observable<Response>.error(NetworkError.invalidNetwork(code: response.statusCode, message: String(data: response.data, encoding: String.Encoding.utf8)  ?? "No Message"))
				default: return Observable<Response>.error(NetworkError.invalidNetwork(code: response.statusCode, message: String(data: response.data, encoding: String.Encoding.utf8)  ?? "No Message"))
				}
			})
			.observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
			.debug("Moya")
	}
}

fileprivate let activityPlugin = NetworkActivityPlugin { (change) in
	switch change {
	case .began:
			UIApplication.shared.isNetworkActivityIndicatorVisible = true
	case .ended:
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
	}
}

public let logger = NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)

fileprivate let endpointClosure = { (target: APIService) -> Endpoint<APIService> in
	let url = target.baseURL.appendingPathComponent(target.path).absoluteString
	var headers = ["Authorization": "Bearer \(Constants.samsaoKey)"]

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
