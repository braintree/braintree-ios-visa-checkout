import Foundation

@objc @objcMembers class HTTPClient: NSObject {

    @objc static let shared = HTTPClient()

    private override init() { }

    func performRequest(with url: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: "https://braintree-sample-merchant.herokuapp.com" + "/config/current") else {
            completion(nil)
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
//        urlRequest.httpBody = try? encoder.encode(orderParams)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            if response == nil {
                completion(nil)
                return
            }

            do {
//                let order = try JSONDecoder().decode(Order.self, from: data)
                completion(data)
            } catch {
                completion(nil)
            }
        }
        .resume()
    }

}
