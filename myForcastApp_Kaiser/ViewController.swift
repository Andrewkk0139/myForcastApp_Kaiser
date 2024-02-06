//
//  ViewController.swift
//  myForcastApp_Kaiser
//
//  Created by ANDREW KAISER on 1/24/24.
//


// This gets the list from the inital JSON
struct WeatherData: Decodable{
    let list: [List]
}
// all the stuff within main
struct Main: Decodable {
    var temp: Float
    var feels_like: Float
    var temp_max: Float
    var temp_min: Float
    var humidity: Float
}
//struct Weather: Decodable{
//    var description: String
//}

// this gets everything in list
struct List: Decodable{
    var main: Main
   // var weather: Weather
    var dt_txt: String
}

struct DataForDay{
    let dayDate: String
    let dayTemp: Float
    var dayFeels_like: Float
    var dayTemp_max: Float
    var dayTemp_min: Float
    var dayHumidity: Float
   // var dayDescription: String
}





import UIKit

class ViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
   
    
    // labels
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var feels_likeLabel: UILabel!
    @IBOutlet weak var temp_maxLabel: UILabel!
    @IBOutlet weak var temp_minLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var ImageOutlet: UIImageView!
    @IBOutlet weak var pickerOutlet: UIPickerView!
    
    //
    
    var fiveDaysData: [DataForDay] = []
    var index = 0
    // New York City, Chicago, Los Angeles, San Fransisco, Miami
    var majorCities:[String:String] = ["40.71":"-74.00","41.87":"87.62","34.05":"-118.24","37.77":"-122.41","25.76":"-80.19"]
    var majorCitiesNames = ["New York City","Chicago","Los Angeles","San Fransisco","Miami"]
    var majorCityIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerOutlet.delegate = self
        // Do any additional setup after loading the view.
        fiveDay(key: "42.24",value: "-88.31")
        sleep(1)
        dateLabel.text = "Date: \(fiveDaysData[index].dayDate)"
        tempLabel.text = "Temp: \(String(fiveDaysData[index].dayTemp))F°"
        feels_likeLabel.text = "Feels Like: \(String(fiveDaysData[index].dayFeels_like))F°"
        temp_maxLabel.text = "Max Temp: \(String(fiveDaysData[index].dayTemp_max))F°"
        temp_minLabel.text = "Min Temp: \(String(fiveDaysData[index].dayTemp_min))F°"
        humidityLabel.text = "Humidity: \(String(fiveDaysData[index].dayHumidity))%"
       // ImageOutlet.image = UIImage(systemName: (whatSym(fiveDaysData[index].dayDescription)))
       
    }
    
    func fiveDay(key: String,value: String){
        print("func running")
        let session = URLSession.shared

                let weatherURL = URL(string: "http://api.openweathermap.org/data/2.5/forecast?lat=\(key)&lon=\(value)&cnt=40&units=imperial&appid=524bb8ef5d193608e792fb9733ac8f8f")!

                let dataTask = session.dataTask(with: weatherURL) {
                    (data: Data?, response: URLResponse?, error: Error?) in

                    if let error = error {
                        print("Error:\n\(error)")
                    } else {
                        if let data = data {
                            if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
                                print("=====================================")
                                print(jsonObj)
                                self.decodeJSONForcast(JSONdata: data)
                                
                            
                        }else {
                                print("Error: Can't convert data to json object")
                            }
                        }else {
                            print("Error: did not receive data")
                        }
                    }
                }

                dataTask.resume()
    }
    
    func decodeJSONForcast(JSONdata: Data){
        let responce = try! JSONDecoder().decode(WeatherData.self, from: JSONdata)
            
        for i in responce.list{
            let tempDate = i.dt_txt
            let tempTemp = i.main.temp
            let tempFeels_Like = i.main.feels_like
            let tempDay_max = i.main.temp_max
            let tempDay_min = i.main.temp_min
            let tempHumidity = i.main.humidity
           // let tempDesc = i.weather.description
            fiveDaysData.append(DataForDay(dayDate: tempDate, dayTemp: tempTemp, dayFeels_like: tempFeels_Like, dayTemp_max: tempDay_max, dayTemp_min: tempDay_min, dayHumidity: tempHumidity))
        }
    }
    
    @IBAction func forwardAction(_ sender: Any) {
        if index <= 39 {
            index+=1
            dateLabel.text = "Date: \(fiveDaysData[index].dayDate)"
            tempLabel.text = "Temp: \(String(fiveDaysData[index].dayTemp))F°"
            feels_likeLabel.text = "Feels Like: \(String(fiveDaysData[index].dayFeels_like))F°"
            temp_maxLabel.text = "Max Temp: \(String(fiveDaysData[index].dayTemp_max))F°"
            temp_minLabel.text = "Min Temp: \(String(fiveDaysData[index].dayTemp_min))F°"
            humidityLabel.text = "Humidity: \(String(fiveDaysData[index].dayHumidity))%"
           // ImageOutlet.image = UIImage(systemName: (whatSym(fiveDaysData[index].dayDescription)))
        }
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        if index >= 1 {
            index-=1
            dateLabel.text = "Date: \(fiveDaysData[index].dayDate)"
            tempLabel.text = "Temp: \(String(fiveDaysData[index].dayTemp))F°"
            feels_likeLabel.text = "Feels Like: \(String(fiveDaysData[index].dayFeels_like))F°"
            temp_maxLabel.text = "Max Temp: \(String(fiveDaysData[index].dayTemp_max))F°"
            temp_minLabel.text = "Min Temp: \(String(fiveDaysData[index].dayTemp_min))F°"
            humidityLabel.text = "Humidity: \(String(fiveDaysData[index].dayHumidity))%"
           // ImageOutlet.image = UIImage(systemName: (whatSym(fiveDaysData[index].dayDescription)))
        }
    }
    func whatSym(_ s1: String) -> String{
        switch s1 {
        case "overcast clouds":
            return "cloud"
        case "light rain":
            return "cloud.drizzle"
        case "broken clouds":
            return "smoke"
        case "light snow":
            return "cloud.snow"
        default:
            return "sun.max.fill"
        }
    }
    
   // num of wheels
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // rows within a wheel
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return majorCities.count
        }
        return 0
    }
    // puts a title in each row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return majorCitiesNames[row]
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            majorCityIndex = row
        }
    }
    
    @IBAction func submitAction(_ sender: Any) {
        fiveDaysData.removeAll()
        let lat = Array(majorCities.keys)[majorCityIndex]
        let long = Array(majorCities.values)[majorCityIndex]
        
        fiveDay(key: lat, value: long)
        sleep(1)
        dateLabel.text = "Date: \(fiveDaysData[index].dayDate)"
        tempLabel.text = "Temp: \(String(fiveDaysData[index].dayTemp))F°"
        feels_likeLabel.text = "Feels Like: \(String(fiveDaysData[index].dayFeels_like))F°"
        temp_maxLabel.text = "Max Temp: \(String(fiveDaysData[index].dayTemp_max))F°"
        temp_minLabel.text = "Min Temp: \(String(fiveDaysData[index].dayTemp_min))F°"
        humidityLabel.text = "Humidity: \(String(fiveDaysData[index].dayHumidity))%"
    }
    
}

