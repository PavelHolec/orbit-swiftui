import XCTest
@testable import Orbit

class CarrierLogoTests: SnapshotTestCase {

    func testCarrierLogos() {
        assert(CarrierLogoPreviews.snapshot)
    }
}
