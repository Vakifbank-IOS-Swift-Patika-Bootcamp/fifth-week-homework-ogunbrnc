//
//  CharactersViewController.swift
//  BreakingBad
//
//  Created by Ogün Birinci on 23.11.2022.
//

import UIKit

final class CharactersViewController: BaseViewController {
    
    // MARK: Data Model
    private var characters: [Character]? {
        didSet {
            charactersCollectionView.reloadData()
        }
    }
    
    // MARK: UI Components
    @IBOutlet weak var charactersCollectionView: UICollectionView!
    
    // MARK: Configure TableView.
    private func configureTableView() {
        charactersCollectionView.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: CharacterCollectionViewCell.identifier)
        charactersCollectionView.delegate = self
        charactersCollectionView.dataSource = self
    }
    
    // MARK: Fetching Characters.
    private func getCharacters(){
        indicatorView.startAnimating()
        Client.getCharacters { [weak self] characters, error in
            guard let self = self else { return }
            self.indicatorView.stopAnimating()
            self.characters = characters
        }

    }
    // MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        getCharacters()
    }
    
    
}
// MARK: CollectionView Extension
extension CharactersViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        characters?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = characters?[indexPath.row]
        guard let characterDetailView = self.storyboard?.instantiateViewController(withIdentifier: "CharacterDetailViewController") as? CharacterDetailViewController else {
                   fatalError("View Controller not found")
               }
        characterDetailView.character = character
        navigationController?.pushViewController(characterDetailView, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let character = characters?[indexPath.row]
        let cell = charactersCollectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.identifier, for: indexPath) as! CharacterCollectionViewCell
        cell.configure(with: character!)
        return cell
    }
}
