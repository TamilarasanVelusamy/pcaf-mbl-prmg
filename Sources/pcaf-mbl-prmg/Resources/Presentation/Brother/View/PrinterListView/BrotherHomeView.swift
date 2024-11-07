//
//  BrotherHomeView.swift
//  DeviceManagerApp
//
//  Created by Anthony Hoepelman on 9/15/22.
//

import SwiftUI

struct BrotherHomeView: View {
    @ObservedObject var viewModel = PrinterViewModel(container: .container())
    @State private var showBTScanPopUp = false
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                /// Setup custom navigationBar View with title, leftBarButton
                ///- Parameters navigationBarTitle: for title  showLeftBarButton: for show leftbar button etc.
                /// - Returns: view
                PMANavigationView(navigationBarTitle: PMAConstants.Titles.printers, showLeftBarButton: true, showRightBarButton: false, backgroundColor: PMAColor.lightGray, isTabbar: false, leftBarButtonTitle: "", enableNavigation: .constant(true))
                VStack(alignment: .leading) {
                    /// List with section header
                    /// - Returns: view
                    List {
                        Section(header: Text(PMAConstants.Titles.myPrinters).font(Font.PMA.regular(size: .thirteen)))
                        {
                            ForEach(viewModel.pairedPrinter) { device in
                                PairedPrinterListView(printerModel: device)
                            }
                            .frame(maxWidth: .infinity)
                            .listRowBackground(PMAColor.white)
                            .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                    .shadow(color: PMAColor.lineShadow, radius: 2, x: 0, y: 2)
                }
                ZStack{
                /// List with section header
                /// - Returns: view
                Button(action: {
                    withAnimation(.linear(duration: 0.4)) {
                        self.showBTScanPopUp = true
                    }
                    viewModel.connectPrinterWithBluetooth()
                }) {
                    Text(PMAConstants.Titles.addNewPrinter)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .font(Font.PMA.semiBold(size: .seventeen))
                        .padding()
                        .foregroundColor(PMAColor.ctablue)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: CGFloat(PMAConstants.Button.cornerRadius))
                        .stroke(PMAColor.ctablue, lineWidth: CGFloat(PMAConstants.Button.borderWidth))
                )
                .background(PMAColor.white)
                .padding()
                .padding(.horizontal, 4)
            }
                .background(PMAColor.white)
            }
            .background(PMAColor.appBackground)
            .onAppear {
                let connectedPrinter = viewModel.pairedPrinter.filter({ $0.deviceConnected == true })
                if connectedPrinter.isEmpty {
                    viewModel.loadAutoConnectedPrinter()
                    viewModel.getPrinterConnectionStatus()
                }
            }
            if viewModel.isLoading {
                ProgressView {
                    Text(PMAConstants.Titles.loading)
                        .font(.title2)
                }
            }
            if $showBTScanPopUp.wrappedValue {
                bluetoothScanView()
            }
        }
        .background(PMAColor.blackWithOpacityPointSix)
    }
}

extension BrotherHomeView {
    func bluetoothScanView() -> some View {
        VStack (spacing : 10) {
            Text(PMAConstants.Titles.selectAccessory).font(Font.PMA.bold(size: .eighteen))
            List(viewModel.nearbyPeripheralDevice, id:\.self) { device in
                HStack {
                    Text(device.name ?? "")
                        .font(Font.PMA.regular(size: .fourteen))
                    Spacer()
                }
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                .listRowBackground(PMAColor.blackWithOpacityZero)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.pairWithScannedPrinter(device: device)
                    self.showBTScanPopUp = false
                }
            }
            .listStyle(.plain)
            Button(action: {
                withAnimation {
                    self.showBTScanPopUp = false
                    viewModel.stopBluetoothScanning()
                }
            }, label: {
                Text(PMAConstants.Titles.cancel)
                    .font(Font.PMA.bold(size: .sixteen))
            })
            
        }
        .padding()
        .frame(width: 260, height: 300)
        .background(PMAColor.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct BrotherHomeView_Previews: PreviewProvider {
    static var previews: some View {
        BrotherHomeView()
    }
}
