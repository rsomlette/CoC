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


struct Network {

	static func request(service: APIService) -> Observable<ClanContainer> {
		return RxMoyaProvider<APIService>(endpointClosure: endpointClosure)
			.request(service)
			.debug("Moya")
			.flatMapLatest({ (response) -> Observable<ClanContainer> in
				return try response.mapObject(type: ClanContainer.self)
			})
	}
}


fileprivate let endpointClosure = { (target: APIService) -> Endpoint<APIService> in
	let url = target.baseURL.appendingPathComponent(target.path).absoluteString
	var endpoint: Endpoint<APIService> = Endpoint<APIService>(url: url, sampleResponseClosure: {
		.networkResponse(200, target.sampleData)
	}, method: target.method, parameters: target.parameters)

	var headers = ["Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiIsImtpZCI6IjI4YTMxOGY3LTAwMDAtYTFlYi03ZmExLTJjNzQzM2M2Y2NhNSJ9.eyJpc3MiOiJzdXBlcmNlbGwiLCJhdWQiOiJzdXBlcmNlbGw6Z2FtZWFwaSIsImp0aSI6ImEyMWMzNDhmLTc1ODYtNGE1Ny04NzliLTYwZjg3NmUzNjRmZiIsImlhdCI6MTQ4MTMwMjU1OSwic3ViIjoiZGV2ZWxvcGVyL2EyNWY2ZjY2LWI1ZDctZmJjNi1kODkwLWI1MTI1NTJmMzJkZCIsInNjb3BlcyI6WyJjbGFzaCJdLCJsaW1pdHMiOlt7InRpZXIiOiJkZXZlbG9wZXIvc2lsdmVyIiwidHlwZSI6InRocm90dGxpbmcifSx7ImNpZHJzIjpbIjE4NC4xNjEuMTguMTUzIl0sInR5cGUiOiJjbGllbnQifV19.YpHq4SJJbMddb_zMrjnFRJd50_wvTw3S_trGIq4GiR6AqLe55GdfFFC9w1e1uCkwLrujONc06faxoznCuhbmhQ"]

	endpoint = endpoint.adding(newParameterEncoding: JSONEncoding())
	return endpoint.adding(newHTTPHeaderFields: headers)
}
