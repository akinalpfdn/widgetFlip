import SwiftUI

// Shared by the widget guide and the support sheet.
enum WidgetGuideStyle {
    static let background = Color(red: 0.065, green: 0.067, blue: 0.075)
    static let gold = Color(red: 0.94, green: 0.77, blue: 0.48)
    static let ink = Color(red: 0.96, green: 0.94, blue: 0.89)
    static let muted = Color(red: 0.64, green: 0.64, blue: 0.65)
}

struct WidgetSetupGuideView: View {
    @Environment(\.dismiss) private var dismiss
    // The shortcut comes first; pages 1–3 retain the widget-gallery method.
    @State private var page = 0

    private let instructions: [LocalizedStringKey] = [
        "On your Home Screen, touch and hold the Widget Flip icon. Choose a widget size at the top of the menu.",
        "Go to your Home Screen. Hold an empty area until the app icons start to jiggle.",
        "Tap Edit, then Add Widget. Search for Widget Flip and select it.",
        "Swipe to choose a size. Tap Add Widget, then Done. Tap the widget to flip a coin."
    ]

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView {
                VStack(spacing: 24) {
                    if page == 0 {
                        WidgetShortcutIllustration()
                            .frame(height: 260)
                            .accessibilityHidden(true)
                    } else {
                        HStack(spacing: 6) {
                            ForEach(1...3, id: \.self) { step in
                                Capsule()
                                    .fill(step <= page ? WidgetGuideStyle.gold : .white.opacity(0.1))
                                    .frame(height: 3)
                            }
                        }
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(Text("Step \(page) of 3"))

                        WidgetGuideIllustration(step: page - 1)
                            .frame(height: 220)
                            .accessibilityHidden(true)
                    }

                    Text(instructions[page])
                        .font(.title2.weight(.medium))
                        .foregroundStyle(WidgetGuideStyle.ink)
                        .lineSpacing(6)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 28)
                .padding(.top, 16)
                .padding(.bottom, 24)
            }
            .id(page)
        }
        .frame(maxWidth: 520)
        .frame(maxWidth: .infinity)
        .safeAreaInset(edge: .bottom, spacing: 0) { footer }
        .background(WidgetGuideStyle.background.ignoresSafeArea())
        .preferredColorScheme(.dark)
        .presentationDetents([.height(620), .large])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(32)
    }

    private var header: some View {
        HStack(spacing: 10) {
            Text("How to add a widget")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(WidgetGuideStyle.ink)
            Spacer()
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(WidgetGuideStyle.muted)
                    .frame(width: 30, height: 30)
                    .background(.white.opacity(0.06), in: Circle())
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Close")
        }
        .padding(.leading, 28)
        .padding(.trailing, 20)
        .padding(.top, 16)
    }

    private var footer: some View {
        VStack(spacing: 4) {
            HStack(spacing: 14) {
                if page > 0 {
                    Button {
                        page -= 1
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.body.weight(.medium))
                            .foregroundStyle(WidgetGuideStyle.ink)
                            .frame(width: 56, height: 56)
                            .background(.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 18))
                    }
                    .accessibilityLabel("Back")
                }

                Button {
                    if page == 0 || page == 3 {
                        dismiss()
                    } else {
                        page += 1
                    }
                } label: {
                    Text(page == 0 || page == 3 ? "Got it" : "Next")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(WidgetGuideStyle.background)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(WidgetGuideStyle.gold, in: RoundedRectangle(cornerRadius: 18))
                }
            }

            if page == 0 {
                Button("Other method") {
                    page = 1
                }
                .font(.body.weight(.medium))
                .foregroundStyle(WidgetGuideStyle.gold)
                .frame(maxWidth: .infinity, minHeight: 44)
            }
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 28)
        .padding(.top, 12)
        .padding(.bottom, 16)
        .frame(maxWidth: 520)
        .frame(maxWidth: .infinity)
        .background(WidgetGuideStyle.background)
    }
}

