//
//  DragView.swift
//  ReleaseNotesGenerator
//
//  Created by Mihai Eros on 12.01.2023.
//

import Cocoa

protocol DragViewDelegate: AnyObject {
    func didDragFileIntoView(_ fileURL: URL)
}

final class DragView: NSView {
    
    /// Properties
    weak var delegate: DragViewDelegate?
    
    private var filePath: String?
    private var isFileTypeCorrect = false
    private var fileTypes = ["txt"]
    private var droppedFilePath: String?
    
    // MARK: - Init
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        registerForDraggedTypes([NSPasteboard.PasteboardType.NSFilePath])
    }
    
    // MARK: - Drag and Drop
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        if checkExtension(sender) {
            isFileTypeCorrect = true
            return .copy
        } else {
            isFileTypeCorrect = false
            return []
        }
    }
    
    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        if isFileTypeCorrect {
            return .copy
        } else {
            return []
        }
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let pasteBoard = sender.draggingPasteboard.propertyList(forType: NSPasteboard.PasteboardType.NSFilePath) as? [NSPasteboard.PasteboardType],
              let filePath = pasteBoard.first else {
            return false
        }
        
        if isFileTypeCorrect {
            delegate?.didDragFileIntoView(URL(fileURLWithPath: filePath.rawValue))
        }
        
        return true
    }
    
    // MARK: - Helpers
    
    private func checkExtension(_ sender: NSDraggingInfo) -> Bool {
        guard let pasteBoard = sender.draggingPasteboard.propertyList(forType: NSPasteboard.PasteboardType.NSFilePath) as? [NSPasteboard.PasteboardType],
              let path = pasteBoard.first else {
            return false
        }
        
        let url = URL(fileURLWithPath: path.rawValue)
        let fileExtension = url.pathExtension.lowercased()
        
        return fileTypes.contains(fileExtension)
    }
}
