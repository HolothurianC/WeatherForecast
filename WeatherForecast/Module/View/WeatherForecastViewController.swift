//
//  WeatherForecastViewController.swift
//  WeatherForecast
//
//  Created by Holothurian on 2023/4/29.
//

import UIKit

class WeatherForecastViewController: UIViewController {
    var vm: WeatherViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        configureViewModel()
    }
    
    private func configureViewModel() {
        vm = WeatherViewModel(lives: { lives in
            
        }, forecast: { forecasts in
            
        }, failure: { errorMsg in
            PrintLog(message: errorMsg)
        })
        vm?.mergeConcurrency()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }

}
