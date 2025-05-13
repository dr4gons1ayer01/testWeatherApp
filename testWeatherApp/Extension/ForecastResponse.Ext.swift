//
//  ForecastResponse.Ext.swift
//  testWeatherApp
//
//  Created by Иван Семенов on 13.05.2025.
//

import Foundation

extension ForecastResponse.Hour {
    var date: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.date(from: self.time)
    }

    var hourString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        return formatter.string(from: self.date ?? Date())
    }
}

extension ForecastResponse.ForecastDay {
    var weekdayShort: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "E"
        guard let date = DateFormatter.yyyyMMdd.date(from: self.date) else { return "—" }
        return formatter.string(from: date).capitalized
    }

    var minTemp: Int {
        hour.map { Int($0.tempC) }.min() ?? 0
    }

    var maxTemp: Int {
        hour.map { Int($0.tempC) }.max() ?? 0
    }
}
