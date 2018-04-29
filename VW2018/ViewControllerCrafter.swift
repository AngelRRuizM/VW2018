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
    @IBOutlet weak var leaveCrafter: UIButton!
    
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
        picker.dataSource = self
        picker.delegate = self
        self.getCrafters()
        if UserDefaults.standard.string(forKey: "crafter") != nil {
            leaveCrafter.isHidden = false
        }
        else{
            leaveCrafter.isHidden = true
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Checar si crafter es nil. Si no lo es, ya selecciono crafter
        
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
                            self.processData(data: data!)
                        }
                    }
                    else{
                        DispatchQueue.main.async {
                            self.logOut()
                        }
                    }
                }
                else{
                    DispatchQueue.main.async {
                        self.logOut()
                    }
                }
            }
        }
        dataTask?.resume()
    }
    
    func processData(data: Data){
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let array = json as? NSArray{
            for crafter in array{
                if let dictionary = crafter as? NSDictionary {
                    let plates = dictionary.value(forKey: "plates")
                    self.pickerData.add("\(plates ?? "no plates" )")
                }
            }
        }
        picker.reloadAllComponents()
    }
    
    func logOut(){
        let x = UserDefaults.standard
        x.set(nil, forKey: "email")
        x.synchronize()
        x.set(nil, forKey: "crafter")
        x.synchronize()
        let alert = UIAlertController(title: "Error en el servidor", message: "Hubo un error en el servidor, vuelva a intentar mas tarde", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
        self.performSegue(withIdentifier: "toLogIn", sender: self)
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
        
        let x = UserDefaults.standard
        x.set( (pickerData[picker.selectedRow(inComponent: 0)] as! String), forKey: "crafter")
        print( (pickerData[picker.selectedRow(inComponent: 0)] as! String) )
        x.synchronize()
        self.performSegue(withIdentifier: "toTabBar", sender: self)
    }
    
    @IBAction func leaveCrafterAction(_ sender: Any) {
        let x = UserDefaults.standard
        x.set( nil, forKey: "crafter")
        print("nil")
        x.synchronize()
        leaveCrafter.isHidden = true
    }
    
    
    
}
