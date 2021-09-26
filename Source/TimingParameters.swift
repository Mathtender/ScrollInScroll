//
//  TimingParameters.swift
//  ScrollInScroll
//
//  Created by Mathtender on 26.09.21.
//

import UIKit

protocol AnimationTimingParameters {
    var duration: TimeInterval { get }
    func value(at time: TimeInterval) -> CGPoint
}

struct ScrollTimingParameters: AnimationTimingParameters {

    // MARK: - Parameters

    private let decelerationMultiplier: CGFloat
    let initialOffset: CGPoint
    let initialVelocity: CGPoint
    let decelerationRate: CGFloat
    let threshold: CGFloat

    var destination: CGPoint {
        let calculatedOffset = initialVelocity / decelerationMultiplier
        return initialOffset - calculatedOffset
    }

    var duration: TimeInterval {
        guard initialVelocity.length != 0 else { return 0 }
        return TimeInterval(log(-decelerationMultiplier * threshold / initialVelocity.length) / decelerationMultiplier)
    }

    // MARK: - Initialization

    init(initialOffset: CGPoint, initialVelocity: CGPoint, decelerationRate: CGFloat, threshold: CGFloat = 1) {
        self.initialOffset = initialOffset
        self.initialVelocity = initialVelocity
        self.decelerationRate = decelerationRate
        self.threshold = threshold
        self.decelerationMultiplier = 1000 * (decelerationRate - 1) / decelerationRate
    }

    // MARK: - Methods

    func value(at time: TimeInterval) -> CGPoint {
        return initialOffset - (pow(decelerationRate, CGFloat(1000 * time)) - 1) / decelerationMultiplier * initialVelocity
    }
}
