//
//  AsReaderDevieceInfoDefine.h
//  FWUpdateSDK
//
//  Created by Y.Oshiro on 2020/10/19.
//

#import <Foundation/Foundation.h>

// AsReaderType
typedef NS_ENUM( NSInteger, AsReaderType ){
    AsReaderTypeUnknown = -1,
    AsReaderType510R = 300,   // (1D Barcode Jacket)
    AsReaderType520R,         // (2D Barcode Jacket)
    AsReaderType300R,         // (RFID Jacket)
    AsReaderType010D,         // (1D Barcode Dongle)
    AsReaderType020D,         // (2D Barcode Dongle)
    AsReaderType022D,         // (2D Barcode Dongle)
    AsReaderType030D,         // (RFID Dongle)
    AsReaderType0230D,        // (2D Barcode  + RFID )
    AsReaderType0240D,        // (2D Barcode  + NFC  )
    AsReaderType060D,         // Ir ASK JVMA
    AsReaderType061D,         // Ir ASK JVMA & VACS
    AsReaderType040D,         // (Only NFC  )
    AsReaderTypeR250G,        // GunType (2D Barcode  + RFID )
    AsReaderTypeL251G,        // GunType (2D Barcode  + RFID )
};

// ModuleType
typedef NS_ENUM(NSInteger, AsReaderModuleType){
    //Selected Module Type
    AsReaderModuleTypeUnknown = -1,
    AsReaderModuleTypeBarcode = 0,
    AsReaderModuleTypeRFID,
    AsReaderModuleTypeNFC,
    AsReaderModuleTypeASK
};

// ButtonAction
typedef NS_ENUM(NSInteger, TriggerButton){
    TriggerButtonUnknown = -1,
    TriggerButtonUp = 0,
    TriggerButtonDown
};

