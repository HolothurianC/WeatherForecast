//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Holothurian on 2023/4/28.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.navigationController?.pushViewController(WeatherForecastViewController(), animated: true)
    }


}

