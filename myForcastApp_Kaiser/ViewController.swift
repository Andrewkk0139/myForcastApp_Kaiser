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
// this gets everything in list
struct List: Decodable{
    var main: Main
    var dt_txt: String
}

struct DataForDay{
    let dayDate: String
    let dayTemp: Float
    var dayFeels_like: Float
    var dayTemp_max: Float
    var dayTemp_min: Float
    var dayHumidity: Float
}





import UIKit

class ViewController: UIViewController {
    // labels
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var feels_likeLabel: UILabel!
    @IBOutlet weak var temp_maxLabel: UILabel!
    @IBOutlet weak var temp_minLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    
    //
    
    var fiveDaysData: [DataForDay] = []
    var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fiveDay()
        sleep(1)
        dateLabel.text = "Date: \(fiveDaysData[index].dayDate)"
        tempLabel.text = "Temp: \(String(fiveDaysData[index].dayTemp))"
        feels_likeLabel.text = "Feels Like: \(String(fiveDaysData[index].dayFeels_like))"
        temp_maxLabel.text = "Max Temp: \(String(fiveDaysData[index].dayTemp_max))"
        temp_minLabel.text = "Min Temp: \(String(fiveDaysData[index].dayTemp_min))"
        humidityLabel.text = "Humidity: \(String(fiveDaysData[index].dayHumidity))"
       
    }
    
    func fiveDay(){
        print("func running")
        let session = URLSession.shared

                let weatherURL = URL(string: "http://api.openweathermap.org/data/2.5/forecast?lat=42.24&lon=-88.31&cnt=40&units=imperial&appid=524bb8ef5d193608e792fb9733ac8f8f")!

                let dataTask = session.dataTask(with: weatherURL) {
                    (data: Data?, response: URLResponse?, error: Error?) in

                    if let error = error {
                        print("Error:\n\(error)")
                    } else {
                        if let data = data {
                            if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
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
            fiveDaysData.append(DataForDay(dayDate: tempDate, dayTemp: tempTemp, dayFeels_like: tempFeels_Like, dayTemp_max: tempDay_max, dayTemp_min: tempDay_min, dayHumidity: tempHumidity))
        }
        print(fiveDaysData)
    }
    
    @IBAction func forwardAction(_ sender: Any) {
        if index <= 39 {
            index+=1
            dateLabel.text = "Date: \(fiveDaysData[index].dayDate)"
            tempLabel.text = "Temp: \(String(fiveDaysData[index].dayTemp))"
            feels_likeLabel.text = "Feels Like: \(String(fiveDaysData[index].dayFeels_like))"
            temp_maxLabel.text = "Max Temp: \(String(fiveDaysData[index].dayTemp_max))"
            temp_minLabel.text = "Min Temp: \(String(fiveDaysData[index].dayTemp_min))"
            humidityLabel.text = "Humidity: \(String(fiveDaysData[index].dayHumidity))"
        }
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        if index >= 1 {
            index-=1
            dateLabel.text = "Date: \(fiveDaysData[index].dayDate)"
            tempLabel.text = "Temp: \(String(fiveDaysData[index].dayTemp))"
            feels_likeLabel.text = "Feels Like: \(String(fiveDaysData[index].dayFeels_like))"
            temp_maxLabel.text = "Max Temp: \(String(fiveDaysData[index].dayTemp_max))"
            temp_minLabel.text = "Min Temp: \(String(fiveDaysData[index].dayTemp_min))"
            humidityLabel.text = "Humidity: \(String(fiveDaysData[index].dayHumidity))"
        }
    }
    
}

