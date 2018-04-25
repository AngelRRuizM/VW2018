//
//  ViewControllerCrafter.swift
//  VW2018
//
//  Created by Alumno on 24/04/18.
//  Copyright © 2018 Gekko. All rights reserved.
//

import UIKit

class ViewControllerCrafter: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var pickerData = NSMutableArray()
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    var dataToProcess = Data()
    @IBOutlet weak var picker: UIPickerView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (pickerData[row] as! String)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCrafters()
        
        picker.dataSource = self
        picker.delegate = self
        
        
        // Do any additional setup after loading the view.
        
        
    }

    func getCrafters(){
        if dataTask != nil {
            dataTask?.cancel()
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let url = NSURL(string: "https://fake-backend-mobile-app.herokuapp.com/crafters")
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
                            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                            if let array = json as? NSArray{
                                for crafter in array{
                                    if let dictionary = crafter as? NSDictionary {
                                        let id = dictionary.value(forKey: "id")
                                        self.pickerData.add("Crafter \(String(describing: id))")
                                    }
                                }
                            }
                        }
                    }
                    else{
                        DispatchQueue.main.async {
                            self.errorsShow(error: String(httpsResponse.statusCode))
                        }
                    }
                }
            }
        }
        dataTask?.resume()
    }
    
    func errorsShow(error: String){
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
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
    
    @IBAction func selectCrafter(_ sender: Any) {
        self.performSegue(withIdentifier: "toTabBar", sender: self)
    }
    
    @IBAction func profile(_ sender: Any) {
        self.performSegue(withIdentifier: "toProfile", sender: self)
    }
    
    @IBAction func notifications(_ sender: Any) {
        self.performSegue(withIdentifier: "toNotifications", sender: self)
    }
    
}
