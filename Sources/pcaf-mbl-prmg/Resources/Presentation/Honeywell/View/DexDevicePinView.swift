//
//  DexDevicePinView.swift
//  SalesProPlus
//
//  Created by hitendra.kumar on 21/02/23.
//

import SwiftUI

struct DexDevicePinView: View {
    @StateObject private var dexDeviceVM = DexAdapterViewModel(container: .container())
    @State private var showAlert: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                VStack{
                    ZStack{
                        HStack{
                            VStack(alignment: .leading){
                                Text(PMAConstants.Titles.devicePin)
                                    .font(Font.PMA.bold(size: .fifteen))
                                    .foregroundColor(.primary).padding(.bottom, 4)
                                Text(dexDeviceVM.pin)
                                    .font(Font.PMA.regular(size: .thirteen))
                                    .foregroundColor(.secondary)
                            }.padding(.leading)
                            Spacer()
                            
                            if showAlert {

                                PinCopiedView()
                                    .transition(AnyTransition.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity).animation(.easeInOut(duration: 1)), removal: .opacity).animation(.easeInOut(duration: 1)))
                                    .offset(x: -15, y: -70)
                            }
                            
                            Spacer()
                            
                            Button {
                                UIPasteboard.general.string = dexDeviceVM.pin
                                if(dexDeviceVM.pin != ""){
                                    
                                    withAnimation {
                                        showAlert = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        showAlert.toggle()
                                    }
                                    
                                }
                            } label: {
                                Image(.copy)
                                    .resizable()
                                    .frame(width: 34, height: 34)
                                    .padding()
                                    .hidden(dexDeviceVM.pin == "" ? true : false)
                            }
                        }
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    .background(PMAColor.white)
                    .shadow(color: PMAColor.lineShadow, radius: 2, x: 0, y: 2)
                    BottomDexInfoView()
                    ScanPairButtonView()
                      
                }
            }.frame(maxHeight: .infinity, alignment: .bottom)
        }
    }
}

struct DexDevicePinView_Previews: PreviewProvider {
    static var previews: some View {
        DexDevicePinView()
            .background(PMAColor.black)
    }
}
