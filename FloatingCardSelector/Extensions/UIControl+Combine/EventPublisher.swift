//
//  EventPublisher.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 27/02/2021.
//

import UIKit.UIControl
import Combine

extension UIButton {
    var tapPublisher: EventPublisher {
        publisher(for: .touchUpInside)
    }
}

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        publisher(for: .editingChanged)
            .map { self.text ?? "" }
            .eraseToAnyPublisher()
    }
    
    var keyboardReturnPublisher: AnyPublisher<Void, Never> {
        publisher(for: .editingDidEndOnExit)
            .eraseToAnyPublisher()
    }
    
    
}

extension UIControl {
    func publisher(for event: Event) -> EventPublisher {
        return EventPublisher(control: self, event: event)
    }
}

extension UIControl {
    struct EventPublisher: Publisher {
        typealias Output = Void
        typealias Failure = Never

        fileprivate var control: UIControl
        fileprivate var event: Event
        
        func receive<S: Subscriber>(subscriber: S) where S.Input == Output, S.Failure == Failure {
            let subscription = EventSubscription<S>()
            subscription.target = subscriber
            
            subscriber.receive(subscription: subscription)

            control.addTarget(subscription, action: #selector(subscription.trigger), for: event)
        }
    }
}

private extension UIControl {
    class EventSubscription<Target: Subscriber>: Subscription
        where Target.Input == Void {
        
        var target: Target?

        func request(_ demand: Subscribers.Demand) {}

        func cancel() {
            target = nil
        }

        @objc func trigger() {
            let _ = target?.receive(())
        }
    }
}

