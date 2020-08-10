//
//  EditViewModel.swift
//  Transformers
//
//  Created by Suneeth on 8/7/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import UIKit

class EditDetailsViewModel: BaseViewModel {
    let screenName = "Edit"
    let cellIdentifier: String = "TextFieldTableViewCell"
    let sectionName = "Transformer Details"
    let numberOfSections = 1
    let rowHeight = 60.0
    let sectionHeaderViewHeight = 50.0
    let sectionFooterViewHeight = 70.0
    let numberOfPickerComponents = 1
    let pickerRowHeight = 50.0
    let transformer: Transformer 
    var didItemUpdate = Dynamic<Bool>(value: false)
    private var dataDictionary: Dictionary<String, String> = [:]
    init(transformer: Transformer) {
        self.transformer = transformer
        super.init()
        updateDataDictionary()
    }
    func updateDataDictionary() {
        dataDictionary[TechSpecs.name.rawValue] = transformer.name
        let teamName = (transformer.team == Constants.TeamCode.autobot) ? TransformerTeam.Autobots.rawValue : TransformerTeam.Decepticons.rawValue
        dataDictionary[TechSpecs.team.rawValue] = teamName
        dataDictionary[TechSpecs.strength.rawValue] = "\(transformer.strength)"
        dataDictionary[TechSpecs.intelligence.rawValue] = "\(transformer.intelligence)"
        dataDictionary[TechSpecs.speed.rawValue] = "\(transformer.speed)"
        dataDictionary[TechSpecs.endurance.rawValue] = "\(transformer.endurance)"
        dataDictionary[TechSpecs.rank.rawValue] = "\(transformer.rank)"
        dataDictionary[TechSpecs.courage.rawValue] = "\(transformer.courage)"
        dataDictionary[TechSpecs.firepower.rawValue] = "\(transformer.firepower)"
        dataDictionary[TechSpecs.skill.rawValue] = "\(transformer.skill)"
    }
    func numberOfRows() -> Int {
        return TechSpecs.allCases.count
    }
    func getCellViewModel(row: Int) -> TextFieldCellViewModel {
        let key = TechSpecs.allCases[row].rawValue
        return .init(with: .init(title: "\(key.capitalizingFirstLetter)*", fieldValue: getFieldValue(key: key)), fieldType: TechSpecs.allCases[row].getTextFieldType())
    }
    func getFieldValue(key: String) -> String {
        return dataDictionary[key] ?? ""
    }
    func getFieldType(row: Int) -> TextFieldType {
        return TechSpecs.allCases[row].getTextFieldType()
    }
    func numberOfPickerItems(for tag: Int) -> Int {
        return TechSpecs.allCases[tag].getPickerList().count
    }
    func pickerText(for tag: Int, row: Int) -> String {
        let key = TechSpecs.allCases[tag]
        return key.getPickerList()[row]
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
    func updateTransformerDetails() {
        if isValidForm() { updateTransformer() }
        else { displayAlert(title: Constants.ValidationMessages.alertTitle,
                            message: Constants.ValidationMessages.emptyValidationMessage) }
    }
    private func displayAlert(title: String, message: String, id: String? = nil) {
        DispatchQueue.main.async { [weak self] in
            self?.alertModel.value = AlertModel(title: title, message: message, okTitle: "OK", id: id)
        }
    }
}
extension EditDetailsViewModel {
    func updateTransformer() {
        viewStatus.value = .loading(loadStyle: loadingStyle(), title: loadingTitle(), subtitle: "")
        TransformersHandler().updateTransformer(transformerId: transformer.id , dataDictionary: dataDictionary) { [weak self] (value, error) in
            self?.viewStatus.value = .loaded
            if let error = error { self?.showAPIError(errorObject: error) }
            else if value != nil { self?.didItemUpdate.value = true }
        }
    }
}
extension EditDetailsViewModel {
    func saveEditedField(with tag: Int, value: String) {
        let key = TechSpecs.allCases[tag].rawValue
        dataDictionary[key] = value
    }
}
