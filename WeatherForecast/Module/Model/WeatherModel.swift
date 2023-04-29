//
//  WeatherModel.swift
//  WeatherForecast
//
//  Created by Holothurian on 2023/4/28.
//

import HandyJSON

//https://lbs.amap.com/api/webservice/guide/api/weatherinfo
//实况天气数据信息
struct LivesModel: HandyJSON {
    var province: String? //省份名
    var city: String?     //城市名
    var adcode: Int?   //区域编码
    var weather: String?  //天气现象（汉字描述）
    var temperature: String? //实时气温，单位：摄氏度
    var temperature_float: String? //实时气温，单位：摄氏度
    var winddirection: String? //风向描述
    var windpower: String? //风力级别，单位：级
    var reporttime: String? // 数据发布的时间
    var humidity: Int? //空气湿度
    var humidity_float: String?
}

//预报天气信息数据
struct ForecastModel: HandyJSON {
    var city: String? //城市名称
    var adcode: String? //城市编码
    var province: String? //省份名称
    var reporttime: String? //预报发布时间
    var casts: [CastsModel]? //预报数据list结构，元素cast,按顺序为当天、第二天、第三天的预报数据
}

//预报数据list结构，元素cast,按顺序为当天、第二天、第三天的预报数据
struct CastsModel: HandyJSON {
    var date: String? //日期
    var weak: String? //星期几
    var dayweather: String? //白天天气现象
    var nightweather: String? //晚上天气现象
    var daytemp: String? //白天温度
    var nighttemp: String?  //晚上温度
    var daywind: String? //白天风向
    var nightwind: String? //晚上风向
    var daypower: String? //白天风力
    var nightpower: String? //晚上风力
}
