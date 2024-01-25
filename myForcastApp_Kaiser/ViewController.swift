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
    
    var fiveDaysData: [DataForDay] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        await fiveDay()
        print("here")
        
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
            var tempDate = i.dt_txt
            var tempTemp = i.main.temp
            var tempFeels_Like = i.main.feels_like
            var tempDay_max = i.main.temp_max
            var tempDay_min = i.main.temp_min
            var tempHumidity = i.main.humidity
            fiveDaysData.append(DataForDay(dayDate: tempDate, dayTemp: tempTemp, dayFeels_like: tempFeels_Like, dayTemp_max: tempDay_max, dayTemp_min: tempDay_min, dayHumidity: tempHumidity))
        }
        print(fiveDaysData)
    }


}

