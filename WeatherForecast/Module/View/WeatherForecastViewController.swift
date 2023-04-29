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
        vm = WeatherViewModel(success: { successMsg in
            PrintLog(message: successMsg)
        }, failure: { errorMsg in
            PrintLog(message: errorMsg)
        })
        vm?.loadDataSource("base")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let index = arc4random() % 6
        vm?.selectIndex = Int(index)
        vm?.loadDataSource(index > 0 ? "all": "base")
    }

}
