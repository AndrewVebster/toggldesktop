//
//  ProjectAutoCompleteTextField.swift
//  TogglDesktop
//
//  Created by Nghia Tran on 3/28/19.
//  Copyright © 2019 Alari. All rights reserved.
//

import Cocoa

final class ProjectAutoCompleteTextField: AutoCompleteTextField {

    // MARK: Variables
    var projectItem: ProjectContentItem? {
        didSet {
            guard let project = projectItem else { return }
            stringValue = project.name
            layoutProject(with: project.name)
            applyColor(with: project.colorHex)
        }
    }
    var dotImageView: DotImageView?
    private lazy var projectCreationView: ProjectCreationView = {
        let view = ProjectCreationView.xibView() as ProjectCreationView
        view.delegate = self
        return view
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.allowsEditingTextAttributes = true
    }

    func setTimeEntry(_ timeEntry: TimeEntryViewItem) {
        projectCreationView.selectedTimeEntry = timeEntry
        stringValue = timeEntry.projectLabel

        layoutProject(with: stringValue)
        applyColor(with: timeEntry.projectColor)
    }

    override func didTapOnCreateButton() {
        super.didTapOnCreateButton()

        // Update content
        updateWindowContent(with: projectCreationView, height: projectCreationView.suitableHeight)

        // Set text and focus
        projectCreationView.setTitleAndFocus(self.stringValue)
    }

    private func layoutProject(with name: String) {
        guard let cell = self.cell as? VerticallyCenteredTextFieldCell else { return }
        if name.isEmpty {
            cell.leftPadding = 10
            dotImageView?.isHidden = true
        } else {
            cell.leftPadding = 28.0
            dotImageView?.isHidden = false
        }
        setNeedsDisplay()
        displayIfNeeded()
    }

    private func applyColor(with hex: String) {
        guard let color = ConvertHexColor.hexCode(toNSColor: hex) else { return }
        dotImageView?.fill(with: color)

        let font = self.font ?? NSFont.systemFont(ofSize: 14.0)
        let att: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font,
                                                  NSAttributedString.Key.foregroundColor: color]
        attributedStringValue = NSAttributedString(string: stringValue, attributes: att)
    }
}

// MARK: ProjectCreationViewDelegate

extension ProjectAutoCompleteTextField: ProjectCreationViewDelegate {

    func projectCreationDidAdd() {
        closeSuggestion()
    }

    func projectCreationDidCancel() {
        closeSuggestion()
    }

    func projectCreationDidUpdateSize() {
        updateWindowContent(with: projectCreationView, height: projectCreationView.suitableHeight)
    }
}