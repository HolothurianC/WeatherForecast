//
//  WeatherForecastViewController.swift
//  WeatherForecast
//
//  Created by Holothurian on 2023/4/29.
//

import UIKit

class WeatherForecastViewController: UIViewController {
    var vm: WeatherViewModel?
    var weatherView: WeatherContentView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
    }
    override func loadView() {
        title = "Weather Forecast"
        weatherView = WeatherContentView(frame: .zero)
        view = weatherView
    }

    private func configureViewModel() {
        vm = WeatherViewModel(lives: { lives in
            
        }, forecast: {[weak self] forecasts in
            self?.weatherView?.vm = self?.vm
            self?.weatherView?.reloadData()
            self?.weatherView?.leftTableView.selectRow(at: IndexPath(row: 0, section: 0),
                                                      animated: false,
                                                      scrollPosition: .top)
        }, failure: { errorMsg in
            PrintLog(message: errorMsg)
        }, indexPath: { [weak self]indexPath in
            self?.vm?.selectIndex = indexPath.row
            self?.weatherView?.rightTableView.reloadData()
        })
        vm?.mergeConcurrency()
        
    }
}
