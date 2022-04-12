//
//  Box.swift
//  MyAnimeList
//
//  Created by Jill Chang on 2022/4/12.
//

import Foundation

public class Box<T> {
    public typealias LinsterType = (_ newValue: T?, _ oldValue: T?) -> Void

    public var eventListeners: [LinsterType] = []

    public var value: T? {
        didSet {
            self.execute(newValue: value, oldValue: oldValue)
        }
    }

    public init(_ value: T?, listener: [LinsterType]? = nil) {

        self.value = value
        self.eventListeners = listener ?? []
    }

    deinit {
    }

    public func binding(trigger: Bool = true, _ index: Int? = nil, listener: @escaping LinsterType) {
        self.appendingBinding(trigger: trigger, index: index, listener: listener)
    }

    private func appendingBinding(trigger: Bool = true, index: Int? = nil, listener: @escaping LinsterType) {
        if let index = index, index < self.eventListeners.count {
            self.eventListeners.insert(listener, at: index)
        } else {
            self.eventListeners.append(listener)
        }

        if trigger {
            listener(self.value, self.value)
        }
    }

    public func removeAllBinding() {
        self.eventListeners.removeAll()
    }

    private func execute(newValue: T?, oldValue: T?) {
        for listener in self.eventListeners {
            listener(newValue, oldValue)
        }
    }
}
