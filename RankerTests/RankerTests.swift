//
//  RankerTests.swift
//  RankerTests
//
//  Created by Shyam Kumar on 9/24/21.
//

import FirebaseFirestore
import XCTest
@testable import Ranker

class RankerTests: XCTestCase {
    
    // MARK: - TEST UID GET/SET
    func testUID() {
        XCTAssertNotNil(uid)
    }
    
    // MARK: - TEST MODEL
    func testAdd() {
        if let sut = generateSUT() {
            let db = Firestore.firestore()
            let expectation = XCTestExpectation(description: "Waiting for add...")
            db.add(collectionName: .polls, object: sut, completion: {
                expectation.fulfill()
            })
            
            wait(for: [expectation], timeout: 10)
        }
    }
    
    func testAddGetDelete() {
        if let sut = generateSUT() {
            let db = Firestore.firestore()
            let expectation = XCTestExpectation(description: "Waiting for add...")
            db.add(collectionName: .polls, object: sut, completion: {
                expectation.fulfill()
            })
            
            wait(for: [expectation], timeout: 10)
            
            let fetchExpectation = XCTestExpectation(description: "Waiting for fetch...")
            db.getAll(collectionName: .polls, decodeInto: [Poll.self], completion: { [self] polls in
                if let polls = polls {
                    if let decodedSUT = polls.last {
                        checkEquality(left: sut, right: decodedSUT)
                        fetchExpectation.fulfill()
                    }
                } else {
                    XCTFail("Could not retrieve polls.")
                }
            })
            
            wait(for: [fetchExpectation], timeout: 10)
            
            db.delete(collectionName: .polls, document: sut.id)
            
            let checkForDeletedDocumentExpectation = XCTestExpectation(description: "Waiting...")
            db.getAll(collectionName: .polls, decodeInto: [Poll.self], completion: { [self] polls in
                if let polls = polls {
                    if let _ = getMatchingObj(arr: polls, obj: sut) {
                        XCTFail("Found deleted object")
                    }
                }
                checkForDeletedDocumentExpectation.fulfill()
            })
            
            wait(for: [checkForDeletedDocumentExpectation], timeout: 10)
        }
    }
    
    func testAddVote() {
        if let sut = generateSUT() {
            let db = Firestore.firestore()
            let expectation = XCTestExpectation(description: "Waiting for add...")
            db.add(collectionName: .polls, object: sut, completion: {
                let vote = Vote(id: UUID().uuidString, data: [
                    "1": sut.choices[1],
                    "2": sut.choices[0]
                ])
                sut.addVote(vote: vote)
                db.getAll(collectionName: .polls, decodeInto: [Poll.self], completion: { [self] polls in
                    if let polls = polls {
                        if let poll = getMatchingObj(arr: polls, obj: sut) {
                            checkEquality(left: sut, right: poll)
                        }
                    }
                    expectation.fulfill()
                })
            })
            
            wait(for: [expectation], timeout: 10)
        }
    }
    
    func testTimeSincePost() {
        let db = Firestore.firestore()
        let expectation = XCTestExpectation(description: "Waiting for fetch...")
        db.getAll(collectionName: .polls, decodeInto: [Poll.self], completion: { polls in
            if let polls = polls {
                for poll in polls {
                    print(poll.getTimeSincePost())
                }
            }
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10)
    }
}

extension RankerTests {
    func generateSUT() -> Poll? {
        let pc1 = PollChoice(
            id: UUID().uuidString,
            title: "Talladega Nights",
            color: Color.red.rawValue
        )
        let pc2 = PollChoice(
            id: UUID().uuidString,
            title: "Superbad",
            color: Color.blue.rawValue
        )
        let pc3 = PollChoice(
            id: UUID().uuidString,
            title: "Borat 1",
            color: Color.pink.rawValue
        )
        let pc4 = PollChoice(
            id: UUID().uuidString,
            title: "Borat 2",
            color: Color.purple.rawValue
        )
        let pc5 = PollChoice(
            id: UUID().uuidString,
            title: "The Dictator",
            color: Color.teal.rawValue
        )
        
        if let uid = uid {
            return Poll(
                postedBy: uid,
                question: "How do you rank these 5 movies?",
                choices: [
                    pc1,
                    pc2,
                    pc3,
                    pc4,
                    pc5
                ],
                date: Date()
            )
        } else {
            XCTFail("Could not get user id")
            return nil
        }
    }
    
    func checkEquality(left: Poll, right: Poll) {
        XCTAssertEqual(left.postedBy, right.postedBy)
        XCTAssertEqual(left.id, right.id)
        XCTAssertEqual(left.question, right.question)
        
        for choice in left.choices {
            checkEquality(left: choice, right: getMatchingObj(arr: right.choices, obj: choice) ?? PollChoice())
        }
        for vote in right.votes {
            checkEquality(left: vote, right: getMatchingObj(arr: right.votes, obj: vote))
        }
    }
    
    func checkEquality(left: Vote?, right: Vote?) {
        XCTAssertEqual(left?.id, right?.id)
        for (key, val) in ((left?.data) ?? [:]) {
            checkEquality(left: val, right: right?.data[key] ?? PollChoice())
        }
    }
    
    func checkEquality(left: PollChoice, right: PollChoice) {
        XCTAssertEqual(left.id, right.id)
        XCTAssertEqual(left.title, left.title)
        XCTAssertEqual(left.color, right.color)
    }
    
    func getMatchingObj<T: Identifiable>(arr: [T], obj: T) -> T? {
        return arr.filter({ $0.id == obj.id }).first
    }
}
