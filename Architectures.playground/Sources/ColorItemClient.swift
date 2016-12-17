import Foundation
import UIKit
import Chameleon

public struct ColorItem {
    public let name: String
    public let color: UIColor
}

public class ColorItemClient {
    public init(){}

    public func requestItems(completion: (([ColorItem]) -> Void)?) {
        completion?([
            ColorItem(name: "red", color: UIColor.flatRed()),
            ColorItem(name: "orange", color: UIColor.flatOrange()),
            ColorItem(name: "yellow", color: UIColor.flatYellow()),
            ColorItem(name: "green", color: UIColor.flatGreen()),
            ColorItem(name: "blue", color: UIColor.flatSkyBlue()),
            ])
    }
}
