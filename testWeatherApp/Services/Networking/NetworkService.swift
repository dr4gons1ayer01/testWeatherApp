//
//  NetworkService.swift
//  testWeatherApp
//
//  Created by Иван Семенов on 13.05.2025.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case badRequest
    case badResponse
    case errorDecoding
}

final class NetworkService {
    static let shared = NetworkService(); private init() { }
    
    func getCurrentWeather(city: String) async throws -> CurrentWeatherResponse {
        guard let url = URLManager.shared.createURL(endpoint: .currentWeather, query: city) else {
            throw NetworkError.badUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.badResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(CurrentWeatherResponse.self, from: data)
        } catch {
            throw NetworkError.errorDecoding
        }
    }
    
    func getForecast(city: String, days: Int = 7) async throws -> ForecastResponse {
        guard let url = URLManager.shared.createURL(endpoint: .forecast, query: city, days: days) else {
            throw NetworkError.badUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.badResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(ForecastResponse.self, from: data)
        } catch {
            throw NetworkError.errorDecoding
        }
    }
}
