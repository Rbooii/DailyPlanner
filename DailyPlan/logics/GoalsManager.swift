import Foundation
import Combine
import SwiftUI

struct Goal: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var isDone: Bool = false
}

class GoalsManager: ObservableObject {
    @Published var goals: [Goal] = []

    private let goalsKey: String
    private let dateKey: String

    init(email: String) {
        self.goalsKey = "dailyGoals_\(email)"
        self.dateKey = "goalsDate_\(email)"
        load()
    }

    // MARK: - Load & Reset
    private func load() {
        let today = todayString()
        let savedDate = UserDefaults.standard.string(forKey: dateKey)

        if savedDate != today {
            // Hari baru → reset
            goals = []
            UserDefaults.standard.set(today, forKey: dateKey)
            save()
        } else {
            if let data = UserDefaults.standard.data(forKey: goalsKey),
               let decoded = try? JSONDecoder().decode([Goal].self, from: data) {
                goals = decoded
            }
        }
    }
    
    func checkAndReset() {
        let today = todayString()
        let savedDate = UserDefaults.standard.string(forKey: dateKey)
        if savedDate != today {
            goals = []
            UserDefaults.standard.set(today, forKey: dateKey)
            save()
        }
    }

    // MARK: - CRUD
    func add(title: String) {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        goals.append(Goal(title: title))
        save()
    }

    func toggle(_ goal: Goal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                goals[index].isDone.toggle()
            }
            save()
        }
    }

    func delete(at offsets: IndexSet) {
        goals.remove(atOffsets: offsets)
        save()
    }

    // MARK: - Helpers
    private func save() {
        if let encoded = try? JSONEncoder().encode(goals) {
            UserDefaults.standard.set(encoded, forKey: goalsKey)
        }
    }

    private func todayString() -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: Date())
    }

    var completedCount: Int { goals.filter { $0.isDone }.count }
    var totalCount: Int { goals.count }
}
