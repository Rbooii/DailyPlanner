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
            ZStack {
                if manager.goals.isEmpty {
                    ContentUnavailableView(
                        "No Goals Yet",
                        systemImage: "flag.fill",
                        description: Text("Add your first goal for today.")
                    ).transition(.opacity.combined(with: .scale(scale: 0.95)))
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
                    }.transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }.animation(.spring(response: 0.5, dampingFraction: 0.8), value: manager.goals.isEmpty)
            .navigationTitle(realTitle())
            .navigationSubtitle(todayTitle())
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showInput = true }) {
                        Image(systemName: "plus")
                            .font(.body)
                            .fontWeight(.semibold)
                            .frame(width: 32, height: 32)
                    }
                    .glassEffect(in: Circle())
                }
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
        case 0: return "Pretty Chill.. 😴"
        case 1: return "Today's Goal"
        default: return "Today's Goals 🔥"
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
