//
//  GitTableViewCell.swift
//  iOSEngineerCodeCheck
//
//  Created by 高橋蓮 on 2022/06/03.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import UIKit
//MARK: - cell Model
class GitTableViewCellViewModel {
    let title: String
    let description: String?
    let imageURL: URL?
    var imageData: Data? = nil
    
    init(
        title: String,
        description: String?,
        imageURL: URL?
    ) {
        self.title = title
        self.description = description
        self.imageURL = imageURL
    }
}

//MARK: -setting TabieViewCells
class GitTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    
    //GitTableViewCellViewModelからデータを取得し、Cellに当てはめる。
    func configure(with viewModel: GitTableViewCellViewModel) {
        titleLabel.text = viewModel.title
        subTitleLabel.text = viewModel.description
        if let data = viewModel.imageData {
            ImageView.image = UIImage(data: data)
        } else if let url = viewModel.imageURL {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.ImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
    //ラベルを再利用するために、空にする
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subTitleLabel.text = nil
        ImageView.image = nil
    }
}
