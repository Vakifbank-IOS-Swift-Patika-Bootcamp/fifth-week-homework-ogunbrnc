//
//  NotesViewController.swift
//  BreakingBad
//
//  Created by Ogün Birinci on 28.11.2022.
//

import UIKit

final class NoteListViewController: BaseViewController {

    //MARK: UI Components
    @IBOutlet private weak var notesTableView: UITableView!
    private let floatingActionButton: UIButton = {
        let floatingButton = UIButton()
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        floatingButton.setImage(UIImage(systemName: "plus"), for: .normal)
        floatingButton.tintColor = .systemBackground

        floatingButton.backgroundColor = .label
        floatingButton.layer.cornerRadius = 25
        return floatingButton
    }()
    private let noNoteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "There are no notes. \n You can add new note using the + button."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    // MARK: Note model.
    var notes: [Note] = []
    
    // MARK: Configure Views
    private func configureSubViews() {
        view.addSubview(floatingActionButton)
    }
    
    private func configureTableView() {
        notesTableView.register(NotesTableViewCell.self, forCellReuseIdentifier: NotesTableViewCell.identifier)
        notesTableView.dataSource = self
        notesTableView.delegate = self
        notesTableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    private func configureConstraints() {
        let floatingActionButtonConstraints = [
            floatingActionButton.widthAnchor.constraint(equalToConstant: 50),
            floatingActionButton.heightAnchor.constraint(equalToConstant: 50),
            floatingActionButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            floatingActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
                                                   
        ]
        
        NSLayoutConstraint.activate(floatingActionButtonConstraints)
    }
    
    private func configureNoNoteLabel(){
        if notes.isEmpty {
            view.addSubview(noNoteLabel)
            noNoteLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            noNoteLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
    }
    
    private func configureButtons() {
        floatingActionButton.addTarget(self, action: #selector(didTapAddNote), for: .touchUpInside)
    }
    
    
    // MARK: UIButton Action
    @objc private func didTapAddNote() {
        guard let noteAddingOrEditingViewController = self.storyboard?.instantiateViewController(withIdentifier: "NoteAddingOrEdditingViewController") as? NoteAddingOrEdditingViewController else {
                   fatalError("View Controller not found")
               }
        noteAddingOrEditingViewController.delegate = self
        navigationController?.present(noteAddingOrEditingViewController, animated: true)
    }

    //MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
                
        notes = CoreDataManager.shared.getNotes()
        
        
        configureNoNoteLabel()
        configureTableView()
        configureSubViews()
        configureConstraints()
        configureButtons()

    }
}

//MARK: TableView Extension
extension NoteListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotesTableViewCell.identifier,for: indexPath) as? NotesTableViewCell else {
            return UITableViewCell()
        }
        let note = notes[indexPath.row]
        cell.configure(with: note)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = notes[indexPath.row]
            CoreDataManager.shared.deleteNote(note: note)
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            // if there is no note left when the note is deleted
            if notes.isEmpty {
                configureNoNoteLabel()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let note = notes[indexPath.row]
        guard let noteAddingOrEditingViewController = self.storyboard?.instantiateViewController(withIdentifier: "NoteAddingOrEdditingViewController") as? NoteAddingOrEdditingViewController else {
                   fatalError("View Controller not found")
               }
        noteAddingOrEditingViewController.delegate = self
        noteAddingOrEditingViewController.note = note
        navigationController?.present(noteAddingOrEditingViewController, animated: true)
        
    }
    
    
}

// MARK: Delegate
extension NoteListViewController: NoteAddingOrEdditingViewControllerDelegate {
    //If new note will be added, firstly note should append to notes array and after that notesTableView should be reload.
    func didAddNote(model: EpisodeNote) {
        // If the first note was added, the noNoteLabel will be removed.
        if notes.isEmpty {
            noNoteLabel.removeFromSuperview()
        }
        notes.append(CoreDataManager.shared.saveNote(episodeNote: model)!)
        notesTableView.reloadData()
    }
    //If note will be updated, firstly note should changed in notes array and after that notesTableView should be reload.
    func didUpdateNote(model: EpisodeNote) {
        if let row = notes.firstIndex(where: {$0.id == model.id}) {
               notes[row] = CoreDataManager.shared.saveNote(episodeNote: model)!
        }
        notesTableView.reloadData()
    }
}
