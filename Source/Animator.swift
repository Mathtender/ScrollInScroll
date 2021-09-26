//
//  Animator.swift
//  ScrollInScroll
//
//  Created by Mathtender on 26.09.21.
//

import UIKit

class Animator {

    typealias Animations = (_ progress: Double, _ time: TimeInterval) -> Void
    typealias Completion = (_ finished: Bool) -> Void

    // MARK: - Parameters

    private let duration: TimeInterval
    private let animations: Animations
    private let completion: Completion?
    private let animationStartTime: CFTimeInterval
    private weak var displayLink: CADisplayLink?

    private var animating: Bool = true

    // MARK: - Initialization

    init(duration: TimeInterval, animations: @escaping Animations, completion: Completion? = nil) {
        self.duration = duration
        self.animations = animations
        self.completion = completion

        animationStartTime = CACurrentMediaTime()

        let displayLink = CADisplayLink(target: self, selector: #selector(displayLinkHandler))
        displayLink.add(to: .main, forMode: RunLoop.Mode.common)
        self.displayLink = displayLink
    }

    deinit {
        invalidate()
    }

    // MARK: - Methods

    func invalidate() {
        guard animating else { return }
        animating = false
        completion?(false)
        displayLink?.invalidate()
    }

    @objc private func displayLinkHandler(_ displayLink: CADisplayLink) {
        guard animating else { return }
        let elapsed = CACurrentMediaTime() - animationStartTime
        if elapsed >= duration {
            animations(1, duration)
            animating = false
            completion?(true)
            displayLink.invalidate()
        } else {
            animations(elapsed / duration, elapsed)
        }
    }
}
