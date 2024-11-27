import SwiftUI

struct GameView: View {
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            if !viewModel.gameStarted {
                startButton
            } else {
                progressContainer
                
                Spacer()
                
                if viewModel.progressIndex < 5 {
                    moveButton
                } else {
                    statistics
                }
                
                Spacer()
                
                resetButtonContainer
            }
        }
        .ignoresSafeArea(.all)
    }
    
    var safeAreaInsets: UIEdgeInsets? {
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
            .windows.first?.safeAreaInsets
    }
}

// MARK: - Buttons

private extension GameView {
    
    var startButton: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let topInset = safeAreaInsets?.top ?? 0
            let bottomInset = safeAreaInsets?.bottom ?? 0

            let centerX = width / 2
            let centerY = (height - topInset - bottomInset) / 2 + topInset

            return Button(
                action: viewModel.startGame,
                label: { startLabel }
            )
            .position(x: centerX, y: centerY)
        }
    }


    
    var startLabel: some View {
        Text("Старт")
            .frame(width: 96, height: 96)
            .foregroundColor(.white)
            .background(Circle().fill(.purple))
    }
    
    var moveButton: some View {
        GeometryReader { geometry in
            Button(
                action: { viewModel.recordTap(in: geometry.size) },
                label: { moveLabel }
            )
            .offset(viewModel.buttonOffset)
            .onAppear {
                viewModel.startTimer(in: geometry.size)
            }
        }
    }
    
    var moveLabel: some View {
        Circle()
            .fill(.purple)
            .frame(width: 96, height: 96)
    }
}

// MARK: - Rest

private extension GameView {
    
    var resetButtonContainer: some View {
        VStack {
            Spacer()
            HStack {
                resetButton
                    .padding(.horizontal, 8)
                    .padding(.vertical, 8)
            }
            .frame(maxWidth: .infinity)
            .background(.gray.opacity(0.2))
            .padding(.bottom, safeAreaInsets?.bottom ?? 0)
        }
    }
    
    var resetButton: some View {
        Button(
            action: viewModel.resetGame,
            label: { resetLabel }
        )
    }
    
    var resetLabel: some View {
        Text("Сброс")
            .frame(maxWidth: .infinity)
            .padding()
            .background(.purple)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal, 20)
    }
}

// MARK: - Progress

private extension GameView {
    
    var progressContainer: some View {
        HStack {
            progress
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
        }
        .frame(maxWidth: .infinity)
        .background(.gray.opacity(0.2))
        .padding(.top, safeAreaInsets?.top ?? 0)
    }
    
    var progress: some View {
        HStack {
            ForEach(0..<5) { index in
                Circle()
                    .fill(index < viewModel.progressIndex ? .green : (index == viewModel.progressIndex ? .yellow : .gray))
                    .frame(width: 12, height: 12)
            }
        }
        .padding()
    }
}

// MARK: - Statistics

private extension GameView {
    
    var statistics: some View {
        VStack {
            ForEach(viewModel.tapTimes.indices, id: \.self) { index in
                HStack {
                    Text("\(index + 1) тап")
                    Spacer()
                    Text("Время: \(Int(viewModel.tapTimes[index])) ms")
                        .bold(viewModel.tapTimes[index] == viewModel.minTapTime)
                }
            }
            HStack {
                Text("Среднее")
                Spacer()
                Text("Время: \(Int(viewModel.averageTapTime)) ms")
                    .bold()
            }
            .background(.gray.opacity(0.5))
        }
        .padding()
    }
}
