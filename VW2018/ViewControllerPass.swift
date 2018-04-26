//
//  ViewControllerPass.swift
//  VW2018
//
//  Created by Alumno on 24/04/18.
//  Copyright © 2018 Gekko. All rights reserved.
//

import UIKit
import Foundation

class ViewControllerPass: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nextStop: UILabel!
    @IBOutlet weak var pasengersCount: UILabel!
    @IBOutlet weak var crafterButton: UIButton!
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    var crafter =  Crafter()
    var passengers = Int()
    var maxPassengers = Int()
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCrafter()
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(putPassengers), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func crafter(_ sender: Any) {
        timer.invalidate()
        self.performSegue(withIdentifier: "toCrafter", sender: self)
    }
    
    func getCrafter(){
        if dataTask != nil {
            dataTask?.cancel()
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let plates = UserDefaults.standard.string(forKey: "crafter")?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = NSURL(string: "https://fake-backend-mobile-app.herokuapp.com/crafters?plates=\(plates!)")
        let request = URLRequest(url: url! as URL)
        
        dataTask = defaultSession.dataTask(with: request){
            data, response, error in
            DispatchQueue.main.async{
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            if let error = error {
                print(error.localizedDescription)
            }
            else{
                if let httpsResponse = response as? HTTPURLResponse {
                    if httpsResponse.statusCode == 200 {
                        DispatchQueue.main.async {
                            self.processData(data: data!)
                        }
                    }
                }
            }
        }
        dataTask?.resume()
    }
    
    func processData(data: Data){
        
        let jsonDecoder = JSONDecoder()
        let array = try? jsonDecoder.decode([Crafter].self, from: data)
        self.crafter = array!.first!
        crafterButton.setTitle("Crafter \(crafter.id) - \(crafter.plates)", for: UIControlState.normal)
        if crafter.passengers == 1{
            pasengersCount.text = "\(crafter.passengers) pasajero"
        }
        else{
            pasengersCount.text = "\(crafter.passengers) pasajeros"
        }
        passengers = crafter.passengers
        maxPassengers = crafter.capacity
    }
    
    @IBAction func addPassenger(_ sender: Any) {
        if passengers < maxPassengers {
            passengers = passengers + 1
            if passengers == 1{
                pasengersCount.text = "\(passengers) pasajero"
            }
            else{
                pasengersCount.text = "\(passengers) pasajeros"
            }
        }
        else{
            let alert = UIAlertController(title: "Capacidad máxima", message: "Haz llegado al limite de capacidad de este crafter (\(maxPassengers) pasajeros).", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(action)
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func subsPassenger(_ sender: Any) {
        if passengers > 0 {
            passengers = passengers - 1
            pasengersCount.text = "\(passengers) pasajeros"
        }
    }
    
    @objc func putPassengers(){
        
        if dataTask != nil {
            dataTask?.cancel()
        }
        crafter.passengers = passengers
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(crafter)
        let url = NSURL(string: "https://fake-backend-mobile-app.herokuapp.com/crafters/\(crafter.id)")
        let request = NSMutableURLRequest(url: url! as URL)
        request.addValue("application/JSON", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        request.httpBody = jsonData
        
        dataTask = defaultSession.dataTask(with: request as URLRequest){
            data, response, error in
            DispatchQueue.main.async{
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            if let error = error {
                print(error.localizedDescription)
            }
            else{
                if let httpsResponse = response as? HTTPURLResponse {
                    if httpsResponse.statusCode == 200 {
                        print("Se hizo el put")
                    }
                }
            }
        }
        dataTask?.resume()
    }
}
