extends Control

signal round_finished(points: int)

const MAX_GUESSES := 6
const ROUND_SECONDS := 180

const ANSWERS := [
	"PLANT", "CRANE", "STONE", "LIGHT", "BRAVE", "CLOUD",
	"TRAIN", "SMILE", "GRAPE", "BEACH", "BREAD", "SHEEP",
	"APPLE", "CHAIR", "DREAM", "EARTH", "FLAME", "GHOST",
	"GREEN", "HEART", "HORSE", "HOUSE", "LEMON", "MANGO",
	"MOUSE", "OCEAN", "PAINT", "PEACH", "PIANO", "PLATE",
	"POWER", "ROBOT", "SHARK", "SNAKE", "SPACE", "SPOON",
	"STORM", "SUGAR", "TABLE", "TOAST", "WATER", "WHALE",
	"WORLD", "CANDY", "CROWN", "MUSIC", "RIVER", "TIGER"
]

const EXTRA_WORDS := """
ABOUT ABOVE ABUSE ACTOR ACUTE ADAPT ADDED ADMIT ADOPT ADULT AFTER AGAIN AGENT AGILE AGREE AHEAD AISLE ALARM ALBUM ALERT ALIEN ALIKE ALIVE ALLOW ALONE ALONG ALTER AMBER AMONG ANGEL ANGER ANGLE ANGRY APART APPLY ARENA ARGUE ARISE ARMOR AROMA ASHES ASIDE ASSET ATLAS AUDIO AUDIT AVOID AWAKE AWARD AWARE AWFUL
BACON BADGE BAGEL BAKER BALMY BANJO BASIC BASIL BASIN BASIS BATCH BATHE BAZAR BEADS BEANS BEARD BEAST BEGIN BEGUN BEING BELLY BELOW BENCH BERRY BIRTH BLACK BLADE BLAME BLAND BLANK BLAST BLAZE BLEAK BLEND BLESS BLIMP BLIND BLINK BLOCK BLOOD BLOOM BLOWN BLUES BLUNT BLUSH BOARD BOAST BONUS BOOST BOOTH BOUND BOWLS BOXER BRACE BRAID BRAIN BRAKE BRAND BRASS BREAK BREED BRICK BRIDE BRIEF BRING BRISK BROAD BROWN BRUSH BUILD BUILT BUNCH BUNNY BURST BUYER
CABIN CABLE CAMEL CAMPS CANAL CANOE CAPER CARGO CARRY CARVE CATCH CAUSE CEASE CEDAR CHAIN CHALK CHAMP CHANT CHARM CHART CHASE CHEAP CHEAT CHECK CHEEK CHEER CHESS CHEST CHIEF CHILD CHILI CHILL CHIMP CHINA CHIPS CHOIR CHORD CHORE CHUNK CIDER CLAIM CLAMP CLASH CLASS CLEAN CLEAR CLERK CLICK CLIFF CLIMB CLOCK CLONE CLOSE CLOTH COACH COAST COCOA COLOR COMET COMIC CORAL COUCH COUGH COULD COUNT COURT COVER CRACK CRAFT CRAMP CRASH CRATE CRAVE CRAWL CRAZE CRAZY CREAM CREEK CREEP CREST CRIME CRISP CROAK CROPS CROSS CROWD CRUDE CRUSH CUBIC CUMIN CURVE CYCLE
DAILY DAIRY DAISY DANCE DEALT DEATH DEBUG DECAY DECOR DECOY DELAY DELTA DENSE DEPTH DEVIL DIARY DIGIT DINER DINGO DIRTY DITCH DIVER DIZZY DOCKS DODGE DONOR DONUT DOORS DOUBT DOUGH DRAFT DRAIN DRAMA DRANK DRAWN DREAD DRESS DRIED DRIFT DRILL DRINK DRIVE DROPS DROVE DROWN DRUMS DRUNK DUSKY DWARF DWELL
EAGER EAGLE EARLY EASEL EATEN EATER EBONY EIGHT ELBOW ELDER ELECT ELITE EMAIL EMBER EMPTY ENACT ENEMY ENJOY ENTER ENTRY EPOCH EQUAL EQUIP ERASE ERECT ERROR ESSAY EVENT EVERY EXACT EXCEL EXERT EXILE EXIST EXTRA
FABLE FACET FAINT FAIRY FAITH FALSE FANCY FATAL FAULT FAVOR FEAST FENCE FERAL FERRY FEVER FEWER FIBER FIELD FIERY FIFTY FIGHT FILES FINAL FINCH FIRST FIXED FIZZY FJORD FLAIR FLAKE FLANK FLARE FLASH FLASK FLEET FLESH FLICK FLING FLINT FLOAT FLOCK FLOOD FLOOR FLOSS FLOUR FLOWN FLUID FLUKE FLUSH FLUTE FOCAL FOCUS FOGGY FOLKS FORCE FORGE FORTH FORTY FORUM FOUND FRAIL FRAME FRANK FRAUD FREAK FRESH FRIED FROGS FRONT FROST FRUIT FULLY FUNNY
GAUGE GENIE GENRE GIANT GIVEN GIVES GLAND GLARE GLASS GLAZE GLEAM GLIDE GLOBE GLOOM GLORY GLOSS GLOVE GNOME GOING GOLEM GOOSE GOUGE GRACE GRADE GRAIN GRAND GRANT GRAPH GRASP GRASS GRATE GRAVE GRAVY GREAT GREED GREET GRIEF GRILL GRIME GRIND GROOM GROUP GROVE GROWN GUARD GUESS GUEST GUIDE GUILD GUILT GUMMY GUSTY
HABIT HAIRY HALVE HANDS HANDY HAPPY HARSH HASTE HASTY HATCH HAVEN HAZEL HEADS HEARD HEATH HEAVY HEDGE HEELS HEIST HELLO HENCE HERBS HIKER HILLS HINGE HIPPO HITCH HOBBY HONEY HONOR HOOPS HOTEL HOUND HOURS HUMAN HUMID HUMOR HURRY
ICING IDEAL IDEAS IDIOM IDIOT IMAGE IMPLY INDEX INDIE INERT INFER INNER INPUT INTRO IRONY ISSUE IVORY
JEANS JELLY JEWEL JOINS JOINT JOKER JOLLY JOUST JUDGE JUICE JUICY JUMBO JUMPY JUROR
KARMA KAYAK KEBAB KHAKI KIOSK KITES KNACK KNEEL KNELT KNIFE KNOCK KNOLL KNOWN KOALA
LABEL LABOR LACED LADEN LADLE LAGER LAKES LAMPS LANCE LANKY LAPEL LAPSE LARGE LASER LATCH LATER LATTE LAUGH LAYER LEACH LEAFY LEAKY LEANS LEAPT LEARN LEASE LEASH LEAST LEAVE LEDGE LEGAL LEMUR LEVER LILAC LIMBO LIMIT LINEN LINER LINES LINGO LINKS LIONS LITER LIVER LIVES LLAMA LOAMY LOANS LOBBY LOCAL LOCUS LODGE LOFTY LOGIC LONER LOOSE LOSER LOTUS LOVER LOWER LOYAL LUCID LUCKY LUMEN LUNAR LUNCH LUNGE LURCH LYRIC
MACAW MACHO MACRO MADAM MAGIC MAGMA MAJOR MAKER MAMBO MANGA MANOR MAPLE MARCH MARRY MARSH MASON MATCH MATEY MAUVE MAXIM MAYBE MAYOR MEANT MEATY MEDAL MEDIA MEDIC MELON MERCY MERGE MERIT MERRY MESSY METAL METER METRO MICRO MIDST MIGHT MILKY MIMIC MINCE MINER MINOR MINTY MINUS MIRTH MISER MISTY MIXER MOCHA MODAL MODEL MODEM MOGUL MOIST MOLAR MOLDY MONEY MONTH MOOSE MORAL MOTEL MOTOR MOTTO MOUND MOUNT MOURN MOUTH MOVER MOVIE MOWER MUDDY MURAL MUSHY MUSKY MUSTY
NAILS NANNY NASTY NATAL NAVAL NAVEL NEEDS NEEDY NEIGH NERVE NEVER NEWER NEWLY NICER NICHE NIECE NIGHT NINJA NINTH NOBLE NOISE NOISY NOMAD NORTH NOTCH NOTES NOVEL NUDGE NURSE NUTTY NYLON NYMPH
OASIS OBESE OCCUR ODDLY OFFER OFTEN OLDER OLIVE OMEGA ONION ONSET OPERA OPTIC ORBIT ORDER ORGAN OTHER OTTER OUGHT OUNCE OUTDO OUTER OVERT OWNER OXIDE OZ OZONE
PADDY PAGAN PAGER PANDA PANEL PANIC PAPER PARKS PARTY PASTA PASTE PASTY PATCH PATIO PAUSE PAYER PEACE PEARL PEARS PEDAL PENAL PENCE PENNY PERCH PERIL PESKY PESTO PETAL PETTY PHASE PHONE PHOTO PICKS PIECE PILOT PINCH PINES PINKY PINTO PIOUS PIPER PITCH PITHY PIVOT PIXEL PIZZA PLACE PLAID PLAIN PLANE PLANK PLANS PLAZA PLEAD PLEAT PLOTS PLUCK PLUMB PLUME PLUMP PLUSH POACH POEMS POETS POINT POISE POKER POLAR POLKA PONDS POOCH POPPY PORCH POSER POSSE POUCH POUND POUTY PRESS PRICE PRICK PRIDE PRIME PRINT PRIOR PRISM PRIVY PRIZE PROBE PRONE PRONG PROOF PROSE PROUD PROVE PROWL PROXY PRUNE PSALM PULSE PUNCH PUPIL PUPPY PUREE PURGE PURSE
QUACK QUAIL QUAKE QUALM QUART QUEEN QUERY QUEST QUEUE QUICK QUIET QUILT QUIRK QUITE QUOTA QUOTE
RADAR RADIO RAINY RAISE RALLY RAMEN RANCH RANGE RAPID RASPY RATIO RAVEN RAZOR REACH REACT READY REALM REBEL REBUS RECAP RECTO REDUX REEDS REEDY REFER REFIT REGAL REHAB REIGN RELAX RELAY RELIC REMIT RENAL RENEW REPAY REPEL REPLY RERUN RESET RESIN RETRO RETRY REUSE REVEL RHINO RHYME RIDER RIDGE RIFLE RIGHT RIGID RIGOR RINSE RIPEN RISKY RIVAL RIVET ROACH ROAST ROCKY RODEO ROGUE ROOMY ROOTS ROTOR ROUGE ROUGH ROUND ROUSE ROUTE ROVER ROYAL RUGBY RULER RUMBA RURAL RUSTY
SABLE SADLY SAFER SAINT SALAD SALON SALSA SALTY SANDY SANTA SAUCE SAUCY SAUNA SAVOR SCALD SCALE SCALP SCALY SCAMP SCANT SCARE SCARF SCARY SCENE SCENT SCION SCOFF SCOLD SCONE SCOOP SCOPE SCORE SCORN SCOUT SCOWL SCRAM SCRAP SCREW SCRUB SEDAN SEEDS SEEDY SEEMS SEIZE SENSE SERUM SERVE SETUP SEVEN SEVER SHADE SHADY SHAFT SHAKE SHAKY SHALL SHALT SHAME SHANK SHAPE SHARD SHARE SHARP SHAVE SHAWL SHEAR SHEDS SHEEN SHEER SHEET SHELF SHELL SHIFT SHINE SHINY SHIRE SHIRT SHOAL SHOCK SHOES SHONE SHOOK SHOOT SHOPS SHORE SHORT SHOTS SHOUT SHOVE SHOWN SHOWY SHRUB SHRUG SIEGE SIGHT SIGMA SILKY SILLY SINCE SINEW SINGE SIREN SIXTH SIXTY SKATE SKIER SKIFF SKILL SKIMP SKIRT SKULL SKUNK SLACK SLAIN SLANG SLANT SLASH SLATE SLAVE SLEEK SLEEP SLEET SLEPT SLICE SLICK SLIDE SLIME SLIMY SLING SLINK SLOPE SLOTH SLUMP SLUNG SMALL SMART SMASH SMEAR SMELL SMELT SMIRK SMITE SMOCK SMOKE SMOKY SNACK SNAIL SNARE SNARL SNEAK SNEER SNIDE SNIFF SNIPE SNOOP SNORE SNORT SNOUT SNOWY SOBER SOCKS SOLAR SOLID SOLVE SONAR SONIC SORRY SOUND SOUTH SOWER SPACK SPACY SPADE SPARE SPARK SPASM SPAWN SPEAK SPEAR SPECK SPEED SPELL SPELT SPEND SPENT SPICE SPICY SPIED SPIEL SPIKE SPIKY SPILL SPILT SPINE SPINY SPIRE SPITE SPLAT SPLIT SPOIL SPOKE SPOOF SPOOK SPOOL SPORE SPORT SPOUT SPRAY SPREE SPRIG SPUNK SPURN SPURT SQUAD SQUAT SQUID STACK STAFF STAGE STAID STAIN STAIR STAKE STALE STALK STALL STAMP STAND STANK STARE STARK START STASH STATE STAVE STEAD STEAK STEAL STEAM STEED STEEL STEEP STEER STEMS STERN STICK STIFF STILL STILT STING STINK STINT STOCK STOIC STOKE STOLE STOMP STONY STOOD STOOL STOOP STORE STORK STORY STOUT STOVE STRAP STRAW STRAY STRIP STRUT STUCK STUDY STUFF STUMP STUNG STUNK STUNT STYLE SUAVE SUEDE SUITE SULKY SULLY SUNNY SUPER SURER SURGE SURLY SUSHI SWAMP SWARM SWASH SWATH SWEAR SWEAT SWEEP SWEET SWELL SWEPT SWIFT SWILL SWINE SWING SWIPE SWIRL SWISH SWOON SWOOP SWORD SWORE SWORN SWUNG SYRUP
TABBY TABOO TACIT TACKY TAFFY TAINT TAKEN TAKER TALES TALLY TALON TANGO TANGY TAPER TAPIR TARDY TAROT TASTE TASTY TATTY TAUNT TAWNY TEACH TEARY TEASE TEDDY TEETH TEMPO TENET TENOR TENSE TENTH TEPEE TERRA TERSE TESTY THANK THEFT THEIR THEME THERE THESE THICK THIEF THIGH THING THINK THIRD THORN THOSE THREE THREW THROB THROW THUMB THUMP THYME TIARA TIBIA TIDAL TIGHT TILDE TIMER TIMID TIPSY TIRED TITAN TITLE TODAY TODDY TOKEN TONAL TONGS TONIC TOOTH TOPAZ TOPIC TORCH TORSO TOTAL TOTEM TOUCH TOUGH TOWEL TOWER TOXIC TOXIN TRACE TRACK TRACT TRADE TRAIL TRAIT TRAMP TRASH TRAWL TREAD TREAT TREES TREND TRIAD TRIAL TRIBE TRICE TRICK TRIED TRIPE TRITE TROLL TROOP TROPE TROUT TROVE TRUCE TRUCK TRULY TRUMP TRUNK TRUSS TRUST TRUTH TRYST TUBAL TUBER TULIP TULLE TUMOR TUNIC TURBO TUTOR TWANG TWEAK TWEED TWEET TWICE TWINE TWIRL TWIST TYING
ULCER ULTRA UMBRA UNCLE UNCUT UNDER UNDID UNDUE UNFED UNFIT UNIFY UNION UNITY UNLIT UNMET UNSET UNTIE UNTIL UNWED UNZIP UPPER UPSET URBAN URGED URINE USAGE USHER USING USUAL UTTER
VAGUE VALET VALID VALOR VALUE VALVE VAPID VAPOR VAULT VAUNT VEGAN VENOM VENTI VENUE VERGE VERSE VERVE VICAR VIDEO VIGIL VILLA VINYL VIOLA VIPER VIRAL VIRUS VISIT VISOR VISTA VITAL VIVID VIXEN VOCAL VODKA VOGUE VOICE VOILA VOMIT VOTER VOUCH VOWEL
WACKY WAFER WAGER WAGON WAIST WAIVE WALTZ WARTY WASTE WATCH WAXEN WEARY WEAVE WEDGE WEEDY WEIGH WEIRD WELCH WELSH WHACK WHARF WHEAT WHEEL WHELP WHERE WHICH WHIFF WHILE WHINE WHINY WHIRL WHISK WHITE WHOLE WHOOP WHOSE WIDEN WIDER WIDOW WIDTH WIELD WIGHT WILLY WIMPY WINCE WINCH WINDY WISER WISPY WITCH WITTY WOKEN WOMAN WOMEN WOODY WOOER WOOLY WOOZY WORDY WORKS WORRY WORSE WORST WORTH WOULD WOUND WOVEN WRACK WRATH WREAK WRECK WREST WRING WRIST WRONG WROTE WRUNG WRYLY
YACHT YEARN YEAST YIELD YODEL YOUNG YOURS YOUTH ZEBRA ZESTY ZONAL
"""

