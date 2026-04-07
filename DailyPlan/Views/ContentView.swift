//
//  ContentView.swift
//  DailyPlan
//
//  Created by Arco zakwan putra on 25/03/26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var auth: AuthManager
    @State var LoginPressed = false
    
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    VStack(alignment: .leading) {
                        Text("DailyPlan")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("Set Goal For the day, Win Everyday and Get Better")
                    }
                    Spacer()
                }.padding(16)
                
                Spacer()
                Button(action: {
                    LoginPressed = true
                }) {
                    Text("Get Started")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }.padding()
            }.navigationDestination(isPresented: $LoginPressed){
                LoginView()
            }
        }.onAppear {
            if auth.isLoggedIn {
                LoginPressed = true
                print("Already Logged in")
            }else{
                print("not yet logged in")
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthManager())
}
