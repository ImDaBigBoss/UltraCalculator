//
//  Comparable.swift
//  UltraCalculator
//
//  Created by alex on 01/08/2021.
//

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
