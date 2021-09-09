//
//  Question.swift
//  WeMultiply
//
//  Created by Theodor Brown on 03/09/2021.
//

import Foundation

struct Question: Identifiable, Hashable {
    var id = UUID().uuidString

    var operand1: Int
    var operand2: Int
    var calc: Int
    
    init(operand1: Int, operand2: Int, calc: Int) {
        self.operand1 = operand1
        self.operand2 = operand2
        self.calc = calc
    }
}
