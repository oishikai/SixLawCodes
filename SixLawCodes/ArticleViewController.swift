//
//  ArticleViewController.swift
//  SixLawCodes
//
//  Created by kai on 2021/02/14.
//

import UIKit
import SwiftyXMLParser

class ArticleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var chapterNum = 0
    var articleNum = 0
    var setLawNumber = ""
    var articleCount: [String] = []
    var sentence: [String] = []
    var seq = 0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleNum
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "article", for: indexPath)
        cell.textLabel!.text = articleCount[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: "https://elaws.e-gov.go.jp/api/1/lawdata/\(setLawNumber)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
        let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            let xml = XML.parse(data!)
            let sequence = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Chapter", self.chapterNum,"Article" ,indexPath.row, "Paragraph"]
            self.seq = sequence.all?.count ?? 0
            self.sentence = []
            
            for i in 0...(self.seq - 1){
                let sentenseSeq = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Chapter", self.chapterNum,"Article" , indexPath.row, "Paragraph", i, "ParagraphSentence", "Sentence"]
//                let itemChecker1 = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Chapter", 4,"Article" , 72, "Paragraph", i, "ParagraphSentence", "Sentence"]
//                let itemChecker2 = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Chapter", 0,"Article" , 6, "Paragraph", i, "ParagraphSentence", "Sentence"]
                print(sentenseSeq.element?.text)
                if(sentenseSeq.element?.text == nil){
                    let sentenseSequExeption = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Chapter", self.chapterNum,"Article" , indexPath.row, "Paragraph", i]
                    let count = sentenseSequExeption.element?.childElements[1].childElements.count ?? 0
                    for j in 0...(count - 1){
                        print(sentenseSequExeption.element?.childElements[1].childElements[j].text)
                        self.sentence.append(sentenseSequExeption.element?.childElements[1].childElements[j].text ?? "")
                        print(self.sentence[j])
                    }
//                    sentenseSequ.element?.childElements[1].childElements[0].text
                }else{
                    self.sentence.append(sentenseSeq.element?.text ?? "")
                    print(sentenseSeq.element?.childElements.count)
                    if(sentenseSeq.element?.childElements.count ?? 0 >= 4){
                        print("hi")
                    }
                }
                
            }
            
            DispatchQueue.main.async { // メインスレッドで行うブロック
                let storyboard = UIStoryboard(name: "Paragraph", bundle: nil)
                let nextVC = storyboard.instantiateViewController(identifier: "paragraph")as! ParagraphViewController
                self.navigationController?.pushViewController(nextVC, animated: true)
                nextVC.title = self.articleCount[indexPath.row]
                nextVC.sentence = self.sentence
                nextVC.paragraphNum = self.seq
            }
        }
        task.resume()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
