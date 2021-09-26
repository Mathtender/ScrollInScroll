//
//  ViewController.swift
//  ScrollInScroll
//
//  Created by Mathtender on 26.09.21.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    // MARK: - Parameters

    @IBOutlet weak var outerScroll: UIScrollView! {
        didSet {
            outerScroll.isScrollEnabled = false
        }
    }
    @IBOutlet weak var innerScroll: UIScrollView! {
        didSet {
            innerScroll.isScrollEnabled = false
        }
    }

    private lazy var panGesture = UIPanGestureRecognizer()
    private lazy var longPressGesture = UILongPressGestureRecognizer()

    private var outerScrollMaxOffset: CGFloat {
        return outerScroll.contentSize.height - outerScroll.bounds.height
    }
    private var innerScrollMaxOffset: CGFloat {
        return innerScroll.contentSize.height - innerScroll.bounds.height
    }

    private var decelerationAnimation: Animator?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        panGesture.addTarget(self, action: #selector(panHandler))
        view.addGestureRecognizer(panGesture)

        longPressGesture.addTarget(self, action: #selector(longPressHandler))
        longPressGesture.minimumPressDuration = 0
        longPressGesture.allowableMovement = 0
        view.addGestureRecognizer(longPressGesture)

        longPressGesture.delegate = self
        panGesture.delegate = self
    }

    // MARK: - Gestures

    @objc func panHandler(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)

        switch gesture.state {
        case .changed:
            if innerScroll.contentOffset.y > 0 {
                let offset = innerScroll.contentOffset.y - translation.y
                if offset < 0 {
                    innerScroll.contentOffset.y = 0
                } else if offset > innerScrollMaxOffset {
                    innerScroll.contentOffset.y = innerScrollMaxOffset
                } else {
                    innerScroll.contentOffset.y = offset
                }
            } else {
                let offset = outerScroll.contentOffset.y - translation.y
                if offset < 0 {
                    outerScroll.contentOffset.y = 0
                } else if offset > innerScrollMaxOffset {
                    outerScroll.contentOffset.y = outerScrollMaxOffset
                } else {
                    outerScroll.contentOffset.y = offset
                }
            }
        case .ended:
            if innerScroll.contentOffset.y > 0 {
                decelerateInnerScroll()
            } else {
                decelerateouterScroll()
            }
        default:
            break
        }

        gesture.setTranslation(.zero, in: view)
    }

    @objc func longPressHandler(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        decelerationAnimation?.invalidate()
    }

    // MARK: - Deceleration

    private func decelerateouterScroll() {
        let decelerationParameters = ScrollTimingParameters(
            initialOffset: outerScroll.contentOffset,
            initialVelocity: panGesture.velocity(in: view),
            decelerationRate: outerScroll.decelerationRate.rawValue)

        self.decelerationAnimation = Decelerator.animateDeceleration(parameters: decelerationParameters) { [weak self] progress in
            guard let self = self else { return }

            if progress.y < 0 {
                self.outerScroll.contentOffset.y = 0
                self.decelerationAnimation?.invalidate()
            } else if progress.y >= self.outerScrollMaxOffset {
                self.outerScroll.contentOffset.y = self.outerScrollMaxOffset
                self.updateInnerScroll(progress: progress.y - self.outerScrollMaxOffset)
            } else {
                self.outerScroll.contentOffset.y = progress.y
            }
        } completion: { [weak self] _ in
            self?.decelerationAnimation = nil
        }
    }

    private func decelerateInnerScroll() {
        let decelerationParameters = ScrollTimingParameters(
            initialOffset: innerScroll.contentOffset,
            initialVelocity: panGesture.velocity(in: view),
            decelerationRate: innerScroll.decelerationRate.rawValue)

        self.decelerationAnimation = Decelerator.animateDeceleration(parameters: decelerationParameters) { [weak self] progress in
            guard let self = self else { return }

            if progress.y < 0 {
                self.innerScroll.contentOffset.y = 0
                self.updateouterScroll(progress: self.outerScrollMaxOffset + progress.y)
            } else if progress.y >= self.innerScrollMaxOffset {
                self.outerScroll.contentOffset.y = self.outerScrollMaxOffset
                self.decelerationAnimation?.invalidate()
            } else {
                self.innerScroll.contentOffset.y = progress.y
            }
        } completion: { [weak self] _ in
            self?.decelerationAnimation = nil
        }
    }

    private func updateouterScroll(progress: CGFloat) {
        if progress < 0 {
            outerScroll.contentOffset.y = 0
            decelerationAnimation?.invalidate()
        } else {
            outerScroll.contentOffset.y = progress
        }
    }

    private func updateInnerScroll(progress: CGFloat) {
        if progress > innerScrollMaxOffset {
            innerScroll.contentOffset.y = innerScrollMaxOffset
            decelerationAnimation?.invalidate()
        } else {
            innerScroll.contentOffset.y = progress
        }
    }

    // MARK: - UIGestureRecognizerDelegate

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

