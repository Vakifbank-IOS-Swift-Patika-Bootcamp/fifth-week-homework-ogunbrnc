//
//  SessionsViewController.swift
//  BreakingBad
//
//  Created by Ogün Birinci on 23.11.2022.
//

import UIKit

final class EpisodesViewController: BaseViewController {
    
    var episodeCharactersView: EpisodeCharactersView!
    var episodes: [[Episode]]? = []
    
    // MARK: UI Components
    @IBOutlet weak var episodesTableView: UITableView!
    
    // MARK: Configure UI Components
    
    // We create a 2D episode array using episode array to divide the TableView into sections
    private func createEpisodeSections(with episodes: [Episode]) {
        let totalSeasonNumber = 5
        for i in 1...totalSeasonNumber {
            self.episodes?.append(episodes.filter { $0.season.trimmingCharacters(in: .whitespacesAndNewlines) == "\(i)"})
        }
        episodesTableView.reloadData()
    }
    
    //MARK: Configure TableView
    private func configureTableView() {
        episodesTableView.register(EpisodesTableViewCell.self, forCellReuseIdentifier: EpisodesTableViewCell.identifier)
        episodesTableView.delegate = self
        episodesTableView.dataSource = self
    }
    
    //MARK: Fetching Data.
    private func getEpisodes() {
        indicatorView.startAnimating()
        Client.getEpisodes { [weak self] episodes, error in
            guard let self = self else { return }
            self.indicatorView.stopAnimating()
            self.createEpisodeSections(with: episodes ?? [])
        }
    }
    
    // MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        getEpisodes()
    }
}

// MARK: TableView Extension
extension EpisodesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Season: \(section + 1)"
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        episodes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        episodes?[section].count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let episode = episodes![indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: EpisodesTableViewCell.identifier) as! EpisodesTableViewCell
        cell.configure(with: episode)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let episode = episodes![indexPath.section][indexPath.row]

        episodeCharactersView = EpisodeCharactersView(frame: CGRect(x: view.frame.size.width  / 2 - 125,
                                                                    y: view.frame.size.height / 2 - 200,
                                                                    width: 250,
                                                                    height: 400),
                                                      characters: episode.characters)
        episodeCharactersView.delegate = self
        self.view.addSubview(episodeCharactersView)
        
    }
}

// MARK: EpisodesViewController Delegate
extension EpisodesViewController: EpisodeCharactersViewDelegate {
    func didTapPopupClose() {
        print("Did tap popup close.")
    }
}
