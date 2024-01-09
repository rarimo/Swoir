import XCTest
import Swoir
import SwoirCore
import Swoirenberg

final class SwoirTests: XCTestCase {

    func testProveVerifySuccess_x_not_eq_y() throws {
        let swoir = Swoir(backend: Swoirenberg.self)
        let manifest = Bundle.module.url(forResource: "x_not_eq_y.json", withExtension: nil)!
        let circuit = try swoir.createCircuit(manifest: manifest)
        let inputs = [ "x": 1, "y": 2 ]
        let proof = try circuit.prove(inputs)
        let verified = try circuit.verify(proof)
        XCTAssertTrue(verified, "Failed to verify proof")
    }

    func testProveFail_x_not_eq_y() throws {
        let swoir = Swoir(backend: Swoirenberg.self)
        let manifest = Bundle.module.url(forResource: "x_not_eq_y.json", withExtension: nil)!
        let circuit = try swoir.createCircuit(manifest: manifest)
        let inputs = [ "x": 1, "y": 1 ]
        XCTAssertThrowsError(try circuit.prove(inputs)) { error in
            XCTAssertEqual(error as? SwoirBackendError, .errorProving("Error generating proof"))
        }
    }

    func testProveVerifySuccess_field_array() throws {
        let swoir = Swoir(backend: Swoirenberg.self)
        let manifest = Bundle.module.url(forResource: "field_array.json", withExtension: nil)!
        let circuit = try swoir.createCircuit(manifest: manifest)
        let inputs = [ "x": [1, 2], "y": [1, 3] ]
        let proof = try circuit.prove(inputs)
        let verified = try circuit.verify(proof)
        XCTAssertTrue(verified, "Failed to verify proof")
    }

    func testProveVerifySuccess_known_preimage() throws {
        let swoir = Swoir(Swoirenberg.self)
        let manifest = Bundle.module.url(forResource: "known_preimage.json", withExtension: nil)!
        let circuit = try swoir.createCircuit(manifest: manifest)
        let inputs = [
            "preimage": Data("Hello, world!".utf8),
            "hash": Data.fromHex("0xb6e16d27ac5ab427a7f68900ac5559ce272dc6c37c82b3e052246c82244c50e4") ]
        let proof = try circuit.prove(inputs)
        let verified = try circuit.verify(proof)
        XCTAssertTrue(verified, "Failed to verify proof")
    }

    func testProveVerifySuccess_count_letters() throws {
        let swoir = Swoir(backend: Swoirenberg.self)
        let manifest = Bundle.module.url(forResource: "count_letters.json", withExtension: nil)!
        let circuit = try swoir.createCircuit(manifest: manifest)
        let inputs = [ "words": Data("Hello, world!".utf8), "letter": Data("l".utf8)[0], "count": 3 ] as [String: Any]
        let proof = try circuit.prove(inputs)
        let verified = try circuit.verify(proof)
        XCTAssertTrue(verified, "Failed to verify proof")
    }
}
