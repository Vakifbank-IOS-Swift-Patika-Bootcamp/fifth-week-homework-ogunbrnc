//
//  CharacterDetailViewController.swift
//  BreakingBad
//
//  Created by Ogün Birinci on 24.11.2022.
//

import UIKit
import SDWebImage

final class CharacterDetailViewController: UIViewController {
    // MARK: Data Model
    var character: Character?
    
    // MARK: UI Components
    @IBOutlet weak var characterStatusLabel: UILabel!
    @IBOutlet weak var characterBirthdayLabel: UILabel!
    @IBOutlet weak var characterNicknameLabel: UILabel!
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    
    @IBAction func goToQuotes(_ sender: Any) {
        guard let characterQuotesView = self.storyboard?.instantiateViewController(withIdentifier: "CharacterQuotesViewController") as? CharacterQuotesViewController else {
                   fatalError("View Controller not found")
               }
        characterQuotesView.characterName = character?.name
        navigationController?.pushViewController(characterQuotesView, animated: true)
    }
    
    // MARK: Configure UI Components
    private func configureSubviews() {
        characterImageView.sd_setImage(with: URL(string: character!.imageURL),placeholderImage: UIImage(systemName: "photo"),options: .continueInBackground)
        characterNameLabel.text = character?.name
        characterNicknameLabel.text = character?.nickname
        characterBirthdayLabel.text = character?.birthday
        characterStatusLabel.text = character?.status
    }
    
    //MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
    }
    

   
    
    
}
