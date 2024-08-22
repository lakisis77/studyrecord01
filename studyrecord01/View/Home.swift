//
//  Home.swift
//  studyrecord01
//
//  Created by Min Lee on 8/22/24.
//

import SwiftUI

struct Home: View {
    var props: Properties
    // MARK: View Properties
    @State var currentTab: String = "Home"
    @Namespace var animation
    @State var showSideBar: Bool = false
    var body: some View {
        HStack(spacing: 0) {
            // MARK: Showing Only For iPad
            if props.isiPad {

            }
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    HeaderView()
                    InfoCards()
                }
                .padding(15)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background {
            Color.black
                .opacity(0.04)
                .ignoresSafeArea()
        }
        .overlay(alignment: .leading) {
            ViewThatFits {
                SideBar()
                ScrollView(.vertical,showsIndicators: false) {
                    SideBar()
                }
                .background(Color.white.ignoresSafeArea())
            }
            .offset(x:showSideBar ? 0 : -100)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background{
                Color.black
                    .opacity(showSideBar ? 0.25 : 0)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut){showSideBar.toggle()}
                    }
            }
        }
        
    }
    
    // MARK: Info Cards View
    @ViewBuilder
    func InfoCards() -> some View{
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 18) {
                ForEach(infos){info in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 15) {
                            Text(info.title)
                                .font(.title3.bold())
                            Spacer()
                            
                            HStack(spacing: 8) {
                                Image(systemName: info.loss ? "arrow.down" : "arrow.up")
                                
                                Text("\(info.percentage)%")
                            }
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(info.loss ? .red : .green)
                        }
                        
                        HStack(spacing: 18) {
                            Image(systemName: info.icon)
                                .font(.title3)
                                .foregroundColor(.white)
                                .frame(width: 45, height: 45)
                                .background {
                                    Circle()
                                        .fill(info.iconColor)
                                }
                            
                            Text(info.amount)
                                .font(.title.bold())
                        }
                        
                    }
                    .padding()
                    .background{
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(.white)
                    }
                }
            }
        }
    }
    
    
    // MARK: Header View
    @ViewBuilder
    func HeaderView()->some View {
        //MARK: Dynamic Layout(iOS 16+)
        let layout = props.isiPad && !props.isMaxSplit ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout(spacing: 22))
        
        layout{
            VStack(alignment: .leading, spacing: 8) {
                Text("Seattle, New York")
                    .font(.title2)
                    .fontWeight(.bold)
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            //MARK: Search Bar With Menu Button
            HStack(spacing: 10) {
                if !(props.isiPad && !props.isMaxSplit) {
                    Button {
                        withAnimation(.easeInOut) {showSideBar.toggle()}
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    
                    TextField("Search", text: .constant(""))
                    
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 22)
                }
            }
            .padding(.horizontal, 15)
            .padding(.vertical,10)
            .background {
                Capsule()
                    .fill(.white)
            }
        }
    }
    
    // MARK: Side Bar
    @ViewBuilder
    func SideBar()->some View {
        // MARK: Tabs
        let tabs: [String] = [
        "house","gearshape"]
        VStack(spacing: 10) {
            Image(systemName: "waveform")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 55, height: 55)
                .padding(.bottom,10)
            
            ForEach(tabs,id: \.self) {tab in
                VStack(spacing: 8){
                    Image(systemName: tab)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 22)
                    
                    Text(tab)
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .foregroundColor(currentTab == tab ? Color("Orange") : .gray)
                .padding(.vertical,13)
                .frame(width: 65)
                .background{
                    if currentTab == tab{
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(Color("Orange").opacity(0.1))
                            .matchedGeometryEffect(id: "TAB", in: animation)
                    }
                }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        currentTab = tab
                    }
                }
            }
            
            Button {
                
            } label: {
                VStack{
                    Image(systemName: "playstation.logo")
                        .resizable()
                        .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                        .frame(width: 45, height: 45)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    
                    Text("Profile")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                }
            }
            .padding(.top,20)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
        .background{
            Color.white
                .ignoresSafeArea()
        }
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//#Preview {
//    ContentView()
//}
