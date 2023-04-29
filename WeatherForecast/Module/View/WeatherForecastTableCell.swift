//
//  WeatherForecastTableCell.swift
//  WeatherForecast
//
//  Created by Holothurian on 2023/4/29.
//

import UIKit

class WeatherForecastTableCell: UITableViewCell {
    //日期
    var dateLabel    = UILabel(frame: .zero)
    //白天温度
    var daytempLabel = UILabel(frame: .zero)
    //白天天气现象
    var dayweatherLabel   = UILabel(frame: .zero)
    //晚上温度
    var nighttempLabel    = UILabel(frame: .zero)
    //晚上天气现象
    var nightweatherLabel = UILabel(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureUI()
    }
    
    func configureUI() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(daytempLabel)
        contentView.addSubview(dayweatherLabel)
        contentView.addSubview(nighttempLabel)
        contentView.addSubview(nightweatherLabel)
        dateLabel.snp.makeConstraints { make in
            make.left.top.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(20)
        }
        daytempLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(5)
            make.height.right.equalTo(dateLabel)
            make.left.equalTo(dateLabel.snp.left).offset(15)
        }
        dayweatherLabel.snp.makeConstraints { make in
            make.top.equalTo(daytempLabel.snp.bottom).offset(5)
            make.right.height.equalTo(dateLabel)
            make.left.equalTo(daytempLabel.snp.left).offset(15)

        }
        
        nighttempLabel.snp.makeConstraints { make in
            make.top.equalTo(dayweatherLabel.snp.bottom).offset(5)
            make.right.height.equalTo(dateLabel)
            make.left.equalTo(dayweatherLabel.snp.left).offset(15)
        }
        
        nightweatherLabel.snp.makeConstraints { make in
            make.top.equalTo(nighttempLabel.snp.bottom).offset(5)
            make.right.height.equalTo(dateLabel)
            make.left.equalTo(nighttempLabel.snp.left).offset(15)
        }
    }
    
    func configureViaModel(vm: WeatherViewModel?, indexPath: IndexPath) {
        if (vm?.selectIndex ?? 0) < vm?.forecastModels?.count ?? 0, let models = vm?.forecastModels?[vm?.selectIndex ?? 0] {
            let model = models.first?.casts?[indexPath.row] as? CastsModel
            dateLabel.text = "日期: "+(model?.date ?? "")
            daytempLabel.text = "白天温度: "+(model?.daytemp ?? "")
            dayweatherLabel.text = "白天天气现象: "+(model?.dayweather ?? "")
            nighttempLabel.text  = "晚上温度: "+(model?.nighttemp ?? "")
            nightweatherLabel.text = "晚上天气现象: "+(model?.nightweather ?? "")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
