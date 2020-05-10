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
        guard let dayBefore = Calendar.current.date(byAdding: .day, value: -1, to: Date()),
            let date = dayBefore.toString().separateDate(by: "-") else { return nil }
        return String(format: URLPaths.dailyCollectionsURL, date.first, date.second, date.third)
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
