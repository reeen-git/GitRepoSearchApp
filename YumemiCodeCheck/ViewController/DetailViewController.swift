//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//
import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var LanguageLabel: UILabel!
    @IBOutlet weak var SratgazerLabel: UILabel!
    @IBOutlet weak var WacherLabel: UILabel!
    @IBOutlet weak var ForksLabel: UILabel!
    @IBOutlet weak var IssueLabel: UILabel!
    @IBOutlet weak var gitUrlLabel: UILabel!
    @IBOutlet weak var webButton: UIButton!
    
    var weburl = ""
    var repository: Repository!
    private let backGroundColor = UIColor(#colorLiteral(red: 0.05199957639, green: 0.06712801009, blue: 0.08817393333, alpha: 1))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getImage()
        setLabelText()
        setButton()
        view.backgroundColor = backGroundColor
    }
    //MARK: - Setting ImageView
    //ユーザーアイコンを取得する
    func getImage(){
        let repo = repository
        imageView.layer.cornerRadius = 125
        guard let imageurl = repo?.avatarImageUrl else {return}
        URLSession.shared.dataTask(with: imageurl) { (data, res, err) in
            let image = UIImage(data: data!)!
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }.resume()
    }
    //MARK: - Setting Labels
    //textの情報を取得しラエルにセットする
    func setLabelText() {
        let repo = repository
        TitleLabel.text = repo?.fullName ?? ""
        TitleLabel.textColor = .white
        if TitleLabel.text!.count > 20 {
            TitleLabel.font = UIFont(name: "Optima-Bold", size: 20)
        } else {
            TitleLabel.font = UIFont(name: "Optima-Bold", size: 30)
        }
        LanguageLabel.text = "Language: \(repo?.language ?? "")"
        LanguageLabel.textColor = .white
        SratgazerLabel.text = "Sratgazer: \(repo?.stargazersCount.description ?? "")"
        SratgazerLabel.textColor = .white
        WacherLabel.text = "Wacher: \(repo?.watchersCount.description ?? "")"
        WacherLabel.textColor = .white
        ForksLabel.text = "Forks: \(repo?.forksCount.description ?? "")"
        ForksLabel.textColor = .white
        IssueLabel.text = "Issue: \(repo?.openIssuesCount.description ?? "")"
        IssueLabel.textColor = .white
        gitUrlLabel.text = repo?.html
        gitUrlLabel.textColor = .white
        if gitUrlLabel.text!.count >= 30 {
            gitUrlLabel.font = UIFont(name: "Optima-Bold", size: 15)
        } else {
            gitUrlLabel.font = UIFont(name: "Optima-Bold", size: 30)
        }
    }
    //MARK: -settting Button
    //webViewに遷移するButtonの設定
    func setButton() {
        webButton.titleLabel?.text = "View on Github"
        webButton.titleLabel?.textColor = .black
        webButton.backgroundColor = UIColor(#colorLiteral(red: 0.3433441818, green: 0.6504875422, blue: 0.9994851947, alpha: 1))
        webButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        webButton.layer.cornerRadius = 25
    }
    
    //webViewにUrlの情報を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let repo = repository
        if segue.identifier == "web"{
            let nextVC = segue.destination as! WebViewController
            //htmlurlの情報をwebVCに渡す
            nextVC.reciveUrl = repo?.html ?? ""
        }
    }
    
    //WebVCに遷移するButton
    @IBAction func tappedButton() {
        let repo = repository
        performSegue(withIdentifier: "web", sender: nil)
        weburl = repo?.html ?? ""
    }
}
