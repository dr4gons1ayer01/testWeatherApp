//
//  SearchBarView.swift
//  testWeatherApp
//
//  Created by Иван Семенов on 13.05.2025.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var cityName: String
    var onSearch: () -> Void

    var body: some View {
        HStack(spacing: 20) {
            TextField("Введите город", text: $cityName)
                .padding(8)
                .background(.white)
                .cornerRadius(8)
                .font(FontManager.bold)
                .submitLabel(.search)
                .onSubmit {
                    onSearch()
                }

            if !cityName.isEmpty {
                Button("Найти") {
                    onSearch()
                }
                .font(FontManager.bold)
                .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 10)
    }
}
