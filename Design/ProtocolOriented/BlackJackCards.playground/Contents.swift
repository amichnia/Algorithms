
// MARK: - Card protocols
protocol AnyCard: Equatable { }

protocol Suited {
    associatedtype Suite
    var suite: Suite { get }
}

protocol WithValue {
    associatedtype Value: RawRepresentable
    var value: Value { get }
}

protocol BlackJackCard: AnyCard, WithValue where Value.RawValue == Int { }

// MARK: - Hand and decks
class Deck<Card: AnyCard> {
    func shuffle() {

    }
    func draw() -> Card {
        fatalError()
    }
}

class Hand<Card: AnyCard> {
    var cards: [Card]
    init() {
        cards = []
    }
    func append(_ card: Card) {
        self.cards.append(card)
    }
}

extension Hand where Card: BlackJackCard {
    func value() -> Int { return cards.value() }
}

extension Array where Element: WithValue, Element.Value.RawValue == Int {
    func value() -> Int {
        return self.reduce(into: 0, { $0 += $1.value.rawValue })
    }
}

enum WinState {
    case none
    case player
    case bank
}

// MARK: - Game
protocol BlackJackGame {
    associatedtype Card: BlackJackCard

    var playerHand: Hand<Card> { get }
    var bankHand: Hand<Card> { get }
    var deck: Deck<Card> { get }

    var blackjack: Int { get }
    func isBlackJack(in hand: Hand<Card>) -> Bool

    init(deck: Deck<Card>)

    func start()
    func draw() -> WinState
    func pass() -> WinState
}

extension BlackJackGame {
    func isBlackJack(in hand: Hand<Card>) -> Bool {
        return hand.value() == blackjack
    }

    func start() {
        deck.shuffle()
    }

    func draw() -> WinState {
        playerHand.append(deck.draw())
        guard !isBlackJack(in: playerHand) else { return .player }
        guard playerHand.value() < blackjack else { return .bank }

        bankHand.append(deck.draw())

        guard bankHand.value() < blackjack else { return .bank }

        return .none
    }

    func pass() -> WinState {
        bankHand.append(deck.draw())
        return playerHand.value() > bankHand.value() ? .player : .bank
    }
}

// MARK: - Implementation - Cards

class StandardEuropeanCard: AnyCard, Suited, WithValue {
    enum Suite {
        case heart
        case diamond
        case trefl
        case spade
    }
    enum Value: RawRepresentable {
        typealias RawValue = Int

        case plain(Int)
        case dude
        case queen
        case king
        case ace

        var rawValue: Int {
            switch self {
            case .plain(let value): return value
            case .dude: return 11
            case .queen: return 12
            case .king: return 13
            case .ace: return 14
            }
        }

        init?(rawValue: RawValue) {
            switch rawValue {
            case let n where n > 0 && n <= 10: self = .plain(n)
            case Value.dude.rawValue: self = .dude
            case Value.queen.rawValue: self = .queen
            case Value.king.rawValue: self = .king
            case Value.ace.rawValue: self = .ace
            default: return nil
            }
        }
    }

    var suite: StandardEuropeanCard.Suite
    var value: StandardEuropeanCard.Value

    init(_ value: Value, _ suite: Suite) {
        self.value = value
        self.suite = suite
    }

    static func == (lhs: StandardEuropeanCard, rhs: StandardEuropeanCard) -> Bool {
        return lhs.suite == rhs.suite && lhs.value.rawValue == rhs.value.rawValue
    }
}

extension StandardEuropeanCard: BlackJackCard { }

// MARK: - Implementation - Game
class StandardBlackJackGame: BlackJackGame {
    typealias Card = StandardEuropeanCard
    let blackjack = 21

    var playerHand: Hand<Card> = Hand()
    var bankHand: Hand<Card> = Hand()
    var deck: Deck<Card>

    required init(deck: Deck<Card>) {
        self.deck = deck
    }
}

print(#line)
