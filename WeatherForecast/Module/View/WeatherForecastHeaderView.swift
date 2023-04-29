//
//  WeatherForecastHeaderView.swift
//  WeatherForecast
//
//  Created by Holothurian on 2023/4/29.
//

import UIKit

class WeatherForecastHeaderView: UITableViewHeaderFooterView {
    var cityLabel       = UILabel(frame: .zero)
    var reportTimeLabel = UILabel(frame: .zero)
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubview(cityLabel)
        addSubview(reportTimeLabel)
        cityLabel.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.centerX.equalToSuperview()
        }
        reportTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
    
    func configureView(vm: WeatherViewModel) {
        if vm.selectIndex < (vm.forecastModels?.count ?? 0),let model = vm.forecastModels?[vm.selectIndex].first {
            cityLabel.text       = "城市: "+(model.city ?? "")
            reportTimeLabel.text = "报告时间: "+(model.reporttime ?? "")
        }
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
