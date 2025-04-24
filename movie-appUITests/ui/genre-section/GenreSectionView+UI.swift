//
//  GenreSectionView+UI.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 22..
//

import XCTest

final class GenreSectionViewUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
        app.launch()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testBasicsUsage() throws {
        app.images["search"].tap()
        app.images["favorites"].tap()
        app.images["settings"].tap()
        app.images["genre"].tap()
    }
    
    func testRecordingUsage() throws {
        
    }
}

extension XCUIElement {
    var firstChildCell: XCUIElement {
        return self.cells.element(boundBy: 0)
    }

    var firstChildImage: XCUIElement {
        return self.images.element(boundBy: 0)
    }
}

extension XCUIApplication {
    func firstCellInCollectionView(withIdentifier id: String) -> XCUIElement {
        return collectionViews[id].cells.element(boundBy: 0)
    }
}

extension XCUIApplication {
    func findElement(withId id: String) -> XCUIElement? {
        // Ellenőrzésre használt összes ismert típus
        let types: [XCUIElement.ElementType] = [
            .staticText,
            .button,
            .image,
            .textField,
            .secureTextField,
            .switch,
            .navigationBar,
            .collectionView,
            .table,
            .cell,
            .other
        ]

        for type in types {
            let element = descendants(matching: type)[id]
            if element.exists {
                return element
            }
        }

        // Ha semmit nem talált, visszatér egy nem létező elemre
        return nil
    }
}
