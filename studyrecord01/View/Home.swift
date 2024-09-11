//
//  Home.swift
//  studyrecord01
//
//  Created by Min Lee on 8/22/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import Charts

struct Home: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var props: Properties
    // MARK: View Properties
    @State var currentTab: String = "Home"
    @Namespace var animation
    
    @State var showSideBar: Bool = false
    @State var showSetting: Bool = false
    @State var showTimerecord: Bool = false
    
    @State var selectedColor = ""
    
    @State var isStudying = false
    @State var isTimerRunning = false
    @State var timeCount = 0
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var startTime = Date()
    @State private var endTime = Date()
    
    var colors: Set = ["red", "green", "blue"]
    
//    var selectedColor = [PostModel]()
    
    @State var feedbackShow = false
    @State var ratings : Int = 0
    @State var comments = ""
    
    // MARK: Main
    var body: some View {
        ZStack() {
            HStack(spacing: 0) {
                // MARK: Showing Only For iPad
                if props.isiPad {
                    
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack{
                        HeaderView()
//                        InfoCards()
                        SumCards()
                        
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack(spacing: 20) {
                                GraphView()
                                PieChartView()
                            }
                            .padding(.horizontal, 15)
                        }
                        .padding(.horizontal,-15)
                        
                        
                        if isStudying { Stopwatch() } else { PickerButton() }
                    }
                    .padding(15)
                }
                .refreshable {
                    viewModel.refresh()
                }
//                .onAppear {
//                    viewModel.refresh()
//                }
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
            
            if self.feedbackShow {
                GeometryReader{geometry in
                    ZStack(alignment: .bottom) {
                        FeedBack().padding()
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                }.background(Color.black.opacity(0.2).edgesIgnoringSafeArea(.all))
            }
            
        }.animation(.default)
        
    }
    
    
    // MARK: FeedBack
    
    @ViewBuilder
    func FeedBack() -> some View{
        
        VStack {
            HStack{
                Text("어느정도 집중했나요?")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
            }.padding()
            .background(Color.blue)
            
            VStack {
                if ratings != 0{
                    if ratings == 5 {
                        Text("훌륭합니다")
                    }
                }
            }.padding(.top,20)
            
            HStack(spacing: 15) {
                ForEach(1...5,id: \.self) {i in
                    Image(systemName: ratings == 0 ? "star" : "star.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(i <= ratings ? .blue : Color.black.opacity(0.2))
                        .onTapGesture {
                            ratings = i
                        }
                }
            }.padding()
//
            
            TextField("한줄평", text: $comments)
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 8)                        .stroke(Color.gray, lineWidth: 1)
            ).padding()

//
            
            HStack {
                Spacer()
                
                Button(action: {
                    isStudying = false
                    isTimerRunning = false

                    ratings=0
                    feedbackShow.toggle()
                    
                }, label: {
                    Text("기록삭제").foregroundColor(.gray).fontWeight(.bold)
                })
                                
                Spacer()
                Spacer()
                
                Button(action: {
                    ratings = 0
                    isTimerRunning = true
                    feedbackShow.toggle()
                }, label: {
                    Text("돌아가기").foregroundColor(.gray).fontWeight(.bold)
                })
                
                Button(action: {
                    isStudying = false
                    isTimerRunning = false
                    let inttimeCount = timeCount
                    feedbackShow.toggle()
                    let timeInterval = startTime.timeIntervalSince1970
                    let intstartTime = doubleToInteger(data:timeInterval)
                    
                    let parameters: [String: Any] = ["title": selectedColor, "starttime": intstartTime, "duration": inttimeCount, "rating" : ratings, "comments": comments]
                    
                    viewModel.createTimerecord(parameters: parameters) {
                           viewModel.fetchPost()
                    }
                    
                    ratings=0
                    viewModel.refresh()
                    
                }, label: {
                    Text("저장하기").foregroundColor(ratings != 0 ? .blue : Color.black.opacity(0.2)).fontWeight(.bold)
                })
                .padding(.leading, 20)
                .disabled(ratings != 0 ? false : true)
                
                
            }.padding()
        }
        .background(Color.white)
        .cornerRadius(10)
        
        
        
    }
    
    // MARK: Stopwatch
    
    @ViewBuilder
    func Stopwatch() -> some View{
        
        var hours = self.timeCount / 3600
        var minutes = self.timeCount / 60
        var seconds = self.timeCount % 60
        
//        Text("\(String(format: "%i", self.timeCount))s")
        ZStack {
            
            Circle()
                .trim(from: 0,to:1)
                .stroke(Color.white, style: StrokeStyle(lineWidth:35,lineCap:.round))
            //                .background(Color.white.shadow(radius: 10))
                .frame(width: 320,height: 320)
                
                
            VStack{
                
                Text("\(String(format: "%02i:%02i:%02i", hours, minutes, seconds))")

                    .font(.system(size:55, design: .monospaced))
                    .bold()
                    .onReceive(self.timer) { time in
                        if isTimerRunning {
                            timeCount += 1
                        }
                    }
                
                Text(selectedColor)
                    .font(.title.bold())
                
            }
        }
        
        
        HStack{
            if isTimerRunning {
                Image(systemName: "pause.circle.fill")
                    
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .padding(.horizontal)
                    .onTapGesture {
                        self.timer.upstream.connect().cancel()
                        isTimerRunning = false
                    }
            } else {
                Image(systemName: "play.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .padding(.horizontal)
                    .onTapGesture {
                        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                        isTimerRunning = true
                    }
            }

            Image(systemName: "stop.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .onTapGesture {
                    isTimerRunning = false
                    feedbackShow.toggle()
                }
        }
    }
    
    // MARK: Picker Button View
    @ViewBuilder
    func PickerButton() -> some View{
        
        VStack{
            Capsule()
                .fill(Color.gray)
                .frame(width: 100,height: 2)
            
            HStack(spacing: 15) {
                VStack(alignment: .leading, spacing: 10, content: {
                    Text("과목")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
//                    Text("2024년 8월 22일")
//                        .font(.caption)
//                        .fontWeight(.bold)
//                        .foregroundColor(.gray)
                })
                Spacer(minLength: 0)
                Button(action: {}, label: {
                    Image(systemName: "square.and.arrow.up.fill")
                        .font(.title2)
                        .foregroundColor(.black)
                })
            }
            
            VStack {
                
                Picker("Choose a color", selection: $selectedColor) {
//                    ForEach(colors, id: \.self) {
//                      Text($0)
//                    }
                    ForEach(viewModel.items, id: \.id) { item in
                        Text(item.title).tag(item.title)
                    }
                  }
                .onAppear {
//                    selectedColor = ContentView.getItem(withViewContext: viewContext)
                    
//                    selectedColor = viewModel.items.isEmpty ? "" : viewModel.items[0].title
                        }
                  .pickerStyle(.wheel)
                  .background(.white)
                  .cornerRadius(15)
                  .padding()
                  
//                  Text("You selected: \(selectedColor)")
                    
                }
                
                
            .frame(width: .infinity, height: 200)
            
            .refreshable {
                viewModel.fetchPost()
            }
            
            Button(action: {
                isStudying = true
                isTimerRunning = true
                timeCount = 0
                startTime = Date()
                if selectedColor.isEmpty {
                    selectedColor = viewModel.items.isEmpty ? "" : viewModel.items[0].title
                }
            }, label: {
                    Image(systemName: "play")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40,height: 30)
                    .padding(.vertical)
                    .padding(.horizontal,50)
                    .background(Color.blue)
                    .clipShape(Capsule())
                    .foregroundColor(.white)
//                    .font(.largeTitle)
//                    .fontWeight(.heavy)
                
            })
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
            .padding(15)
        }
        .padding(.horizontal, -15)
    }

    // MARK: Sum Duration Cards View
    @ViewBuilder
    func SumCards() -> some View{
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 18) {
                ForEach(viewModel.durations, id: \.title){info in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 15) {
                            
                            Text(info.title)
                                .font(.title3.bold())
                            
                            Spacer()
                            
                            HStack(spacing: 8) {
                                Image(systemName: "arrow.up")
                                
                                Text("\(info.sum_duration)초")
                            }
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.red)
                        }
                        
                        HStack(spacing: 18) {
                            Image(systemName: "arrow.up")
                                .font(.title3)
                                .foregroundColor(.white)
                                .frame(width: 45, height: 45)
                                .background {
                                    Circle()
                                        .fill(.blue)
                                }
                            
                            Text("\(info.sum_duration)초")
                                .font(.title.bold())
                        }
                        
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(.white)
                    }
                }
            }
            .padding(15)
        }
        .padding(.horizontal, -15)
    }
    
    // MARK: PieChart View
    @ViewBuilder
    func PieChartView()-> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("과목 비중")
                .font(.title3.bold())
  
            NavigationStack {
                VStack{
                    Chart(viewModel.durations, id: \.title) { item in
                        
                        SectorMark(angle: .value("비중", item.sum_duration), 
                                   innerRadius: .ratio(0.7),
                                   angularInset: 1
                        )
                        .foregroundStyle(by: .value("과목", item.title))
                    }
                    .padding()
                }
//                .navigationTitle("과목비중")
            }
            
