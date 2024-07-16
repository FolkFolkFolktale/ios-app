import SwiftUI

struct makeStoryView: View {
    @StateObject private var viewModel = makeStoryViewModel()
    @State var title: String = ""
    @State var start: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading && viewModel.storyResponse == nil {
                    ProgressView("생성중...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    Spacer()
                    Text("제목을 만들어주세요.")
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                        .foregroundColor(.purple)
                    TextField("제목을 입력하세요", text: $title)
                        .padding()
                        .border(Color.purple)
                        .padding([.leading, .trailing], 30)
                        .padding(.bottom, 50)
                    Text("시작문장을 적어주세요.")
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                        .foregroundColor(.purple)
                    TextField("시작 문장을 입력하세요", text: $start)
                        .padding()
                        .border(Color.purple)
                        .padding([.leading, .trailing], 30)
                    Spacer()
                    Button(action: {
                        viewModel.MakeStory(title: title, start: start)
                    }) {
                        Text("이야기 시작하기")
                            .padding()
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                            .frame(width: 150)
                            .fontWeight(.bold)
                            .background(Color.purple)
                            .cornerRadius(30)
                    }
                    Spacer()
                    NavigationLink(
                        destination: StoryDetailView()
                            .environmentObject(viewModel),
                        isActive: $viewModel.navigateToDetail,
                        label: {
                            EmptyView()
                        })
                        .isDetailLink(false)
                }
            }
            .padding()
        }
    }
}

struct StoryDetailView: View {
    @EnvironmentObject var viewModel: makeStoryViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("생성중...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else if let storyResponse = viewModel.storyResponse {
                    VStack(spacing: 20) {
                        Text("이로봇")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.purple)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)

                        if let url = URL(string: storyResponse.imageUrl ?? "") {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 200)
                                case .failure:
                                    Image(systemName: "exclamationmark.triangle")
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }

                        Text(storyResponse.title ?? "제목 없음")
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        Text(storyResponse.content)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        ForEach(storyResponse.choices.indices, id: \.self) { index in
                            NavigationLink(
                                destination: StoryDetailView()
                                    .environmentObject(viewModel),
                                label: {
                                    Text(storyResponse.choices[index])
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.purple)
                                        .cornerRadius(10)
                                        .padding(.horizontal)
                                }
                            )
                            .simultaneousGesture(TapGesture().onEnded {
                                viewModel.continueStory(id: storyResponse.id, choiceIndex: index)
                            })
                        }
                    }
                } else {
                    Text("No Story Available")
                }
            }
            .padding()
        }
    }
}

struct makeStoryView_Previews: PreviewProvider {
    static var previews: some View {
        makeStoryView()
    }
}
