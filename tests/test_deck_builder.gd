extends GutTest

const DeckBuilderScene = preload("res://deck_builder.tscn")

var deck_builder

func _make_card(card_name: String = "Test Card") -> CardData:
	var card = CardData.new()
	card.name = card_name
	card.cost = 1
	card.type = "Attack"
	card.description = "A test card."
	return card

func before_each():
	deck_builder = DeckBuilderScene.instantiate()
	add_child(deck_builder)
	await get_tree().process_frame
	# Start each test with a clean deck regardless of _ready defaults
	deck_builder.deck_cards = [] as Array[CardData]

func after_each():
	deck_builder.queue_free()

# --- Adding Cards ---

func test_adding_one_card_increases_deck_size_to_one():
	var card = _make_card("Scythe")
	deck_builder._on_card_dropped(card)
	assert_eq(deck_builder.deck_cards.size(), 1)

func test_adding_two_different_cards_both_appear_in_deck():
	var card_a = _make_card("Scythe")
	var card_b = _make_card("Watering Can")
	deck_builder._on_card_dropped(card_a)
	deck_builder._on_card_dropped(card_b)
	assert_eq(deck_builder.deck_cards.size(), 2)

func test_added_card_is_the_correct_card():
	var card = _make_card("Scythe")
	deck_builder._on_card_dropped(card)
	assert_eq(deck_builder.deck_cards[0], card)

# --- Duplicate Prevention ---

func test_adding_duplicate_card_is_rejected():
	var card = _make_card("Scythe")
	deck_builder._on_card_dropped(card)
	deck_builder._on_card_dropped(card)
	assert_eq(deck_builder.deck_cards.size(), 1)

func test_adding_duplicate_does_not_affect_other_cards():
	var card_a = _make_card("Scythe")
	var card_b = _make_card("Watering Can")
	deck_builder._on_card_dropped(card_a)
	deck_builder._on_card_dropped(card_b)
	deck_builder._on_card_dropped(card_a)  # duplicate
	assert_eq(deck_builder.deck_cards.size(), 2)

# --- Removing Cards ---

func test_removing_a_card_decreases_deck_size():
	var card = _make_card("Scythe")
	deck_builder._on_card_dropped(card)
	deck_builder._on_card_removed(card)
	assert_eq(deck_builder.deck_cards.size(), 0)

func test_removing_one_card_leaves_others_intact():
	var card_a = _make_card("Scythe")
	var card_b = _make_card("Watering Can")
	deck_builder._on_card_dropped(card_a)
	deck_builder._on_card_dropped(card_b)
	deck_builder._on_card_removed(card_a)
	assert_eq(deck_builder.deck_cards.size(), 1)
	assert_eq(deck_builder.deck_cards[0], card_b)

func test_removing_a_card_not_in_deck_does_not_crash():
	var card = _make_card("Ghost Card")
	deck_builder._on_card_removed(card)  # should not crash
	assert_eq(deck_builder.deck_cards.size(), 0)

func test_removing_same_card_twice_does_not_crash():
	var card = _make_card("Scythe")
	deck_builder._on_card_dropped(card)
	deck_builder._on_card_removed(card)
	deck_builder._on_card_removed(card)  # second removal should be a no-op
	assert_eq(deck_builder.deck_cards.size(), 0)

# --- Deck State ---

func test_deck_starts_empty():
	assert_eq(deck_builder.deck_cards.size(), 0)
