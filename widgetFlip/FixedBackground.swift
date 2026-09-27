import SwiftUI
import UIKit

/// Background image fixed to the device: when the interface rotates, the image counter-rotates inside the same
/// system animation, so it never moves on screen and a portrait image also fits landscape without extra cropping.
struct FixedBackground: UIViewControllerRepresentable {
    let imageName: String

    func makeUIViewController(context: Context) -> FixedBackgroundController {
        let controller = FixedBackgroundController()
        controller.image = UIImage(named: imageName)
        return controller
    }

    func updateUIViewController(_ controller: FixedBackgroundController, context: Context) {}
}

final class FixedBackgroundController: UIViewController {
    private let imageView = UIImageView()
    /// Rotation of the image relative to the interface, in radians.
    private var angle: CGFloat = 0
    private var hasInitialAngle = false

    var image: UIImage? {
        get { imageView.image }
        set { imageView.image = newValue }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.isUserInteractionEnabled = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        view.addSubview(imageView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !hasInitialAngle, let orientation = view.window?.windowScene?.effectiveGeometry.interfaceOrientation {
            angle = Self.angle(for: orientation)
            hasInitialAngle = true
        }
        layoutImage(in: view.bounds.size)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        // Undo the interface rotation in the same animation so the image stays still on screen.
        let transform = coordinator.targetTransform
        let delta = atan2(transform.b, transform.a)
        coordinator.animate(alongsideTransition: { [weak self] _ in
            guard let self else { return }
            angle -= delta
            layoutImage(in: size)
        }, completion: { [weak self] _ in
            guard let self else { return }
            angle = atan2(sin(angle), cos(angle))
            layoutImage(in: view.bounds.size)
        })
    }

    private func layoutImage(in size: CGSize) {
        let sideways = abs(sin(angle)) > 0.5
        imageView.transform = .identity
        imageView.bounds = CGRect(origin: .zero, size: sideways ? CGSize(width: size.height, height: size.width) : size)
        imageView.center = CGPoint(x: size.width / 2, y: size.height / 2)
        imageView.transform = CGAffineTransform(rotationAngle: angle)
    }

    private static func angle(for orientation: UIInterfaceOrientation) -> CGFloat {
        switch orientation {
        case .landscapeLeft: return .pi / 2
        case .landscapeRight: return -.pi / 2
        case .portraitUpsideDown: return .pi
        default: return 0
        }
    }
}
