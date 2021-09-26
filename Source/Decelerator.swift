//
//  Decelerator.swift
//  ScrollInScroll
//
//  Created by Mathtender on 26.09.21.
//

import UIKit

class Decelerator {

    // MARK: - Methods

    static func animateDeceleration(parameters: AnimationTimingParameters,
                                    animation: @escaping ((CGPoint) -> Void),
                                    completion: ((Bool) -> Void)? = nil) -> Animator {
        return Animator(duration: parameters.duration) { progress, _ in
            animation(parameters.value(at: progress * parameters.duration))
        } completion: { finished in
            completion?(finished)
        }
    }
}