const KEY_ROWS := ["QWERTYUIOP", "ASDFGHJKL", "ZXCVBNM"]
const KEY_COLORS := [
	Color("#26344e"), # Unused
	Color("#434b59"), # Absent
	Color("#805708"), # Misplaced
	Color("#176247")  # Exact
]
const KEY_STATUS := ["Unused", "Absent", "Misplaced", "Exact match"]

var accepted_words: Dictionary = {}
var secret_word := ""
var attempts := 0
var seconds_left := ROUND_SECONDS
var playing := false

var clock_label := Label.new()
var status := Label.new()
var guess_box := LineEdit.new()
var submit_button := Button.new()
var replay_button := Button.new()
var timer := Timer.new()

var tiles: Array[PanelContainer] = []
var letters: Array[Label] = []
var key_buttons: Dictionary = {}
var key_ranks: Dictionary = {}
var keyboard_actions: Array[Button] = []


func _ready() -> void:
	for word in ANSWERS:
		accepted_words[word] = true
	for word in EXTRA_WORDS.replace("\n", " ").split(" ", false):
		if word.length() == 5:
			accepted_words[word] = true

	var center := CenterContainer.new()
	add_child(center)
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var layout := VBoxContainer.new()
	layout.custom_minimum_size.x = 340
	layout.add_theme_constant_override("separation", 8)
	center.add_child(layout)

	var title := Label.new()
	title.text = "Word Race"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 30)
	layout.add_child(title)

	clock_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	layout.add_child(clock_label)

	var grid_center := CenterContainer.new()
	layout.add_child(grid_center)

	var grid := GridContainer.new()
	grid.columns = 5
	grid.add_theme_constant_override("h_separation", 5)
	grid.add_theme_constant_override("v_separation", 5)
	grid_center.add_child(grid)

	for i in range(MAX_GUESSES * 5):
		var tile := PanelContainer.new()
		tile.custom_minimum_size = Vector2(44, 36)
		grid.add_child(tile)
		tiles.append(tile)

		var letter := Label.new()
		letter.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		letter.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		letter.add_theme_font_size_override("font_size", 22)
		letter.add_theme_color_override("font_color", Color.WHITE)
		tile.add_child(letter)
		letters.append(letter)

	var legend := Label.new()
	legend.text = "Green: exact  ·  Yellow: misplaced  ·  Gray: absent"
	legend.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	legend.add_theme_font_size_override("font_size", 13)
	layout.add_child(legend)

	status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	layout.add_child(status)

	guess_box.placeholder_text = "Type a five-letter word"
	guess_box.custom_minimum_size.y = 36
	guess_box.text_submitted.connect(_submit_guess)
	layout.add_child(guess_box)

	_build_keyboard(layout)

	submit_button.text = "Submit Guess"
	submit_button.custom_minimum_size.y = 38
	submit_button.pressed.connect(_submit_current_guess)
	layout.add_child(submit_button)

	replay_button.text = "Play Again"
	replay_button.custom_minimum_size.y = 38
	replay_button.pressed.connect(_start_round)
	layout.add_child(replay_button)

	timer.wait_time = 1.0
	timer.timeout.connect(_tick)
	add_child(timer)

	_start_round()


