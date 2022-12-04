//
//  EpisodesTableViewCell.swift
//  BreakingBad
//
//  Created by Ogün Birinci on 24.11.2022.
//

import UIKit


final class EpisodesTableViewCell: UITableViewCell {
    static let identifier = "EpisodesTableViewCell"
    
    // MARK: UI Components
    private let episodeSeasonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let episodeNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    // MARK: Configure UI Components
    private func configureConstraints() {
            
        let episodeSeasonLabelConstraints = [
            episodeSeasonLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            episodeSeasonLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
        ]
        
        let episodeNameLabelConstraints = [
            episodeNameLabel.leadingAnchor.constraint(equalTo: episodeSeasonLabel.trailingAnchor,constant: 10),
            episodeNameLabel.topAnchor.constraint(equalTo: episodeSeasonLabel.topAnchor),
        ]
        
        
        NSLayoutConstraint.activate(episodeSeasonLabelConstraints)
        NSLayoutConstraint.activate(episodeNameLabelConstraints)

    }
    
    private func configureSubviews(){
        addSubview(episodeNameLabel)
        addSubview(episodeSeasonLabel)
    }
    
    // Season and episode will be used seperated by "." to be more readable.
    func configure(with model: Episode){
        episodeNameLabel.text = model.title
        episodeSeasonLabel.text = model.season + "." + model.episode
        
    }
    
    // MARK: Life Cycle Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
      
        configureSubviews()
        configureConstraints()
            
    }
    
    required init?(coder: NSCoder) {
            fatalError()
    }
    
 
    
}
