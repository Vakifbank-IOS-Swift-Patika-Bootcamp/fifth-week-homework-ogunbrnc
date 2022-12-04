//
//  CharacterQuotesViewController.swift
//  BreakingBad
//
//  Created by Ogün Birinci on 24.11.2022.
//

import UIKit

class CharacterQuotesViewController: BaseViewController {
    
    //MARK: Data Model
    var characterName: String?
    private var characterQuotes: [CharacterQuote]? {
        didSet {
            characterQuotesTableView.reloadData()
        }
    }
    
    //MARK: UI Components
    @IBOutlet weak var characterQuotesTableView: UITableView!
    
    // MARK: Configure TableView
    private func configureTableView(){
        characterQuotesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "characterQuotesCell")
        characterQuotesTableView.delegate = self
        characterQuotesTableView.dataSource = self
        characterQuotesTableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    // MARK: Fetching Character Quotes
    private func getCharacterQuotes() {
        indicatorView.startAnimating()
        Client.getCharacterQuotes(characterName: characterName!) { [weak self] characterQuotes, error in
            guard let self = self else { return }
            self.indicatorView.stopAnimating()
            if characterQuotes!.isEmpty {
                self.showAlert(title: "No Quotes", message: "There is no quotes for this character.") {
                    self.navigationController?.popViewController(animated: true)
                }
                return
            }
            self.characterQuotes = characterQuotes
        }
    }
    
    //MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        getCharacterQuotes()
    }


}

//MARK: TableView Extension
extension CharacterQuotesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterQuotes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "characterQuotesCell",for: indexPath)
        cell.textLabel?.text = characterQuotes?[indexPath.row].quote ?? ""
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
