import XCTest
@testable import UserDefaultsSerializable

final class UserDefaultsSerializableTests: XCTestCase {
    enum Constant {
        static let key = "key"
        static let userDefaultsDefaultBoolValue = false
        static let userDefaultsDefaultIntegerValue: Int = 0
        static let userDefaultsDefaultDoubleValue: Double = 0
        static let userDefaultsDefaultFloatValue: Float = 0
    }

    private var userDefaults: MockUserDefaults!

    override func setUpWithError() throws {
        try super.setUpWithError()

        MockPropertyListType.didGetValue = false
        userDefaults = MockUserDefaults()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func test_string_저장및조회() {
        /// given
        let savingValue = "newValue"
        let defaultValue = "default"

        @UserDefaultsSerializable(
            key: Constant.key,
            defaultValue: defaultValue,
            userDefaults: userDefaults
        )
        var variable: String

        /// when
        variable = savingValue

        /// then
        XCTAssertEqual(savingValue, variable)
    }

    func test_string_없는값조회시_디폴트값반환() {
        /// given
        let defaultValue = "default"

        @UserDefaultsSerializable(
            key: Constant.key,
            defaultValue: defaultValue,
            userDefaults: userDefaults
        )
        var variable: String

        /// when

        /// then
        XCTAssertEqual(defaultValue, variable)
    }

    func test_string_키는같으나_다른타입으로_삽입후_조회시_디폴트값반환() {
        /// given
        let stringDefaultValue = "default"
        let savingValue = 10000

        @UserDefaultsSerializable(
            key: Constant.key,
            defaultValue: stringDefaultValue,
            userDefaults: userDefaults
        )
        var sameKeyStringType: String

        @UserDefaultsSerializable(
            key: Constant.key,
            defaultValue: 10,
            userDefaults: userDefaults
        )
        var sameKeyIntegerType: Int

        /// when
        sameKeyIntegerType = savingValue

        /// then
        XCTAssertEqual(stringDefaultValue, sameKeyStringType)
        XCTAssertEqual(sameKeyIntegerType, savingValue)
    }

    func test_integer_없는값조회시_userDefault로직무시하고_디폴트값반환() {
        /// given
        let defaultValue = 10

        @UserDefaultsSerializable(
            key: Constant.key,
            defaultValue: defaultValue,
            userDefaults: userDefaults
        )
        var variable: Int

        /// when

        /// then
        XCTAssertEqual(defaultValue, variable)
        XCTAssertNotEqual(Constant.userDefaultsDefaultIntegerValue, variable)
    }

    func test_double_없는값조회시_userDefault로직무시하고_디폴트값반환() {
        /// given
        let defaultValue: Double = 10

        @UserDefaultsSerializable(
            key: Constant.key,
            defaultValue: defaultValue,
            userDefaults: userDefaults
        )
        var variable: Double

        /// when

        /// then
        XCTAssertEqual(defaultValue, variable)
        XCTAssertNotEqual(Constant.userDefaultsDefaultDoubleValue, variable)
    }

    func test_float_없는값조회시_userDefault로직무시하고_디폴트값반환() {
        /// given
        let defaultValue: Float = 10

        @UserDefaultsSerializable(
            key: Constant.key,
            defaultValue: defaultValue,
            userDefaults: userDefaults
        )
        var variable: Float

        /// when

        /// then
        XCTAssertEqual(defaultValue, variable)
        XCTAssertNotEqual(Constant.userDefaultsDefaultFloatValue, variable)
    }

    func test_bool_없는값조회시_userDefault로직무시하고_디폴트값반환() {
        /// given
        let defaultValue = true

        @UserDefaultsSerializable(
            key: Constant.key,
            defaultValue: defaultValue,
            userDefaults: userDefaults
        )
        var variable: Bool

        /// when

        /// then
        XCTAssertEqual(defaultValue, variable)
        XCTAssertNotEqual(Constant.userDefaultsDefaultBoolValue, variable)
    }

    func test_propertyListType인경우_자체로직으로_저장및조회_수행() {
        /// given
        let defaultValue = MockPropertyListType()
        let savingValue = MockPropertyListType()

        @UserDefaultsSerializable(
            key: Constant.key,
            defaultValue: defaultValue,
            userDefaults: userDefaults
        )
        var variable: MockPropertyListType

        XCTAssertEqual(MockPropertyListType.didGetValue, false)

        /// when
        variable = savingValue

        /// then
        XCTAssertEqual(MockPropertyListType.didGetValue, false)

        /// when
        _ = variable

        /// then
        XCTAssertEqual(MockPropertyListType.didGetValue, true)
    }

    func test_일반타입인경우_저장및조회() {
        /// given
        let defaultValue = MockNotPropertyListType(integer: 1)
        let savingValue = MockNotPropertyListType(integer: 10)

        @UserDefaultsSerializable(
            key: Constant.key,
            defaultValue: defaultValue,
            userDefaults: userDefaults
        )
        var variable: MockNotPropertyListType

        /// when
        variable = savingValue

        /// then
        XCTAssertEqual(variable, savingValue)
    }

    func test_일반타입인경우_없는값조회시_디폴트값반환() {
        /// given
        let defaultValue = MockNotPropertyListType(integer: 1)

        @UserDefaultsSerializable(
            key: Constant.key,
            defaultValue: defaultValue,
            userDefaults: userDefaults
        )
        var variable: MockNotPropertyListType

        /// when

        /// then
        XCTAssertEqual(variable, defaultValue)
    }

    func test_일반타입인경우_Data로_변환한후_저장() {
        /// given
        let defaultValue = MockNotPropertyListType(integer: 1)
        let savingValue = MockNotPropertyListType(integer: 10)

        @UserDefaultsSerializable(
            key: Constant.key,
            defaultValue: defaultValue,
            userDefaults: userDefaults
        )
        var variable: MockNotPropertyListType

        XCTAssertEqual(userDefaults.didSetWithDataObject, false)

        /// when
        variable = savingValue

        /// then
        XCTAssertEqual(variable, savingValue)
        XCTAssertEqual(userDefaults.didSetWithDataObject, true)
    }

    func test_array_Element가_PropertyListType인경우_저장및조회() {
        /// given
        let defaultValue: [Int] = []
        let savingValue: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

        @UserDefaultsSerializable(
            key: Constant.key,
            defaultValue: defaultValue,
            userDefaults: userDefaults
        )
        var variable: [Int]

        /// when
        variable = savingValue

        /// then
        XCTAssertEqual(variable, savingValue)
    }

    func test_array_Element가_복잡한PropertyListType인경우_저장및조회() {
        /// given
        let defaultValue: [[[[[[Int]]]]]] = []
        let savingValue: [[[[[[Int]]]]]] = [
            [
                [
                    [
                        [
                            [
                                1, 2, 3, 4, 5, 6, 7, 8, 9, 10
                            ]
                        ]
                    ]
                ]
            ]
        ]

        @UserDefaultsSerializable(
            key: Constant.key,
            defaultValue: defaultValue,
            userDefaults: userDefaults
        )
        var variable: [[[[[[Int]]]]]]

        /// when
        variable = savingValue

        /// then
        XCTAssertEqual(variable, savingValue)
    }

    func test_array_Element가_복잡한PropertyListType인경우_저장및조회2() {
        /// given
        let defaultValue: [[String: [String: Int]]] = []
        let savingValue: [[String: [String: Int]]] = [
            [
                "key": [
                    "key": 10
                ]
            ]
        ]

        @UserDefaultsSerializable(
            key: Constant.key,
            defaultValue: defaultValue,
            userDefaults: userDefaults
        )
        var variable: [[String: [String: Int]]]

        /// when
        variable = savingValue

        /// then
        XCTAssertEqual(variable, savingValue)
    }

    func test_array_Element가_PropertyListType이_아닌경우_Data로변환후_저장및조회() {
        /// given
        let defaultValue: [MockNotPropertyListType] = []
        let savingValue: [MockNotPropertyListType] = [
            MockNotPropertyListType(integer: 1),
            MockNotPropertyListType(integer: 2),
            MockNotPropertyListType(integer: 3),
            MockNotPropertyListType(integer: 4),
            MockNotPropertyListType(integer: 5),
            MockNotPropertyListType(integer: 6),
            MockNotPropertyListType(integer: 7),
            MockNotPropertyListType(integer: 8),
            MockNotPropertyListType(integer: 9),
            MockNotPropertyListType(integer: 10)
        ]

        @UserDefaultsSerializable(
            key: Constant.key,
            defaultValue: defaultValue,
            userDefaults: userDefaults
        )
        var variable: [MockNotPropertyListType]

        XCTAssertEqual(userDefaults.didSetWithDataObject, false)

        /// when
        variable = savingValue

        /// then
        XCTAssertEqual(variable, savingValue)
        XCTAssertEqual(userDefaults.didSetWithDataObject, true)
    }

    func test_dictionary_Key가_String이고_Value가PropertyListType인경우_저장및조회() {
        /// given
        let defaultValue: [String: Int] = [:]
        let savingValue: [String: Int] = [
            "key": 1
        ]

        @UserDefaultsSerializable(
            key: Constant.key,
            defaultValue: defaultValue,
            userDefaults: userDefaults
        )
        var variable: [String: Int]

        /// when
        variable = savingValue

        /// then
        XCTAssertEqual(variable, savingValue)
    }

    func test_dictionary_Key가_String이고_Value가_복잡한PropertyListType인경우_저장및조회() {
        /// given
        let defaultValue: [String: [String: [String: [String: [String: Int]]]]] = [:]
        let savingValue: [String: [String: [String: [String: [String: Int]]]]] = [
            "key": [
                "key": [
                    "key": [
                        "key": [
                            "key": 1
                        ]
                    ]
                ]
            ]
        ]

        @UserDefaultsSerializable(
            key: Constant.key,
            defaultValue: defaultValue,
            userDefaults: userDefaults
        )
        var variable: [String: [String: [String: [String: [String: Int]]]]]

        /// when
        variable = savingValue

        /// then
        XCTAssertEqual(variable, savingValue)
    }

    func test_dictionary_Key가_String이고_Value가_복잡한PropertyListType인경우_저장및조회2() {
        /// given
        let defaultValue: [String: [[String: [String: [Int]]]]] = [:]
        let savingValue: [String: [[String: [String: [Int]]]]] = [
            "key": [
                [
                    "key": [
                        "key": [1]
                    ]
                ]
            ]
        ]

        @UserDefaultsSerializable(
            key: Constant.key,
            defaultValue: defaultValue,
            userDefaults: userDefaults
        )
        var variable: [String: [[String: [String: [Int]]]]]

        /// when
        variable = savingValue

        /// then
        XCTAssertEqual(variable, savingValue)
    }

    func test_dictionary_Key가_String이_아닌경우_Data로변환후_저장및조회() {
        /// given
        let defaultValue: [Int: Int] = [:]
        let savingValue: [Int: Int] = [
            1: 2
        ]

        @UserDefaultsSerializable(
            key: Constant.key,
            defaultValue: defaultValue,
            userDefaults: userDefaults
        )
        var variable: [Int: Int]

        XCTAssertEqual(userDefaults.didSetWithDataObject, false)

        /// when
        variable = savingValue

        /// then
        XCTAssertEqual(variable, savingValue)
        XCTAssertEqual(userDefaults.didSetWithDataObject, true)
    }

    func test_dictionary_Value가_PropertyListType이_아닌경우_Data로변환후_저장및조회() {
        /// given
        let defaultValue: [String: MockNotPropertyListType] = [:]
        let savingValue: [String: MockNotPropertyListType] = [
            "key": MockNotPropertyListType(integer: 1)
        ]

        @UserDefaultsSerializable(
            key: Constant.key,
            defaultValue: defaultValue,
            userDefaults: userDefaults
        )
        var variable: [String: MockNotPropertyListType]

        XCTAssertEqual(userDefaults.didSetWithDataObject, false)

        /// when
        variable = savingValue

        /// then
        XCTAssertEqual(variable, savingValue)
        XCTAssertEqual(userDefaults.didSetWithDataObject, true)
    }

    func test_optional_Wrapped가_PropertyListType일때_저장및조회() {
        /// given
        let defaultValue: Int? = nil
        let savingValue: Int? = 10

        @UserDefaultsSerializable(
            key: Constant.key,
            defaultValue: defaultValue,
            userDefaults: userDefaults
        )
        var variable: Int?

        /// when
        variable = savingValue

        /// then
        XCTAssertEqual(variable, savingValue)
    }

    func test_optional_Wrapped가_PropertyListType일때_nil_저장시_데이터제거() {
        /// given
        let defaultValue: Int? = nil
        let savingValue: Int? = 10

        @UserDefaultsSerializable(
            key: Constant.key,
            defaultValue: defaultValue,
            userDefaults: userDefaults
        )
        var variable: Int?

        variable = savingValue
        XCTAssertEqual(variable, savingValue)

        /// when
        variable = nil

        /// then
        let object = userDefaults.object(forKey: Constant.key)
        XCTAssertNil(object)
    }

    func test_optional_Wrapped가_PropertyListType이_아닌경우_nil_저장시_데이터제거() {
        /// given
        let defaultValue: MockNotPropertyListType? = nil
        let savingValue: MockNotPropertyListType? = MockNotPropertyListType(integer: 10)

        @UserDefaultsSerializable(
            key: Constant.key,
            defaultValue: defaultValue,
            userDefaults: userDefaults
        )
        var variable: MockNotPropertyListType?

        variable = savingValue
        XCTAssertEqual(variable, savingValue)

        /// when
        variable = nil

        /// then
        let object = userDefaults.object(forKey: Constant.key)
        XCTAssertNil(object)
    }

    func test_optional_Wrapped가_PropertyListType이_아닌경우_Data로변환후_저장및조회() {
        /// given
        let defaultValue: MockNotPropertyListType? = nil
        let savingValue: MockNotPropertyListType? = MockNotPropertyListType(integer: 1)

        @UserDefaultsSerializable(
            key: Constant.key,
            defaultValue: defaultValue,
            userDefaults: userDefaults
        )
        var variable: MockNotPropertyListType?

        XCTAssertEqual(userDefaults.didSetWithDataObject, false)

        /// when
        variable = savingValue

        /// then
        XCTAssertEqual(variable, savingValue)
        XCTAssertEqual(userDefaults.didSetWithDataObject, true)
    }
}

extension UserDefaultsSerializableTests {
    final class MockUserDefaults: UserDefaultsProtocol {
        var didSetWithDataObject: Bool = false
        var dictionary: [String: Any] = [:]

