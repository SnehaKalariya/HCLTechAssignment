//
//  GarmentListView.swift
//  GarmentManager
//
//  Created by Sneha Kalariya on 2024-03-21.
//

import SwiftUI

struct GarmentListView: View {
    
    @State private var isPlusClicked = false
    @State private var selectedItem : Sort = .alpha
    @EnvironmentObject var viewModel : GarmentListViewModel

    var body: some View {
        NavigationStack{
            VStack {
                Picker("", selection: $selectedItem) {
                    Text(AppConstant.segmentList[0]).tag(Sort.alpha)
                    Text(AppConstant.segmentList[1]).tag(Sort.creationTime)
                }
                .onChange(of: selectedItem, perform: { newValue in
                    viewModel.didSelectCategory(sortBy: selectedItem)
                })
                .pickerStyle(.segmented)
            }
            .padding(20)
            Spacer()
            List{
                ForEach(viewModel.garments){ garment in
                    Text(garment.name)
                        .modifier(BlackTitleText())
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("List")
                        .modifier(BlackBoldText())
                        .accessibilityAddTraits(.isHeader)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.isPlusClicked = true
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.black)
                    })
                    .navigationDestination(isPresented: $isPlusClicked) {
                        AddGarmentView(viewModel: AddGarmentViewModel())
                    }

                }
            }
        }
    }
}

struct GarmentListView_Previews: PreviewProvider {
    static var previews: some View {
        GarmentListView()
    }
}
