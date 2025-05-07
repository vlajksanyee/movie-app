//
//  ErrorPresentable.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 06..
//

import Foundation

protocol ErrorPresentable {
    func toAlertModel(_ error: Error) -> AlertModel
}

extension ErrorPresentable {
    func toAlertModel(_ error: Error) -> AlertModel {
        guard let error = error as? MovieError else {
            return AlertModel(
                title: NSLocalizedString("unexpectederror.title", comment: ""),
                message: NSLocalizedString("unexpectederror.message", comment: ""),
                dismissButtonTitle: NSLocalizedString("dismissbutton.title", comment: "")
            )
        }
        switch error {
        case .invalidApiKeyError(let message):
            return AlertModel(
                title: NSLocalizedString("apierror.message", comment: ""),
                message: message,
                dismissButtonTitle: NSLocalizedString("dismissbutton.title", comment: "")
            )
        case .clientError:
            return AlertModel(
                title: NSLocalizedString("clienterror.title", comment: ""),
                message: error.localizedDescription,
                dismissButtonTitle: NSLocalizedString("dismissbutton.title", comment: "")
            )
        case .mappingError:
            return AlertModel(
                title: NSLocalizedString("mappingerror.title", comment: ""),
                message: NSLocalizedString("mappingerror.message", comment: ""),
                dismissButtonTitle: NSLocalizedString("dismissbutton.title", comment: "")
            )
        default:
            return AlertModel(
                title: NSLocalizedString("unexpectederror.title", comment: ""),
                message: NSLocalizedString("unexpectederror.message", comment: ""),
                dismissButtonTitle: NSLocalizedString("dismissbutton.title", comment: "")
            )
        }
    }
}
