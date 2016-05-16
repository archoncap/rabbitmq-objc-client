import XCTest

class RMQExchangeTest: XCTestCase {

    func testPublishCallsPublishOnChannel() {
        let ch = ChannelSpy(1)
        let ex = RMQExchange(name: "", channel: ch)
        ex.publish("foo", routingKey: "my.q")

        XCTAssertEqual("foo", ch.lastReceivedBasicPublishMessage)
        XCTAssertEqual("my.q", ch.lastReceivedBasicPublishRoutingKey)
        XCTAssertEqual("", ch.lastReceivedBasicPublishExchange)
    }

    func testPublishWithoutRoutingKeyUsesEmptyString() {
        let ch = ChannelSpy(1)
        let ex = RMQExchange(name: "", channel: ch)
        ex.publish("foo")

        XCTAssertEqual("foo", ch.lastReceivedBasicPublishMessage)
        XCTAssertEqual("", ch.lastReceivedBasicPublishRoutingKey)
        XCTAssertEqual("", ch.lastReceivedBasicPublishExchange)
    }

    func testPublishWithPersistence() {
        let ch = ChannelSpy(1)
        let ex = RMQExchange(name: "some-ex", channel: ch)
        ex.publish("foo", routingKey: "my.q", persistent: true)

        XCTAssertEqual("foo", ch.lastReceivedBasicPublishMessage)
        XCTAssertEqual("my.q", ch.lastReceivedBasicPublishRoutingKey)
        XCTAssertEqual("some-ex", ch.lastReceivedBasicPublishExchange)
        XCTAssertEqual(true, ch.lastReceivedBasicPublishPersistent)
    }

    func testDeleteCallsDeleteOnChannel() {
        let ch = ChannelSpy(1)
        let ex = RMQExchange(name: "deletable", channel: ch)
        
        ex.delete()
        XCTAssertEqual("deletable", ch.lastReceivedExchangeDeleteExchangeName)
        XCTAssertEqual([], ch.lastReceivedExchangeDeleteOptions)

        ex.delete([.IfUnused])
        XCTAssertEqual("deletable", ch.lastReceivedExchangeDeleteExchangeName)
        XCTAssertEqual([.IfUnused], ch.lastReceivedExchangeDeleteOptions)
    }

}
