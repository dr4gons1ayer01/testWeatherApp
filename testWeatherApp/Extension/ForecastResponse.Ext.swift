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
