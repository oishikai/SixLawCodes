//
//  ViewController.swift
//  SixLawCodes
//
//  Created by kai on 2021/01/25.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let sixCodes = ["憲法", "刑法", "民法", "商法", "刑事訴訟法", "民事訴訟法"]
    let lawNumber = ["昭和二十一年憲法","明治四十年法律第四十五号", "明治二十九年法律第八十九号", "明治三十二年法律第四十八号", "昭和二十三年法律第百三十一号", "昭和二十三年法律第百三十一号"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sixCodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "code", for: indexPath)
        cell.textLabel!.text = sixCodes[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {  // cellがタップされたときに呼ばれる処理
        let storyboard = UIStoryboard(name: "Article", bundle: nil)  //storyboardクラスのインスタンスとしてArticle.storyboardを指定
        let vc = storyboard.instantiateViewController(identifier: "article")  //Article.storyboard中の"article"をIDとして持つviewを指定
        self.navigationController?.pushViewController(vc, animated: true)
        print(indexPath.row) // 引数のidexpathを数値として受け取る
        let setLawNumber = lawNumber[indexPath.row]
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        print("https://elaws.e-gov.go.jp/api/1/lawdata/\(setLawNumber)")
        // urlにlawNumberを埋め込んで,そのままだと扱えないので .addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)! でエンコード
        
        let url = URL(string: "https://elaws.e-gov.go.jp/api/1/lawdata/\(setLawNumber)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!

        let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            print(response)
        }
        task.resume()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }



    
    

}

