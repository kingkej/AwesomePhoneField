import SwiftUI

public struct AwesomePhoneFieldView: View {
    @Binding var country: CountryData
    @Binding var phoneNumber: String
    @State private var showingSheet: Bool = false
    let countries: [CountryData] = Bundle.main.getCountries()
    
    public init(country: Binding<CountryData>, phoneNumber: Binding<String>) {
        self._phoneNumber = phoneNumber
        self._country = country
    }
    
    public var body: some View {
        FieldPlusButtonView(showingSheet: $showingSheet, country: $country, phoneNumber: $phoneNumber, countries: countries)
            .onAppear(perform: {
                let localeIdentifier: String = NSLocale.current.regionCode ?? "US"
                if let c = countries.first(where: { $0.isoCode == localeIdentifier }) {
                    country.phoneCode = "\(c.phoneCode)"
                    phoneNumber = "+\(c.phoneCode)"
                    }
                country.isoCode = localeIdentifier
            })
    }
}
