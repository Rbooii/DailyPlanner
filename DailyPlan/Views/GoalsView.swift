import SwiftUI
import Combine

struct GoalsView: View {
    @StateObject private var manager: GoalsManager
    @State private var newGoalText = ""
    @State private var showInput = false
    @Environment(\.scenePhase) private var scenePhase
    
    init(email: String) {
        _manager = StateObject(wrappedValue: GoalsManager(email: email))
    }
    
    private var progress: Double {
        guard manager.totalCount > 0 else { return 0 }
        return Double(manager.completedCount) / Double(manager.totalCount)
    }

    var body: some View {
        NavigationStack {
            Group {
                if manager.goals.isEmpty {
                    ContentUnavailableView(
                        "No Goals Yet",
                        systemImage: "flag.fill",
                        description: Text("Add your first goal for today.")
                    )
                } else {
                    List {
                        Section {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("\(manager.completedCount) of \(manager.totalCount) done")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                    Spacer()
                                    Text("\(progressPercent())%")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.tint)
                                        .contentTransition(.numericText())
                                        .animation(.spring(duration: 0.4), value: manager.completedCount)
                                }
                                ProgressView(value: progress)
                                    .tint(.accentColor)
                                    .animation(.spring(response: 1, dampingFraction: 0.8), value: progress)
                            }
                            .padding(.vertical, 4)
                        }

                        Section {
                            ForEach(manager.goals) { goal in
                                Button(action: { manager.toggle(goal) }) {
                                    HStack(spacing: 12) {
                                        Image(systemName: goal.isDone ? "checkmark.circle.fill" : "circle")
                                            .font(.title3)
                                            .foregroundStyle(goal.isDone ? AnyShapeStyle(.tint) : AnyShapeStyle(.secondary))
                                        Text(goal.title)
                                            .foregroundStyle(goal.isDone ? .secondary : .primary)
                                            .strikethrough(goal.isDone)
                                    }
                                    .padding(.vertical, 2)
                                }
                                .buttonStyle(.plain)
                            }
                            .onDelete(perform: manager.delete)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .top) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(realTitle())
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text(todayTitle())
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Button(action: { showInput = true }) {
                        Image(systemName: "plus")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(width: 36, height: 36)
                            .background(Color.accentColor)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color(.systemBackground))
            }
            .sheet(isPresented: $showInput) {
                AddGoalSheet(isPresented: $showInput) { title in
                    manager.add(title: title)
                }
                .presentationDetents([.height(220)])
                .presentationDragIndicator(.visible)
            }
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .active {
                    manager.checkAndReset()
                }
            }
            .onReceive(Timer.publish(every: 60, on: .main, in: .common).autoconnect()) { _ in
                manager.checkAndReset()
            }
        }
    }

    private func progressPercent() -> Int {
        guard manager.totalCount > 0 else { return 0 }
        return Int((Double(manager.completedCount) / Double(manager.totalCount)) * 100)
    }

    private func todayTitle() -> String {
        let f = DateFormatter()
        f.dateFormat = "EEEE, d MMM"
        return f.string(from: Date())
    }

    private func realTitle() -> String {
        switch manager.totalCount {
        case 0:
            return "Pretty Chill.. 😴"
        case 1:
            return "Today's Goal"
        default:
            return "Today's Goals 🔥"
        }
    }
}

struct AddGoalSheet: View {
    @Binding var isPresented: Bool
    @State private var text = ""
    var onAdd: (String) -> Void

    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: 16) {
            Divider()

            Text("What do you want to achieve today?")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            TextField("Enter your goal", text: $text)
                .textFieldStyle(.plain)
                .padding(.horizontal, 16)
                .frame(height: 52)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color(.secondarySystemBackground))
                )
                .focused($isFocused)
                .submitLabel(.done)
                .onSubmit(submit)

            Button(action: submit) {
                Text("Add Goal")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
            }
            .buttonStyle(.borderedProminent)
            .disabled(text.trimmingCharacters(in: .whitespaces).isEmpty)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isFocused = true
            }
        }
    }

    private func submit() {
        let trimmed = text.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        onAdd(trimmed)
        isPresented = false
    }
}

#Preview {
    GoalsView(email: "arcozkwn@gmail.com")
}
