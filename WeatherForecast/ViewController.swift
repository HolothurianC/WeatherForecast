//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Holothurian on 2023/4/28.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    var btn = UIButton(type: .custom)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI()
    }
    
    func configureUI() {
        view.addSubview(btn)
        btn.setTitle("Touch Me", for: .normal)
        btn.setTitleColor(.cyan, for: .normal)
        btn.backgroundColor     = .red
        btn.layer.cornerRadius  = 15
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(buttonEvent), for: .touchUpInside)
        btn.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.size.equalTo(CGSize(width: 120, height: 30))
        }
    }
    
    @objc func buttonEvent() {
        navigationController?.pushViewController(WeatherForecastViewController(), animated: true)

    }
}

