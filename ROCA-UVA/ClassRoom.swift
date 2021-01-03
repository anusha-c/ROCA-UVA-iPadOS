//
//  ClassRoom.swift
//  ROCA-UVA
//
//  Created by Anusha Choudhary on 12/20/20.
//
struct ClassRoom {
    var title: String
    var num: [String]
    var imgURI: String?
    
    init(_ title: String, _ num: [String]){
        self.title = title;
        self.num = num;
    }
}

