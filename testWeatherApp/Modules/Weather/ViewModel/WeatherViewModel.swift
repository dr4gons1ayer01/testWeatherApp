//
//  WeatherViewModel.swift
//  testWeatherApp
//
//  Created by Иван Семенов on 13.05.2025.
//

import Foundation
import Combine
import CoreLocation

final class WeatherViewModel: ObservableObject {
    @Published var cityName = "Moscow"
    @Published var currentWeather: CurrentWeatherResponse?
    @Published var forecast: ForecastResponse?
    @Published var hourlyForecast: [ForecastResponse.Hour] = []

    private let locationManager = LocationManager()
    private var cancellables = Set<AnyCancellable>()

    init() {
        locationManager.requestLocation()
        ///subscription for successful
        locationManager.$location
            .compactMap { $0 }
            .first()
            .sink { [weak self] location in
                let coordinates = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
                self?.fetchWeather(for: coordinates)
            }
            .store(in: &cancellables)

        ///fallback to "Moscow"
        locationManager.$authorizationStatus
            .sink { [weak self] status in
                guard let self else { return }
                if status == .denied || status == .restricted {
                    self.fetchWeather(for: "Moscow")
                }
            }
            .store(in: &cancellables)
    }

    func fetchWeather(for query: String) {
        Task {
            do {
                let weather = try await NetworkService.shared.getCurrentWeather(city: query)
                let forecastData = try await NetworkService.shared.getForecast(city: query)

                await MainActor.run {
                    self.currentWeather = weather
                    self.forecast = forecastData
                    self.cityName = ""
                    self.extractHourlyForecast(from: forecastData)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    private func extractHourlyForecast(from forecast: ForecastResponse) {
        let now = Date()
        ///day 1: current time
        let todayHours = forecast.forecast.forecastday.first?.hour.filter {
            $0.date.map { $0 > now } ?? false
        } ?? []
        ///day 2: all time
        let tomorrowHours = forecast.forecast.forecastday.dropFirst().first?.hour ?? []
        self.hourlyForecast = todayHours + tomorrowHours
    }
}
