//
//  AddGarmentView.swift
//  GarmentManager
//
//  Created by Sneha Kalariya on 2024-03-21.
//

import SwiftUI
import Combine

struct AddGarmentView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel : AddGarmentViewModel
    @State private var garmentName : String = ""
    
    init(viewModel: AddGarmentViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack{
            TextField("", text: $garmentName)
                .padding(20)
                .textFieldStyle(.roundedBorder)
            Spacer()
                
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Add")
                    .modifier(BlackBoldText())
                    .accessibilityAddTraits(.isHeader)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    Task{
                        await viewModel.saveNewGarment(name: garmentName)
                        await MainActor.run(body: {
                            presentationMode.wrappedValue.dismiss()
                        })
                    }
                    
                }, label: {
                    Text("Save")
                        .foregroundColor(.black)
                })

            }
        }
        
    }
}

struct AddGarmentView_Previews: PreviewProvider {
    static var previews: some View {
        AddGarmentView(viewModel: AddGarmentViewModel())
    }
}
