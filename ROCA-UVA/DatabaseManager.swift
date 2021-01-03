//
//  DatabaseManager.swift
//  ROCA-UVA
//
//  Created by Anusha Choudhary on 12/22/20.
//

import Foundation

struct DatabaseManager {
    func getDatabaseContents() -> Database? {
        guard let mainUrl = Bundle.main.url(forResource: "database", withExtension: "json") else { return nil}

        return decodeData(pathName: mainUrl)
    }
    
    func decodeData(pathName: URL)->Database?{
                do{
                    let jsonData = try Data(contentsOf: pathName)
                    let decoder = JSONDecoder()
                    let database = try decoder.decode(Database.self, from: jsonData)
                    return database;
                } catch {}
        return nil;
    }
}


