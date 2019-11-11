//
//  ViewController.swift
//  FrisqStopwatch
//
//  Created by joakim lundberg on 2019-11-09.
//  Copyright © 2019 joakim lundberg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    public var time = 0.0, centerPos = 0.0
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()

    
    let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
    
    
    var laps: [String] = []
    public var timer = Timer()
    var isCounting = false
    var progressView: UIProgressView?
    
      let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 30)
        button.backgroundColor = UIColor.blue
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(startTimer), for: .touchUpInside)
            
        return button
        }()
    
    let resetButton: UIButton = {
          let button = UIButton(type: .system)
          button.setTitle("reset", for: .normal)
          button.translatesAutoresizingMaskIntoConstraints = false
          button.titleLabel?.font = .systemFont(ofSize: 20)
          button.backgroundColor = UIColor.blue
          button.setTitleColor(UIColor.white, for: .normal)
          button.addTarget(self, action: #selector(resetTimer), for: .touchUpInside)
              
          return button
          }()
    
    let stopButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Stop", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 20)

        button.backgroundColor = UIColor.blue
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(stopTimer), for: .touchUpInside)
        
        return button
    }()
    let newLapButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Lap", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.backgroundColor = UIColor.blue
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(newLap), for: .touchUpInside)
            
        return button
       }()
    let timeLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 50, y: 200, width: 300, height: 200))
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.textColor = .blue
        label.font = .systemFont(ofSize: 60)
        label.textAlignment = .center
        label.text = "0:0:0"
        
        return label
    }()
    
    let lapList: UITableView = {
       let lapstableView = UITableView(frame: .zero, style: .plain)
        lapstableView.translatesAutoresizingMaskIntoConstraints = false
        
        return lapstableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lapList.dataSource = self
        setupViewComponents()
     
    }
    
    func setupViewComponents(){
        self.view.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.heightAnchor.constraint(equalToConstant: 250).isActive = true
        timeLabel.widthAnchor.constraint(equalTo: view!.widthAnchor, constant: -100).isActive = true
        timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 140).isActive = true
        
        var center = view.center
        center.y = 140
        let circularPath = UIBezierPath(arcCenter: center, radius: 115, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(trackLayer)
        
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = UIColor.blue.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        
        shapeLayer.strokeEnd = 0
        
        view.layer.addSublayer(shapeLayer)
        
        self.view.addSubview(lapList)
        lapList.translatesAutoresizingMaskIntoConstraints = false
        lapList.heightAnchor.constraint(equalToConstant: 140).isActive = true
        lapList.widthAnchor.constraint(equalTo: view!.widthAnchor, constant: -100).isActive = true
        lapList.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20).isActive = true
        lapList.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
       
        self.view.addSubview(startButton)
        startButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100).isActive = true
        startButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        startButton.layer.cornerRadius = 20
        startButton.centerYAnchor.constraint(equalTo: lapList.bottomAnchor, constant: 50).isActive = true
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
       
        self.view.addSubview(stopButton)
        stopButton.widthAnchor.constraint(equalTo: startButton.widthAnchor, constant: -150).isActive = true
        stopButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        stopButton.layer.cornerRadius = 20
        stopButton.centerYAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 40).isActive = true
        stopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -70).isActive = true
             
        self.view.addSubview(newLapButton)
        newLapButton.widthAnchor.constraint(equalTo: startButton.widthAnchor, constant: -150).isActive = true
        newLapButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        newLapButton.layer.cornerRadius = 20
        newLapButton.centerYAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 40).isActive = true
        newLapButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 70).isActive = true
        
        self.view.addSubview(resetButton)
        resetButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        resetButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        resetButton.layer.cornerRadius = 20
        resetButton.centerYAnchor.constraint(equalTo: stopButton.bottomAnchor, constant: 40).isActive = true
        resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
    }
    
    
    
    @objc func startTimer(){
        
        if isCounting == false {
            print("Starting timer")
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            
            self.time = self.time + 0.1
            let hours = Int(self.time) / 3600
            let minutes = Int(self.time) / 60 % 60
            let seconds = Int(self.time) % 60
                 
            let timeFormatted = String(format:"%01i:%01i:%01i", hours, minutes, seconds)
            self.timeLabel.text = timeFormatted
            self.isCounting = true
                
            }
                            
            basicAnimation.toValue = 1
            basicAnimation.duration = 1
                            
            basicAnimation.fillMode = CAMediaTimingFillMode.forwards
            basicAnimation.isRemovedOnCompletion = false
            basicAnimation.repeatCount = .infinity
            self.shapeLayer.add(basicAnimation, forKey: "secondAnim")
        }
    }
  
    @objc func stopTimer(){
        isCounting = false
        timer.invalidate()
        shapeLayer.removeAllAnimations()
         self.view.layoutIfNeeded()
        
    }
    
    @objc func resetTimer(){
        print("resetting timer")
        self.time = 0.0
        let timeFormatted = String(format:"%01i:%01i:%01i", 0, 0, 0)
        self.timeLabel.text = timeFormatted
        shapeLayer.removeAllAnimations()

        timer.invalidate()
        isCounting = false
    }
    @objc func newLap(){
        
        let (h, m, s) = secondsToHoursMinutesSeconds(seconds: Int(time))
        
        let formatted = String("\(h):\(m):\(s)")
        
        laps.insert("\(formatted)", at: 0)
        print(laps)
        
        lapList.beginUpdates()
        lapList.insertRows(at: [IndexPath(row: laps.count-1, section: 0)], with: .automatic)
        lapList.endUpdates()
        lapList.reloadData()
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func setupTableView(){
          lapList.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
}
extension ViewController: UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return laps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        let lapTime = laps[indexPath.row]
        cell.textLabel?.text = lapTime
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    
}