        func integer(forKey defaultName: String) -> Int {
            dictionary[defaultName] as? Int ?? Constant.userDefaultsDefaultIntegerValue
        }

        func double(forKey defaultName: String) -> Double {
            dictionary[defaultName] as? Double ?? Constant.userDefaultsDefaultDoubleValue
        }

        func float(forKey defaultName: String) -> Float {
            dictionary[defaultName] as? Float ?? Constant.userDefaultsDefaultFloatValue
        }

        func bool(forKey defaultName: String) -> Bool {
            dictionary[defaultName] as? Bool ?? Constant.userDefaultsDefaultBoolValue
        }

        func string(forKey defaultName: String) -> String? {
            dictionary[defaultName] as? String
        }

        func data(forKey defaultName: String) -> Data? {
            dictionary[defaultName] as? Data
        }

        func array(forKey defaultName: String) -> [Any]? {
            dictionary[defaultName] as? [Any]
        }

        func dictionary(forKey defaultName: String) -> [String: Any]? {
            dictionary[defaultName] as? [String: Any]
        }

        func object(forKey defaultName: String) -> Any? {
            dictionary[defaultName]
        }

        func removeObject(forKey defaultName: String) {
            dictionary.removeValue(forKey: defaultName)
        }

        func set(_ value: Any?, forKey defaultName: String) {
            if let value,
               value is Data {
                didSetWithDataObject = true
            }
            dictionary[defaultName] = value
        }
    }
}

extension UserDefaultsSerializableTests {
    struct MockPropertyListType: PropertyListType, Codable {
        private static let dummyPropertyListType: Int = 1 /// PropertyListType은 본래 UserDefaults가 지원하는 타입만이 채택하여야 하므로, 목업 데이터는 PropertyList중 하나인 Int 로 넣는다
        nonisolated(unsafe) static var didGetValue = false

        init() { }

        static func getValue(userDefaults: UserDefaultsProtocol, key: String) throws (PropertyListAccessError) -> PropertyListType {
            didGetValue = true

            return dummyPropertyListType
        }
    }
}

extension UserDefaultsSerializableTests {
    struct MockNotPropertyListType: Codable, Equatable {
        let integer: Int
    }
}
