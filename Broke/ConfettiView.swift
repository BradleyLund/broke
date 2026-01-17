//
//  ConfettiView.swift
//  Broke
//
//  Created by Claude on 15/01/2026.
//
import SwiftUI

struct ConfettiView: View {
    let confettiColors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple, .pink]
    let confettiCount = 50

    @State private var animate = false

    var body: some View {
        ZStack {
            ForEach(0..<confettiCount, id: \.self) { index in
                ConfettiPiece(color: confettiColors.randomElement() ?? .red)
                    .offset(
                        x: randomX(),
                        y: animate ? UIScreen.main.bounds.height + 100 : -100
                    )
                    .rotationEffect(.degrees(animate ? Double.random(in: 360...720) : 0))
                    .animation(
                        Animation.linear(duration: Double.random(in: 2...4))
                            .delay(Double.random(in: 0...0.5))
                            .repeatCount(1, autoreverses: false),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }

    private func randomX() -> CGFloat {
        return CGFloat.random(in: -UIScreen.main.bounds.width/2...UIScreen.main.bounds.width/2)
    }
}

struct ConfettiPiece: View {
    let color: Color

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 10, height: 10)
    }
}

struct SuccessOverlay: View {
    let duration: TimeInterval
    let onDismiss: () -> Void

    @State private var showMessage = false
    @State private var scale: CGFloat = 0.5

    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)

            ConfettiView()

            VStack(spacing: 20) {
                Text("Well Done!")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)

                Text("You had your phone blocked for")
                    .font(.headline)
                    .foregroundColor(.white)

                Text(formattedDuration(duration))
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(.green)

                Button(action: onDismiss) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 15)
                        .background(Color.blue)
                        .cornerRadius(25)
                }
                .padding(.top, 20)
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.2))
                    .blur(radius: 20)
            )
            .scaleEffect(scale)
            .opacity(showMessage ? 1 : 0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                showMessage = true
                scale = 1.0
            }
        }
    }

    private func formattedDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) / 60 % 60
        let seconds = Int(duration) % 60

        if hours > 0 {
            return String(format: "%dh %dm %ds", hours, minutes, seconds)
        } else if minutes > 0 {
            return String(format: "%dm %ds", minutes, seconds)
        } else {
            return String(format: "%ds", seconds)
        }
    }
}
