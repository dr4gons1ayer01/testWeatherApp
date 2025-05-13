//
//  WeatherViewController.swift
//  testWeatherApp
//
//  Created by Иван Семенов on 13.05.2025.
//

import UIKit
import SwiftUI

final class WeatherViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contentView = WeatherView()
        
        let content = UIHostingController(rootView: contentView)
        addChild(content)
        content.view.frame = view.frame
        view.addSubview(content.view)
        content.didMove(toParent: self)
    }
}
