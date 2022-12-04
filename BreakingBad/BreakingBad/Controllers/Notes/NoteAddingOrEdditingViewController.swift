//
//  NoteAddingOrEdditingViewController.swift
//  BreakingBad
//
//  Created by Ogün Birinci on 28.11.2022.
//

import UIKit

protocol NoteAddingOrEdditingViewControllerDelegate: AnyObject {
    func didAddNote(model: EpisodeNote)
    func didUpdateNote(model: EpisodeNote)
}

class NoteAddingOrEdditingViewController: BaseViewController {

    //MARK: UI Components
    @IBOutlet weak var seasonNumberTextField: UITextField!
    @IBOutlet weak var episodeNameTextField: UITextField!
    @IBOutlet weak var noteContentTextField: UITextField!
    
    private var seasonPickerView = ToolbarPickerView()
    private var episodePickerView = ToolbarPickerView()
    
    // MARK: Variable declaration
    private var selectedEpisodeRow: Int = 0
    private var selectedSeasonRow: Int = 0
    private var episodeOptions: [[String]] = []
    private var seasonOptions: [String] = []
    private var seasonCount: Int {
        return seasonOptions.count
    }
    weak var delegate: NoteAddingOrEdditingViewControllerDelegate?
    var note: Note?
   
    
    // MARK: Configure UI Components
    private func configureTextViews() {
        //If the user  is editing the note, the season and episode will not be changable.
        if note != nil {
            seasonNumberTextField.isUserInteractionEnabled = false
        }
        
        seasonNumberTextField.inputView = seasonPickerView
        seasonNumberTextField.inputAccessoryView = seasonPickerView.toolbar
        seasonNumberTextField.layer.borderWidth = 1.0
        seasonNumberTextField.layer.cornerRadius = 5.0
        seasonNumberTextField.layer.borderColor = UIColor.label.cgColor
        seasonNumberTextField.text = note?.episodeSeason
        seasonNumberTextField.attributedPlaceholder = NSAttributedString(string: "Select Season", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        
        episodeNameTextField.inputView = episodePickerView
        episodeNameTextField.inputAccessoryView = episodePickerView.toolbar
        episodeNameTextField.layer.borderWidth = 1.0
        episodeNameTextField.layer.cornerRadius = 5.0
        episodeNameTextField.layer.borderColor = UIColor.label.cgColor
        episodeNameTextField.text = note?.episodeName
        episodeNameTextField.attributedPlaceholder = NSAttributedString(string: "Select Episode", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        episodeNameTextField.isUserInteractionEnabled = false

        //If the note is editing, old note will appear, if not, placeholder will appear.
        noteContentTextField.text = note?.noteContent
    }
    
    
    private func configurePickerOptions() {
        Client.getEpisodes { [weak self] episodes, error in
            guard let self = self else { return }
            
            // all unique season will be stored in seasonOptions array.
            self.seasonOptions = (episodes?.map{$0.season.trimmingCharacters(in: .whitespacesAndNewlines)}.unique())!
            
            // all episodes information will be stored in 2d episodeOptions array and the episodes will be listed according to the user's season selection
            for i in 1...self.seasonCount {
                self.episodeOptions.append(episodes!.filter { $0.season.trimmingCharacters(in: .whitespacesAndNewlines) == "\(i)"}.map {$0.title})
            }
        }
    }
    private func configurePickerViews() {
            
        
        seasonPickerView.dataSource = self
        seasonPickerView.delegate = self
        seasonPickerView.toolbarDelegate = self
        
        episodePickerView.dataSource = self
        episodePickerView.delegate = self
        episodePickerView.toolbarDelegate = self

        seasonPickerView.reloadAllComponents()
        episodePickerView.reloadAllComponents()
    }
    
    // MARK: UIButton Action
    @IBAction func saveNote(_ sender: Any) {
        guard let seasonNumber = seasonNumberTextField.text,
              !seasonNumber.isEmpty,
              let episodeName = episodeNameTextField.text,
              !episodeName.isEmpty,
              let noteContent = noteContentTextField.text,
              !noteContent.isEmpty else {
            
            showAlert(title: "Empty field", message: "Please fill each field correctly.")
            return
        }
        
        let currentDate = Date.now
        //if a new note is entered
        if note == nil {
            delegate?.didAddNote(model: EpisodeNote(episodeName: episodeName,
                                                    episodeSeason: seasonNumber,
                                                    noteDate: currentDate,
                                                    noteContent: noteContent,
                                                    id: UUID().uuidString))
        }
        //if the note is updating
        else {
            //if the user wanted to save the Note content without updating
            if note?.noteContent == noteContent {
                showAlert(title: "No change", message: "Please update the note!")
                return
            }
            
            delegate?.didUpdateNote(model: EpisodeNote(episodeName: episodeName,
                                                    episodeSeason: seasonNumber,
                                                    noteDate: currentDate,
                                                    noteContent: noteContent,
                                                    id: (note?.id)!))
        }
        self.dismiss(animated: true)
    }
    
    //MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextViews()
        configurePickerOptions()
        configurePickerViews()
        
    }
}

// MARK: PickerView Extension
extension NoteAddingOrEdditingViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == seasonPickerView {
            return seasonOptions.count
        }
        else {
            return episodeOptions[selectedSeasonRow].count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == seasonPickerView{
            return seasonOptions[row]
        } else {
            return episodeOptions[selectedSeasonRow][row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent  component: Int) {
        if pickerView == seasonPickerView {
            selectedSeasonRow = row
            seasonNumberTextField.text = seasonOptions[row]
            // If the user ise selecting the season information for the first time, the episode selection will be active.
            if !episodeNameTextField.isUserInteractionEnabled {
                episodeNameTextField.isUserInteractionEnabled = true
            }

        } else {
            selectedEpisodeRow = row
            episodeNameTextField.text = episodeOptions[selectedSeasonRow][row]
        }
    }
    
}

extension NoteAddingOrEdditingViewController: ToolbarPickerViewDelegate {
    func didTapDone(_ picker: ToolbarPickerView) {
        if picker == seasonPickerView {
            let row = self.seasonPickerView.selectedRow(inComponent: 0)
            self.seasonPickerView.selectRow(row, inComponent: 0, animated: false)
            self.seasonNumberTextField.text = self.seasonOptions[row]
            self.seasonNumberTextField.resignFirstResponder()
            self.episodeNameTextField.isUserInteractionEnabled = true
        }
        else {
            let row = self.episodePickerView.selectedRow(inComponent: 0)
            self.episodePickerView.selectRow(row, inComponent: 0, animated: false)
            self.episodeNameTextField.text = self.episodeOptions[selectedSeasonRow][row]
            self.episodeNameTextField.resignFirstResponder()
        }
    }

    func didTapCancel(_ picker: ToolbarPickerView) {
        if picker == seasonPickerView {
            self.seasonNumberTextField.text = nil
            self.seasonNumberTextField.resignFirstResponder()
        }
        else {
            self.episodeNameTextField.text = nil
            self.episodeNameTextField.resignFirstResponder()
        }
    }
}