/// Illustrates the Home Screen app-icon shortcut, not an interactive menu.
private struct WidgetShortcutIllustration: View {
    var body: some View {
        GeometryReader { geometry in
            let scale = min(1, geometry.size.width / 280)
            VStack(alignment: .trailing, spacing: 14) {
                VStack(spacing: 6) {
                    Image("GuideAppIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    Text("Widget Flip")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(WidgetGuideStyle.ink)
                }
                .padding(.trailing, 12)

                VStack(spacing: 0) {
                    HStack(spacing: 8) {
                        Image(systemName: "square.grid.2x2")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundStyle(WidgetGuideStyle.muted)
                            .frame(width: 46, height: 44)
                            .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 10))

                        HStack(spacing: 10) {
                            sizeIcon(width: 20, height: 20)
                            sizeIcon(width: 30, height: 20)
                            sizeIcon(width: 28, height: 28)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .foregroundStyle(WidgetGuideStyle.gold)
                        .background(WidgetGuideStyle.gold.opacity(0.09), in: RoundedRectangle(cornerRadius: 12))
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(WidgetGuideStyle.gold.opacity(0.6))
                        }
                    }
                    .padding(12)

                    Divider().overlay(.white.opacity(0.04))
                    menuRow("Edit Home Screen", symbol: "apps.iphone", color: WidgetGuideStyle.ink)
                    Divider().overlay(.white.opacity(0.04))
                    menuRow("Remove App", symbol: "minus.circle", color: Color(red: 0.94, green: 0.4, blue: 0.4))
                }
                .background(Color(red: 0.17, green: 0.18, blue: 0.20), in: RoundedRectangle(cornerRadius: 22))
                .overlay {
                    RoundedRectangle(cornerRadius: 22).strokeBorder(.white.opacity(0.1))
                }
            }
            .frame(width: 280)
            .scaleEffect(scale)
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .environment(\.dynamicTypeSize, .medium)
        .allowsHitTesting(false)
    }

    private func sizeIcon(width: CGFloat, height: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 4)
            .strokeBorder(lineWidth: 1.8)
            .frame(width: width, height: height)
            .overlay(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 1)
                    .frame(width: 5, height: 5)
                    .padding(4)
            }
            .frame(width: 38, height: 28)
    }

    private func menuRow(_ title: LocalizedStringKey, symbol: String, color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: symbol)
                .frame(width: 20)
            Text(title)
            Spacer(minLength: 0)
        }
        .font(.system(size: 14))
        .foregroundStyle(color)
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
    }
}

/// A simplified Home Screen illustration; the real widget is added in iOS.
private struct WidgetGuideIllustration: View {
    let step: Int
    private let symbols = ["message.fill", "calendar", "camera.fill", "cloud.sun.fill", "music.note", "clock.fill", "map.fill", "heart.fill"]

