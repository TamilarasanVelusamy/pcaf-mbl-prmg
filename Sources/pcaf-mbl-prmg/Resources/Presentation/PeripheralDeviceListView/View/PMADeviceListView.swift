//
//  ContentView.swift
//
//  Created by anthony.hoepelman on 11/2/22.
//  Modified by amit.verma on 11/4/22.

import SwiftUI

struct PMADeviceListView: View {
    @StateObject fileprivate var viewModel = PeripheralDeviceViewModel(fileDownloader: FileDownloader(firmwarePackageModel: [FirmwarePackage]()), checkFirmwareValidation: CheckFirmwareValidation())
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8, alignment: .center), count: 2)
    /// Designing for peripheral device list view (Home view).
    var body: some View {
        ZStack {
            VStack(spacing: PMAConstants.Constants.Padding.standard.rawValue) {
                PMANavigationView(navigationBarTitle: PMAConstants.Titles.peripheralManagement, showLeftBarButton: true, showRightBarButton: false, backgroundColor: PMAColor.clear, isTabbar: false, leftBarButtonTitle: "", enableNavigation: .constant(true))
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.devices, id:\.id) { device in
                            PMACardView(device: device)
                        }
                    }.padding(.init(top: 16, leading: 16, bottom: 0, trailing: 16))
                }
            }
        }
        .background(PMAColor.appBackground)
        .hiddenNavigationBarStyle()
        .onAppear() {
            viewModel.getPeripheralFileData()
        }
    }
}
