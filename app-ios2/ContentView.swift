import SwiftUI

struct ContentView: View {
    @State var selected: Bool
    @State var viewModel: MyViewModel = MyViewModel()
    @State private var showDetailView = false
    
    init(_ selected: Bool) {
        self.selected = selected
    }
    
    var body: some View {
        if viewModel.viewState == .Idle {
            NavBeforeiOS16(showDetailView: $showDetailView, selected: $selected) {
                viewModel.verify()
            }
        } else if viewModel.viewState == .Loading {
            LoadingView()
        } else if viewModel.viewState == .Success {
            SuccesView()
        } else if viewModel.viewState == .Failure {
            FailureView()
        }
    }
}

struct NavBeforeiOS16: View {
    @Binding var showDetailView: Bool
    @Binding var selected: Bool
    let action: () -> Void
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(
                    destination: DetailView(), isActive: $showDetailView) {
                        Button(action: {
                          print("Button Action")
                            Task {
                                try! await Task.sleep(for: .seconds(2))
                                let random = Int.random(in: 0...10)
                                showDetailView = random > 5
                                print(random)
                                print(showDetailView)
                            }
                        }) {
                            Text("Button")
                        }
                    }
                Spacer()
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, Swift UI!")

                Toggle(isOn: $selected) {
                    Text("Select Toogle")
                }.onChange(of: selected) {
                    action()
                    print(selected)
                }

                Spacer()
                SecondView(selection: $selected)
                Spacer()
            }
            .padding()
        }
    }
}

struct SecondView: View {
    @Binding var selection: Bool
    
    var body: some View {
        HStack {
            Text("Selection is: " + String(selection))
                .onTapGesture {
                    selection = false
                }
        }
    }
}

struct LoadingView: View {
    var body: some View {
        ProgressView("Loading...")
    }
}

struct SuccesView: View {
    var body: some View {
        Text("Success!")
            .onTapGesture {
                print("Tapped")
            }
    }
}

struct FailureView: View {
    var body: some View {
        Text("Failure!")
            .onTapGesture {
                print("Tapped")
            }
    }
}

#Preview {
    ContentView(true)
}