func _build_keyboard(layout: VBoxContainer) -> void:
	var keyboard := VBoxContainer.new()
	keyboard.add_theme_constant_override("separation", 4)
	layout.add_child(keyboard)

	for keys in KEY_ROWS:
		var row := HBoxContainer.new()
		row.alignment = BoxContainer.ALIGNMENT_CENTER
		row.add_theme_constant_override("separation", 4)
		keyboard.add_child(row)

		for letter in keys:
			var key := Button.new()
			key.text = letter
			key.custom_minimum_size = Vector2(28, 34)
			key.focus_mode = Control.FOCUS_NONE
			key.pressed.connect(_type_letter.bind(letter))
			row.add_child(key)
			key_buttons[letter] = key

		if keys == "ZXCVBNM":
			var backspace := Button.new()
			backspace.text = "⌫"
			backspace.tooltip_text = "Delete last letter"
			backspace.custom_minimum_size.y = 34
			backspace.focus_mode = Control.FOCUS_NONE
			backspace.pressed.connect(_delete_letter)
			row.add_child(backspace)
			keyboard_actions.append(backspace)

			var enter := Button.new()
			enter.text = "Enter"
			enter.custom_minimum_size.y = 34
			enter.focus_mode = Control.FOCUS_NONE
			enter.pressed.connect(_submit_current_guess)
			row.add_child(enter)
			keyboard_actions.append(enter)