    var body: some View {
        GeometryReader { geometry in
            let scale = min(geometry.size.height / 320, geometry.size.width / 310)
            ZStack {
                Circle()
                    .fill(WidgetGuideStyle.gold.opacity(0.06))
                    .frame(width: 280, height: 280)
                    .blur(radius: 24)
                phone
                    .rotationEffect(.degrees(step == 0 ? -5 : (step == 2 ? 4 : 0)))
                    .offset(y: -6)
                if step == 0 {
                    holdGesture
                        .offset(x: 54, y: 62)
                }
                instructionBadge
                    .offset(y: 137)
            }
            .frame(width: 310, height: 320)
            .scaleEffect(scale)
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .environment(\.dynamicTypeSize, .medium)
        .allowsHitTesting(false)
    }

    private var phone: some View {
        VStack(spacing: 16) {
            HStack {
                Text("9:41").font(.system(size: 9, weight: .semibold))
                Spacer()
                Capsule().fill(.black.opacity(0.7)).frame(width: 48, height: 12)
                Spacer()
                Image(systemName: "battery.100percent").font(.system(size: 11))
            }
            .foregroundStyle(.white.opacity(0.65))

            if step == 1 {
                gallery
            } else {
                homeScreen
            }
            Spacer(minLength: 0)
            Capsule()
                .fill(.white.opacity(0.45))
                .frame(width: 64, height: 3)
        }
        .padding(16)
        .frame(width: 216, height: 286)
        .background {
            RoundedRectangle(cornerRadius: 32)
                .fill(Color(red: 0.16, green: 0.17, blue: 0.19).gradient)
                .overlay {
                    RadialGradient(colors: [WidgetGuideStyle.gold.opacity(0.23), .clear], center: .bottomLeading, startRadius: 0, endRadius: 280)
                }
                .clipShape(RoundedRectangle(cornerRadius: 32))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 32)
                .strokeBorder(.white.opacity(0.17), lineWidth: 1)
                .padding(0.5)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 36)
                .strokeBorder(.white.opacity(0.05), lineWidth: 4)
                .padding(-4)
        }
        .shadow(color: .black.opacity(0.35), radius: 20, y: 14)
    }

    private var homeScreen: some View {
        VStack(spacing: 14) {
            if step == 0 {
                HStack {
                    Text("Edit")
                    Image(systemName: "chevron.down")
                }
                .font(.system(size: 9, weight: .semibold))
                .foregroundStyle(WidgetGuideStyle.ink)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(.white.opacity(0.12), in: Capsule())
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            if step == 2 {
                HStack(alignment: .top, spacing: 12) {
                    coinWidget
                    VStack(spacing: 12) {
                        appTile("calendar")
                        appTile("camera.fill")
                    }
                }
            }
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 14) {
                ForEach(0..<(step == 2 ? 4 : 8), id: \.self) { index in
                    appTile(symbols[index])
                        .rotationEffect(.degrees(step == 0 ? (index.isMultiple(of: 2) ? -5 : 5) : 0))
                        .overlay(alignment: .topLeading) {
                            if step == 0 {
                                Image(systemName: "minus")
                                    .font(.system(size: 6, weight: .bold))
                                    .foregroundStyle(.white.opacity(0.7))
                                    .frame(width: 11, height: 11)
                                    .background(Color(white: 0.35), in: Circle())
                                    .offset(x: -3, y: -3)
                            }
                        }
                }
            }
        }
    }

    private var gallery: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "magnifyingglass")
                Text("Widget Flip")
                Spacer(minLength: 0)
            }
            .font(.system(size: 11, weight: .medium))
            .foregroundStyle(WidgetGuideStyle.ink)
            .padding(10)
            .background(.white.opacity(0.09), in: RoundedRectangle(cornerRadius: 10))
            HStack(spacing: 8) {
                Image("HeadsImage")
                    .resizable().scaledToFit().frame(width: 24, height: 24)
                Text("Widget Flip").font(.system(size: 11, weight: .semibold))
                Spacer()
                Image(systemName: "chevron.right").font(.system(size: 9))
            }
            .foregroundStyle(WidgetGuideStyle.ink)
            .padding(.horizontal, 4)
            coinWidget
                .frame(maxWidth: .infinity)
        }
    }

    private var coinWidget: some View {
        VStack(spacing: 8) {
            Image("HeadsImage")
                .resizable().scaledToFit().frame(width: 55, height: 55)
            Text("HEADS")
                .font(.system(size: 8, weight: .bold))
                .tracking(1.8)
                .foregroundStyle(WidgetGuideStyle.gold)
        }
        .frame(width: 116, height: 110)
        .background(Color(red: 0.08, green: 0.10, blue: 0.12), in: RoundedRectangle(cornerRadius: 22))
        .overlay {
            RoundedRectangle(cornerRadius: 22).strokeBorder(WidgetGuideStyle.gold.opacity(0.22))
        }
    }

    private func appTile(_ symbol: String) -> some View {
        Image(systemName: symbol)
            .font(.system(size: 16, weight: .medium))
            .foregroundStyle(.white.opacity(0.48))
            .frame(width: 34, height: 34)
            .background(.white.opacity(0.09), in: RoundedRectangle(cornerRadius: 9))
    }

    private var holdGesture: some View {
        ZStack {
            Circle().strokeBorder(WidgetGuideStyle.gold.opacity(0.16), lineWidth: 1).frame(width: 76, height: 76)
            Circle().strokeBorder(WidgetGuideStyle.gold.opacity(0.3), lineWidth: 1).frame(width: 54, height: 54)
            Circle().fill(WidgetGuideStyle.gold.opacity(0.16)).frame(width: 34, height: 34)
            Image(systemName: "hand.point.up.left.fill")
                .font(.system(size: 36))
                .foregroundStyle(WidgetGuideStyle.gold)
                .shadow(color: .black.opacity(0.4), radius: 6, y: 4)
                .offset(x: 15, y: 19)
        }
    }

    private var instructionBadge: some View {
        HStack(spacing: 8) {
            Image(systemName: step == 0 ? "hand.tap" : (step == 1 ? "plus" : "checkmark"))
            Text(step == 0 ? "Touch & hold" : (step == 1 ? "Edit → Add Widget" : "Add Widget → Done"))
        }
        .font(.system(size: 12, weight: .medium))
        .foregroundStyle(WidgetGuideStyle.gold)
        .padding(.horizontal, 16)
        .padding(.vertical, 11)
        .background(Color(red: 0.15, green: 0.14, blue: 0.12), in: Capsule())
        .overlay { Capsule().strokeBorder(WidgetGuideStyle.gold.opacity(0.2)) }
        .shadow(color: .black.opacity(0.2), radius: 12, y: 6)
    }
}


#Preview {
    WidgetSetupGuideView()
}
