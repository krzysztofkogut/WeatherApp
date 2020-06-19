//
//  MasterTableViewController.swift
//  WeatherApp
//
//  Created by Kris on 17/06/2020.
//  Copyright © 2020 Kris. All rights reserved.
//

import UIKit

protocol CitySelectionDelegate: class {
    func citySelected(_ newCity: CityModel)
}

class MasterTableViewController: UITableViewController {
    
    var cities = [CityModel]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    let url = "https://api.openweathermap.org/data/2.5/weather?appid=1c197254ed8743944deb1b69560c18f9&units=metric"
    
    weak var delegate: CitySelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadStrategyCities()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func downloadStrategyCities() {
        
        
        let names = ["Paris", "London", "Tokyo"]
        
        for city in names {
            downloadJSON(cityName: city)
        }
    }
       func downloadJSON(cityName: String) {
        guard let urlCity = URL(string: "\(url)&q=\(cityName)") else { return }
            URLSession.shared.dataTask(with: urlCity) { (data, response, error) in
                guard let data = data else {
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    
                    let decodedData = try decoder.decode(WeatherDataCity.self, from: data)
                    let id = decodedData.weather[0].id
                    let temp = decodedData.main.temp
                    let lon = decodedData.coord.lon
                    let lat = decodedData.coord.lat
                    
                    let weatherObject = WeatherModelCity(conditionId: id, temperature: temp, lon: lon, lat: lat)
                    
                    DispatchQueue.main.async {
                        let city = CityModel.init(name: cityName)
                        city.weather = weatherObject
                        self.cities.append(city)
                        self.tableView.reloadData()
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }.resume()
        }
    
    
    // MARK: - Table view data source
    
    /*
     override func numberOfSections(in tableView: UITableView) -> Int {
     // #warning Incomplete implementation, return the number of sections
     return 0
     }
     */
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        // Configure the cell...
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
        
        let city = cities[indexPath.row]
        cell.textLabel?.text = city.name
        DispatchQueue.main.async {
            cell.setWeather(weather: city.weather!)
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = cities[indexPath.row]
        delegate?.citySelected(selectedCity)
        if let weatherViewController = delegate as? WeatherViewController {
            splitViewController?.showDetailViewController(weatherViewController, sender: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New City", message: "", preferredStyle: .alert)
        let addCityAction = UIAlertAction(title: "Add City", style: .default) { (action) in

            self.downloadJSON(cityName: textField.text ?? "Warsaw")
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new city"
            textField = alertTextField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
                self.tableView.reloadData()
        }
        
        alert.addAction(addCityAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
        
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