func _start_round() -> void:
	var choices: Array = ANSWERS.duplicate()
	choices.erase(secret_word)
	secret_word = choices.pick_random()
	attempts = 0
	seconds_left = ROUND_SECONDS
	playing = true

	for i in range(tiles.size()):
		_set_tile(i, "", 0)

	key_ranks.clear()
	for letter in key_buttons:
		var key: Button = key_buttons[letter]
		key.disabled = false
		_paint_key(letter, 0)

	for button in keyboard_actions:
		button.disabled = false

	status.text = "Guess the word in six tries."
	guess_box.clear()
	guess_box.show()
	submit_button.show()
	replay_button.hide()
	_update_clock()
	timer.start()
	guess_box.grab_focus()


func _type_letter(letter: String) -> void:
	if playing and guess_box.text.length() < 5:
		guess_box.text += letter
		guess_box.caret_column = guess_box.text.length()
		guess_box.grab_focus()


func _delete_letter() -> void:
	if playing and not guess_box.text.is_empty():
		guess_box.text = guess_box.text.left(guess_box.text.length() - 1)
		guess_box.caret_column = guess_box.text.length()
		guess_box.grab_focus()


func _submit_current_guess() -> void:
	_submit_guess(guess_box.text)


func _submit_guess(raw_guess: String) -> void:
	if not playing:
		return

	var guess := raw_guess.strip_edges().to_upper()
	if guess.length() != 5:
		status.text = "Enter exactly five letters."
		guess_box.grab_focus()
		return

	if not accepted_words.has(guess):
		status.text = "That word isn’t in the word bank."
		guess_box.grab_focus()
		guess_box.select_all()
		return

	_show_feedback(guess)
	attempts += 1
	guess_box.clear()

	if guess == secret_word:
		var points := 100 - (attempts - 1) * 10
		_finish_round("Solved in %d of %d tries!" % [attempts, MAX_GUESSES], points)
	elif attempts == MAX_GUESSES:
		_finish_round("The word was %s." % secret_word, 0)
	else:
		status.text = "Guesses left: %d" % (MAX_GUESSES - attempts)
		guess_box.grab_focus()


