//
//  ContentView.swift
//  TestTask
//
//  Created by Mikhail Kolkov  on 25.02.2021.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var showModal = false
    @State private var showCamera = false
    var body: some View {
        Home()
    }
}

struct ModalView: View {
    @Environment(\.presentationMode) var presentation
    let message: String

    var body: some View {
        NavigationView {
            Button(message) {
                self.presentation.wrappedValue.dismiss()
            }
            .navigationBarItems(trailing: Button("Done") {
                self.presentation.wrappedValue.dismiss()
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct Player : Identifiable {
    
    var id = UUID().uuidString
    var image : String
    var name : String
    var color : Color
    
    var offset : CGFloat = 0
}

struct Home : View {
    @State var bill : CGFloat = 750
    @State var players  = [
        Player(image: "1", name: "Имя", color: Color("1")),
        Player(image: "2", name: "Имя", color: Color("2")),
        Player(image: "3", name: "Имя", color: Color("3"))
    ]
    @State var pay = false
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                HStack {
                    Button(action: {
                        
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(Color("card"))
                            .padding()
                            .background(Color.black.opacity(0.35))
                            .cornerRadius(15)
                    }
                    Spacer()
                    
                }.padding()
                
                VStack(spacing: 15) {
                    Button(action: {
                        
                    }) {
                        Text("Label")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color("bg"))
                            .cornerRadius(12)
                    }
                    
                    Line()
                        .stroke(Color.black,style: StrokeStyle(lineWidth: 1, lineCap: .butt, lineJoin: .miter, dash: [10]))
                        .frame(height: 1)
                        .padding(.horizontal)
                        .padding(.top, 10)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 8 ) {
                            Text("Title")
                                .font(.caption)
                            
                            Text("Title Label")
                                .font(.title2)
                                .fontWeight(.heavy)
                        }.foregroundColor(Color("bg"))
                        .frame(maxWidth: .infinity)
                        
                        VStack(alignment: .leading, spacing: 8 ) {
                            Text("Total")
                                .font(.caption)
                            
                            Text("$\(Int(bill))")
                                .font(.title2)
                                .fontWeight(.heavy)
                        }.foregroundColor(Color("bg"))
                        .frame(maxWidth: .infinity)
                        .padding(.top, 10)
                    }
                    
                    VStack {
                        HStack(spacing: -20) {
                            ForEach(players){ player in
                                Image(player.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 45, height: 45)
                                    .clipShape(Capsule())
                            }
                        }
                        Text("Label")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }.frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("bg"))
                    .cornerRadius(25)
                }.frame(maxWidth: .infinity)
                .padding()
                .background(Color("card").clipShape(Capsule()).cornerRadius(25))
                .padding(.horizontal)
                
                ForEach(players.indices){ index in
                    PriceView(player: $players[index], total: bill)
                    
                }
                Spacer(minLength: 25)
                
                HStack {
                    HStack(spacing: 0) {
                        ForEach(1...6,id: \.self){ index in
                            Image(systemName: "chevron.right")
                                .font(.system(size: 20, weight: .heavy))
                                .foregroundColor(Color.white.opacity(Double(index) * 0.06))
                            
                        }
                    }.padding(.leading, 45)
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }) {
                        Text("Label")
                            .fontWeight(.bold)
                            .foregroundColor(Color("card"))
                            .padding(.horizontal, 25)
                            .padding(.vertical)
                            .background(Color("bg"))
                            .clipShape(Capsule())
                        
                    }.padding()
                    .background(Color.black.opacity(0.35))
                    .clipShape(Capsule())
                    .padding(.horizontal)
                    
                }
            }.background(Color("bg"))
        }
    }
}



struct PriceView : View {
    @Binding var player : Player
    var total : CGFloat
    var body: some View {
        VStack(spacing: 15){
            HStack {
                Image(player.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 35, height: 35)
                    .padding(5)
                    .clipShape(Circle())
                
                
                Text(player.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(getPrice())
                    .foregroundColor(.black)
                    .fontWeight(.heavy)
                    
            }
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
                Capsule()
                    .fill(Color.black.opacity(0.35))
                    .frame(height: 30)
                Capsule()
                    .fill(player.color)
                    .frame(width: player.offset + 20,height: 30)
                
                HStack(spacing: (UIScreen.main.bounds.width - 100) / 12) {
                    ForEach(0..<12, id: \.self) { index in
                        Circle()
                            .fill(Color.white)
                            .frame(width: index % 4 == 0 ? 7 : 4, height: index % 4 == 0 ? 7 : 4)
                        
                    }
                }.padding(.leading)
                
                
                Circle()
                    .fill(Color("card"))
                    .frame(width: 35, height: 35)
                    .background(Circle().stroke(Color.white, lineWidth: 5))
                    .offset(x: player.offset)
                    .gesture(DragGesture().onChanged({ (value) in
                        if value.location.x >= 20 && value.location.x <= UIScreen.main.bounds.width - 50 {
                            player.offset = value.location.x - 20
                        }
                    }))
                
                
            }.padding()
        }
    }
    
    func getPrice()-> String {
        let percent = player.offset / (UIScreen.main.bounds.width - 70)
        let amount = percent * (total / 3)
        return String(format: "%.2f", amount)
    }
}

struct Line : Shape {
    func path(in rect: CGRect) -> Path {
        return Path{ path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
        }
    }
}


struct BillShape : Shape {
    func path(in rect: CGRect) -> Path {
        return Path{ path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            
            path.move(to: CGPoint(x: 0, y: 80))
            path.addArc(center: CGPoint(x: 0, y: 80), radius: 20, startAngle: .init(degrees: -90), endAngle: .init(degrees: 90), clockwise: false)
            path.move(to: CGPoint(x: rect.width, y: 80))
            path.addArc(center: CGPoint(x: rect.width, y: 80), radius: 20, startAngle: .init(degrees: 90), endAngle: .init(degrees: -90), clockwise: false)
        }
    }
}
