//
//  NetworkHelpers.swift
//  imdbTop
//
//  Created by Vladyslav Demchenko on 25.11.2022.
//

import Foundation

typealias HTTPHeaders = [String: String]
typealias JSONParameters = [String: Any]

enum HTTPMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
}

struct APIResult<ResultType: Decodable>: Decodable {
    let results: ResultType
    let errorMessage: String?
}

protocol HTTPBody {
    func httpData() -> Data?
}

extension JSONParameters: HTTPBody {
    func httpData() -> Data? {
        try? JSONSerialization.data(withJSONObject: self, options: [])
    }
}

extension HTTPHeaders {
    static let defaultUserAgent: HTTPHeaders = {
        let info = Bundle.main.infoDictionary
        let executable = (info?[kCFBundleExecutableKey as String] as? String) ??
            (ProcessInfo.processInfo.arguments.first?.split(separator: "/").last.map(String.init)) ??
            "Unknown"
        let bundle = info?[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
        let appBuild = info?[kCFBundleVersionKey as String] as? String ?? "Unknown"

        let osNameVersion: String = {
            let version = ProcessInfo.processInfo.operatingSystemVersion
            let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
            let osName = "iOS"
            return "\(osName) \(versionString)"
        }()

        let userAgent = "\(bundle); build:\(appBuild); \(osNameVersion))"

        return ["User-Agent": userAgent]
    }()

    static let urlEncodedContentType = "application/x-www-form-urlencoded; charset=utf-8"
    static let jsonContentType = "application/json"
}