//            HStack(spacing: 20) {
//                Label {
//                    Text("")
//                } icon: {
//                    Image(systemName: "circle.fill")
//                        .font(.caption2)
//                        .foregroundStyle(.green)
//                }
//            }
        }
        .padding(15)
        .frame(width: 250, height: 250)
        .background{
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(.white)
        }
        
    }
    
    // MARK: Summary Graph View
    @ViewBuilder
    func GraphView() -> some View{
        VStack(alignment: .leading) {
            Text("집중도 평균")
                .font(.title3.bold())   
            
            Chart{
                ForEach(viewModel.durations, id: \.title){info in
                    // MARK: Area Mark
                    AreaMark (
                        x: .value("과목", info.title),
                        y: .value("평균 집중도", info.avg_rating)
                    )
                    
                    .foregroundStyle(.linearGradient(colors: [
                        Color.blue.opacity(0.6),
                        Color.blue.opacity(0.5),
                        Color.blue.opacity(0.3),
                        Color.blue.opacity(0.1),
                        .clear
                    ], startPoint: .top, endPoint: .bottom))
                    .interpolationMethod(.catmullRom)
                    
                    // MARK: Line Mark
                    LineMark (
                        x: .value("과목", info.title),
                        y: .value("평균 집중도", info.avg_rating)
                    )
                    .foregroundStyle(Color.blue)
                    .interpolationMethod(.catmullRom)
                    
                    // MARK: Point Mark
                    PointMark (
                        x: .value("과목", info.title),
                        y: .value("평균 집중도", info.avg_rating)
                    )
                    .foregroundStyle(Color.blue)
                    
                }
                
            }
            .chartYAxis{
                AxisMarks(values: [1, 3, 5]) {
                    AxisGridLine()
                }
                AxisMarks(values: [1, 3, 5]) {
                    AxisValueLabel()
                    // format: Decimal.FormatStyle.Percent.percent.scale(1)
                }
            }
            .frame(height: 180)
        }
        .padding(15)
        .background(content: {
            RoundedRectangle(cornerRadius: 15,style: .continuous)
                .fill(.white)
        })
        .frame(minWidth: props.size.width - 30)
    }
        

    
    // MARK: Header View
    @ViewBuilder
    func HeaderView()->some View {
        //MARK: Dynamic Layout(iOS 16+)
        let layout = props.isiPad && !props.isMaxSplit ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout(spacing: 22))
        
        layout{
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 10) { 
                    Button {
                        withAnimation(.easeInOut) {showSideBar.toggle()}
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    
                    Text("미카운터")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            //MARK: Search Bar With Menu Button
//            HStack(spacing: 10) {
//                if !(props.isiPad && !props.isMaxSplit) {
//                    Button {
//                        withAnimation(.easeInOut) {showSideBar.toggle()}
//                    } label: {
//                        Image(systemName: "line.3.horizontal")
//                            .font(.title2)
//                            .foregroundColor(.black)
//                    }
//                    
//                    TextField("Search", text: .constant(""))
//                    
//                    Image(systemName: "magnifyingglass")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 22, height: 22)
//                }
//            }
//            .padding(.horizontal, 15)
//            .padding(.vertical,10)
//            .background {
//                Capsule()
//                    .fill(.white)
//            }
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
            
            Button {
                showSideBar.toggle()
            } label: {
                VStack{
                    Image(systemName:"house")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 22)
                    Text("홈")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
            }.padding()
            
            Button {
                showSetting.toggle()
            } label: {
                VStack{
                    Image(systemName:"gearshape")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 22)
                    Text("과목수정")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
            }
            .sheet(isPresented: $showSetting) {
                SettingView()}
            .padding()
            
            Button {
                showTimerecord.toggle()
            } label: {
                VStack{
                    Image(systemName:"gearshape")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 22)
                    Text("기록삭제")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
            }
            .sheet(isPresented: $showTimerecord) {
                TimerecordView()}
            .padding()
            
            // MARK: 로그아웃
            
            Button(action: {
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                } catch let signOutError as NSError {
                    print("Error signing out: %@", signOutError)
                }
                UserDefaults.standard.set(false, forKey: "signIn")
                
                viewModel.items = [PostModel]()
                viewModel.timerecords = [TimerecordModel]()
                viewModel.durations = [DurationModel]()
                UserDefaults.standard.set("", forKey: "apikey")
                
            }, label: {
                VStack {
                    Image(systemName: "rectangle.portrait.and.arrow.forward")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 22)
                    Text("로그아웃")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
            })
            .padding()
            
            
//            ForEach(tabs,id: \.self) {tab in
//                VStack(spacing: 8){
//                    Image(systemName: tab)
//                        .resizable()
//                        .renderingMode(.template)
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 22, height: 22)
//                    
//                    Text(tab)
//                        .font(.caption)
//                        .fontWeight(.semibold)
//                }
//                .foregroundColor(currentTab == tab ? Color.blue : .gray)
//                .padding(.vertical,13)
//                .frame(width: 65)
//                .background{
//                    if currentTab == tab {
//                        RoundedRectangle(cornerRadius: 15, style: .continuous)
//                            .fill(Color.blue.opacity(0.1))
//                            .matchedGeometryEffect(id: "TAB", in: animation)
//                    }
//                }
//                .onTapGesture {
//                    withAnimation(.easeInOut) {
//                        currentTab = tab
//                    }
//                }
//            }
            
