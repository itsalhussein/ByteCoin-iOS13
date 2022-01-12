//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

protocol CoinManagerDeleagate {
    func didFailWithError(error: Error)
    func didUpdatePrice(price: String, currency: String)
}


struct CoinManager {
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "8F096AB8-BA0E-4AFB-A438-BB1FB91481F5"
    
    var delegate: CoinManagerDeleagate?
    
    func getCoinPrice(for currency: String)  {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        if let url = URL(string: urlString) {
            
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData){
                        
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
                
            }
            task.resume()
        }
    }
    
    
    func parseJSON(_ coinData: Data) -> Double? {
        
        //Create a JSONDecoder
        let decoder = JSONDecoder()
        do {
            
            //try to decode the data using the CoinData structure
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            
            //Get the last property from the decoded data.
            let lastPrice = decodedData.rate
            //print(lastPrice)
            return lastPrice
            
        } catch {
            
            //Catch and print any errors.
            print(error)
            return nil
        }
    }
    
}

