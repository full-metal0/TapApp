import SwiftUI
import Combine

final class GameViewModel: ObservableObject {
    @Published var gameStarted = false
    @Published var tapTimes: [Double] = []
    @Published var progressIndex = 0
    @Published var buttonOffset: CGSize = .zero
    
    private var startTime: Date?
    private var timer: Timer?
}

extension GameViewModel {
    
    func startGame() {
        gameStarted = true
        startTime = Date()
    }
    
    func recordTap(in size: CGSize) {
        if let start = startTime {
            let tapTime = Date().timeIntervalSince(start) * 1000
            tapTimes.append(tapTime)
            progressIndex += 1
            startTime = Date()
            buttonOffset = randomOffset(in: size)
            startTimer(in: size)
        }
    }
    
    func startTimer(in size: CGSize) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] _ in
            self?.moveButtonAutomatically(in: size)
        }
    }
    
    func resetGame() {
        gameStarted = false
        tapTimes.removeAll()
        progressIndex = 0
        timer?.invalidate()
    }
    
    var minTapTime: Double? {
        tapTimes.min()
    }
    
    var averageTapTime: Double {
        guard !tapTimes.isEmpty else { return 0 }
        return tapTimes.reduce(0, +) / Double(tapTimes.count)
    }
}

private extension GameViewModel {
    
    func randomOffset(in size: CGSize) -> CGSize {
        let x = CGFloat.random(in: 0...(size.width - 96))
        let y = CGFloat.random(in: 0...(size.height - 96))
        return CGSize(width: x, height: y)
    }
    
    func moveButtonAutomatically(in size: CGSize) {
        if progressIndex < 5 {
            buttonOffset = randomOffset(in: size)
            startTime = Date()
            startTimer(in: size)
        }
    }
}