func _show_feedback(guess: String) -> void:
	var ranks: Array[int] = [1, 1, 1, 1, 1]
	var remaining: Dictionary = {}

	# Mark exact matches before counting misplaced letters.
	for i in range(5):
		if guess[i] == secret_word[i]:
			ranks[i] = 3
		else:
			var letter := secret_word[i]
			remaining[letter] = int(remaining.get(letter, 0)) + 1

	for i in range(5):
		var letter := guess[i]
		var copies := int(remaining.get(letter, 0))
		if ranks[i] != 3 and copies > 0:
			ranks[i] = 2
			remaining[letter] = copies - 1

	for i in range(5):
		_set_tile(attempts * 5 + i, guess[i], ranks[i])
		_paint_key(guess[i], ranks[i])


func _set_tile(index: int, letter: String, rank: int) -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = KEY_COLORS[rank]
	style.set_corner_radius_all(6)
	tiles[index].add_theme_stylebox_override("panel", style)
	letters[index].text = letter
	tiles[index].tooltip_text = "" if letter.is_empty() else KEY_STATUS[rank]


func _paint_key(letter: String, rank: int) -> void:
	var best_rank := maxi(rank, int(key_ranks.get(letter, 0)))
	key_ranks[letter] = best_rank

	var key: Button = key_buttons[letter]
	key.tooltip_text = KEY_STATUS[best_rank]
	key.add_theme_color_override("font_disabled_color", Color.WHITE)

	var style := StyleBoxFlat.new()
	style.bg_color = KEY_COLORS[best_rank]
	style.set_corner_radius_all(5)
	key.add_theme_stylebox_override("normal", style)
	key.add_theme_stylebox_override("disabled", style)

	var hover := style.duplicate() as StyleBoxFlat
	hover.bg_color = style.bg_color.lightened(0.12)
	key.add_theme_stylebox_override("hover", hover)
	key.add_theme_stylebox_override("pressed", hover)


func _tick() -> void:
	seconds_left -= 1
	_update_clock()
	if seconds_left <= 0:
		_finish_round("Time’s up! The word was %s." % secret_word, 0)


func _update_clock() -> void:
	var minutes := floori(seconds_left / 60.0)
	clock_label.text = "Time left  %d:%02d" % [minutes, seconds_left % 60]


func _finish_round(message: String, points: int) -> void:
	playing = false
	timer.stop()
	status.text = "%s  Score: %d" % [message, points]

	for letter in key_buttons:
		var key: Button = key_buttons[letter]
		key.disabled = true

	for button in keyboard_actions:
		button.disabled = true

	guess_box.hide()
	submit_button.hide()
	replay_button.show()
	replay_button.grab_focus()
	round_finished.emit(points)
