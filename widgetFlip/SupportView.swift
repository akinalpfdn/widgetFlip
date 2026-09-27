import SwiftUI

/// Opened from the star button. Review opens the App Store's write-review page, which always works;
/// the automatic in-app rating prompt is separate (see ContentView.requestReviewIfNeeded).
struct SupportView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    // No country code: iPhones open the App Store app, browsers get redirected to the viewer's own storefront.
    private let appStoreLink = "https://apps.apple.com/app/widget-flip/id6757090449"
    private let reviewURL = URL(string: "https://apps.apple.com/app/id6757090449?action=write-review")!

    // Shared as plain text: sharing a URL through ShareLink sends a binary plist ("bplist00…") to apps such as WhatsApp.
    private var shareText: String {
        String(localized: "Flip a coin right from your Home Screen.") + "\n" + appStoreLink
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
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
            .padding(.trailing, 20)
            .padding(.top, 16)

            ScrollView {
                VStack(spacing: 18) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 44, weight: .semibold))
                        .foregroundStyle(WidgetGuideStyle.gold)
                        .accessibilityHidden(true)

                    Text("Enjoying Widget Flip?")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(WidgetGuideStyle.ink)

                    Text("Widget Flip has no ads and nothing to buy. If you enjoy it, please support us by leaving a review or sharing it with friends.")
                        .font(.body)
                        .foregroundStyle(WidgetGuideStyle.muted)
                        .lineSpacing(4)
                }
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 28)
                .padding(.bottom, 24)
            }

            VStack(spacing: 12) {
                Button {
                    openURL(reviewURL)
                    dismiss()
                } label: {
                    Label("Write a Review", systemImage: "star.bubble")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(WidgetGuideStyle.background)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(WidgetGuideStyle.gold, in: RoundedRectangle(cornerRadius: 18))
                }

                ShareLink(item: shareText) {
                    Label("Share Widget Flip", systemImage: "square.and.arrow.up")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(WidgetGuideStyle.ink)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 18))
                }
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 28)
            .padding(.bottom, 16)
        }
        .frame(maxWidth: 520)
        .frame(maxWidth: .infinity)
        .background(WidgetGuideStyle.background.ignoresSafeArea())
        .preferredColorScheme(.dark)
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(32)
    }
}

#Preview {
    SupportView()
}
