//
//  String + Ex.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 6/3/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

extension String {
    subscript(integerRange: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: integerRange.lowerBound)
        let end = index(startIndex, offsetBy: integerRange.upperBound)
        let range = start..<end
        return String(self[range])
    }

    subscript(integerIndex: Int) -> Character {
        let index = self.index(startIndex, offsetBy: integerIndex)
        return self[index]
    }

    func local() -> String {
        return NSLocalizedString(self, comment: "")
    }

    func local(args: CVarArg...) -> String {
        return NSString(format: self.local(), arguments: getVaList(args)) as String
    }

    func textWidth(font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }

    func separateDate(by: Character) -> (first: String, second: String, third: String)? {
        var firstElement = ""
        var secondElement = ""
        var thirdElement = ""
        let separatedDate = self.split(separator: by)

        guard separatedDate.count > 2  else { return nil }
        firstElement = String(separatedDate[0])
        firstElement = firstElement.isEmpty ? "" : "\(firstElement)"
        secondElement = String(separatedDate[1] )
        secondElement = secondElement.isEmpty ? "" : "\(secondElement)"
        thirdElement = String(separatedDate[2] )
        thirdElement = thirdElement.isEmpty ? "" : "\(thirdElement)"

        return (firstElement, secondElement, thirdElement)
    }

    func toDate(format: String = "yyyy-MM-dd") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}
