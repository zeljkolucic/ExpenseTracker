//
//  CategoriesRepository.swift
//  ExpenseTracker
//
//  Created by Zeljko Lucic on 22.9.22..
//

import Foundation

protocol CategoriesRepository {
    func getSubcategories(completion: @escaping (Result<[FirestoreSubcategory], Error>) -> Void)
}
