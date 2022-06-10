//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//
import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    private var repository = [Repository]()
    private var viewModels = [GitTableViewCellViewModel]()
    private let backGroundColor = UIColor(#colorLiteral(red: 0.05199957639, green: 0.06712801009, blue: 0.08817393333, alpha: 1))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        
        //schBr.text → searchBar.placeholder
        searchBar.placeholder = "リポジトリを検索します"
        //titleを変更 & largeTitleに設定
        title = "GithubSearcher"
        searchBar.delegate = self
        searchBar.searchTextField.textColor = .black
        searchBar.searchTextField.backgroundColor = .white
        searchBar.barTintColor = backGroundColor
        view.backgroundColor = backGroundColor
        //navigationItemの「Backボタン」の文字を設定
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(#colorLiteral(red: 0.3433441818, green: 0.6504875422, blue: 0.9994851947, alpha: 1))
        
    }
    //MARK: -Search
    //キーボードの検索ボタン or pcのEnterボタンが押された時に呼ばれる
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {return}
        APICaller.shared.Searchs(with: text) { [weak self] result in
            switch result {
            case .success(let articles):
                self?.repository = articles
                self?.viewModels = articles.compactMap({
                    GitTableViewCellViewModel(
                        title: $0.fullName,
                        description: $0.description,
                        imageURL: $0.avatarImageUrl
                    )
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //searchBarの×ボタンが押された時に呼ばれる
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
    
    //StatusBarを白くする
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

//MARK: -Extensions

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? GitTableViewCell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        cell.backgroundColor = backGroundColor
        cell.ImageView.layer.cornerRadius = 25
        cell.titleLabel.textColor = UIColor(#colorLiteral(red: 0.3433441818, green: 0.6504875422, blue: 0.9994851947, alpha: 1))
        cell.subTitleLabel.textColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Detail", sender: nil)
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail"{
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let destination = segue.destination as? DetailViewController else {
                    fatalError("Failed to prepare DetailViewController.")
                }
                destination.repository = repository[indexPath.row]
            }
        }
    }
}
