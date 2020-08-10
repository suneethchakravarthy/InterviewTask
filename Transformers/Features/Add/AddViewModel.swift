//
//  AddViewModel.swift
//  Transformers
//
//  Created by Suneeth on 8/7/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import UIKit

enum TechSpecs: String, CaseIterable {
    case name
    case strength
    case intelligence
    case speed
    case endurance
    case rank
    case courage
    case firepower
    case skill
    case team
}
extension TechSpecs {
    func getTextFieldType() -> TextFieldType {
        switch self {
        case .name:
            return .text
        case .strength, .intelligence, .speed, .endurance, .rank, .courage, .firepower, .skill, .team:
            return .picker
        }
    }
    func getPickerList() -> [String] {
        switch self {
        case .name:
            return []
        case .strength, .intelligence, .speed, .endurance, .rank, .courage, .firepower, .skill:
            return ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
        case .team:
            return [TransformerTeam.Autobots.rawValue, TransformerTeam.Decepticons.rawValue]
        }
    }
}
class AddViewModel: BaseViewModel {
    let screenName = "Create"
    let cellIdentifier: String = "TextFieldTableViewCell"
    let sectionName = "Transformer Details"
    let rowHeight = 60.0
    let sectionHeaderViewHeight = 50.0
    let sectionFooterViewHeight = 70.0
    var didItemCreate = Dynamic<Bool>(value: false)
    let numberOfSections = 1
    let numberOfPickerComponents = 1
    let pickerRowHeight = 50.0
    private var dataDictionary: Dictionary<String, String> = [:]
    
    func numberOfRows() -> Int {
        return TechSpecs.allCases.count
    }
    func getCellViewModel(row: Int) -> TextFieldCellViewModel {
        let key = TechSpecs.allCases[row].rawValue
        return .init(with: .init(title: "\(key.capitalizingFirstLetter)*", fieldValue: getFieldValue(key: key)), fieldType: TechSpecs.allCases[row].getTextFieldType())
    }
    func getFieldType(row: Int) -> TextFieldType {
        return TechSpecs.allCases[row].getTextFieldType()
    }
    func getFieldValue(key: String) -> String {
        return dataDictionary[key] ?? ""
    }
    func numberOfPickerItems(for tag: Int) -> Int {
        return TechSpecs.allCases[tag].getPickerList().count
    }
    func pickerText(for tag: Int, row: Int) -> String {
        let key = TechSpecs.allCases[tag]
        return key.getPickerList()[row]
    }
    func createTransformer() {
        if isValidForm() { createNewTransformer() }
        else { displayAlert(title: Constants.ValidationMessages.alertTitle,
                            message: Constants.ValidationMessages.emptyValidationMessage) }
    }
    private func isValidForm() -> Bool {
        for techSpec in TechSpecs.allCases {
            let value = dataDictionary[techSpec.rawValue]
            if value == nil || (value?.trimmed.count ?? 0) <= 0 {
                return false
            }
        }
        return true
    }
    private func displayAlert(title: String, message: String, id: String? = nil) {
        DispatchQueue.main.async { [weak self] in
            self?.alertModel.value = AlertModel(title: title, message: message, okTitle: "OK", id: id)
        }
    }
}
extension AddViewModel {
    private func createNewTransformer() {
        viewStatus.value = .loading(loadStyle: loadingStyle(), title: loadingTitle(), subtitle: "")
        TransformersHandler().createTransformer(with: dataDictionary) { [weak self] (value, error) in
            self?.viewStatus.value = .loaded
            if let error = error { self?.showAPIError(errorObject: error) }
            else if value != nil { self?.didItemCreate.value = true }
        }
    }
}
extension AddViewModel {
    func saveEditedField(with tag: Int, value: String) {
        let key = TechSpecs.allCases[tag].rawValue
        dataDictionary[key] = value
    }
}
