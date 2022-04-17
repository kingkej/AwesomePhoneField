//
//  File.swift
//  
//
//  Created by kej on 17.04.2022.
//

import SwiftUI

extension UIApplication {
     func dismissKeyboard() {
         sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
     }
 }