//            Button {
//
//            } label: {
//                VStack{
//                    Image(systemName: "playstation.logo")
//                        .resizable()
//                        .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
//                        .frame(width: 45, height: 45)
//                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
//                    
//                    Text("Profile")
//                        .font(.caption)
//                        .fontWeight(.semibold)
//                        .foregroundColor(.gray)
//                }
//            }
//            .padding(.top,20)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
        .background{
            Color.white
                .ignoresSafeArea()
        }
        
    }
    
    // MARK: Timerecord View
    
    @ViewBuilder
    func TimerecordView()->some View {
        
        NavigationView {
            List {
                ForEach(viewModel.timerecords, id: \.id) { item in
                    NavigationLink(
                        destination: TRDetailView(item: item),
                        label: {
                            VStack(alignment: .leading) {
                                Text(item.title)
                                // convert Int to TimeInterval (typealias for Double)
                                let timeInterval = TimeInterval(item.starttime)
                                
                                // create NSDate from Double (NSTimeInterval)
                                let myNSDate = Date(timeIntervalSince1970: timeInterval)
                                
                                let dateString = getFormattedDate(from: myNSDate)
                                
                                Text("시작시간: "+dateString).font(.caption).foregroundColor(.gray)
                                
                                let (h, m, s) = secondsToHoursMinutesSeconds(item.duration)
                                
                                Text("\(h) 시간, \(m) 분, \(s) 초").font(.caption).foregroundColor(.gray)
                            }
                        
                    })
                    
                }.onDelete(perform: deleteTimerecord)
                
            }.listStyle(InsetListStyle())
            .refreshable {
                viewModel.fetchTable()
            }
            
            .navigationBarTitle("Posts")
            
//            .navigationBarTitle(email)
//            .navigationBarItems(trailing: plusButton)
//            .navigationBarItems(leading: logoutButton)
        }
//        .sheet(isPresented: $isPresentedNewPost, content: {
//            NewPostView(isPresented: $isPresentedNewPost, title: $title, post: $post)
//        })
        
    }
    
    
    // MARK: Setting View
    
    @State var isPresentedNewPost = false
    @State var title = ""
    @State var post = ""
    
    @ViewBuilder
    func SettingView()->some View {
        
        NavigationView {
            List {
                ForEach(viewModel.items, id: \.id) { item in
                    NavigationLink(
                        destination: DetailView(item: item),
                        label: {
                            VStack(alignment: .leading) {
                                Text(item.title)
                                Text(item.post).font(.caption).foregroundColor(.gray)
                            }
                        
                    })
                    
                }.onDelete(perform: deletePost)
                
            }.listStyle(InsetListStyle())
            .refreshable {
                viewModel.fetchPost()
            }
            
            .navigationBarTitle("Posts")
            
//            .navigationBarTitle(email)
            .navigationBarItems(trailing: plusButton)
//            .navigationBarItems(leading: logoutButton)
        }.sheet(isPresented: $isPresentedNewPost, content: {
            NewPostView(isPresented: $isPresentedNewPost, title: $title, post: $post)
        })
        
    }
    
    private func deletePost (indexSet: IndexSet) {
        let id = indexSet.map { viewModel.items[$0].id}
        DispatchQueue.main.async {
            let parameters: [String: Any] = ["id": id[0]]
            viewModel.deletePost(parameters: parameters) {
                   viewModel.fetchPost()
            }
            //            self.viewModel.deletePost(parameters: parameters)
            self.viewModel.fetchPost()
        }
        viewModel.refresh()
    }
    
    private func deleteTimerecord (indexSet: IndexSet) {
        let id = indexSet.map { viewModel.timerecords[$0].id}
        DispatchQueue.main.async {
            let parameters: [String: Any] = ["id": id[0], "table": "timerecord"]
            viewModel.deletePost(parameters: parameters) {
                   viewModel.fetchTable()
            }
            //            self.viewModel.deletePost(parameters: parameters)
            self.viewModel.fetchTable()
        }
        viewModel.refresh()
    }
    
    var plusButton: some View {
        Button(action: {
            isPresentedNewPost.toggle()
        }, label: {Image(systemName: "plus")})
    }
    
//    var logoutButton: some View {
//        
//    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//#Preview {
//    ContentView()
//}

func doubleToInteger(data:Double)-> Int {
    let doubleToString = "\(data)"
    let stringToInteger = (doubleToString as NSString).integerValue
            
    return stringToInteger
}

// Mark : getFormattedDate
func getFormattedDate(from date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    return dateFormatter.string(from: date)
}

// Mark : secondsToHoursMinutesSeconds
func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
    return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
}
