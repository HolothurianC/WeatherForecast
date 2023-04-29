//
//  WeatherContentView.swift
//  WeatherForecast
//
//  Created by Holothurian on 2023/4/29.
//

import UIKit

class WeatherContentView: UIView {
    var vm: WeatherViewModel?
    let equalWidth             = ScreenWidth/4.0
    let TableCellIdentifier    = "TableViewCellIdentifier"
    let ForecastCellIdentifier = "ForecastCellIdentifier"
    var leftTableView          = UITableView(frame: .zero, style: .plain)
    var rightTableView         = UITableView(frame: .zero, style: .plain)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    func configureUI() {
        leftTableView.delegate   = self
        leftTableView.dataSource = self
        addSubview(leftTableView)
        leftTableView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(equalWidth)
        }
        rightTableView.delegate   = self
        rightTableView.dataSource = self
        addSubview(rightTableView)
        rightTableView.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(equalWidth * 3.0)
        }
        
        leftTableView.register(UITableViewCell.self, forCellReuseIdentifier: TableCellIdentifier)
        rightTableView.register(WeatherForecastTableCell.self, forCellReuseIdentifier: ForecastCellIdentifier)
        
    }
    
    func reloadData() {
        leftTableView.reloadData()
        rightTableView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WeatherContentView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == leftTableView {
            return vm?.weatherCity.count ?? 0
        } else if tableView == rightTableView {
            if (vm?.selectIndex ?? 0) < vm?.forecastModels?.count ?? 0 {
                return ((vm?.forecastModels?[vm?.selectIndex ?? 0])?.first?.casts ?? []).count
            }
            return 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == leftTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableCellIdentifier) else { return UITableViewCell()}
            cell.textLabel?.text      = vm?.weatherCity[indexPath.row] ?? ""
            cell.textLabel?.textColor = .black
            cell.textLabel?.font      = .systemFont(ofSize: 20)
            cell.textLabel?.textAlignment = .center
            return cell
        } else if tableView == rightTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ForecastCellIdentifier) as? WeatherForecastTableCell else { return UITableViewCell()}
            cell.configureViaModel(vm: vm, indexPath: indexPath)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == leftTableView {
            return 150
        } else if tableView == rightTableView {
            return 145
        }
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == leftTableView {
            vm?.didSelectIndex?(indexPath)
        } else if tableView == rightTableView {
            
        }
    }
}
