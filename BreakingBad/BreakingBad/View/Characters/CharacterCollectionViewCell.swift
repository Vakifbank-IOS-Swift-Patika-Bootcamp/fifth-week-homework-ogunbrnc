//
//  CharacterCollectionViewCell.swift
//  BreakingBad
//
//  Created by Ogün Birinci on 23.11.2022.
//

import UIKit

final class CharacterCollectionViewCell: UICollectionViewCell {
    static var identifier = "CharacterCollectionViewCell"
    
    // MARK: UI Components
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 40
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let characterBirthdayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let characterNicknameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let characterNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    // MARK: Configure UI Components
    private func configureConstraints() {
        let characterImageViewConstraints = [
            characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            characterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            characterImageView.heightAnchor.constraint(equalToConstant: 80),
            characterImageView.widthAnchor.constraint(equalToConstant: 80)
        ]
    
        let characterNicknameLabelConstraints = [
            characterNicknameLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 40),
            characterNicknameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            characterNicknameLabel.topAnchor.constraint(equalTo: characterImageView.topAnchor),
        ]
        
        let characterNameLabelConstraints = [
            characterNameLabel.leadingAnchor.constraint(equalTo: characterNicknameLabel.leadingAnchor),
            characterNameLabel.trailingAnchor.constraint(equalTo: characterNicknameLabel.trailingAnchor),
            characterNameLabel.topAnchor.constraint(equalTo: characterNicknameLabel.bottomAnchor,constant: 10),
        ]
        
        let characterBirthdayLabelConstraints = [
            characterBirthdayLabel.leadingAnchor.constraint(equalTo: characterNicknameLabel.leadingAnchor),
            characterBirthdayLabel.trailingAnchor.constraint(equalTo: characterNicknameLabel.trailingAnchor),
            characterBirthdayLabel.topAnchor.constraint(equalTo: characterNameLabel.bottomAnchor,constant: 10),
        ]
        
        NSLayoutConstraint.activate(characterImageViewConstraints)
        NSLayoutConstraint.activate(characterNicknameLabelConstraints)
        NSLayoutConstraint.activate(characterNameLabelConstraints)
        NSLayoutConstraint.activate(characterBirthdayLabelConstraints)

    }
    
    private func configureSubviews() {
        addSubview(characterImageView)
        addSubview(characterNicknameLabel)
        addSubview(characterNameLabel)
        addSubview(characterBirthdayLabel)
        
    }
    // If there is no image, the "photo" image will be used to provide a consistent structure
    func configure(with model: Character){
        characterNameLabel.text = model.name
        characterNicknameLabel.text = model.nickname
        characterBirthdayLabel.text = "Birthday: \(model.birthday)"
        characterImageView.sd_setImage(with: URL(string: model.imageURL),placeholderImage: UIImage(systemName: "photo"),options: .continueInBackground)
    }
    
    
    // MARK: Life Cycle Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
