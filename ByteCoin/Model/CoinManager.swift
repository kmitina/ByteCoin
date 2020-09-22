

import Foundation
protocol CoinManagerDelegate {
    func didFailWithError(error: Error)
    func didUpdateRate(price: String, currency: String)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "8A3E91CA-E68A-40B9-8551-C7ABEE64F601"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    var delegate: CoinManagerDelegate?
    
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
       if let url = URL(string: urlString) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) {(data, response, error) in
            if error != nil {
                self.delegate?.didFailWithError(error: error!)
                return
            }
            
            if let safeData = data {
                if let rate = self.parseJSON(safeData) {
                    let priceString = String(format: "%.2f", rate)
                    self.delegate?.didUpdateRate(price: priceString, currency: currency)
                }
                }
            }
            task.resume()
        }
    }
    
    
    
    
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            print(lastPrice)
            return lastPrice
        } catch {
            delegate?.didFailWithError(error: error)

            return nil
        }
    }
    

    }
    
    

