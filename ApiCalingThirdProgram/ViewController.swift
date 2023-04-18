//
//  ViewController.swift
//  ApiCalingThirdProgram
//
//  Created by MANSI SAVANI on 03/03/23.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    var arrApiDetails: ApiDetails!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configerTableView()
    }
    private func setup(){
        AF.request(" https://api.publicapis.org/entries", method: .get).responseData { [self]
            response in
            debugPrint("response\(response)")
            if  response.response?.statusCode == 200 {
                guard let apiData = response.data else {return}
                do{
                    let productDetails = try JSONDecoder().decode(ApiDetails.self, from: apiData)
                    print(productDetails)
                    arrApiDetails = productDetails
                    tableView.reloadData()
                }catch{
                    print(error.localizedDescription)
                }
            }else{
                print("tame kaik locho karo")
            }
        }
    }
    
    private func configerTableView(){
        let nibName: UINib = UINib(nibName: "ApiCallingTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
    }
}
// MARK: - Empty
struct ApiDetails: Decodable {
    let count: Int
    let entries: [Entry]
}

// MARK: - Entry
struct Entry: Decodable {
    let api, description: String
    let auth: String
    let https: Bool
    let cors: String
    let link: String
    let category: String

    enum CodingKeys: String, CodingKey {
        case api = "API"
        case description = "Description"
        case auth = "Auth"
        case https = "HTTPS"
        case cors = "Cors"
        case link = "Link"
        case category = "Category"
    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrApiDetails?.entries.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ApiCallingTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for:  indexPath) as! ApiCallingTableViewCell
        cell.nameLable.text = arrApiDetails.entries[indexPath.row].api
        return cell
    }
    
    
}
