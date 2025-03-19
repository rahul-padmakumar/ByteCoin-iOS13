//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinDelegate{
    func onSuccess(coinModel: CoinModel)
    func onFailure(error: Error?)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "xxx"
    
    var delegate: CoinDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String){
        
        let url = URL(string: "\(baseURL)/\(currency)?apikey=\(apiKey)")
        print(url!)
    
        if let safeurl = url{
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: safeurl) { data, response, error in
                if error != nil{
                    delegate?.onFailure(error: error)
                    return
                }
                if let safeData = data{
                    decodeData(data: safeData)
                }
            }
            task.resume()
        }
    }
    
    func decodeData(data: Data){
        
        let jsonDecoder = JSONDecoder()
        do{
            let decodeData = try jsonDecoder.decode(CoinModel.self, from: data)
            delegate?.onSuccess(coinModel: decodeData)
        } catch let error{
            delegate?.onFailure(error: error)
        }
    }
}
