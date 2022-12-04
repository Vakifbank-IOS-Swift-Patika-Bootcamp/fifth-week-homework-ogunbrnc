//
//  EpisodeCharacters.swift
//  BreakingBad
//
//  Created by Ogün Birinci on 24.11.2022.
//

import UIKit

protocol EpisodeCharactersViewDelegate: AnyObject {
    func didTapPopupClose()
}

final class EpisodeCharactersView: UIView {
    static var identifier = "EpisodeCharactersView"
    
    // MARK: UI Components
    weak var delegate: EpisodeCharactersViewDelegate?
    var characters: [String]?

    private let episodeCharactersLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemBackground
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: .normal)
        button.tintColor = .systemBackground
        return button
    }()
    
    @objc private func didTapCancel() {
        delegate?.didTapPopupClose()
        self.removeFromSuperview()
    }
    
    // MARK: Configure UI Components
    private func configureButtons() {
        cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
    }
    
    private func configureConstraints() {
            
        let cancelButtonConstraints = [
            cancelButton.leadingAnchor.constraint(equalTo: trailingAnchor, constant:  -70),
            cancelButton.topAnchor.constraint(equalTo: topAnchor , constant: 10)
        ]
        
        let episodeCharactersLabelConstraints = [
            episodeCharactersLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 20),
            episodeCharactersLabel.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 10),
        ]
        
        NSLayoutConstraint.activate(episodeCharactersLabelConstraints)
        NSLayoutConstraint.activate(cancelButtonConstraints)
       
    }
    // We combined character names to show them in a single label.
    private func configureSubviews() {
        episodeCharactersLabel.text = characters?.reduce("") {$0 + $1 + "\n"}
        addSubview(episodeCharactersLabel)
        addSubview(cancelButton)
    }
    
    private func configureUI(){
        self.backgroundColor = .label
        self.layer.cornerRadius = 10
    }
    
    // MARK: Life Cycle Methods
    init(frame: CGRect,characters: [String]?) {
        super.init(frame: frame)
        self.characters = characters
        configureUI()
        
        configureSubviews()
        configureConstraints()
        configureButtons()
            
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}

