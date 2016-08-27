//
//  TBGlobals.swift
//  TaxibeatHomeTest
//
//  Created by Konstantinos Dimitros on 27/08/16.
//  Copyright © 2016 Taxibeat. All rights reserved.
//

import UIKit



@objc class TBGlobals: NSObject {

    // MARK: Singleton
    class var sharedInstance: TBGlobals {
        struct Singleton {
            static let instance = TBGlobals()
        }
        return Singleton.instance
    }
    
    // MARK: - Color theme
    let kTBColorMaroon: UIColor = UIColor(colorLiteralRed: 122/255, green: 46/255, blue: 31/255, alpha: 1)
    let kTBColorMaroonLight: UIColor = UIColor(colorLiteralRed: 198/255, green: 115/255, blue: 99/255, alpha: 1)
    let kTBColorMaroonVeryLight: UIColor = UIColor(colorLiteralRed: 231/255, green: 162/255, blue: 146/255, alpha: 1)
    let kTBColorGreen: UIColor = UIColor(colorLiteralRed: 44/255, green: 122/255, blue: 91/255, alpha: 1)
    let kTBColorGreenLight: UIColor = UIColor(colorLiteralRed: 91/255, green: 198/255, blue: 155/255, alpha: 1)
    let kTBColorGreenVeryLight: UIColor = UIColor(colorLiteralRed: 144/255, green: 255/255, blue: 210/255, alpha: 1)
    let kTBColorGrayWithRed: UIColor = UIColor(colorLiteralRed: 210/255, green: 203/255, blue: 203/255, alpha: 1)
    
    // MARK: - Other helper methods
    func getMaroonColor() -> UIColor {
        return kTBColorMaroon;
    }
    
}