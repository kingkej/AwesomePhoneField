//
//  File.swift
//  
//
//  Created by kej on 17.04.2022.
//

import Foundation
import SwiftUI
import IsoCountryCodes
import PhoneNumberKit

struct FieldPlusButtonView: View {
    @Binding var showingSheet: Bool
    @Binding var country: CountryData
    @Binding var phoneNumber: String
    let phoneNumberKit = PhoneNumberKit()
    let countries: [CountryData]
    
    var body: some View {
        HStack {
            Button(action: {
                showingSheet = true
            }) {
                HStack {
                    Text("\(country.isoCode.getFlag())")
                    //Text("+\(country.phoneCode)")
                }
            }
            .buttonStyle(PlainButtonStyle())
            TextField("+", text: $phoneNumber)
                .keyboardType(.phonePad)
        }
        .font(.system(size: 30, weight: .bold, design: .rounded))
        .sheet(isPresented: $showingSheet) {
            CountryPickerView(country: $country, isPresented: $showingSheet, countries: countries)
        }
        .onChange(of: phoneNumber) { newValue in
           // var newValue = _newValue
            //if phoneNumber.count <= 4 && newValue.count > phoneNumber.count + 7 {
              //  let index = phoneNumber.index(phoneNumber.startIndex, offsetBy: phoneNumber.count)
                //newValue = String(newValue[index...])
            //}
            var normalizedNumber = ""
            for i in newValue {
                if (i == "+" || i.isNumber) {
                    normalizedNumber += "\(i)"
                }
            }
            
            let cs = CharacterSet.init(charactersIn: "+")
            let phoneNumWithoutPlus = normalizedNumber.trimmingCharacters(in: cs)
            if (!phoneNumWithoutPlus.isEmpty) {
                let rawCountryCode = phoneNumWithoutPlus.prefix(4)
                updateFlag(phoneNum: String(rawCountryCode))
            }
            
            if (phoneNumber.isEmpty || !normalizedNumber.starts(with: "+")) {
                normalizedNumber = "+\(normalizedNumber)"
            }
            phoneNumber = PartialFormatter().formatPartial(normalizedNumber)
        }
//        .onChange(of: country.phoneCode) { newValue in
//            //phoneNumber = ""
//            phoneNumber = "+\(newValue)"
//        }
    }
    func updateFlag(phoneNum: String) {
        for i in (1 ... phoneNum.count).reversed() {
            let possiblePrefix = phoneNum.prefix(i)
            for c in countries {
                if (possiblePrefix == c.phoneCode) {
                    country.isoCode = c.isoCode
                    country.phoneCode = c.phoneCode
                }
            }
        }
        
    }
}
struct CountryPickerView: View {
    @Binding var country: CountryData
    @Binding var isPresented: Bool
    @State var searchText = ""
    let countries: [CountryData]
    
    var body: some View {
        NavigationView {
            Form {
            Section(header: Text("Current country")) {
                HStack {
                    Text("\(country.isoCode.getFlag())")
                    Text("+\(country.phoneCode)")
                        .bold()
                    Text("\(country.localizedName)")
                }
            }
            Section {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search", text: $searchText) { startedEditing in
                        if startedEditing {
                        }
                    } onCommit: {
                        withAnimation {
                            UIApplication.shared.dismissKeyboard()
                        }
                    }
                }
                .foregroundColor(.gray)
                .padding(.leading, 13)
            }
                
            ForEach(countries.filter({ (cnt: CountryData) -> Bool in
                return cnt.localizedName.lowercased().hasPrefix(searchText.lowercased()) || searchText == ""
            })) { cnt in
                Button(action: {
                    modifyCountry(newCountry: cnt)
                }) {
                    HStack {
                        Text("\(cnt.isoCode.getFlag())")
                        Text("+\(cnt.phoneCode)")
                            .bold()
                        Spacer()
                        Text("\(cnt.localizedName)")
                        }
                    .contentShape(Rectangle())
                    .onTapGesture {
                       modifyCountry(newCountry: cnt)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationBarItems(trailing:Button(action: {
                withAnimation {
                    UIApplication.shared.dismissKeyboard()
                }
                isPresented.toggle()
        }) {
          Image(systemName: "xmark")
        })
            .navigationTitle("Pick country")
        }
    }
    
    func modifyCountry(newCountry: CountryData) {
        country.isoCode = newCountry.isoCode
        country.phoneCode = newCountry.phoneCode
        withAnimation {
            UIApplication.shared.dismissKeyboard()
        }
        isPresented = false
    }
}
