
import Foundation

// MARK: - PeripheralDataModel
struct PeripheralDataModel: Codable {
    let firmware: [Firmware]

    enum CodingKeys: String, CodingKey {
        case firmware = "Firmware"
    }
}

// MARK: - Firmware
struct Firmware: Codable {
    let vendor: String
    let firmwarePackage: [FirmwarePackage]

    enum CodingKeys: String, CodingKey {
        case vendor = "Vendor"
        case firmwarePackage = "FirmwarePackage"
    }
}

// MARK: - FirmwarePackage
struct FirmwarePackage: Codable {
    let url: String
    let hardwareVersion, version, rollBack: String
    let models: [String]

    enum CodingKeys: String, CodingKey {
        case url
        case hardwareVersion = "HardwareVersion"
        case version, rollBack
        case models = "Models"
    }
}

