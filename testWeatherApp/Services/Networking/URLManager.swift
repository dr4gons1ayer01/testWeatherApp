//
//  URLManager.swift
//  testWeatherApp
//
//  Created by Иван Семенов on 13.05.2025.
//

import Foundation

enum Endpoint: String {
    case currentWeather = "current.json"
    case forecast = "forecast.json"
}

//http://api.weatherapi.com/v1/current.json?key=fa8b3df74d4042b9aa7135114252304&q=LAT,LON
//http://api.weatherapi.com/v1/forecast.json?key=fa8b3df74d4042b9aa7135114252304&q=LAT,LON&days=7

final class URLManager {
    static let shared = URLManager(); private init() { }
    
    private let scheme = "https"
    private let host = "api.weatherapi.com"
    private let pathPrefix = "/v1"
    private let apiKey = "fa8b3df74d4042b9aa7135114252304"
    
    func createURL(endpoint: Endpoint, query: String, days: Int? = nil) -> URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = pathPrefix + "/" + endpoint.rawValue
        
        var queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "lang", value: "ru")
        ]
        
        if endpoint == .forecast, let days = days {
            queryItems.append(URLQueryItem(name: "days", value: "\(days)"))
        }
        
        components.queryItems = queryItems
        print("Component URL: \(String(describing: components.url))")
        return components.url
    }
}
