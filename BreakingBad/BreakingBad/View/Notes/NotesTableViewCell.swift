//
//  NotesTableViewCell.swift
//  BreakingBad
//
//  Created by Ogün Birinci on 28.11.2022.
//

import UIKit

class NotesTableViewCell: UITableViewCell {

    static var identifier = "NotesTableViewCell"


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
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let episodeNoteDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    private let episodeNoteContentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    
    // MARK: Configure UI Components
    private func configureConstraints() {
            
        let episodeSeasonLabelConstraints = [
            episodeSeasonLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            episodeSeasonLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
        ]
        
        let episodeNameLabelConstraints = [
            episodeNameLabel.leadingAnchor.constraint(equalTo: episodeNoteContentLabel.leadingAnchor),
            episodeNameLabel.topAnchor.constraint(equalTo: episodeSeasonLabel.bottomAnchor, constant: 10),
        ]
        
        
        let episodeNoteContentLabelConstraints = [
            episodeNoteContentLabel.leadingAnchor.constraint(equalTo: episodeSeasonLabel.leadingAnchor),
            episodeNoteContentLabel.topAnchor.constraint(equalTo: episodeNameLabel.bottomAnchor,constant: 10)
        
        ]
        
        let episodeNoteDateLabelConstraints = [
            episodeNoteDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -20),
            episodeNoteDateLabel.topAnchor.constraint(equalTo: episodeNoteContentLabel.bottomAnchor, constant: 10),
            episodeNoteDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ]
        
        
        NSLayoutConstraint.activate(episodeSeasonLabelConstraints)
        NSLayoutConstraint.activate(episodeNameLabelConstraints)
        NSLayoutConstraint.activate(episodeNoteDateLabelConstraints)
        NSLayoutConstraint.activate(episodeNoteContentLabelConstraints)


    }
    
    private func configureSubviews(){
        addSubview(episodeNameLabel)
        addSubview(episodeSeasonLabel)
        addSubview(episodeNoteDateLabel)
        addSubview(episodeNoteContentLabel)
    }
    
    // Season and episode will be used seperated by "." to be more readable.
    func configure(with model: Note){
        episodeNameLabel.text = "Episode: \(model.episodeName!)"
        episodeNoteDateLabel.text = dateToString(model.noteDate!)
        episodeNoteContentLabel.text = model.noteContent
        episodeSeasonLabel.text = "Season: \(model.episodeSeason!)"
        
    }
    
    // dateToString function take date argument and convert to
    private func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm E, d MMM y"
        return dateFormatter.string(from: date)
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
