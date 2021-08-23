//
// This source file is part of the Apodini open source project
//
// SPDX-FileCopyrightText: 2019-2021 Paul Schmiedmayer and the Apodini project authors (see CONTRIBUTORS.md) <paul.schmiedmayer@tum.de>
//
// SPDX-License-Identifier: MIT
//

import Foundation

/// Represents distinct cases of necessities for parameters or properties of an object
public enum Necessity: String, TypeInformationElement {
    /// `.required` necessity describes properties which require a value in any case.
    case required
    /// `.optional` necessity describes properties which do not necessarily require a value.
    case optional
}

/// An object that represents a property of an `.object` TypeInformation
public struct TypeProperty {
    /// Name of the property
    public let name: String
    /// Type of the property
    public let type: TypeInformation
    /// Annotation of the property, e.g. `@Field` of Fluent property
    public let annotation: String?

    /// Necessity of a property
    public var necessity: Necessity {
        type.isOptional ? .optional : .required
    }
    
    /// Initializes a new `TypeProperty` instance
    public init(name: String, type: TypeInformation, annotation: String? = nil) {
        self.name = name
        self.type = type
        self.annotation = annotation
    }
    
    /// Returns a version of self where the type is a reference
    public func referencedType() -> TypeProperty {
        .init(name: name, type: type.asReference(), annotation: annotation)
    }
}

extension TypeProperty: Codable {
    // MARK: Private Inner Types
    private enum CodingKeys: String, CodingKey {
        case name, type, annotation
    }
}

extension TypeProperty: Hashable {
    public static func == (lhs: TypeProperty, rhs: TypeProperty) -> Bool {
        lhs.name == rhs.name && lhs.type == rhs.type
    }
}
