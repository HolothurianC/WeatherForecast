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
        configureUI()
    }
    
    private func configureUI() {
        title = "Weather Forecast"
        view.backgroundColor = .white
        weatherView = WeatherContentView(frame: .zero)
        view.addSubview(weatherView!)
        weatherView?.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    private func configureViewModel() {
        vm = WeatherViewModel(lives: { lives in
            
        }, forecast: {[weak self] forecasts in
            self?.weatherView?.vm = self?.vm
            self?.weatherView?.reloadData()
            self?.weatherView?.leftTableView.selectRow(at: IndexPath(row: 0, section: 0),
                                                      animated: true,
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
