//
//  CoreDataManager.swift
//  BreakingBad
//
//  Created by Ogün Birinci on 28.11.2022.
//

import UIKit
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private let managedContext: NSManagedObjectContext!
    
    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    func saveNote(episodeNote: EpisodeNote) -> Note? {
        let note: Note!
        
        let fetchNote: NSFetchRequest<Note> = Note.fetchRequest()
        fetchNote.predicate = NSPredicate(format: "id = %@", episodeNote.id as String)

        let results = try? managedContext.fetch(fetchNote)

        if results?.count == 0 {
            //to add new note.
            note = Note(context: managedContext)
         } else {
             //to update note.
            note = results?.first
         }
        note.id = episodeNote.id
        note.noteContent = episodeNote.noteContent
        note.episodeName = episodeNote.episodeName
        note.episodeSeason = episodeNote.episodeSeason
        note.noteDate = episodeNote.noteDate
        
        do {
            try managedContext.save()
            return note
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        return nil
    }
    
    func getNotes() -> [Note] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Note")
        do {
            let notes = try managedContext.fetch(fetchRequest)
            return notes as! [Note]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return []
    }
    
    func deleteNote(note: Note) {
        managedContext.delete(note)
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

}
