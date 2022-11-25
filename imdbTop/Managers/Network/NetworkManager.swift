//
//  NetworkManager.swift
//  imdbTop
//
//  Created by Vlada Kemskaya on 25.11.2022.
//

import Combine
import Foundation

final class NetworkManager {
    private enum Constants {
        static let retryCount = 2
    }
    private static let session = URLSession.shared
    
    private static var jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        return jsonDecoder
    }()
    
    func makeRequest<ResultType: Decodable>(method: HTTPMethod, endpoint: Endpoint, body: HTTPBody?)
    -> AnyPublisher<ResultType, Error> {
        var urlRequest = endpoint.asURLRequest()
        var defaultHeaders = HTTPHeaders.defaultUserAgent
        defaultHeaders["Content-Type"] = method == .get ?
            HTTPHeaders.urlEncodedContentType : HTTPHeaders.jsonContentType
        urlRequest.allHTTPHeaderFields = defaultHeaders
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = body?.httpData()

        return Self.session.dataTaskPublisher(for: urlRequest)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .tryMap {
                try Self.jsonDecoder.decode(APIResult<ResultType>.self, from: $0).results
            }
            .eraseToAnyPublisher()
    }
}
