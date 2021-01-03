//
//  Database.swift
//  ROCA-UVA
//
//  Created by Anusha Choudhary on 12/20/20.
//

import Foundation

struct Database : Decodable {
    let activities: [Activities];
    let a_events: AEvents;
    let z_events: ZEvents;
    let rooms: [Rooms];
}

struct Activities : Decodable {
    let title: String;
    let data: [ActivityItem];
}

struct ActivityItem : Decodable {
    let title: String;
    let code: String;
    let key: Int;
    
}

struct AEvents : Decodable {
    let Instructor: [EventItem];
    let Technology: [EventItem];
    let Student: [EventItem];
}

struct ZEvents : Decodable {
    let Instructor: [EventItem];
}

struct EventItem : Decodable {
    let title: String;
    let code: String;
    let type: String;
    let dependencies: [Int]
}

struct Rooms : Decodable {
    let name: String;
    let key: Int;
    let z1: [Int]?;
    let z2: [Int]?;
    let z3: [Int]?;
    let z4: [Int]?;
    let z5: [Int]?;
    let z6: [Int]?;
}


