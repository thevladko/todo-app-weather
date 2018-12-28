//
//  WeatherViewController.swift
//  assignment4-todo-app
//
//  Created by Vladislav Kobyakov on 7/16/18.
//  Copyright © 2018 Vladislav Kobyakov. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    let manager = CLLocationManager()
    var location: CLLocation!
    var weatherData = WeatherData()
    private let apiKey = "" //private key is not written on purpose. For the app to work an actual apiKey is required.

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        askPermissionToTrackLocation()
    }
    
    let timezoneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "Timezone: ", attributes: attributesForText)
        return label
    }()
    
    let currentTemperatureTextView: UITextView = {
        let textView = UITextView()
        textView.attributedText = NSAttributedString(string: "Current Temperature: ", attributes: attributesForText)
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let apparentTemperatureTextView: UITextView = {
        let textView = UITextView()
        textView.attributedText = NSAttributedString(string: "Apparent Temperature: ", attributes: attributesForText)
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let refreshButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Refresh", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        return button
    }()
    
    @objc func handleRefresh() {
        getLocation()
        guard let long = weatherData.longitude, let lat = weatherData.latitude else {
            alert(message: "Failed to get location")
            return
        }
        let jsonUrlString = "https://api.darksky.net/forecast/\(apiKey)/\(lat),\(long)"
        fetchData(jsonUrlString: jsonUrlString) { [unowned self] (weather) in
            self.weatherData.temperature = weather.temperature
            self.weatherData.apparentTemperature = weather.apparentTemperature
            self.weatherData.timezone = weather.timezone
            self.updateUI()
        }
    }
    
    func fetchData(jsonUrlString: String, completion: @escaping (WeatherData) -> ()) {
        guard let url = URL(string: jsonUrlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if error != nil {
                    self.alert(message: "error making an http request")
                }
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        guard let data = data else { return }
                        do {
                            guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary else { return }
                            let weather = WeatherData()
                            guard let timezone = json["timezone"] as? String else {return}
                            if let current = json["currently"] as? [String : AnyObject] {
                                if let temperature = current["temperature"], let apparentTemperature = current["apparentTemperature"] {
                                    weather.temperature = "\(temperature)"
                                    weather.apparentTemperature = "\(apparentTemperature)"
                                    weather.timezone = timezone
                                    completion(weather)
                                }
                            }
                        } catch {
                            self.alert(message: "error has occured")
                        }
                    } else {
                        self.alert(message: "statusCode: \(httpResponse.statusCode)")
                    }
                }
            }
        }.resume()
    }

    
    func askPermissionToTrackLocation() {
        manager.requestWhenInUseAuthorization()
    }
    
    func getLocation() {
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            location = manager.location
            if let loc = manager.location {
                weatherData.latitude = "\(loc.coordinate.latitude)"
                weatherData.longitude = "\(loc.coordinate.longitude)"
            }
        } else {
            alert(message: "Location services must be enabled")
        }
    }
    
    func alert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil )
        }))
        self.present(alert, animated: true, completion: nil)
    }
}


//UI
extension WeatherViewController {
    private func prepareUI() {
        manager.delegate = self
        view.layer.insertSublayer(createGradient(bounds: view.bounds), at: 0)
        setupViews()
    }
    
    private func updateUI() {
        timezoneLabel.attributedText = NSAttributedString(string: "Timezone: \(weatherData.timezone ?? "nil")", attributes: attributesForText)
        currentTemperatureTextView.attributedText = NSAttributedString(string: "Current temperature: \(weatherData.temperature ?? "nil")°F", attributes: attributesForText)
        apparentTemperatureTextView.attributedText = NSAttributedString(string: "Apparent temperature: \(weatherData.apparentTemperature ?? "nil")°F", attributes: attributesForText)
    }
    
    private func setupViews() {
        view.addSubview(timezoneLabel)
        view.addSubview(currentTemperatureTextView)
        view.addSubview(apparentTemperatureTextView)
        view.addSubview(refreshButton)
        
        //locationLabel
        view.addConstraint(NSLayoutConstraint(item: timezoneLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 80))
        timezoneLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        //currentTemperatureTextView
        view.addConstraint(NSLayoutConstraint(item: currentTemperatureTextView, attribute: .top, relatedBy: .equal, toItem: timezoneLabel, attribute: .bottom, multiplier: 1, constant: 100))
        currentTemperatureTextView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        //apparentTemperatureTextView
        view.addConstraint(NSLayoutConstraint(item: apparentTemperatureTextView, attribute: .top, relatedBy: .equal, toItem: currentTemperatureTextView, attribute: .bottom, multiplier: 1, constant: 100))
        apparentTemperatureTextView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        //refreshButton
        view.addConstraint(NSLayoutConstraint(item: refreshButton, attribute: .top, relatedBy: .equal, toItem: apparentTemperatureTextView, attribute: .bottom, multiplier: 1, constant: 100))
        refreshButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        refreshButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
}
