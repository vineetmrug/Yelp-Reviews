//
//  NetworkManagerTests.swift
//  Yelp ReviewsTests
//
//  Created by Vineet Mrug on 2019-08-12.
//  Copyright © 2019 Vineet Mrug. All rights reserved.
//

import XCTest
@testable import Yelp_Reviews

class NetworkManagerTests: XCTestCase {

    func testSearchBusinesses() {
        let expectation = XCTestExpectation(description: "Search businesses")
        let searchTerm = "italian"
        let limit = 10
        NetworkManager.shared.searchBusinesses(searchTerm: searchTerm, location: "toronto", limit: limit, completion: { result in
            switch result {
            case .success(let businesses):
                expectation.fulfill()
                XCTAssertEqual(businesses.count, limit)
            case .error(let errorMessage):
                XCTFail(errorMessage)
            }
        })
        wait(for: [expectation], timeout: 10)
    }

    func testBusinessesDetails() {
        let expectation = XCTestExpectation(description: "Businesses details")
        let businessId = "B70iTJjcPkuYn8ouUewWgw"
        NetworkManager.shared.getBusinessDetails(id: businessId, completion: { result in
            switch result {
            case .success(let business):
                expectation.fulfill()
                XCTAssertEqual(business.id, businessId)
            case .error(let errorMessage):
                XCTFail(errorMessage)
            }
        })
        wait(for: [expectation], timeout: 10)
    }

    func testBusinessesReviews() {
        let expectation = XCTestExpectation(description: "Businesses reviews")
        let businessId = "B70iTJjcPkuYn8ouUewWgw"
        NetworkManager.shared.getReviews(id: businessId, completion: { result in
            switch result {
            case .success(_):
                expectation.fulfill()
            case .error(let errorMessage):
                XCTFail(errorMessage)
            }
        })
        wait(for: [expectation], timeout: 10)
    }

}
