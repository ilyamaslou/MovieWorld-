//
//  MWCollectionOfCategoriesHelper.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 5/9/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import Foundation

class MWCollectionsHelper {

    //MARK:- static variables

    static let sh = MWCollectionsHelper()

    //MARK: - initialization

    private init() {}

    //MARK:- functions that retrived working data

    private func sepparateLinesInFile(inFile: String, withExtension: String) -> [String] {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = URL(fileURLWithPath: inFile, relativeTo: directoryURL).appendingPathExtension(withExtension)
        var myStrings: [String] = []
        do {
            let data = try String(contentsOf: fileURL, encoding: .utf8)
            myStrings = data.components(separatedBy: .newlines)
            myStrings.removeLast()
        } catch {
            print(error)
        }
        return myStrings
    }

    func decodeLineByLineFileData<T: Decodable>(file: String = "dailyCollections",
                                                pathExtension: String = "txt",
                                                decodeType: T.Type) -> [T] {
        let stringsToDecode = self.sepparateLinesInFile(inFile: file, withExtension: pathExtension)
        var decodedArray: [T] = []
        for string in stringsToDecode {
            guard let stringData = string.data(using: .utf8) else { continue }
            do {
                let value = try JSONDecoder().decode(decodeType, from: stringData)
                decodedArray.append(value)
            }
            catch {
                print("JSON Decoding Failed with string line: \(string)")
            }
        }
        return decodedArray
    }

    //MARK: - getters

    func getUrl() -> String? {
        guard let date = Date().toString().separateDate(by: "-"),
            let month = Int(date.first),
            let day = Int(date.second),
            let year = Int(date.third) else { return nil }

        var selectedDay = (day - 1) < 10 ? "0\(day - 1)" : "\(day - 1)"
        var selectedMonth = month < 10 ? "0\(month)" : "\(month)"
        var selectedYear = year

        guard selectedDay == "00" else { return String(format: URLPaths.dailyCollectionsURL, selectedMonth, selectedDay, selectedYear) }
        selectedMonth = (month - 1) < 10 ? "0\(month - 1)" : "\(month - 1)"
        if selectedMonth != "00" {
            let numDays = self.getNumOfDays(month: month - 1, year: year)
            selectedDay = "\(numDays ?? 28)"
        } else {
            selectedYear = year - 1
            selectedMonth = "12"
            selectedDay = "31"
        }
        return String(format: URLPaths.dailyCollectionsURL, selectedMonth, selectedDay, selectedYear)
    }

    private func getNumOfDays(month: Int, year: Int) -> Int? {
        let dateComponents = DateComponents(year: year, month: month - 1)
        let calendar = Calendar.current
        guard let date = calendar.date(from: dateComponents) else { return nil }
        let range = calendar.range(of: .day, in: .month, for: date)
        return range?.count
    }

    //MARK: - save to file action

    func saveToFile(data: Data) throws {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = URL(fileURLWithPath: "dailyCollections", relativeTo: directoryURL).appendingPathExtension("txt")

        let decompressedData: Data
        if data.isGzipped {
            decompressedData = try data.gunzipped()
            try decompressedData.write(to: fileURL)
        } else {
            decompressedData = data
        }
    }
}
