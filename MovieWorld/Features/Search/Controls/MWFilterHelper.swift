//
//  MWFilterHelper.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 5/15/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import Foundation

struct MWFilterHelper {

    //MARK: - private variable

    private var movieFilters: MWFilters?

    //MARK:- static variables

    static var sh = MWFilterHelper()

    //MARK: - initialization

    private init() {}

    //MARK: - setter

    mutating func filter(for moviesForFiltering: [MWMovie], filters: MWFilters?) -> [MWMovie]? {
        self.movieFilters = filters

        let moviesFilteredByGenre = self.getFilteredMovies(for: moviesForFiltering,
                                                           filter: self.filterMoviesByGenre)
        let moviesFilteredByYear = self.getFilteredMovies(for: moviesFilteredByGenre,
                                                          filter: self.filterMoviesByYear)
        let moviesFilteredByCountry = self.getFilteredMovies(for: moviesFilteredByYear,
                                                             filter: self.filterMoviesByCountry)
        return self.getFilteredMovies(for: moviesFilteredByCountry,
                                      filter: self.filterMoviesByRating)
    }

    //MARK: - getters

    private func getFilteredMovies(for moviesForFilter: [MWMovie]?,
                                   filter: ( ([MWMovie]) -> [MWMovie]?)) -> [MWMovie]? {
        guard let moviesForFilter = moviesForFilter else { return nil }
        var moviesFilteredByAttribute: [MWMovie]? = []
        moviesFilteredByAttribute = filter(moviesForFilter)

        if let filtredMovies = moviesFilteredByAttribute, filtredMovies.isEmpty {
            return []
        } else if moviesFilteredByAttribute == nil {
            return moviesForFilter
        }

        return moviesFilteredByAttribute
    }

    private func getCountriesIso() -> [String?] {
        guard let countries = self.movieFilters?.countries else { return [] }
        var countriesIso: [String?] = []
        for sysCountry in MWSys.sh.languages {
            for country in countries {
                if country == sysCountry.englishName {
                    countriesIso.append(sysCountry.iso)
                }
            }
        }
        return countriesIso
    }

    //MARK: filtering actions

    private func filterMoviesByGenre(for moviesForFiltering: [MWMovie]) -> [MWMovie]? {
        guard let genres = self.movieFilters?.genres, !genres.isEmpty else { return nil }
        var tempFilteredMovies: [MWMovie] = []
        tempFilteredMovies.append(contentsOf: moviesForFiltering.filter{ (movie) in
            var isFiltered: Bool = false
            for genre in genres {
                isFiltered = (movie.movieGenres?.contains(genre) ?? false)
            }
            return isFiltered && !tempFilteredMovies.contains(movie)
        })
        return tempFilteredMovies
    }

    private func filterMoviesByYear(for moviesForFiltering: [MWMovie]) -> [MWMovie]? {
        guard let year = self.movieFilters?.year, !year.isEmpty else { return nil }
        var tempFilteredMovies: [MWMovie] = []
        tempFilteredMovies = moviesForFiltering.filter { $0.getMovieReleaseYear() == year }
        return tempFilteredMovies
    }

    private func filterMoviesByCountry(for moviesForFiltering: [MWMovie]) -> [MWMovie]? {
        let countries = self.getCountriesIso()
        guard !countries.isEmpty else { return nil }
        var tempFilteredMovies: [MWMovie] = []
        for country in countries {
            tempFilteredMovies.append(contentsOf: moviesForFiltering.filter{ $0.originalLanguage == country })
        }
        return tempFilteredMovies
    }

    private func filterMoviesByRating(for moviesForFiltering: [MWMovie]) -> [MWMovie]? {
        guard let ratingRange = self.movieFilters?.ratingRange else { return nil }
        var tempFilteredMovies: [MWMovie] = []
        let minRating = Double(ratingRange.0)
        let maxRating = Double(ratingRange.1)
        tempFilteredMovies = moviesForFiltering.filter{ ($0.voteAvarage ?? 100.0 >= minRating)
            && ($0.voteAvarage ?? 100.0 <= maxRating) }
        return tempFilteredMovies
    }
}
