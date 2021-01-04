//
//  ClassRoom.swift
//  ROCA-UVA
//
//  Created by Anusha Choudhary on 12/20/20.
//

import UIKit

struct ClassRoom {
    var title: String
    var num: [String]
    var imgURI: String?
    var sections: [CGRect]?
    
    init(_ title: String, _ num: [String]){
        self.title = title;
        self.num = num;
        let x = 80
        let y = 100
        let w = 403
        let h = 60
        
        self.sections = [CGRect(x: x, y: y, width: w, height: h),
                         CGRect(x: x+w, y: y, width: w, height: h),
                         CGRect(x: x-70, y: y+h+5, width: w+70, height: h+20),
                         CGRect(x: x+w, y: y+h+5, width: w+70, height: h+20),
                         CGRect(x: x-100, y: y+(2*h)+30, width: w+100, height: h+40),
                         CGRect(x: x+w, y: y+(2*h)+30, width: w+100, height: h+40)
                        ]
    }
}

