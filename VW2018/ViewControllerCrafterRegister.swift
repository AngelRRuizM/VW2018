//
//  ViewControllerCrafterRegister.swift
//  VW2018
//
//  Created by Alumno on 24/04/18.
//  Copyright © 2018 Gekko. All rights reserved.
//

import UIKit

class ViewControllerCrafterRegister: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var pickerData = NSMutableArray()
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    var dataToProcess = Data()
    
    @IBOutlet weak var picker: UIPickerView!
    
    //Componentes del pirckerview
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Cantidad de filas en el pickerview
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    //Texto para cada fila
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (pickerData[row] as! String)
    }
    
    //Establece datasource y delegate, además de precargar las crafters
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.dataSource = self
        picker.delegate = self
        self.getCrafters()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Precarga los crafters
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
                //Si es exitoso, procesa la información.
                if let httpsResponse = response as? HTTPURLResponse {
                    if httpsResponse.statusCode == 200 {
                        DispatchQueue.main.async {
                            self.processData(data: data!)
                        }
                    }
                    else{
                        DispatchQueue.main.async {
                            self.errorsShow(error: "Response code")
                        }
                    }
                }
                else{
                    DispatchQueue.main.async {
                        self.errorsShow(error: "Response")
                    }
                }
            }
        }
        dataTask?.resume()
    }
    
    //Procesa la información para conseguir las placas de los crafters, además de recargar el componente del picker para que aparezca la información actualizada
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
    
    //Muestra errores
    func errorsShow(error: String){
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    //Maneja la selección de opciones en el picker.
    @IBAction func seleccionar(_ sender: Any) {
        let x = UserDefaults.standard
        x.set( (pickerData[picker.selectedRow(inComponent: 0)] as! String), forKey: "registerCrafter")
        print( (pickerData[picker.selectedRow(inComponent: 0)] as! String) )
        x.synchronize()
        self.performSegue(withIdentifier: "toRegisterTable", sender: self)
    }
}
