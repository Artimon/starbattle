///////////////////////////////////////////////////////
// MORPG-Battle

// New enemy:
// class sting and class string array
// enemy _num_x
// experience
// create_enemy() ent_create and spell action
// set_stats()

// for slime names: Muck (Dung/ Fraﬂ); Pudding; Gel Fish; Ice Flan (Torte); Cream; Scum (Abschaum)

savedir "characters";
path "files";

function character_selection(val);
function toggle_character(button_number);
function load_character(&skillvar);
function create_player(character_offset);
function action_input(button_number, panel_ptr);
function back_input();
function hide_action_text();
function show_action_text(button_number, panel_ptr);
function action_input_options(val);
function activate_nosend(entptr);
function set_stats(heal);
function right_direction();
function rel_dist(&vec_1, &vec_2);
function enemy_spawn();
function create_enemy(ID);
function create_arrow(ent_ptr_1, ent_ptr_2);
function transfer_text();
function avatar_counting();
function IIf(expression, truepart, falsepart);
function server_ip_input();
function toggle_netstats();
function gain_exp(_num_killed);
function object_to_camera(entptr, dist);
function action_place(button_number, panel_ptr);
function shadowsprite();
function nextWeapon();
function nextArmor();
function buyWeapon();
function buyArmor();
function openLevelSelect();
function selectForest();
function selectWaterfall();
function selectFrostfield();
function selectValleyofthedead();
function selectAncientforest();
function writeLevelText(buttonID, panelptr);
function clearLevelText();
function playNAsound();
function writeNAText();


var video_mode   =  8;
var video_depth  = 16;
var video_screen =  1;

var TEMPs;

var current_player[4];	// Slots to store the online players
var pos_target;
var camera_angle;
var Camtramble;
var Camquake;
var Serverlogout;
var Clientlogout;

var enemies[5];	// The current number of enemies, waves ect.
var button_block;	// blocking command inputs when over buttons
var avatar_counter;
var AoE_Position;

// Trade values
var weaponPrices[5] = 200, 1600, 4200, 7500, 13000;
var weaponLevels[5] = 3, 6, 9, 12, 15;
var weaponpDam[4] = 40, 40, 20, 15;	// Weapon basic values for all player classes
var weaponmDam[4] =  0, 30, 35, 40;
var armorPrices[5] = 100, 1200, 3500, 6500, 11000;
var armorLevels[5] = 2, 5, 8, 11, 14;
var armorpDef[4] = 15, 10, 10,  5;	// Armor basic values for all player classes
var armormDef[4] =  0,  5, 10, 20;

var net_transfer;		// I want to see, how many Bytes I'm sending... ;-)
var Level_ID;	// Needed for level change
var Level_Select;	// Stops animate functinons during shopping/ level selection
var fatal;	// all players defeated
var _ignore_sprites;	// optional scan
var _ID_for_message;	// ID for the animated messages

var freeze_game;
var pause_request;
var cleared_levels[9];
var text_toggle;
var load_character_level;

var bgm;

bmap mouse = <mouse.bmp>;
bmap mousena = <mousena.bmp>;

sound selection1 = <selection1.wav>;
sound selection3 = <selection3.wav>;
sound BBB_Sword = <BBB_Sword~.wav>;
sound rack = <rack.wav>;
sound BBB_zaubern2 = <BBB_zaubern2.wav>;
sound BBB_charge = <BBB_charge~.wav>;
sound water = <water.wav>;
sound heal = <heal.wav>;
sound holylight = <light.wav>;
sound bolt = <bolt.wav>;
sound earthspell = <earth.wav>;
sound enemy_die = <enemy_die.wav>;
sound charge_enemy = <charge_enemy.wav>;
sound victory = <victory.wav>;
sound charsel = <charsel.wav>;
sound startup = <startup.wav>;
sound newlevel = <newlevel.wav>;
sound hugefire = <hugefire.wav>;
sound explo = <explo.wav>;
sound buy_no = <buy_no.wav>;
sound buy_ok = <buy_ok.wav>;
sound chaos = <chaos.wav>;
sound MM_Ende = <MM_Ende.wav>;
sound earthquake = <earthquake.wav>;
sound daggro = <aggro.wav>;
sound rage = <rage.wav>;
sound summonevil = <summonevil.wav>;
sound summongood = <summongood.wav>;
sound thorns = <thorns.wav>;

string TEMP_STRING;
string str_save_file;

string class_knight = "Knight";
string class_archer = "Archer";
string class_priest = "Priest";
string class_wizard = "Wizard";
string class_slime = "Slime";
string class_raptor = "Raptor";
string class_allosaur = "Allosaur";
string class_decay_jelly = "Decay Jelly";
string class_dragon = "Dragon";
string class_oktion = "Oktion";
string class_old_spirit = "Old Spirit";
string class_frost_ooze = "Frost Ooze";
string class_blue_dragon = "Blue Dragon";
string class_cold_jelli = "Cold Jelli";
string class_wraith = "Wraith";
string class_beholder_twins1 = "Beholder Twins";
string class_beholder_twins2 = "Beholder Twins";
string class_skeleton = "Skeleton";
string class_skeleton_poleman = "Skeleton Poleman";
string class_dark_galert = "Dark Galert";
string class_samurai_zombie = "Samurai Zombie";
string class_little_death = "Little Death";
string class_doom_dragon = "Doom Dragon";
string class_ghost_lord = "Ghost Lord";
string class_battle_lord = "Battle Lord";
string class_evil_spirit = "Evil Spirit";
string class_green_wizard = "Green Wizard";
string class_ice_frog = "Ice Frog";
string class_viscous_slime = "Viscous Slime";
string class_succubus_twins1 = "Succubus Twins";
string class_succubus_twins2 = "Succubus Twins";
string class_risen_muck = "Risen Muck";
string class_the_ring = "The Ring";
string class_acid_flan = "Acid Flan";
string class_blood_rex = "Blood Rex";
string class_white_dragon = "White Dragon";
string class_abyss_mage = "Abyss Mage";
string class_doppelganger1 = "Doppelganger";
string class_doppelganger2 = "Doppelganger";
string class_blood_pudding = "Blood Pudding";
string class_blade_demon = "Blade Demon";
string class_phoenix_dragon = "Phoenix Dragon";
string class_dawn_of_souls = "Dawn of Souls";
string class_elder_ghost = "Elder Ghost";
string class_damned_sorcerer = "Damned Sorcerer";
string class_zombie_witch = "Zombie Witch";
string class_valkyrie = "Valkyrie";
string class_zombie_dragon = "Zombie Dragon";


string player_1_desc = ":\n- Good defence and physical damage.\n- Battle skills.";
string player_2_desc = ":\n- Moderate defence and phys./ magic. damage.\n- Support and attack skills.";
string player_3_desc = ":\n- Low defence and good magical damage.\n- Support and battle skills.";
string player_4_desc = ":\n- Weak defence and high magical damage.\n- Attack skills.";
//string player_name_to_server[50];	// We use this one to send the name to the server

string weapon1;
string weapon2;
string weapon3;
string weapon4;
string weapon5;
string armor1;
string armor2;
string armor3;
string armor4;
string armor5;

string show_actor_string;
string show_netstats;

string show_WeaponText_string;
string show_ArmorText_string;

string animated_message;	// shows animated messages

entity* _mouse_ent;		// The entity hit by the c_trace in the mouse_toggle function
entity* _cam_target;		// The camera follows this entity
entity* _action_circle;	// show the circle within which actions can be performed
entity* victim;	// pointer for the spell effects
entity* TEMP_ENT;
entity* BOSS_PTR;
panel* _temp_panel;

define _Str,				skill1;	// Strength; physical damage
define _Dex,				skill2;	// Dexterity; hit chance/ critical
define _Agi,				skill3;	// Agility; action bar speed/ counter chance 25%
define _Vit,				skill4;	// Vitality; health
define _Int,				skill5;	// Intelligence; mana
define _Wis,				skill6;	// Wisdom; magical damage
define _HP,					skill7;	// actual health
define _MP,					skill8;	// actual mana

// Define an actor by it's class and ID
define _Actor_class, 	skill9;	// ¥Knight¥, ¥Priest¥, ¥Skeleton¥, ect.
define _Actor_ID, 		skill10;	// _ID_Player or _ID_Enemy

define _pdam,				skill11;	// physical damage
define _mdam,				skill12;	// magical damage

define _pdef,				skill13;	// physical defence
define _mdef,				skill14;	// magical defence

define _action_timer,	skill15;	// When the timer reaches 0 we can give commands

// We'll try to control the game by sending and _Action_ID (like ¥Attack¥) and a handle to an entity. This will be interpreted like "Attack this entity" on the local clients.
define _Action_target_X,skill16;
define _Action_target_Y,skill17;
define _Action_target_Z,skill18;
define _Action_handle,	skill19;
define _Action_ID,		skill20;

// Clients send action requests to the server which copies the values to the real action skills and sends it to the clients for execution
define _ActReq_handle,	skill21;
define _ActReq_ID,		skill22;

// We'll use this to corret position differences between server and clients from time to time.
define _pos_X,				skill23;
define _pos_Y,				skill24;
define _pos_Z,				skill25;

define _Action_msg,		skill26;	// Action text ID for "Miss!" or "Counter!"
define _Action_spell,	skill27;	// We'll store the spell-ID here
define _Action_HP,		skill28;	// Make damage/ heal numbers visible
define _Action_MP,		skill29;	// Make mana regeneration numbers visible

// State machine (DEA)
define _last_action,		skill30;	// Used to stor the last action for resetting the animation sequence
define _action,			skill31;
define _speed,				skill32;
define _angle,				skill33;
define _anime,				skill34;
define _player_number,	skill35;

define _temp_dmg,			skill37;
define _temp,				skill38;
define _cast_active,		skill39;
define _counter_active,	skill40;
define _reset_timer,		skill41;	// skills 41 to 44 also used by the terrain shader

define _weakness,			skill42;
define _you_save,			skill50;
define _avatar_ID,		skill51;

define _kills,				skill52;
define _buff_Str,			skill53;	// buff that increases Str (Battle Rage)
define _buff_Dex,			skill54;	// buff that increases Dex (Battle Rage)
define _buff_Agi,			skill55;	// buff that increases Agi
define _buff_mpdef,		skill56;	// buff that increases defence

define _input_state,		skill57;

define _ActReq_counter,	skill58;	// Store counter requests that can not be performed yet

define _Level,				skill59;
define _LevelUp,			skill60;
define _exp,				skill61;

define _timer_agi,		skill62;
define _timer_mpdef,		skill63;
define _timer_battlerage,	skill64;
define _timer_drawaggro,skill65;
define _timer_revengeleap,	skill66;
define _timer_thornaura,	skill67;
define _timer_transform,	skill68;

define _Aggro,				skill69;
define _dist_or_aggro,	skill70;
define _Actor_pretransform,	skill71;

define _emote_req,		skill80;
define _emote_timer,		skill81;

define _gold,				skill82;
define _SpReq_ID,			skill83;
define _Spell_ID,			skill84;

define _Boss,	flag1;
define _morphed, flag2;
define _doubled, flag3;

define _state_disabled,	0;
define _state_select,	1;
define _state_confirm,	2;

// _Actor_ID defintitions
define _ID_Undefined, 0;	// For detecting objects that have to be ignored
define _ID_Player,    1;
define _ID_Enemy,     2;

define _action_stand,	10;	// default action
define _action_jump,		20;	// move to a sposition
define _action_attack,	30;	// perform an attack
define _action_counter,	40;	// counter attack, starts _action_jump and _action_attack
define _action_regena,	50;	// regenerate: HP-ID 0.1; MP-ID 0.2
define _action_cast,		60;	// cast a spell, fractionals define the spell
define _action_pain,		70;	// being hit
define _action_die,		80;	// actor dies
define _action_dead,		90;	// end state of _action_die

define _action_time,		80;	// 5 seconds

define _action_range,	256;	// Actors can only do things within that range
define _level_size,		768;

define _msg_miss,			  1;
define _msg_counter,		  2;
define _msg_critical,	  3;
define _msg_mpdef_up,	  4;
define _msg_mpdef_dn,	  5;
define _msg_agi_up,		  6;
define _msg_agi_dn,		  7;
define _msg_battlerage,	  8;
define _msg_drawaggro,	  9;
define _msg_revengeleap, 10;
define _msg_thorns,		 11;
define _msg_raisebuffs,  12;
define _msg_levelup,     13;
define _msg_formreturned,14;
define _msg_valkmight,   15;
define _msg_thornaura,   16;
define _msg_revleap,     17;
define _msg_drawaggro,   18;
define _msg_battlerage,  19;

define _num_knight,		 0;
define _num_archer,		 1;
define _num_priest,		 2;
define _num_wizard,		 3;
define _num_slime,		 4;
define _num_raptor,		 5;
define _num_allosaur,	 6;
define _num_decay_jelly, 7;
define _num_dragon,      8;
define _num_oktion,      9;
define _num_old_spirit,	10;
define _num_frost_ooze, 11;
define _num_blue_dragon,12;
define _num_cold_jelli,	13;
define _num_wraith,		14;
define _num_beholder_twins1, 15;
define _num_beholder_twins2, 16;
define _num_skeleton,	     17;
define _num_skeleton_poleman,18;
define _num_dark_galert,     19;
define _num_samurai_zombie,  20;
define _num_little_death,	  21;
define _num_doom_dragon,	  22;
define _num_ghost_lord,		  23;
define _num_battle_lord,	  24;
define _num_evil_spirit,     25;
define _num_green_wizard,    26;
define _num_ice_frog,        27;
define _num_viscous_slime,   28;
define _num_succubus_twins1, 29;
define _num_succubus_twins2, 30;
define _num_risen_muck,      31;
define _num_the_ring,        32;
define _num_acid_flan,       33;
define _num_blood_rex,       34;
define _num_white_dragon,    35;
define _num_abyss_mage,      36;
define _num_doppelganger1,   37;
define _num_doppelganger2,   38;
define _num_blood_pudding,   39;
define _num_blade_demon,     40;
define _num_phoenix_dragon,  41;
define _num_dawn_of_souls,   42;
define _num_elder_ghost,     43;
define _num_damned_sorcerer, 44;
define _num_zombie_witch,    45;
define _num_valkyrie,        46;
define _num_zombie_dragon,   47;


var enemy_exp[48] = 0, 0, 0, 0, 15, 20, 30, 25, 35, 30, 100, 30, 40, 35, 35, 150, 150, 30, 35, 35, 40, 35, 45, 450, 0, 120, 25, 40, 20, 350, 350, 45, 50, 30, 45, 150, 35, 200, 200, 10, 25, 40, 300, 35, 30, 40, 0, 550;

// Zauber
define _mp_heal,			5;	// ID 1
define _mp_light,			6;	// ID 2
define _mp_ice,			6;	// ID 3
define _mp_lightning,	8;	// ID 4
define _mp_earth,       7;	// ID 5
define _mp_mpdef,      25;	// ID 6
define _mp_agi,        25; // ID 7
define _mp_fire,       24;	// ID 8
define _mp_explodingarrow, 10;	// ID 9
define _mp_laserinferno,   10;	// ID 10
define _mp_summonice,   8;	// ID 11
define _mp_meteor,	   6;	// ID 12
define _mp_firerain,		7;	// ID 13
define _mp_earthquake, 80;	// ID 14
define _mp_summongaja, 40;	// ID 15

// Elemente
define _light, 2;
define _ice,	3;
define _lightning,	4;
define _earth,	5;
define _fire,	8;

// Regena
define _mp_callskeleton,    5;	// ID 5 Call Skeleton
define _mp_callbattlelord, 75;	// ID 6 Call Battle Lord
define _mp_revengeleap,	-800;		// ID 7 Revenge Leap
define _mp_drawaggro,	-480;		// ID 8 Draw Aggro
define _mp_battlerage,	-1920;	// ID 9 Battel Rage
define _mp_callbloodpudding,5;	// ID 10 Call Blood Pudding
define _mp_thornaura,	-960;		// ID 11 Thorn aura
define _mp_selftransform,	20;	// ID 12 Self Transform
define _mp_firestorm,		15;	// ID 13 Fire Storm
define _mp_raisebuffs,		50;	// ID 14 Raise Buffs

define _Level_Forest,	1;
define _Level_Snow,		2;
define _Level_Rocks,		3;

define _lvl_Forest,				0;
define _lvl_Waterfall,			1;
define _lvl_Frostfield,			2;
define _lvl_Valleyofthedead,	3;
define _lvl_Ancientforest,		4;
define _lvl_Lostforest,			5;

// Animation frames:
// 1 stand
// 2-3 jump
// 4 pain
// 5-7 die; 7 dead
// 8-11 attack


include <mp3.wdl>;
include <music.wdl>;
include <energy.wdl>;	// Include the spell effect functions, they're just a collection of functions, ent_createlocal and effect_local, nothing with multiplayer code.
include <blendmapping.wdl>;


sky background_forest
{ 		
	type = <bg_forest.bmp>;
	layer = 3;
	scale_x = 0.08;
	tilt = -20;
	flags = scene, visible;
}
sky background_snow
{ 		
	type = <bg_snow.bmp>;
	layer = 3;
	scale_x = 0.08;
	tilt = -20;
	flags = scene;
}
sky background_rocks
{ 		
	type = <bg_rocks.bmp>;
	layer = 3;
	scale_x = 0.08;
	tilt = -20;
	flags = scene;
}

///////////////////////////////////////////////////////
// String arrays

// Actor classes
text actor_class {
	strings = 48;
	string =
		class_knight,
		class_archer,
		class_priest,
		class_wizard,
		class_slime,
		class_raptor,
		class_allosaur,
		class_decay_jelly,
		class_dragon,
		class_oktion,
		class_old_spirit,
		class_frost_ooze,
		class_blue_dragon,
		class_cold_jelli,
		class_wraith,
		class_beholder_twins1,
		class_beholder_twins2,
		class_skeleton,
		class_skeleton_poleman,
		class_dark_galert,
		class_samurai_zombie,
		class_little_death,
		class_doom_dragon,
		class_ghost_lord,
		class_battle_lord,
		class_evil_spirit,
		class_green_wizard,
		class_ice_frog,
		class_viscous_slime,
		class_succubus_twins1,
		class_succubus_twins2,
		class_risen_muck,
		class_the_ring,
		class_acid_flan,
		class_blood_rex,
		class_white_dragon,
		class_abyss_mage,
		class_doppelganger1,
		class_doppelganger2,
		class_blood_pudding,
		class_blade_demon,
		class_phoenix_dragon,
		class_dawn_of_souls,
		class_elder_ghost,
		class_damned_sorcerer,
		class_zombie_witch,
		class_valkyrie
		class_zombie_dragon;
}


// Player names
text player_description {
	strings = 4;
	string =
		player_1_desc,
		player_2_desc,
		player_3_desc,
		player_4_desc;
}

text weapon_names {
	strings = 5;
	string =
		weapon1,
		weapon2,
		weapon3,
		weapon4,
		weapon5;
}
text armor_names {
	strings = 5;
	string =
		armor1,
		armor2,
		armor3,
		armor4,
		armor5;
}

///////////////////////////////////////////////////////
// Character selection panel
var character_offset;
bmap character_pics = <character_pics.bmp>;
//bmap next_character = <next_character.bmp>;
//bmap take_character = <take_character.bmp>;
bmap show_emote = <show_emote.bmp>;
font arial_font = "Arial", 1, 16;

//panel characters {
//	pos_x = 462;
//	pos_y =  64;
//	button = 0, 110, next_character, next_character, next_character, toggle_character, NULL, NULL;
//	button = 0, 144, take_character, take_character, take_character, toggle_character, NULL, NULL;
//	window = 0,   0, 100, 100, character_pics, character_offset[2], NULL;
//	flags = overlay;
//	layer = 100;
//}

text action_text {
	pos_x = 512;
	pos_y = 32;
	font = arial_font;
	layer = 100;
	flags = center_x, shadow;
}

text pause_text
{
	pos_x = 512;
	pos_y = 192;
	font = arial_font;
	string = "Pause";
	layer = 101;
	flags = center_x, shadow;
}
panel emoteicons {
	pos_x = 299;
	pos_y =  16;
	bmap show_emote;
	flags = overlay;
	layer = 50;
}


///////////////////////////////////////////////////////
// Title screens

bmap gs_logo       = <gs_logo.bmp>;
bmap sb_characters = <sb_characters.bmp>;
bmap sb_background = <sb_background.bmp>;

panel title_gs_logo {
	bmap = gs_logo;
	scale_x = 2;
	scale_y = 2;
	layer = 5;
	flags = visible, d3d;
}
panel title_characters {
	bmap = sb_characters;
	scale_x = 2;
	scale_y = 2;
	layer = 7;
	flags = overlay, d3d;
}
panel title_background {
	bmap = sb_background;
	scale_x = 2;
	scale_y = 2;
	layer = 6;
	flags = d3d;
}


///////////////////////////////////////////////////////
// Trade window

font arial_dialog = "Arial", 1, 24;
string dialog_text;
bmap dialogbox = <dialogbox.bmp>;
bmap dialoginfo = <dialoginfo.bmp>;
bmap dialogbutton = <dialogbutton.bmp>;

bmap wood_bg   = <wood_bg.bmp>;
bmap forest_img    = <forest_img.bmp>;
bmap forest_img_na = <forest_img_na.bmp>;
bmap waterfall_img    = <waterfall_img.bmp>;
bmap waterfall_img_na = <waterfall_img_na.bmp>;
bmap frostfield_img    = <frostfield_img.bmp>;
bmap frostfield_img_na = <frostfield_img_na.bmp>;
bmap valleyofthedead_img    = <valleyofthedead_img.bmp>;
bmap valleyofthedead_img_na = <valleyofthedead_img_na.bmp>;
bmap ancientforest_img    = <ancientforest_img.bmp>;
bmap ancientforest_img_na = <ancientforest_img_na.bmp>;
bmap lostforest_img    = <lostforest_img.bmp>;
bmap lostforest_img_na = <lostforest_img_na.bmp>;

//bmap knight_dial = <knight_dial.bmp>;
//bmap archer_dial = <archer_dial.bmp>;
//bmap priest_dial = <priest_dial.bmp>;
//bmap wizard_dial = <wizard_dial.bmp>;

bmap swords = <swords.bmp>;
bmap bows   = <bows.bmp>;
bmap wands  = <wands.bmp>;
bmap spears = <spears.bmp>;
bmap heavy_armor  = <heavy_armor.bmp>;
bmap light_armor  = <light_armor.bmp>;
bmap priest_robes = <priest_robes.bmp>;
bmap wizard_robes = <wizard_robes.bmp>;

panel* weapon_panel;
panel* armor_panel;

var TradeOffset[4];

panel show_wood_bg {
	scale_x = 2;
	scale_y = 2;
	bmap = wood_bg;
	layer = 99;
}

panel show_na_places {
	button =  58,  64, forest_img_na, forest_img_na, forest_img_na, playNAsound, clearLevelText, writeNAText;
	button = 380,  64, waterfall_img_na, waterfall_img_na, waterfall_img_na, playNAsound, clearLevelText, writeNAText;
	button = 702,  64, frostfield_img_na, frostfield_img_na, frostfield_img_na, playNAsound, clearLevelText, writeNAText;
	button =  58, 306, valleyofthedead_img_na, valleyofthedead_img_na, valleyofthedead_img_na, playNAsound, clearLevelText, writeNAText;
	button = 380, 306, ancientforest_img_na, ancientforest_img_na, ancientforest_img_na, playNAsound, clearLevelText, writeNAText;
	button = 702, 306, lostforest_img_na, lostforest_img_na, lostforest_img_na, playNAsound, clearLevelText, writeNAText;
	layer = 100;
	flags = overlay;
}
panel show_place_forest {
	button =  58,  64, forest_img, forest_img, forest_img, selectForest, clearLevelText, writeLevelText;
	layer = 101;
	flags = overlay;
}
panel show_place_waterfall {
	button = 380,  64, waterfall_img, waterfall_img, waterfall_img, selectWaterfall, clearLevelText, writeLevelText;
	layer = 101;
	flags = overlay;
}
panel show_place_frostfield {
	button = 702,  64, frostfield_img, frostfield_img, frostfield_img, selectFrostfield, clearLevelText, writeLevelText;
	layer = 101;
	flags = overlay;
}
panel show_place_valleyofthedead {
	button =  58, 306, valleyofthedead_img, valleyofthedead_img, valleyofthedead_img, selectValleyofthedead, clearLevelText, writeLevelText;
	layer = 101;
	flags = overlay;
}
panel show_place_ancientforest {
	button = 380, 306, ancientforest_img, ancientforest_img, ancientforest_img, selectAncientforest, clearLevelText, writeLevelText;
	layer = 101;
	flags = overlay;
}

panel show_place_lostforest {
	button = 702, 306, lostforest_img, lostforest_img, lostforest_img, selectLostforest, clearLevelText, writeLevelText;
	layer = 101;
	flags = overlay;
}

panel show_dialog {
	pos_y = 512;	// Changed during character selection
	button = 274, 64, dialogbox, dialogbox, dialogbox, null, null, null;
	window =   0,  0, 256, 256, character_pics, character_offset[2], NULL;
	flags = overlay;
	layer = 100;
}
text show_dialogtext
{
	pos_x = 292;
	pos_y = 588;
	font = arial_dialog;
	string = dialog_text;
	layer = 101;
	flags = outline;
}

panel show_dialoginfo {
	button = 173,  64, dialoginfo, dialoginfo, dialoginfo, null, null, null;
	button = 173, 256, dialoginfo, dialoginfo, dialoginfo, null, null, null;
	flags = overlay;
	layer = 100;
}
text show_WeaponText
{
	pos_x = 191;
	pos_y =  76;
	font = arial_dialog;
	string = show_WeaponText_string;
	layer = 101;
	flags = outline;
}
text show_ArmorText
{
	pos_x = 191;
	pos_y = 268;
	font = arial_dialog;
	string = show_ArmorText_string;
	layer = 101;
	flags = outline;
}

panel show_options {
	button = 570,  64, dialogbutton, dialogbutton, dialogbutton, nextWeapon, null, null;
	button = 570, 118, dialogbutton, dialogbutton, dialogbutton, buyWeapon, null, null;
	button = 570, 256, dialogbutton, dialogbutton, dialogbutton, nextArmor, null, null;
	button = 570, 310, dialogbutton, dialogbutton, dialogbutton, buyArmor, null, null;
	flags = overlay;
	layer = 100;
}
text show_WeaponNext
{
	pos_x = 611;
	pos_y =  76;
	font = arial_dialog;
	string = "Next";
	layer = 101;
	flags = center_x, outline;
}
text show_WeaponBuy
{
	pos_x = 611;
	pos_y = 130;
	font = arial_dialog;
	string = "Buy";
	layer = 101;
	flags = center_x, outline;
}
text show_ArmorNext
{
	pos_x = 611;
	pos_y = 268;
	font = arial_dialog;
	string = "Next";
	layer = 101;
	flags = center_x, outline;
}
text show_ArmorBuy
{
	pos_x = 611;
	pos_y = 322;
	font = arial_dialog;
	string = "Buy";
	layer = 101;
	flags = center_x, outline;
}

panel show_Next {
	button = 770, 648, dialogbutton, dialogbutton, dialogbutton, openLevelSelect, null, null;
	flags = overlay;
	layer = 100;
}
text show_NextText
{
	pos_x = 811;
	pos_y = 660;
	font = arial_dialog;
	string = "Next";
	layer = 101;
	flags = center_x, outline;
}

panel show_NextStart {
	button = 770, 576, dialogbutton, dialogbutton, dialogbutton, toggle_character, null, null;
	button = 770, 648, dialogbutton, dialogbutton, dialogbutton, toggle_character, null, null;
	flags = overlay;
	layer = 100;
}
text show_NextStartText
{
	pos_x = 811;
	pos_y = 588;
	font = arial_dialog;
	string = "Next\n\n\nStart";
	layer = 101;
	flags = center_x, outline;
}

panel show_HostJoin {
	button = 770, 576, dialogbutton, dialogbutton, dialogbutton, start_game, null, null;
	button = 770, 648, dialogbutton, dialogbutton, dialogbutton, start_game, null, null;
	flags = overlay;
	layer = 100;
}
text show_HostJoinText
{
	pos_x = 811;
	pos_y = 588;
	font = arial_dialog;
	string = "Host\n\n\nJoin";
	layer = 101;
	flags = center_x, outline;
}

panel show_swords {
	window = 475, 64, 75, 100, swords, TradeOffset[2], null;
	layer = 100;
}
panel show_bows {
	window = 475, 64, 75, 100, bows, TradeOffset[2], null;
	layer = 100;
}
panel show_wands {
	window = 475, 64, 75, 100, wands, TradeOffset[2], null;
	layer = 100;
}
panel show_spears {
	window = 475, 64, 75, 100, spears, TradeOffset[2], null;
	layer = 100;
}
panel show_heavy_armor {
	window = 475, 256, 75, 100, heavy_armor, TradeOffset[3], null;
	layer = 100;
}
panel show_light_armor {
	window = 475, 256, 75, 100, light_armor, TradeOffset[3], null;
	layer = 100;
}
panel show_priest_robes {
	window = 475, 256, 75, 100, priest_robes, TradeOffset[3], null;
	layer = 100;
}
panel show_wizard_robes {
	window = 475, 256, 75, 100, wizard_robes, TradeOffset[3], null;
	layer = 100;
}

///////////////////////////////////////////////////////
// Character action panel
bmap opt_move        = <opt_move.bmp>;
bmap opt_attack      = <opt_attack.bmp>;
bmap opt_hpreg       = <opt_hpreg.bmp>;
bmap opt_mpreg       = <opt_mpreg.bmp>;
bmap opt_heal        = <opt_heal.bmp>;
bmap opt_light       = <opt_light.bmp>;
bmap opt_ice         = <opt_ice.bmp>;
bmap opt_lightning   = <opt_lightning.bmp>;
bmap opt_earth       = <opt_earth.bmp>;
bmap opt_fire        = <opt_fire.bmp>;
bmap opt_mpdef       = <opt_mpdef.bmp>;
bmap opt_agi         = <opt_agi.bmp>;
bmap opt_revengeleap = <opt_revengeleap.bmp>;
bmap opt_battlerage  = <opt_battlerage.bmp>;
bmap opt_drawaggro   = <opt_drawaggro.bmp>;
bmap opt_callbattlelord = <opt_callbattlelord.bmp>;
bmap opt_explodingarrow = <opt_explodingarrow.bmp>;
bmap opt_earthquake	= <opt_earthquake.bmp>;
bmap opt_summongaja	= <opt_summongaja.bmp>;
bmap opt_thornaura	= <opt_thornaura.bmp>;
bmap opt_selftransform  = <opt_selftransform.bmp>;
bmap opt_firestorm	= <opt_firestorm.bmp>;
bmap opt_raisebuffs	= <opt_raisebuffs.bmp>;
bmap opt_back        = <opt_back.bmp>;

panel show_opt_move {
	pos_y = 480;
	button = 0, 0, opt_move, opt_move, opt_move, action_input, hide_action_text, show_action_text;
	layer = 150;
}
panel show_opt_attack {
	pos_y = 480;
	button = 0, 0, opt_attack, opt_attack, opt_attack, action_input, hide_action_text, show_action_text;
	layer = 150;
}
panel show_opt_hpreg {
	pos_y = 480;
	button = 0, 0, opt_hpreg, opt_hpreg, opt_hpreg, action_input, hide_action_text, show_action_text;
	layer = 150;
}
panel show_opt_mpreg {
	pos_y = 480;
	button = 0, 0, opt_mpreg, opt_mpreg, opt_mpreg, action_input, hide_action_text, show_action_text;
	layer = 150;
}
panel show_opt_heal {
	pos_y = 480;
	button = 0, 0, opt_heal, opt_heal, opt_heal, action_input, hide_action_text, show_action_text;
	layer = 150;
}
panel show_opt_light {
	pos_y = 480;
	button = 0, 0, opt_light, opt_light, opt_light, action_input, hide_action_text, show_action_text;
	layer = 150;
}
panel show_opt_ice {
	pos_y = 480;
	button = 0, 0, opt_ice, opt_ice, opt_ice, action_input, hide_action_text, show_action_text;
	layer = 150;
}
panel show_opt_lightning {
	pos_y = 480;
	button = 0, 0, opt_lightning, opt_lightning, opt_lightning, action_input, hide_action_text, show_action_text;
	layer = 150;
}
panel show_opt_earth {
	pos_y = 480;
	button = 0, 0, opt_earth, opt_earth, opt_earth, action_input, hide_action_text, show_action_text;
	layer = 150;
}
panel show_opt_fire {
	pos_y = 480;
	button = 0, 0, opt_fire, opt_fire, opt_fire, action_input, hide_action_text, show_action_text;
	layer = 150;
}
panel show_opt_mpdef {
	pos_y = 480;
	button = 0, 0, opt_mpdef, opt_mpdef, opt_mpdef, action_input, hide_action_text, show_action_text;
	layer = 150;
}
panel show_opt_agi {
	pos_y = 480;
	button = 0, 0, opt_agi, opt_agi, opt_agi, action_input, hide_action_text, show_action_text;
	layer = 150;
}
panel show_opt_revengeleap {
	pos_y = 480;
	button = 0, 0, opt_revengeleap, opt_revengeleap, opt_revengeleap, action_input, hide_action_text, show_action_text;
	layer = 150;
}
panel show_opt_battlerage {
	pos_y = 480;
	button = 0, 0, opt_battlerage, opt_battlerage, opt_battlerage, action_input, hide_action_text, show_action_text;
	layer = 150;
}
panel show_opt_drawaggro {
	pos_y = 480;
	button = 0, 0, opt_drawaggro, opt_drawaggro, opt_drawaggro, action_input, hide_action_text, show_action_text;
	layer = 150;
}
panel show_opt_callbattlelord {
	pos_y = 480;
	button = 0, 0, opt_callbattlelord, opt_callbattlelord, opt_callbattlelord, action_input, hide_action_text, show_action_text;
	layer = 150;
}
panel show_opt_explodingarrow {
	pos_y = 480;
	button = 0, 0, opt_explodingarrow, opt_explodingarrow, opt_explodingarrow, action_input, hide_action_text, show_action_text;
	layer = 150;
}
panel show_opt_earthquake {
	pos_y = 480;
	button = 0, 0, opt_earthquake, opt_earthquake, opt_earthquake, action_input, hide_action_text, show_action_text;
	layer = 100;
}
panel show_opt_summongaja {
	pos_y = 480;
	button = 0, 0, opt_summongaja, opt_summongaja, opt_summongaja, action_input, hide_action_text, show_action_text;
	layer = 100;
}
panel show_opt_thornaura {
	pos_y = 480;
	button = 0, 0, opt_thornaura, opt_thornaura, opt_thornaura, action_input, hide_action_text, show_action_text;
	layer = 100;
}
panel show_opt_selftransform {
	pos_y = 480;
	button = 0, 0, opt_selftransform, opt_selftransform, opt_selftransform, action_input, hide_action_text, show_action_text;
	layer 100;
}
panel show_opt_firestorm {
	pos_y = 480;
	button = 0, 0, opt_firestorm, opt_firestorm, opt_firestorm, action_input, hide_action_text, show_action_text;
	layer 100;
}
panel show_opt_raisebuffs {
	pos_y = 480;
	button = 0, 0, opt_raisebuffs, opt_raisebuffs, opt_raisebuffs, action_input, hide_action_text, show_action_text;
	layer 100;
}
panel show_opt_back {
	pos_x = 486;
	pos_y = 530;
	button = 0, 0, opt_back, opt_back, opt_back, back_input, hide_action_text, show_action_text;
	layer = 150;
}

text show_actor_class {
	string = show_actor_string;
	flags = shadow, center_x;
	layer = 10;
}
text netstats {
	pos_x = 60;
	pos_y = 20;
	string = show_netstats;
	font = arial_font;
	layer = 1;
	flags = SHADOW;
} 	

bmap act_knight = <act_knight.bmp>;
bmap act_archer = <act_archer.bmp>;
bmap act_priest = <act_priest.bmp>;
bmap act_wizard = <act_wizard.bmp>;
bmap act_valkyrie = <act_valkyrie.bmp>;
panel show_action_effect {
	scale_x = 1;
	scale_y = 1;
	pos_x = 486;
	pos_y = 512;
	layer = 100;
	flags = overlay;
}

panel debug_panel
{
	POS_X 20;
	POS_Y 20;
	DIGITS 0,  0, 4.2, arial_font, 1, TEMPs.X;
	DIGITS 0, 20, 4.2, arial_font, 1, TEMPs.Y;
	DIGITS 0, 40, 4.2, arial_font, 1, TEMPs.Z;

	LAYER 500;
//	FLAGS = VISIBLE;
}


ifdef client;
	var connecting = 1;
ifelse;
	var connecting = 0;
endif;


///////////////////////////////////////////////////////
// main function
function main()
{
	randomize();

	MAX_ENTITIES = 1000;
	fps_max = 60;
	IF (d3d_mode == 3){
		d3d_anisotropy = 2;	// anisotropic filtering active
	}
	d3d_autotransparency = ON;
//	draw_textmode("Arial", 1, 16, 100);
	draw_textmode("Georgia", 1, 16, 100);
	vec_set(screen_color,vector(12, 12, 12));

	Clientlogout = -1;

	mouse_toggle();	// activate the mouse
	title_gs_logo.visible = ON;	// switch gs logo on

	// recieve ip inputs; number 0 to 9 and .
	if (connection == 0) {
		server_ip_input();
		BGM_Start(2);
	}

	character_offset[2] = 256 * (4 + int(random(3)));
	show_dialog.visible = on;
	show_dialogtext.visible = on;
	while (connection == 0) {	// It seems that the connection var is not always != 0 right from the beginning even if a server was found.
		str_cpy(dialog_text, "Welcome to Starbattle <3 <3 <3");

		// Print headline
		if (connecting > 0) {	// Engine started with -cl commandline option
			if (connecting > 40) {	// Print connection failed message after 2.5 seconds
				str_cat(dialog_text, "\n\nFailed to connect to server.");

				show_HostJoin.visible = on;
				show_HostJoinText.visible = on;
			} else {	// give some time to finally connect
				str_cat(dialog_text, "\n\nConnecting...");
				connecting += time;
			}
		} else {	// Engine was started without commandline option -cl
			str_cat(dialog_text, "\n\nConnect via IP adress (only for internet play):\n");
			str_cat(dialog_text, server_ip);

			title_background.visible = on;
			title_characters.visible = on;

			show_HostJoin.visible = on;
			show_HostJoinText.visible = on;
		}
	wait(1);
	}
	character_offset[2] = 0;
	show_dialog.visible = off;
	show_dialogtext.visible = off;

	show_HostJoin.visible = off;
	show_HostJoinText.visible = off;


	title_background.visible = OFF;
	title_characters.visible = OFF;

	LEVEL_LOAD("plains.wmb");
	WAIT (3);	// Wait 3 frames for the level to load
	move_camera();	// Activate camera movement
	CAMERA.AUDIBLE = OFF;

	IF (connection == 3) {
		Level_ID = _Level_Forest;	// Initiate level ID
		morph_level(Level_ID);
	} ELSE {
		WHILE (Level_ID == 0) { WAIT (1); }
	}

	WAITT (16);
	BGM_Start(2);

	// Fade in character background, cancel if any key is pressed
	title_background.visible = ON;	// Headline "Star Battle" with shooting star in the middle
	title_background.transparent = ON;
	title_background.alpha = 0;
	WHILE ((title_background.alpha < 100) && (!KEY_ANY)) {
		title_background.alpha = MIN(100, title_background.alpha + 10 * TIME);
	WAIT (1);
	}
	title_background.alpha = 100;
	title_background.transparent = OFF;

	snd_play(startup, 100, 0);

	// Fade in characters, cancel if any key is pressed
	title_characters.visible = ON;	// Players in front, enemies behind, play honorable sound!
	title_characters.transparent = ON;
	title_characters.alpha = 0;
	WHILE ((title_characters.alpha < 100) && (!KEY_ANY)) {
		title_characters.alpha = MIN(100, title_characters.alpha + 6 * TIME);
	WAIT (1);
	}
	title_characters.alpha = 100;
	title_characters.transparent = OFF;

	title_gs_logo.visible = OFF;


//	IF (!KEY_ANY) { WAITT (16); }



	character_selection(ON);
	while (player == null) { wait(1); }
//	WHILE (show_dialog.visible == on) { wait(1); }


	// Fade out background after character selection
	title_characters.transparent = ON;
	title_background.transparent = ON;
	WHILE (title_characters.alpha > 0) {
		title_characters.alpha = MAX(0, title_characters.alpha - 12 * TIME);
		title_background.alpha = title_characters.alpha;
	WAIT (1);
	}
	title_characters.visible = OFF;
	title_background.visible = OFF;

	// Free memory
	bmap_purge(gs_logo);
	bmap_purge(sb_characters);
	bmap_purge(sb_background);


//	bgm = dll_mp3init("Aga F1.wma");
//	dll_mp3loopplay(bgm);
//	dll_mp3setvolume(bgm, 1000);

	BGM_Start(1);


	transfer_text();
	avatar_counting();
	activate_animated_message();

	// The server spawns enemies
	IF (connection == 3) {
		enemy_spawn();

		WHILE (1) {
			IF (Clientlogout != -1) {
				current_player[Clientlogout] = 0;
				Clientlogout = -1;
			}

			TEMP[0] = 0;
			TEMP[1] = 0;
			TEMP[2] = 0;
			WHILE (TEMP[0] < 4) {
				IF (current_player[TEMP[0]] != 0) {
					YOU = ptr_for_handle(current_player[TEMP[0]]);
					IF (YOUR._HP > 0) {
						TEMP[1] = 1;	// At least 1 player alive
						fatal = 0;
						break;
					}
					TEMP[2] += 1;
				}
			TEMP[0] += 1;
			}

			// All players dead?
			if ((TEMP[1] == 0) && (TEMP[2] > 0)) {
				fatal = 1;
				_ID_for_message = -2;	// Game over message-ID

				WAITT(120);

				// fatal message

				enemies[1] = 0;	// Reset waves
//				enemies[1] = IIf(enemies[1] > 13, 13, IIf(enemies[1] > 22, 22, enemies[1]));
//				IF (enemies[1] > 22) {
//					enemies[1] = 22;
//					Level_ID = _Level_Rocks;	// change to rocks level
//				} ELSE {
//					IF (enemies[1] > 13) {
//						enemies[1] = 13;
//						Level_ID = _Level_Snow;	// change to snow level
//					} ELSE {
//						enemies[1] = 0;
//						Level_ID = _Level_Forest;	// change to forest level
//					}
//				}
				morph_level(Level_ID);
				SEND_VAR(Level_ID);

//				enemies[3] = 0;	// Reset total rounds

				YOU = ENT_NEXT(NULL);
				WHILE (YOU) {
					IF (YOUR._Actor_ID == _ID_Enemy) {
						ENT_REMOVE(YOU);	// Remove all enemies
					}
				YOU = ENT_NEXT(YOU);
				}

				YOU = ENT_NEXT(NULL);
				WHILE (YOU) {
					IF ((YOUR._Actor_ID == _ID_Player) && (YOUR._Actor_class != _num_battle_lord)) {
						YOUR._HP = YOUR._Vit;
						YOUR._MP = YOUR._Int;
						YOUR._kills = 0;
						VEC_SET(YOUR.X, vector(-(256 + Random(256)), Random(256) -128, 50));

						SEND_SKILL(YOUR._HP, SEND_ALL); net_transfer += 4;
						SEND_SKILL(YOUR._MP, SEND_ALL); net_transfer += 4;
						SEND_SKILL(YOUR._kills, SEND_ALL); net_transfer += 4;
						SEND_SKILL(YOUR.X, SEND_VEC + SEND_ALL); net_transfer += 12;
					}
				YOU = ENT_NEXT(YOU);
				}

				WAITT(32);
			}
		WAITT(4);
		}
	}
}

function IIf(expression, truepart, falsepart)
{
	IF (expression) { RETURN (truepart);
	} ELSE { RETURN (falsepart); }
}

function server_ip_input()
{
	WHILE (connection == 0) {
		// Key input 1 to 0 (0 to 9)
		if (str_len(server_ip) < 15) {
			IF ((key_lastpressed >= 2) && (key_lastpressed <= 11) || (key_lastpressed == 52)) {
				IF (key_lastpressed == 52) {	// '.'
					STR_CAT(server_ip, ".");	// Add character to string
				} ELSE {	// '0-9'
					TEMP = key_lastpressed;
					IF (TEMP == 11) { TEMP = 0;
					} ELSE { TEMP -= 1; }

					STR_FOR_NUM(TEMP_STRING, TEMP);	// Create character from number
					STR_CAT(server_ip, TEMP_STRING);	// Add character to string
				}

				key_lastpressed = 0;
			}
		}
		IF (KEY_PRESSED(14)) {	// Backspace
			STR_TRUNC(server_ip, 1);
			WAITT (4);
			WHILE (KEY_PRESSED(14)) {
				STR_TRUNC(server_ip, 1);
			WAITT(1);
			}
		}
	WAIT (1);
	}

	RETURN;
}


function stop_bgm()
{
	dll_mp3stop(bgm);
}
on_F12 = stop_bgm;

function toggle_netstats()
{
	netstats.visible = netstats.visible == OFF;
}
on_F11 = toggle_netstats();

function action_effect(chance)
{
var timer;

	IF ((show_action_effect.visible == ON) || (Random(100) > chance)) { RETURN; }

	IF (MY._Actor_class == _num_knight) { show_action_effect.bmap = act_knight; timer[2] =  1; }
	IF (MY._Actor_class == _num_archer) { show_action_effect.bmap = act_archer; timer[2] =  1; }
	IF (MY._Actor_class == _num_priest) { show_action_effect.bmap = act_priest; timer[2] =  0; }
	IF (MY._Actor_class == _num_wizard) { show_action_effect.bmap = act_wizard; timer[2] = -1; }
	if (my._Actor_class == _num_valkyrie) { show_action_effect.bmap = act_valkyrie; timer[2] = -1; }

	show_action_effect.pos_x = 128 + Random(256);
	show_action_effect.visible = ON;
	show_action_effect.transparent = ON;
	show_action_effect.alpha = 0;
	WHILE (show_action_effect.alpha < 100) {
		show_action_effect.alpha = MIN(100, show_action_effect.alpha + 25 * TIME);
		show_action_effect.pos_x += 2 * timer[2] * TIME;
	WAIT (1);
	}
	show_action_effect.transparent = OFF;

	WHILE (timer[0] < 8) {
		show_action_effect.pos_x += 2 * timer[2] * TIME;
		timer[0] += TIME;
	WAIT (1);
	}

	show_action_effect.transparent = ON;
	WHILE (show_action_effect.alpha > 0) {
		show_action_effect.alpha = MAX(0, show_action_effect.alpha - 25 * TIME);
		show_action_effect.pos_x += 2 * timer[2] * TIME;
	WAIT (1);
	}

	show_action_effect.visible = OFF;

	RETURN;
}

function show_animated_message(ascii_val, number, strlen)
{
var tPOS;	// X-Pos, Y-Pos, Timer (Z)

number *= -16;
strlen *= (16 / 2);

	WHILE (tPOS.Z < 16) {
		STR_CPY(TEMP_STRING, "");
		STR_FOR_ASC (TEMP_STRING, ascii_val);

		tPOS.X = 1024 + strlen + number - tPOS.Z * 32;
		tPOS.Y = 50 + FSIN(tPOS.Z * 5.625, 64);
		DRAW_TEXT (TEMP_STRING, tPOS.X, tPOS.Y, VECTOR (  0,  0,  0));
		tPOS.X -= 1; tPOS.Y -= 1;
		DRAW_TEXT (TEMP_STRING, tPOS.X, tPOS.Y, VECTOR (255,255,255));
		tPOS.Z += TIME;
	WAIT (1);
	}
	WHILE (tPOS.Z < 64) {
		STR_CPY(TEMP_STRING, "");
		STR_FOR_ASC (TEMP_STRING, ascii_val);

		tPOS.X = 512 + strlen + number;
		tPOS.Y = 114;
		DRAW_TEXT (TEMP_STRING, tPOS.X, tPOS.Y, VECTOR (  0,  0,  0));
		tPOS.X -= 1; tPOS.Y -= 1;
		DRAW_TEXT (TEMP_STRING, tPOS.X, tPOS.Y, VECTOR (255,255,255));
		tPOS.Z += TIME;
	WAIT (1);
	}
	WHILE (tPOS.Z < 96) {
		STR_CPY(TEMP_STRING, "");
		STR_FOR_ASC (TEMP_STRING, ascii_val);

		tPOS.X = 512 + strlen + number - (tPOS.Z - 64) * 32;
		tPOS.Y = 50 + FSIN((tPOS.Z - 48) * 5.625, 64);
		DRAW_TEXT (TEMP_STRING, tPOS.X, tPOS.Y, VECTOR (  0,  0,  0));
		tPOS.X -= 1; tPOS.Y -= 1;
		DRAW_TEXT (TEMP_STRING, tPOS.X, tPOS.Y, VECTOR (255,255,255));
		tPOS.Z += TIME;
	WAIT (1);
	}
}

function activate_animated_message()
{
var strlen;

	WHILE (1) {
		IF (_ID_for_message != 0) {
			IF (connection == 3) {
				SEND_VAR(_ID_for_message); net_transfer += 12;
				WAIT (1);
			}

			IF (_ID_for_message >   0) {
				STR_CPY(animated_message, "Wave ");
				STR_FOR_NUM(TEMP_STRING, _ID_for_message);
				STR_CAT(animated_message, TEMP_STRING);

				IF (strlen[1]) {	// Last wave was boss battle
					strlen[1] = 0;	// reset value
				}
			}
			IF (_ID_for_message == -1) {
				STR_CPY(animated_message, "Boss battle!");
				strlen[1] = 1;	// remember we are in a boss battle
			}
			IF (_ID_for_message == -2) {
				STR_CPY(animated_message, "Game over...");
				strlen[1] = 0;	// no boss victory
			}

			strlen = STR_LEN(animated_message);

			WHILE (STR_LEN(animated_message)) {
				show_animated_message(STR_TO_ASC(animated_message), STR_LEN(animated_message), strlen);
				STR_CLIP (animated_message, 1);	// kill first character
			WAITT (4);
			}

			_ID_for_message = 0;
		}
	WAITT (4);
	}
}

// text schreiben, bei hover textfeld sichtbar
function action_place(button_number, panel_ptr)
{
//	if (panel_ptr == bp1) {
//		Level_Select[0] = off;
//		enemies[4] = 1;
//		Level_ID = _Level_Rocks;
//	}

	send_var(Level_Select);
	morph_level(Level_ID);
	send_var(Level_ID);
}

function open_trade()
{
	if (Level_Select[2]) {
		snd_play(MM_Ende, 100, 0);
	} else {
		snd_play(victory, 100, 0);
	}

	BGM_Start(2);
	show_wood_bg.visible = on;
	startSpeech(player._Actor_class);

	return;
}

function close_worldmap()
{
	show_wood_bg.visible = off;

	show_dialog.visible = off;
	show_dialogtext.visible = off;
}

function enemy_Level(round)
{
	return(min(20, round * 2));
}

function enemy_spawn()
{
// enemies:
// 0 - Gegnerzahl
// 1 - Welle
// 2 - Spielerzahl
// 3 - Runde/Gegnerlevels
// 4 - Gebiet

//enemies[1] = 12;
//enemies[3] = INT(Random(2)) + 3;
//enemies[4] = _lvl_Forest;
//enemies[4] = _lvl_Waterfall;
//enemies[4] = _lvl_Frostfield;
//enemies[4] = _lvl_Valleyofthedead;
//enemies[4] = _lvl_Ancientforest;
//enemies[4] = _lvl_Lostforest;

	while (1) {

		enemies[0] = 0;
		YOU = ENT_NEXT(NULL);
		WHILE (YOU) {
			IF (YOUR._Actor_ID == _ID_Enemy) {
				enemies[0] += 1;
			}
		YOU = ENT_NEXT(YOU);
		}

		if (enemies[0] == 0) {

			if (fatal) { Level_Select[1] = on; }

			if (Level_Select[1] == on) {
				Level_Select[0] = on;
				Level_Select[1] = off;
				Level_Select[2] = fatal;
				if (fatal == 0) { cleared_levels[enemies[4]] += 1; }
				send_var(Level_Select);
				open_trade();
				while (Level_Select[0]) { wait(1); }
				enemies[1] = 0;	// Start with wave 1
			}

			enemies[1] += 1;	// next wave

			WAITT (48);

			_ID_for_message = enemies[1];

			// Get player count to adjust enemy number
			TEMP = 0;
			enemies[2] = 0;
			WHILE (TEMP < 4) {
				IF (current_player[TEMP]) { enemies[2] += 1; }
			TEMP += 1;
			}

			enemies[3] = cleared_levels[enemies[4]];
			enemies[2]  = 0.6 + (0.6 - Random(0.2)) * enemies[2];
			enemies[2] *= 1 + 0.5 * enemies[3];	// Increase spawn with increasing number

			if (enemies[4] == _lvl_Forest) {
				if (enemies[1] ==  1) { enemies[2] = INT(1.4 * enemies[2]); }
				if (enemies[1] ==  2) { enemies[2] = INT(1.2 * enemies[2]); }
				if (enemies[1] ==  3) { enemies[2] = INT(1.5 * enemies[2]); }
				if (enemies[1] ==  4) { enemies[2] = INT(1.0 * enemies[2]); }
				if (enemies[1] ==  5) { enemies[2] = INT(1.6 * enemies[2]); }
				if (enemies[1] ==  6) { enemies[2] = INT(1.6 * enemies[2]); }
				if (enemies[1] ==  7) { enemies[2] = INT(1.4 * enemies[2]); }
				if (enemies[1] ==  8) { enemies[2] = INT(1.7 * enemies[2]); }
				if (enemies[1] ==  9) { enemies[2] = INT(1.4 * enemies[2]); }
				if (enemies[1] == 10) { enemies[2] = INT(1.2 * enemies[2]); }
				if (enemies[1] == 11) { enemies[2] = INT(1.4 * enemies[2]); }
				if (enemies[1] == 12) { enemies[2] = INT(1.2 * enemies[2]); }
				if (enemies[1] == 13) {
					enemies[2] = INT(1.0 * enemies[2]);
					_ID_for_message = -1;
				}
			}

			if (enemies[4] == _lvl_Waterfall) {
				if (enemies[1] ==  1) { enemies[2] = int(2.0 * enemies[2]); }
				if (enemies[1] ==  2) { enemies[2] = int(1.0 * enemies[2]); }
				if (enemies[1] ==  3) { enemies[2] = int(1.5 * enemies[2]); }
				if (enemies[1] ==  4) { enemies[2] = int(1.0 * enemies[2]); }
				if (enemies[1] ==  5) { enemies[2] = int(1.7 * enemies[2]); }
				if (enemies[1] ==  6) { enemies[2] = int(1.6 * enemies[2]); }
				if (enemies[1] ==  7) { enemies[2] = int(1.3 * enemies[2]); }
				if (enemies[1] ==  8) { enemies[2] = int(1.7 * enemies[2]); }
				if (enemies[1] ==  9) { enemies[2] = int(1.4 * enemies[2]); }
				if (enemies[1] == 10) { enemies[2] = int(1.6 * enemies[2]); }
				if (enemies[1] == 11) { enemies[2] = int(1.8 * enemies[2]); }
				if (enemies[1] == 12) { enemies[2] = int(1.3 * enemies[2]); }
				if (enemies[1] == 13) {
					enemies[2] = int(1.2 * enemies[2]);
					_ID_for_message = -1;
				}
			}

			if (enemies[4] == _lvl_Frostfield) {
				if (enemies[1] ==  1) { enemies[2] = int(2.5 * enemies[2]); }
				if (enemies[1] ==  2) { enemies[2] = int(1.0 * enemies[2]); }
				if (enemies[1] ==  3) { enemies[2] = int(1.7 * enemies[2]); }
				if (enemies[1] ==  4) { enemies[2] = int(1.4 * enemies[2]); }
				if (enemies[1] ==  5) { enemies[2] = int(1.8 * enemies[2]); }
				if (enemies[1] ==  6) { enemies[2] = int(1.0 * enemies[2]); }
				if (enemies[1] ==  7) { enemies[2] = int(1.5 * enemies[2]); }
				if (enemies[1] ==  8) { enemies[2] = int(1.7 * enemies[2]); }
				if (enemies[1] ==  9) { enemies[2] = int(1.2 * enemies[2]); }
				if (enemies[1] == 10) { enemies[2] = int(1.6 * enemies[2]); }
				if (enemies[1] == 11) {
					enemies[2] = int(1.0 * enemies[2]);
					_ID_for_message = -1;
				}
			}

			if (enemies[4] == _lvl_Valleyofthedead) {
				if (enemies[1] ==  1) { enemies[2] = int(2.5 * enemies[2]); }
				if (enemies[1] ==  2) { enemies[2] = int(1.8 * enemies[2]); }
				if (enemies[1] ==  3) { enemies[2] = int(1.4 * enemies[2]); }
				if (enemies[1] ==  4) { enemies[2] = int(2.0 * enemies[2]); }
				if (enemies[1] ==  5) { enemies[2] = int(1.4 * enemies[2]); }
				if (enemies[1] ==  6) { enemies[2] = int(1.7 * enemies[2]); }
				if (enemies[1] ==  7) { enemies[2] = int(1.8 * enemies[2]); }
				if (enemies[1] ==  8) { enemies[2] = int(1.0 * enemies[2]); }
				if (enemies[1] ==  9) { enemies[2] = int(1.4 * enemies[2]); }
				if (enemies[1] == 10) { enemies[2] = int(1.7 * enemies[2]); }
				if (enemies[1] == 11) { enemies[2] = int(1.5 * enemies[2]); }
				if (enemies[1] == 12) { enemies[2] = int(2.2 * enemies[2]); }
				if (enemies[1] == 13) {
					enemies[2] = int(1.6 * enemies[2]);
					_ID_for_message = -1;
				}
			}

			if (enemies[4] == _lvl_Ancientforest) {
				if (enemies[1] ==  1) { enemies[2] = int(2.0 * enemies[2]); }
				if (enemies[1] ==  2) { enemies[2] = int(1.2 * enemies[2]); }
				if (enemies[1] ==  3) { enemies[2] = int(1.6 * enemies[2]); }
				if (enemies[1] ==  4) { enemies[2] = int(3.0 * enemies[2]); }
				if (enemies[1] ==  5) { enemies[2] = int(2.5 * enemies[2]); }
				if (enemies[1] ==  6) { enemies[2] = int(2.1 * enemies[2]); }
				if (enemies[1] ==  7) { enemies[2] = int(1.4 * enemies[2]); }
				if (enemies[1] ==  8) { enemies[2] = int(2.2 * enemies[2]); }
				if (enemies[1] ==  9) { enemies[2] = int(1.2 * enemies[2]); }	// White Dragon
				if (enemies[1] == 10) { enemies[2] = int(1.4 * enemies[2]); }
				if (enemies[1] == 11) { enemies[2] = int(1.4 * enemies[2]); }
				if (enemies[1] == 12) { enemies[2] = int(2.2 * enemies[2]); }
				if (enemies[1] == 13) {
					enemies[2] = int(1.2 * enemies[2]);
					_ID_for_message = -1;
				}
			}

			if (enemies[4] == _lvl_Lostforest) {
				if (enemies[1] ==  1) { enemies[2] = int(3.2 * enemies[2]); }
				if (enemies[1] ==  2) { enemies[2] = int(1.5 * enemies[2]); }
				if (enemies[1] ==  3) { enemies[2] = int(2.3 * enemies[2]); }
				if (enemies[1] ==  4) { enemies[2] = int(2.0 * enemies[2]); }
				if (enemies[1] ==  5) { enemies[2] = int(1.4 * enemies[2]); }
				if (enemies[1] ==  6) { enemies[2] = int(2.0 * enemies[2]); }
				if (enemies[1] ==  7) { enemies[2] = int(2.1 * enemies[2]); }
				if (enemies[1] ==  8) { enemies[2] = int(1.7 * enemies[2]); }
				if (enemies[1] ==  9) { enemies[2] = int(2.7 * enemies[2]); }	// Dawn of Souls
				if (enemies[1] == 10) { enemies[2] = int(1.6 * enemies[2]); }
				if (enemies[1] == 11) { enemies[2] = int(1.6 * enemies[2]); }
				if (enemies[1] == 12) { enemies[2] = int(1.4 * enemies[2]); }
				if (enemies[1] == 13) { enemies[2] = int(2.2 * enemies[2]); }
				if (enemies[1] == 14) { enemies[2] = int(1.8 * enemies[2]); }
				if (enemies[1] == 15) { enemies[2] = int(1.7 * enemies[2]); }
				if (enemies[1] == 16) { enemies[2] = int(1.8 * enemies[2]); }
				if (enemies[1] == 17) { enemies[2] = int(1.9 * enemies[2]); }
				if (enemies[1] == 18) {
					enemies[2] = int(1.4 * enemies[2]);
					_ID_for_message = -1;
				}
			}


			if (_ID_for_message == -1) { Level_Select[1] = on; }

			while (enemies[2] > 0) {
				if (enemies[4] == _lvl_Forest) {
					if (enemies[1] ==  1) { create_enemy(_num_slime); }
					if (enemies[1] ==  2) { create_enemy(_num_raptor); }
					if (enemies[1] ==  3) {
						if (int(Random(3))) { create_enemy(_num_raptor);
						} else { create_enemy(_num_slime); }
					}
					if (enemies[1] ==  4) { create_enemy(_num_allosaur); }
					if (enemies[1] ==  5) {
						if (int(Random(3))) { create_enemy(_num_slime);
						} else { create_enemy(_num_allosaur); }
					}
					if (enemies[1] ==  6) {
						if (int(Random(3))) { create_enemy(_num_raptor);
						} else { create_enemy(_num_allosaur); }
					}
					if (enemies[1] ==  7) { create_enemy(_num_decay_jelly); }
					if (enemies[1] ==  8) {
						if (int(Random(2))) { create_enemy(_num_raptor);
						} else { create_enemy(_num_decay_jelly); }
					}
					if (enemies[1] ==  9) { create_enemy(_num_dragon); }
					if (enemies[1] == 10) {
						TEMP = int(Random(3));
						if (TEMP == 0) { create_enemy(_num_raptor); }
						if (TEMP == 1) { create_enemy(_num_decay_jelly); }
						if (TEMP == 2) { create_enemy(_num_dragon); }
					}
					if (enemies[1] == 11) { create_enemy(_num_oktion); }
					if (enemies[1] == 12) {
						if (int(Random(2))) { create_enemy(_num_dragon);
						} else { create_enemy(_num_oktion); }
					}
					if (enemies[1] == 13) {
						create_enemy(_num_old_spirit);
						while (enemies[2] > 0) {
							TEMP = int(Random(3));
							if (TEMP == 0) { create_enemy(_num_allosaur); }
							if (TEMP == 1) { create_enemy(_num_decay_jelly); }
							if (TEMP == 2) { create_enemy(_num_dragon); }
						enemies[2] -= 1;
						}
					}
				}

				if (enemies[4] == _lvl_Waterfall) {
					if (enemies[1] ==  1) { create_enemy(_num_viscous_slime); }
					if (enemies[1] ==  2) { create_enemy(_num_skeleton); }
					if (enemies[1] ==  3) {
						if (int(Random(3))) { create_enemy(_num_viscous_slime);
						} else { create_enemy(_num_skeleton); }
					}
					if (enemies[1] ==  4) { create_enemy(_num_blue_dragon); }
					if (enemies[1] ==  5) {
						TEMP = int(Random(3));
						if (TEMP == 0) { create_enemy(_num_viscous_slime); }
						if (TEMP == 1) { create_enemy(_num_skeleton); }
						if (TEMP == 2) { create_enemy(_num_blue_dragon); }
					}
					if (enemies[1] ==  6) {
						if (int(Random(3))) { create_enemy(_num_viscous_slime);
						} else { create_enemy(_num_blue_dragon); }
					}
					if (enemies[1] ==  7) { create_enemy(_num_green_wizard); }
					if (enemies[1] ==  8) {
						if (int(Random(2))) { create_enemy(_num_skeleton);
						} else { create_enemy(_num_green_wizard); }
					}
					if (enemies[1] ==  9) {
						if (int(Random(2))) { create_enemy(_num_decay_jelly);
						} else { create_enemy(_num_green_wizard); }
					}
					if (enemies[1] == 10) {
						TEMP = int(Random(3));
						if (TEMP == 0) { create_enemy(_num_oktion); }
						if (TEMP == 1) { create_enemy(_num_green_wizard); }
						if (TEMP == 2) { create_enemy(_num_blue_dragon); }
					}
					if (enemies[1] == 11) {
						if (int(Random(2))) { create_enemy(_num_oktion);
						} else { create_enemy(_num_decay_jelly); }
					}
					if (enemies[1] == 12) {
						TEMP = int(Random(3));
						if (TEMP == 0) { create_enemy(_num_dragon); }
						if (TEMP == 1) { create_enemy(_num_green_wizard); }
						if (TEMP == 2) { create_enemy(_num_decay_jelly); }
					}
					if (enemies[1] == 13) {
						create_enemy(_num_evil_spirit);
						while (enemies[2] > 0) {
							TEMP = int(Random(2));
							if (TEMP == 0) { create_enemy(_num_skeleton); }
							if (TEMP == 1) { create_enemy(_num_green_wizard); }
						enemies[2] -= 1;
						}
					}
				}

				if (enemies[4] == _lvl_Frostfield) {
					if (enemies[1] ==  1) { create_enemy(_num_frost_ooze); }
					if (enemies[1] ==  2) { create_enemy(_num_blue_dragon); }
					if (enemies[1] ==  3) {
						if (int(Random(2))) { create_enemy(_num_frost_ooze);
						} else { create_enemy(_num_blue_dragon); }
					}
					if (enemies[1] ==  4) { create_enemy(_num_cold_jelli); }
					if (enemies[1] ==  5) {
						TEMP = int(Random(3));
						if (TEMP == 0) { create_enemy(_num_frost_ooze); }
						if (TEMP == 1) { create_enemy(_num_blue_dragon); }
						if (TEMP == 2) { create_enemy(_num_cold_jelli); }
					}
					if (enemies[1] ==  6) { create_enemy(_num_wraith); }
					if (enemies[1] ==  7) {
						if (int(Random(2))) { create_enemy(_num_blue_dragon);
						} else { create_enemy(_num_wraith); }
					}
					if (enemies[1] ==  8) {
						if (int(Random(2))) { create_enemy(_num_frost_ooze);
						} else { create_enemy(_num_wraith); }
					}
					if (enemies[1] ==  9) { create_enemy(_num_ice_frog); }
					if (enemies[1] == 10) {
						if (int(Random(2))) { create_enemy(_num_frost_ooze);
						} else { create_enemy(_num_ice_frog); }
					}
					if (enemies[1] == 11) {
						create_enemy(_num_beholder_twins1);
						create_enemy(_num_beholder_twins2);
						while (enemies[2] > 0) {
							TEMP = int(Random(2));
							if (TEMP == 0) { create_enemy(_num_cold_jelli); }
							if (TEMP == 1) { create_enemy(_num_ice_frog); }
						enemies[2] -= 1;
						}
					}
				}

				if (enemies[4] == _lvl_Valleyofthedead) {
					if (enemies[1] ==  1) { create_enemy(_num_skeleton); }
					if (enemies[1] ==  2) {
						if (int(Random(2))) { create_enemy(_num_skeleton);
						} else { create_enemy(_num_skeleton_poleman); }
					}
					if (enemies[1] ==  3) { create_enemy(_num_dark_galert); }
					if (enemies[1] ==  4) {
						if (int(Random(2))) { create_enemy(_num_skeleton);
						} else { create_enemy(_num_skeleton_poleman); }
					}
					if (enemies[1] ==  5) { create_enemy(_num_samurai_zombie); }
					if (enemies[1] ==  6) {
						if (int(Random(2))) { create_enemy(_num_dark_galert);
						} else { create_enemy(_num_samurai_zombie); }
					}
					if (enemies[1] ==  7) {
						create_enemy(_num_ghost_lord);
						while (enemies[2] > 0) {
							TEMP = int(Random(3));
							if (TEMP == 0) { create_enemy(_num_dark_galert); }
							if (TEMP == 1) { create_enemy(_num_skeleton_poleman); }
							if (TEMP == 2) { create_enemy(_num_little_death); }
						enemies[2] -= 1;
						}
					}
					if (enemies[1] ==  8) { create_enemy(_num_little_death); }
					if (enemies[1] ==  9) {
						if (int(Random(2))) { create_enemy(_num_dark_galert);
						} else { create_enemy(_num_little_death); }
					}
					if (enemies[1] == 10) {
						TEMP = int(Random(3));
						if (TEMP == 0) { create_enemy(_num_dark_galert); }
						if (TEMP == 1) { create_enemy(_num_little_death); }
						if (TEMP == 2) { create_enemy(_num_samurai_zombie); }
					}
					if (enemies[1] == 11) {
						if (Random(3) < 2) { create_enemy(_num_doom_dragon);
						} else { create_enemy(_num_little_death); }
					}
					if (enemies[1] == 12) { create_enemy(_num_dark_galert); }
					if (enemies[1] == 13) {
						create_enemy(_num_zombie_dragon);
						while (enemies[2] > 0) {
							TEMP = int(Random(3));
							if (TEMP == 0) { create_enemy(_num_dark_galert); }
							if (TEMP == 1) { create_enemy(_num_doom_dragon); }
						enemies[2] -= 1;
						}
					}
				}

				if (enemies[4] == _lvl_Ancientforest) {
					if (enemies[1] ==  1) { create_enemy(_num_risen_muck); }
					if (enemies[1] ==  2) { create_enemy(_num_the_ring); }
					if (enemies[1] ==  3) {
						if (int(Random(3))) { create_enemy(_num_risen_muck);
						} else { create_enemy(_num_the_ring); }
					}
					if (enemies[1] ==  4) { create_enemy(_num_acid_flan); }
					if (enemies[1] ==  5) {
						if (int(Random(3))) { create_enemy(_num_risen_muck);
						} else { create_enemy(_num_acid_flan); }
					}
					if (enemies[1] ==  6) {
						if (int(Random(3))) { create_enemy(_num_the_ring);
						} else { create_enemy(_num_acid_flan); }
					}
					if (enemies[1] ==  7) { create_enemy(_num_blood_rex); }
					if (enemies[1] ==  8) {
						if (int(Random(3))) { create_enemy(_num_blood_rex);
						} else { create_enemy(_num_acid_flan); }
					}
					if (enemies[1] ==  9) {
						create_enemy(_num_white_dragon);
						while (enemies[2] > 0) {
							TEMP = int(Random(2));
							if (TEMP == 0) { create_enemy(_num_risen_muck); }
							if (TEMP == 1) { create_enemy(_num_blood_rex); }
						enemies[2] -= 1;
						}
					}
					if (enemies[1] == 10) {
						if (int(Random(3))) { create_enemy(_num_risen_muck);
						} else { create_enemy(_num_acid_flan); }
					}
					if (enemies[1] == 11) { create_enemy(_num_abyss_mage); }
					if (enemies[1] == 12) {
						if (int(Random(3))) { create_enemy(_num_abyss_mage);
						} else { create_enemy(_num_acid_flan); }
					}
					if (enemies[1] == 13) {
						create_enemy(_num_doppelganger1);
						create_enemy(_num_doppelganger2);
						while (enemies[2] > 0) {
							TEMP = int(Random(3));
							if (TEMP == 0) { create_enemy(_num_abyss_mage); }
							if (TEMP == 1) { create_enemy(_num_acid_flan); }
							if (TEMP == 2) { create_enemy(_num_blood_rex); }
						enemies[2] -= 1;
						}
					}
				}

				if (enemies[4] == _lvl_Lostforest) {
					if (enemies[1] ==  1) { create_enemy(_num_blood_pudding); }
					if (enemies[1] ==  2) { create_enemy(_num_blade_demon); }
					if (enemies[1] ==  3) {
						if (int(Random(2))) { create_enemy(_num_blood_pudding);
						} else { create_enemy(_num_blade_demon); }
					}
					if (enemies[1] ==  4) {
						if (int(Random(3))) { create_enemy(_num_blood_pudding);
						} else { create_enemy(_num_blade_demon); }
					}
					if (enemies[1] ==  5) { create_enemy(_num_phoenix_dragon); }
					if (enemies[1] ==  6) {
						if (int(Random(2))) { create_enemy(_num_blood_pudding);
						} else { create_enemy(_num_phoenix_dragon); }
					}
					if (enemies[1] ==  7) {
						TEMP = int(Random(3));
						if (TEMP == 0) { create_enemy(_num_blood_pudding); }
						if (TEMP == 1) { create_enemy(_num_blade_demon); }
						if (TEMP == 2) { create_enemy(_num_phoenix_dragon); }
					}
					if (enemies[1] ==  8) {
						if (int(Random(2))) { create_enemy(_num_blade_demon);
						} else { create_enemy(_num_phoenix_dragon); }
					}
					if (enemies[1] ==  9) {
						create_enemy(_num_dawn_of_souls);
						while (enemies[2] > 0) {
							create_enemy(_num_blood_pudding);
						enemies[2] -= 1;
						}
					}
					if (enemies[1] == 10) { create_enemy(_num_elder_ghost); }
					if (enemies[1] == 11) {
						if (int(Random(2))) { create_enemy(_num_phoenix_dragon);
						} else { create_enemy(_num_elder_ghost); }
					}
					if (enemies[1] == 12) { create_enemy(_num_damned_sorcerer); }
					if (enemies[1] == 13) {
						if (int(Random(2))) { create_enemy(_num_blood_pudding);
						} else { create_enemy(_num_damned_sorcerer); }
					}
					if (enemies[1] == 14) {
						if (int(Random(2))) { create_enemy(_num_elder_ghost);
						} else { create_enemy(_num_damned_sorcerer); }
					}
					if (enemies[1] == 15) { create_enemy(_num_zombie_witch); }
					if (enemies[1] == 16) {
						if (int(Random(2))) { create_enemy(_num_phoenix_dragon);
						} else { create_enemy(_num_zombie_witch); }
					}
					if (enemies[1] == 17) {
						if (int(Random(2))) { create_enemy(_num_elder_ghost);
						} else { create_enemy(_num_zombie_witch); }
					}
					if (enemies[1] == 18) {
						create_enemy(_num_succubus_twins1);
						create_enemy(_num_succubus_twins2);
						while (enemies[2] > 0) {
							if (int(Random(2))) { create_enemy(_num_damned_sorcerer);
							} else { create_enemy(_num_zombie_witch); }
						enemies[2] -= 1;
						}
					}
				}

			enemies[2] -= 1;
			}
		}
	wait(1);
	}
}


function screenshots()
{
var number;

	while (1) {
		if (key_pressed(25)) {
			file_for_screen("starbattle.jpg", number);
			number = number + 1;
			while (key_pressed(25)) { wait(1); }
		}
	wait(1);
	}

	return;
}


function send_important_skills(entptr)
{
	me = entptr;

	// Now we got the character information and pass it through to the clients
	send_skill(my._Actor_class,		send_all); net_transfer += 4;
	send_skill(my._Actor_ID,			send_all); net_transfer += 4;
	send_skill(my._HP,					send_all); net_transfer += 4;	// Needed for the death-detection on the clients
	send_skill(my._MP,					send_all); net_transfer += 4;	// Needed for clients to define if they still can cast spells
	send_skill(my.X,						send_all + send_vec); net_transfer += 12;	// Send the positions of the actors
	send_skill(my._Level,				send_all); net_transfer += 4;
	send_skill(my._buff_Str,			send_all); net_transfer += 4;
	send_skill(my._buff_Dex,			send_all); net_transfer += 4;
	send_skill(my._buff_Agi,			send_all); net_transfer += 4;
	send_skill(my._buff_mpdef,			send_all); net_transfer += 4;
	send_skill(my._timer_battlerage,	send_all); net_transfer += 4;
	send_skill(my._timer_Agi,			send_all); net_transfer += 4;
	send_skill(my._timer_mpdef,		send_all); net_transfer += 4;

	// Just set, reset is done by the clients.
	if (my._Actor_pretransform) { send_skill(my._Actor_pretransform, send_all); net_transfer += 4; }

	return;
}


///////////////////////////////////////////////////////
// Character selection functions
function create_Dialog_text()
{
	str_cpy(dialog_text, actor_class.string[character_offset]);
	if (text_toggle[1] == 1) {
		str_cat(dialog_text, " level ");

		str_for_num(TEMP_STRING, load_character_level);
		str_cat(dialog_text, TEMP_STRING);
	}
	str_cat(dialog_text, player_description.string[character_offset]);

	return;
}

function character_selection(val)
{
var temp_character;

	show_dialog.visible = val;
	show_dialogtext.visible = val;
	show_NextStart.visible = val;
	show_NextStartText.visible = val;
//	characters.visible = val;
//	character_class.visible = val;
	if (val == on) {
		str_cpy(dialog_text, actor_class.string[0]);
		str_cat(dialog_text, player_description.string[0]);
		character_offset[0] = 0;
		character_offset[2] = 0;

		temp_character[0] = 1;	// Update immediately
		temp_character[1] = 0;
		while (show_NextStart.visible == on) {
			if (temp_character[0] != character_offset[0]) {
				temp_character[0] = character_offset[0];
				temp_character[2] = get_character_file(temp_character[0]);

				if (temp_character[2]) {
					temp = 0;	// Skill._Level == Skill59
					while (temp < 59) {
						load_character_level = file_var_read(temp_character[2]);
					temp += 1;
					}
					file_close(temp_character[2]);
					temp_character[1] = 1;

					show_NextStartText.string = "Next\n\n\nLoad";
				} else {
					temp_character[1] = 0;

					show_NextStartText.string = "Next\n\n\nStart";
				}

				text_toggle[0] = 0;
				text_toggle[1] = 0;
			}

			if (temp_character[1] == 1) {
				text_toggle[0] -= time;
				if (text_toggle[0] < 0) {
					text_toggle[0] += 48;

					if (text_toggle[1] == 1) {
						text_toggle[1] = 0;
						show_NextStartText.string = "Next\n\n\nStart";
					} else {
						text_toggle[1] = 1;
						show_NextStartText.string = "Next\n\n\nLoad";
					}
					create_Dialog_text();
				}
			}
		wait(1);
		}
	}
}

function toggle_character(button_number)
{
	IF (button_number == 1) {
		character_offset += 1;
		character_offset %= 4;

		character_offset[2] = 256 * character_offset;

		create_Dialog_text();
//		character_class.string = actor_class.string[character_offset];
	} ELSE {
		character_selection(OFF);
/*
		// The Name has to have at least 2 characters
		character_class.visible = ON;	// We use the character_class text to give in our character's name
		character_class.string = player_name_to_server;
		WHILE (STR_LEN(player_name_to_server) < 2) {	// A Name must be entered
			STR_CPY(player_name_to_server, "Name");

			inkey(player_name_to_server);
		}

		character_class.visible = OFF;
		SEND_STRING(player_name_to_server); net_transfer += STR_LEN(player_name_to_server);	// After we've got the name we can send it to the server
*/

		create_player(character_offset);
		snd_play(charsel, 100, 0);
	}

	return;
}

function start_game(button_number)
{
	// Host game selected
	if (button_number == 1) {
		exec("starbattle.exe", "-black -sv -cl");	// Start as server/client-hybrid
		exit;	// exit current game
	} else {
		// "0.0.0.0"
		if (str_len(server_ip >= 7)) {
			str_cpy(TEMP_STRING, "-black -cl -ip ");	// Start as client and connect to given IP
			str_cat(TEMP_STRING, server_ip);
			exec("starbattle.exe", TEMP_STRING);
			exit;	// exit current game
		} else {
			exec("starbattle.exe", "-black -cl");	// Start as client
			exit;	// exit current game
		}
	}

	return;
}


///////////////////////////////////////////////////////
// Other functions

function Action_messages(str)
{
var timer;	// 24 Ticks == 1.5 sec.

	WHILE (timer < 24) {
		VEC_SET (TEMP.X, MY.X);
		VEC_TO_SCREEN (TEMP.X, CAMERA);

		draw_text(str, (TEMP.X - 19 + timer * 1.2), (TEMP.Y - 39 - FSIN((6 * timer), 48)), vector(  0,   0,   0));
		draw_text(str, (TEMP.X - 20 + timer * 1.2), (TEMP.Y - 40 - FSIN((6 * timer), 48)), vector(144, 144,   0));

		timer += TIME;
	WAIT (1);
	}
}

function Action_damage(number, colorID)
{
var timer;
var color_vec;
var position;

	// Use the given colorID to set the color vector
	IF (colorID == 1) { VEC_SET(color_vec.X, vector(  0,   0, 255)); }
	IF (colorID == 2) { VEC_SET(color_vec.X, vector(  0, 144, 144)); }
	IF (colorID == 3) { VEC_SET(color_vec.X, vector(255,   0,   0)); }

	VEC_SET(position.X, MY.X);
	timer[2] = 1 + Random(0.2);

	wait(1);	// otherwise _Action_HP doubles

	WHILE ((me) && (timer < 24)) {
		if ((my._Action_HP != 0) && (timer < 16) && (sign(number) == sign(my._Action_HP))) {
			number += my._Action_HP;
			my._Action_HP = 0;
		}

		VEC_SET (TEMP.X, position.X);
		VEC_TO_SCREEN (TEMP.X, CAMERA);

		STR_FOR_NUM(TEMP_STRING, INT(ABS(number) + 0.5));
		draw_text(TEMP_STRING, (TEMP.X - 7 + timer * timer[2]), (TEMP.Y - 31 - FSIN((6 * timer), 32 * timer[2])), vector(0, 0, 0));
		draw_text(TEMP_STRING, (TEMP.X - 8 + timer * timer[2]), (TEMP.Y - 32 - FSIN((6 * timer), 32 * timer[2])), color_vec.X);

		timer += TIME;
	WAIT (1);
	}
}

function Action_digit(digit_number, hp_number, mp_number)
{
var timer;
var position;
var digit_data;	// 0-current value; 1-number of digits; 2-scalation

	you = me;
	while (1) {
		if (hp_number > 0) {
			me = ent_createlocal("redfont+11.bmp", nullvector, null);
			break;
		}
		if (hp_number < 0) {
			me = ent_createlocal("greenfont+11.bmp", nullvector, null);
			break;
		}
		if (mp_number > 0) {
			me = ent_createlocal("bluefont+11.bmp", nullvector, null);
			break;
		}
		return;
	}

	my.unlit = on;
	my.ambient = 100;
	my.overlay = on;
	my.transparent = on;
	my.alpha = 100;
	my.facing = on;
	my.passable = on;

	while ((you) && (timer < 24)) {
		temp = off;
		if (digit_data[0] == 0) {
			digit_data[0] = abs(hp_number) + abs(mp_number);
			temp = on;
		} else {
			if (sign(your._Action_HP) == sign(hp_number)) {
				digit_data[0] += abs(your._Action_HP);
				if (digit_number == 0) { your._Action_HP = 0; }
				temp = on;
			}
			if (sign(your._Action_MP) == sign(mp_number)) {
				digit_data[0] += abs(your._Action_MP);
				if (digit_number == 0) { your._Action_MP = 0; }
				temp = on;
			}
		}

		if (temp == on) {
			str_for_num(temp_string, int(digit_data[0] + 0.5));
			digit_data[1] = str_len(temp_string);

			while (1) {
				if (digit_data[0] < 10) {
					digit_data[2] = 5;
					break;
				}
				if (digit_data[0] < 50) {
					digit_data[2] = 8;
					break;
				}
				if (digit_data[0] < 100) {
					digit_data[2] = 10;
					break;
				}
				if (digit_data[0] < 150) {
					digit_data[2] = 12;
					break;
				}
				if (digit_data[0] < 200) {
					digit_data[2] = 15;
					break;
				}
				if (digit_data[0] < 300) {
					digit_data[2] = 20;
					break;
				}
				if (digit_data[0] < 500) {
					digit_data[2] = 28;
					break;
				}
				digit_data[2] = 35;
				break;
			}

			my.scale_x = digit_data[2] / 10;
			my.scale_y = my.scale_x;

			temp = digit_data[1] - 1;
			if (temp < digit_number) {
				my.frame = 11;
			} else {
				while (temp > digit_number) {
					str_clip(temp_string, 1);
					temp -= 1;
				}

				my.frame = str_to_asc(temp_string) - 47;
			}
		}

		position.y = (digit_data[1] * 0.5 * digit_data[2] + (digit_data[2] * (digit_number - digit_data[1])) - timer + digit_data[2]);
		position.z = 16 + fsin(6 * timer, 32);

		vec_set(my.x, position.x);
		vec_rotate(my.x, vector(camera.pan, 0, 0));
		vec_add(my.x, your.x);

		if (timer > 19) {
			my.alpha = 100 - max(0, (timer - 19) * 20);
		}

		timer += time;
	wait(1);
	}

	ent_remove(me);
	return;
}

function Action_number()
{
	Action_digit(3, my._Action_HP, my._Action_MP);
	Action_digit(2, my._Action_HP, my._Action_MP);
	Action_digit(1, my._Action_HP, my._Action_MP);
	Action_digit(0, my._Action_HP, my._Action_MP);
	return;
}

function Action_image(image_number)
{
var timer;
var position;

	you = me;
	while (1) {
		if (image_number == _msg_miss) {
			me = ent_createlocal("act_miss.bmp", nullvector, null);
			break;
		}
		if (image_number == _msg_critical) {
			me = ent_createlocal("act_critical.bmp", nullvector, null);
			break;
		}
		if (image_number == _msg_counter) {
			me = ent_createlocal("act_counter.bmp", nullvector, null);
			break;
		}
		if (image_number == _msg_mpdef_up) {
			me = ent_createlocal("act_defup.bmp", nullvector, null);
			break;
		}
		if (image_number == _msg_mpdef_dn) {
			me = ent_createlocal("act_defdown.bmp", nullvector, null);
			break;
		}
		if (image_number == _msg_agi_up) {
			me = ent_createlocal("act_agiup.bmp", nullvector, null);
			break;
		}
		if (image_number == _msg_agi_dn) {
			me = ent_createlocal("act_agidown.bmp", nullvector, null);
			break;
		}
		if (image_number == _msg_thorns) {
			me = ent_createlocal("act_thorns.bmp", nullvector, null);
			break;
		}
		if (image_number == _msg_raisebuffs) {
			me = ent_createlocal("act_raisebuffs.bmp", nullvector, null);
			break;
		}
		if (image_number == _msg_levelup) {
			me = ent_createlocal("act_levelup.bmp", nullvector, null);
			break;
		}
		if (image_number == _msg_formreturned) {
			me = ent_createlocal("act_formret.bmp", nullvector, null);
			break;
		}
		if (image_number == _msg_valkmight) {
			me = ent_createlocal("act_valkmight.bmp", nullvector, null);
			break;
		}
		if (image_number == _msg_thornaura) {
			me = ent_createlocal("act_thornaura.bmp", nullvector, null);
			break;
		}
		if (image_number == _msg_revleap) {
			me = ent_createlocal("act_revleap.bmp", nullvector, null);
			break;
		}
		if (image_number == _msg_drawaggro) {
			me = ent_createlocal("act_drawaggro.bmp", nullvector, null);
			break;
		}
		if (image_number == _msg_battlerage) {
			me = ent_createlocal("act_battlerage.bmp", nullvector, null);
			break;
		}

		return;
	}

	my.unlit = on;
	my.ambient = 100;
	my.overlay = on;
	my.transparent = on;
	my.alpha = 100;
	my.facing = on;
	my.passable = on;

	my.scale_x = 0.6;
	my.scale_y = my.scale_x;

	while ((you) && (timer < 24)) {
		position.y = -1.2 * timer;
		position.z = 24 + fsin(6 * timer, 48);

		vec_set(my.x, position.x);
		vec_rotate(my.x, vector(camera.pan, 0, 0));
		vec_add(my.x, your.x);

		if (timer > 19) {
			my.alpha = 100 - max(0, (timer - 19) * 20);
		}

		timer += time;
	wait(1);
	}

	ent_remove(me);
	return;
}


// Every actor on every client creates his own shadow, there is no global shadow. 2 Players thus have 4 shadows, 2 for the 2 players on the client and 2 for the 2 players on the server. 3 players have 9 shadows ect.
function shadowsprite()
{
	proc_late();	// Otherwise the shadow would be 1 frame behind it's actor when he moves.

	MY.TRANSPARENT = ON;
	MY.PASSABLE = ON;
	MY.ORIENTED = ON;
	MY.TILT = 90;

	VEC_NORMALIZE(MY.SCALE_X, (YOUR.MAX_Z / 25));

	MY.Z = 1;
	WHILE (YOU) {
		MY.X = YOUR.X;
		MY.Y = YOUR.Y;

		MY.ALPHA = 0.8 * YOUR.ALPHA;	// Fade shadow, too.
	wait(1);
	}

	ENT_REMOVE(ME);
	RETURN;
}

function multibar()
{
	MY._anime = MAX(1, INT(TEMP));	// TEMP has to be set to 1, 2, 3 or 4 before creating the entity.

	proc_late();	// Otherwise the shadow would be 1 frame behind it's actor when he moves.

	MY.PASSABLE = ON;
	MY.OVERLAY = OFF;	// sprites have overlay by default, but we don't need it for the HP-bar
	MY.TRANSPARENT = OFF;
	MY.ALPHA = 100;

	VEC_NORMALIZE(MY.SCALE_X, 0.5);	// Make it a bit smaller

	// Wait until the actor's stats have been initialized to avoid division by zero
	WHILE (YOU) {
		IF (YOUR._Vit != 0) { break; }
	WAIT (1);
	}

	WHILE (YOU) {
		VEC_DIFF(MY.X, CAMERA.X, YOUR.X);
		VEC_NORMALIZE(MY.X, 32);
		VEC_ADD(MY.X, YOUR.X);

		TEMP = 0.5;
		MY.Z -= YOUR.MAX_Z - 10;

		// HP bar
		IF (MY._anime == 1) {
			IF (YOUR._you_save != 0) {
				TEMP_ENT = YOUR._you_save;
				MY.SCALE_X = TEMP * (TEMP_ENT._HP / TEMP_ENT._Vit);

				MY.SCALE_X *= 0.25;
				MY.SCALE_Y = 0.125;

				MY.Z -= 12;
			} ELSE {
				MY.SCALE_X = TEMP * (YOUR._HP / YOUR._Vit);
			}
		}

		// MP bar
		IF (MY._anime == 2) {
			MY.Z -= 8 * TEMP;
			MY.SCALE_X = TEMP * (YOUR._MP / YOUR._Int);
		}

		// action bar below MP bar
		IF (MY._anime == 3) {
			MY.Z -= 16 * TEMP;
			IF ((MY._action_timer < 0) && (MY._reset_timer > 0)) {
				MY.SCALE_X = TEMP * (1 - MY._reset_timer / 24);
			} ELSE {
				MY.SCALE_X = TEMP * (YOUR._action_timer / _action_time);
			}
		}

		// action bar below HP bar
		IF (MY._anime == 4) {
			MY.Z -= 8 * TEMP;
			IF ((MY._action_timer < 0) && (MY._reset_timer > 0)) {
				MY.SCALE_X = TEMP * (1 - MY._reset_timer / 24);
			} ELSE {
				MY.SCALE_X = TEMP * (YOUR._action_timer / _action_time);
			}

			IF (YOUR._you_save != 0) {
				MY.SCALE_X *= 0.25;
				MY.SCALE_Y = 0.125;

				MY.Z -= 10;
			}
		}

		MY.INVISIBLE = IIf(MY.SCALE_X <= 0, ON, OFF);
	WAIT (1);
	}

	ENT_REMOVE(ME);
	RETURN;
}

// Everywhere I'm adding 4 or 12 to net_transfer, those are the bytes which are being send. This function updates the shown text every second.
function transfer_text()
{
	WHILE (1) {
		STR_CPY(show_netstats, "Bytes sent within the last second: ");
		STR_FOR_NUM(TEMP_STRING, net_transfer);
		STR_CAT(show_netstats, TEMP_STRING);
		STR_CAT(show_netstats, "\nFrames per second: ");
		STR_FOR_NUM(TEMP_STRING, INT(16 / TIME));
		STR_CAT(show_netstats, TEMP_STRING);

		net_transfer = 0;
	WAITT(16);
	}
}


///////////////////////////////////////////////////////
// Multiplayer control
function activate_nosend(entptr)
{
	ME = entptr;
	MY.nosend_origin = ON;	// we do that locally most of the time
	MY.nosend_angles = ON;	// not necessary for sprites
	MY.nosend_frame  = ON;	// we animate locally
	MY.nosend_scale  = ON;	// this is done locally, too, +1 / -1 to define in which direction depending on the camera angle the sprite is looking.
	MY.nosend_skin   = ON;	// we won't need that since we're using sprite actors
	MY.nosend_color  = ON;
	MY.nosend_alpha  = ON;
}

function get_target_position(ent_ptr, ent_handle)
{
	ME = ent_ptr;
	YOU = ptr_for_handle(ent_handle);

	VEC_DIFF(TEMP.X, YOUR.X, MY.X);
	VEC_NORMALIZE(TEMP.X, (VEC_LENGTH(TEMP.X) - 72));
	VEC_ADD(TEMP.X, MY.X);

	VEC_SET(MY._Action_target_X, TEMP.X);

	return;
}

// for thorn aura or sudden counter dmg in common, wheren the attacking entity has to get dmg, too.
function inverseCounter(ent_ptr)
{
	you = me;
	me = ent_ptr;
	counter_calculation(you);

	return;
}

function counter_calculation(ent_ptr)
{
	YOU = ent_ptr;

	IF (YOUR._HP > 0) {
		// Calculate counter attack chance, if MY._Agi == 100 the actor counters 25%.
		IF ((Random(100) < (YOUR._Agi + YOUR._buff_Agi) / 4) && (YOU != ME)) {
			YOUR._ActReq_handle = handle(ME);	// Define who the actor shall counter attack
			YOUR._ActReq_ID = _action_counter;
//				get_target_position(YOU, YOUR._ActReq_handle);	// To know where the countering actor has to go to after far distance attacks
//
//				SEND_SKILL(YOUR._Action_target_X, SEND_ALL + SEND_VEC); net_transfer += 12;
			SEND_SKILL(YOUR._ActReq_handle, SEND_ALL); net_transfer += 4;

			// Set the "Counter!" ID and send it. The countering actor shouts "Counter!".
//			YOUR._Action_msg = _msg_counter;
//			SEND_SKILL(YOUR._Action_msg, SEND_ALL); net_transfer += 4;
		} ELSE {
			YOUR._ActReq_ID = _action_pain;
		}

		IF ((YOUR._Actor_ID == _ID_Enemy) && (10 > Random(100))) {
			YOUR._emote_req = -(INT(Random(3)) + 7);
			SEND_SKILL(YOUR._emote_req, NULL); net_transfer += 4;
		}

	} ELSE {
		YOUR._HP = 0;

		gain_exp(YOUR._Actor_class);	// exp and gold

		my._kills += 1;
		send_skill(my._kills, send_all); net_transfer += 4;

//		my._gold = min(9999, my._gold + int(enemy_exp[YOUR._Actor_class] / 2));	// give gold in value of 1/1 of exp
//		send_skill(my._gold, null); net_transfer += 4;

		if ((YOUR._Actor_ID == _ID_Enemy) && (16 > Random(100))) {
			YOUR._emote_req = -2;
			send_skill(YOUR._emote_req, NULL); net_transfer += 4;
		}
	}

	RETURN;
}



function avatar_counting()
{
	WAIT (8);
	WHILE (1) {
		avatar_counter[0] = 0;
		avatar_counter[1] = 0;

		YOU = ENT_NEXT(NULL);
		WHILE (YOU) {
			TEMP_ENT = YOUR._you_save;
			IF (TEMP_ENT) {
				IF (TEMP_ENT._Actor_ID == _ID_Player) {
					YOUR._avatar_ID = avatar_counter[0];
					avatar_counter[0] += 1;
				}
				IF (TEMP_ENT._Actor_ID == _ID_Enemy) {
					YOUR._avatar_ID = avatar_counter[1];
					avatar_counter[1] += 1;
				}
			}
		YOU = ENT_NEXT(YOU);
		}
	WAIT (1);
	}
}

function create_morph_string(class, Actor_ID)
{
	str_cpy(TEMP_STRING, actor_class.string[class]);

	if (Actor_ID == _ID_Enemy) {
		str_cat(TEMP_STRING, "+12.bmp");
	} else {
		str_cat(TEMP_STRING, "+15.bmp");
	}

	return;
}

function rescale_actor_pic(entptr)
{
	me = entptr;

	you = ent_next(null);
	while (you) {
		if (your._you_save == entptr) {
			your._Actor_class = my._Actor_class;

			create_morph_string(my._Actor_class, my._Actor_ID);
			ent_morph(you, TEMP_STRING);

			wait(1);
			vec_normalize(your.scale_x, (15 / my.max_z));
			break;
		}
	you = ent_next(you);
	}

	return;
}

function create_actor_pic()
{
	YOU = ME;

	STR_CPY(TEMP_STRING, "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
	str_for_entfile(TEMP_STRING, ME);
	ME = ENT_CREATELOCAL(TEMP_STRING, NULLVECTOR, NULL);

	activate_nosend(ME);

	MY.FACING = ON;
	MY.OVERLAY = ON;
	MY.TRANSPARENT = ON;
	MY.ALPHA = 100;

	MY._you_save = YOU;
	MY._Actor_class = YOUR._Actor_class;
	vec_normalize(my.scale_x, (15 / your.max_z));

	set_stats(on);

	TEMP = 1;
	ENT_CREATELOCAL("hpbar.bmp", MY.X, multibar);

	if (you == player) {
		TEMP = 4;
		ENT_CREATELOCAL("actionbar.bmp", MY.X, multibar);
	}

	WHILE (YOU) {
		IF ((YOUR._HP <= 0) && (YOUR._Actor_ID == _ID_Enemy)) {
			wait(1);
			if (your._HP <= 0) { break; }
		}

		MY.LIGHT = IIf(YOUR.LIGHT == ON, ON, OFF);
		MY.RED   = YOUR.RED;
		MY.GREEN = YOUR.GREEN;
		MY.BLUE  = YOUR.BLUE;

		MY._HP = YOUR._HP;
		MY._action_timer = YOUR._action_timer;
		MY.FRAME = YOUR.FRAME;

		IF (YOUR._Actor_ID == _ID_Player) {
			VEC_SET(MY.X, vector(256, (10 * avatar_counter[0] - 20 * (MY._avatar_ID + 0.5)), -70));
		}
		IF (YOUR._Actor_ID == _ID_Enemy) {
			VEC_SET(MY.X, vector(256, (10 * avatar_counter[1] - 20 * (MY._avatar_ID + 0.5)), -90));
		}
		VEC_ROTATE(MY.X, CAMERA.PAN);

		VEC_ADD(MY.X, CAMERA.X);
	WAIT (1);
	}

	ENT_REMOVE(ME);
	RETURN;
}


function transform_actor(entptr, class)
{
	if (connection != 3) { return; }

	if (my._Boss == on) {
		my._Action_msg = _msg_miss;
		send_skill(my._Action_msg, send_all); net_transfer += 4;
		return;
	}

	me = entptr;

	if (class == 0) {
		class = int(random(6)) + 4;
	}

	my._Actor_pretransform = my._Actor_class;
	my._Actor_class = class;
	my._timer_transform = 2 * 60 * 16;
//	send_skill(my._Actor_class, send_all); net_transfer += 4;
//	send_skill(my._Actor_pretransform, send_all); net_transfer += 4;
	send_skill(my._timer_transform, send_all); net_transfer += 4;

	set_stats(off);
	send_important_skills(entptr);

	return;
}


function buff_actor(entptr, buffID)
{
var timer;

	ME = entptr;

	// mpdef
	IF (buffID == 6) {
		MY._buff_mpdef = 10;	// No need to send def since damage is only calculated on the server
		SEND_SKILL(MY._buff_mpdef, SEND_ALL); net_transfer += 4;

		// Set the "Defence up!" ID and send it.
		MY._Action_msg = _msg_mpdef_up;
		SEND_SKILL(MY._Action_msg, SEND_ALL); net_transfer += 4;


		MY._timer_mpdef = 6 * 60 * 16;
		SEND_SKILL(MY._timer_mpdef, SEND_ALL); net_transfer += 4;

		WHILE (ME) {
			IF (MY._timer_mpdef < 0) { break; }
		WAIT (1);
		}

		IF (!ME) { RETURN; }	// Maybe the actor does not exist anymore


		MY._buff_mpdef = 0;	// No need to send def since damage is only calculated on the server
		SEND_SKILL(MY._buff_mpdef, SEND_ALL); net_transfer += 4;

		// Set the "Defence down!" ID and send it.
		MY._Action_msg = _msg_mpdef_dn;
		SEND_SKILL(MY._Action_msg, SEND_ALL); net_transfer += 4;
	}
	// agi
	IF (buffID == 7) {
		MY._buff_agi = 75;	// We must send this one because the action bar is calculated on the clients
		SEND_SKILL(MY._buff_agi, SEND_ALL); net_transfer += 4;	// It is enough to send it to the player of this actor

		// Set the "Agility up!" ID and send it.
		MY._Action_msg = _msg_agi_up;
		SEND_SKILL(MY._Action_msg, SEND_ALL); net_transfer += 4;


		MY._timer_agi = 6 * 60 * 16;
		SEND_SKILL(MY._timer_agi, SEND_ALL); net_transfer += 4;

		WHILE (ME) {
			IF (MY._timer_agi < 0) { break; }
		WAIT (1);
		}

		IF (!ME) { RETURN; }	// Maybe the actor does not exist anymore


		MY._buff_agi = 0;	// We must send this one because the action bar is calculated on the clients
		SEND_SKILL(MY._buff_agi, SEND_ALL); net_transfer += 4;	// It is enough to send it to the player of this actor

		// Set the "Agility down!" ID and send it.
		MY._Action_msg = _msg_agi_dn;
		SEND_SKILL(MY._Action_msg, SEND_ALL); net_transfer += 4;
	}
	// drawaggro
	IF (buffID == 8) {
		TEMP[0] = 0;
		WHILE (TEMP[0] < 4) {
			IF (current_player[TEMP[0]] != 0) {
				YOU = ptr_for_handle(current_player[TEMP[0]]);
				IF (YOU) {
					IF (ME != YOU) {
						TEMP[1] = YOUR._Aggro * 0.5;
						MY._Aggro += TEMP[1];
						YOUR._Aggro = TEMP[1];
					}
				}
			}
		TEMP[0] += 1;
		}

		MY._timer_drawaggro = 0;
		SEND_SKILL(MY._timer_drawaggro, NULL); net_transfer += 4;
	}
	// battlerage
	IF (buffID == 9) {
		MY._buff_Str = 75;
		MY._buff_Dex = 200;

		SEND_SKILL(MY._buff_Str, SEND_ALL); net_transfer += 4;
		SEND_SKILL(MY._buff_Dex, SEND_ALL); net_transfer += 4;

		MY._timer_battlerage = 60 * 16;
		SEND_SKILL(MY._timer_battlerage, SEND_ALL); net_transfer += 4;

		WHILE (ME) {
			IF (MY._timer_battlerage < 0) { break; }
		WAIT (1);
		}

		IF (!ME) { RETURN; }	// Maybe the actor does not exist anymore


		MY._buff_Str = 0;
		MY._buff_Dex = 0;

		SEND_SKILL(MY._buff_Str, SEND_ALL); net_transfer += 4;
		SEND_SKILL(MY._buff_Dex, SEND_ALL); net_transfer += 4;
	}

	// thronaura
	if (buffID == 11) {
		my._timer_thornaura = 5 * 60 * 16;
		send_skill(my._timer_thornaura, send_all); net_transfer += 4;
	}

	// raisebuffs
	if (buffID == 14) {
		you = ent_next(null);
		while (you) {
			if (your._Actor_ID == my._Actor_ID) {
				temp = off;

				if (your._timer_agi > 0) {
					temp = on;

					your._timer_agi = min(999, your._timer_agi + 60 * 16);	// +60 sec.
					send_skill(your._timer_agi, send_all);
				}
				if (your._timer_mpdef > 0) {
					temp = on;

					your._timer_mpdef = min(999, your._timer_mpdef + 60 * 16);	// +60 sec.
					send_skill(your._timer_mpdef, send_all);
				}
				if (your._timer_battlerage > 0) {
					temp = on;

					your._timer_battlerage = min(99, your._timer_battlerage + 60 * 16);	// +60 sec
					send_skill(your._timer_battlerage, send_all);
				}

				if (temp) {
					my._Action_msg = _msg_raisebuffs;
					send_skill(my._Action_msg, send_all);
				}
			}
		you = ent_next(you);
		}
	}

	RETURN;
}


function gain_exp(_num_killed)
{
	_num_killed = enemy_exp[_num_killed];	// Get exp

	TEMP[0] = 0;
	TEMP[1] = 0;
	WHILE (TEMP[0] < 4) {
		IF (current_player[TEMP[0]] != 0) {
			YOU = ptr_for_handle(current_player[TEMP[0]]);
			IF (YOU) {
				TEMP[1] += 1;
			}
		}
	TEMP[0] += 1;
	}

	TEMP[0] = 0;
	WHILE (TEMP[0] < 4) {
		IF (current_player[TEMP[0]] != 0) {
			you = ptr_for_handle(current_player[TEMP[0]]);
			if (you) {
				if (your._HP > 0) {

					if (you == me) {
						your._gold = min(99999, your._gold + int((1.1 * _num_killed) / (2 * TEMP[1])));
					} else {
						your._gold = min(99999, your._gold + int(_num_killed / (2 * TEMP[1])));
					}
					send_skill(your._gold, null); net_transfer += 4;

					if (YOUR._Level < 20) {
						if (you == me) {	// The player who defeated the enemie gains more exp
							YOUR._exp += 1.2 * _num_killed / TEMP[1];
						} else {
							YOUR._exp += _num_killed / TEMP[1];
						}

						TEMP[2] = pow(1.3, YOUR._Level);

						if (YOUR._exp > 125 * TEMP[2]) {
							YOUR._LevelUp = YOUR._Level + 1;
							YOUR._exp = 0;
							SEND_SKILL(YOUR._LevelUp, SEND_ALL); net_transfer += 4;
						}
					}
				}
			}
		}
	TEMP[0] += 1;
	}
}


function get_magic_weakness(Weakness, Spell)
{
	if (Weakness == 0) { return(1); }

	if (Weakness == _light) {
		if ((Spell == 2) || (Spell == 10) || (Spell == 15)) {
			return(1.5);
		}
	}

	if (Weakness == _ice) {
		if ((Spell == 3) || (Spell == 11)) {
			return(1.5);
		}
	}

	if (Weakness == _lightning) {
		if (Spell == 4) {
			return(1.5);
		}
	}

	if (Weakness == _earth) {
		if ((Spell == 5) || (Spell == 12) || (Spell == 14)) {
			return(1.5);
		}
	}

	// Spell 13 and Regena 13
	if (Weakness == _fire) {
		if ((Spell == 8) || (Spell == 9) || (Spell == 13)) {
			return(1.5);
		}
	}

	return(1);
}


function get_temp_dmg(spell_id, me_ptr, you_ptr)
{
	me = me_ptr;
	you = you_ptr;

	my._temp_dmg = (my._mdam * (0.5 + (my._Wis / 200))) * (1 + Random(0.5));	// base damage: 1 times
//	if (your._weakness == my._Action_spell) { my._temp_dmg *= 1.5; }
	my._temp_dmg *= get_magic_weakness(your._weakness, my._Action_spell);

	return(my._temp_dmg);
}


function area_of_effect(damage, range)
{
var Actor_ID;

	IF (MY._Actor_ID == _ID_Player) { Actor_ID = _ID_Enemy; } ELSE { Actor_ID = _ID_Player; }

	TEMP = 1;
	YOU = ENT_NEXT(NULL);
	WHILE (YOU) {
		IF ((YOUR._Actor_ID == Actor_ID) && (YOUR._HP > 0) && (rel_dist(YOUR.X, AoE_Position.X) < range)) {
			TEMP *= 0.85;
			IF (TEMP < 0.5) {
				TEMP = 0.5;
				break;
			}
		}
		YOU = ENT_NEXT(YOU);
	}

	damage *= TEMP;

	YOU = ENT_NEXT(NULL);
	WHILE (YOU) {
		IF ((YOUR._Actor_ID == Actor_ID) && (YOUR._HP > 0) && (rel_dist(YOUR.X, AoE_Position.X) < range)) {
			// Activate a spell
//			MY._temp_dmg = (MY._mdam * (0.5 + (MY._Wis / 200))) * (1 + Random(0.5));	// base damage: 1 times
//			IF (YOUR._weakness == MY._Action_spell) { MY._temp_dmg *= 1.5; }


			YOUR._Action_HP = MAX(1, (damage * get_temp_dmg(MY._Action_spell, ME, YOU) - (YOUR._mdef + YOUR._buff_mpdef)));
			YOUR._HP -= YOUR._Action_HP;
			MY._Aggro += ABS(YOUR._Action_HP);


			YOUR._HP = MAX(0, MIN(YOUR._HP, YOUR._Vit));	// Can't get more hitpoints than vitality
			counter_calculation(YOU);
			SEND_SKILL(YOUR._ActReq_ID, SEND_ALL); net_transfer += 4;

			SEND_SKILL(YOUR._Action_HP, SEND_ALL); net_transfer += 4;
			SEND_SKILL(YOUR._HP, SEND_ALL); net_transfer += 4;
		}
		YOU = ENT_NEXT(YOU);
	}

	RETURN;
}


function attack_area(entptr, damage, range)
{
var Actor_ID;

	victim = entptr;

	IF (MY._Actor_ID == _ID_Player) { Actor_ID = _ID_Enemy; } ELSE { Actor_ID = _ID_Player; }

	TEMP = 1;
	YOU = ENT_NEXT(NULL);
	WHILE (YOU) {
		IF ((YOUR._Actor_ID == Actor_ID) && (YOUR._HP > 0) && (rel_dist(YOUR.X, victim.X) < range)) {
			TEMP *= 0.9;
			IF (TEMP < 0.6) {
				TEMP = 0.7;
				break;
			}
		}
		YOU = ENT_NEXT(YOU);
	}

	damage *= TEMP;

	YOU = ENT_NEXT(NULL);
	WHILE (YOU) {
		IF ((YOUR._Actor_ID == Actor_ID) && (YOUR._HP > 0) && (rel_dist(YOUR.X, victim.X) < range)) {
			// Calculate hit chance, max 95%.
			IF (Random(100) < MIN(95, (MY._Dex + MY._buff_Dex))) {
				// Calculate damage and send the resulting HP to the clients, activate "Pain" for the hit entity
				MY._temp_dmg = (MY._pdam * (0.5 + ((MY._Str + MY._buff_Str) / 200)) * (1 + Random(0.5)));
				IF (Random(100) < (MY._Dex + MY._buff_Dex) * 0.25) {
					MY._temp_dmg *= 1.5;

					// Set the "Critical!" ID and send it. The hit actor shows the "Critical!" message.
					YOUR._Action_msg = _msg_critical;
					SEND_SKILL(YOUR._Action_msg, SEND_ALL); net_transfer += 4;
				}

				your._Action_HP = max(1, (damage * my._temp_dmg - (your._pdef + your._buff_mpdef)));	// defence + buffed defence
				your._HP -= your._Action_HP;
				my._Aggro += abs(your._Action_HP);
				counter_calculation(you);

				send_skill(your._Action_HP, send_all); net_transfer += 4;
				send_skill(your._HP, send_all); net_transfer += 4;
				send_skill(your._Action_ID, send_all); net_transfer += 4;

				if (your._timer_thornaura > 0) {
					my._Action_HP = max(1, (0.75 * damage * my._temp_dmg - (my._pdef + my._buff_mpdef)));	// defence + buffed defence
					my._HP -= my._Action_HP;
					my._Action_msg = _msg_thorns;
					your._Aggro += abs(my._Action_HP);
					if (my._HP <= 0) { inverseCounter(you); }

					send_skill(my._Action_HP, send_all); net_transfer += 4;
					send_skill(my._HP, send_all); net_transfer += 4;
					send_skill(my._Action_ID, send_all); net_transfer += 4;
					send_skill(my._Action_msg, send_all); net_transfer += 4;
				}

			} ELSE {
				// Set the "Miss!" ID and send it. The missed actor shows the "Miss!" message.
				YOUR._Action_msg = _msg_miss;
				SEND_SKILL(YOUR._Action_msg, SEND_ALL); net_transfer += 4;
			}
		}
		YOU = ENT_NEXT(YOU);
	}

	RETURN;
}


function cast_damage_delay(spell_id)
{
var target_position;
var pain_switch;
var cnt;

	YOU = victim;
	IF (!YOU) { RETURN; }

	VEC_SET(target_position.X, YOUR.X);

	pain_switch = ON;	// Send pain?
	IF (spell_id == 1) {	// heal
		WAITT (6);	// Wait until the effect has reached a certain point
		IF (!YOU) { RETURN; }

		// add further undead here
		IF ((YOUR._Actor_class == _num_skeleton) || (YOUR._Actor_class == _num_skeleton_poleman) || (YOUR._Actor_class == _num_samurai_zombie) || (YOUR._Actor_class == _num_little_death) || (YOUR._Actor_class == _num_ghost_lord) || (YOUR._Actor_class == _num_zombie_witch) || (your._Actor_class == _num_zombie_dragon)) {
			YOUR._Action_HP = MAX(1, (2.0 * get_temp_dmg(spell_id, ME, YOU) - (YOUR._mdef + YOUR._buff_mpdef)));
			YOUR._HP -= YOUR._Action_HP;
			MY._Aggro += ABS(YOUR._Action_HP);
		} ELSE {
			pain_switch = OFF;	// deactivate pain
			IF (YOUR._HP > 0) {
				YOUR._Action_HP = -MIN(YOUR._Vit - YOUR._HP, MAX(1, 2 * get_temp_dmg(spell_id, ME, YOU)));
				YOUR._HP -= YOUR._Action_HP;
				MY._Aggro += ABS(YOUR._Action_HP);
			}
		}
		MY._MP -= _mp_heal;
	}
	IF (spell_id == 2) {	// light
		WAITT (4);	// Wait until the effect has reached a certain point

		VEC_SET(AoE_Position.X, target_position.X);
		area_of_effect(1.1, 70);
		MY._MP -= _mp_light;
		YOU = NULL;
	}
	IF (spell_id == 3) {	// ice
		WAITT (32);	// Wait until the effect has reached a certain point
		IF (!YOU) { RETURN; }

		YOUR._Action_HP = MAX(1, (1.0 * get_temp_dmg(spell_id, ME, YOU) - (YOUR._mdef + YOUR._buff_mpdef)));
		YOUR._HP -= YOUR._Action_HP;
		MY._Aggro += ABS(YOUR._Action_HP);
		MY._MP -= _mp_ice;
	}
	IF (spell_id == 4) {	// lightning
		WAITT (4);	// Wait until the effect has reached a certain point
		IF (!YOU) { RETURN; }

		YOUR._Action_HP = MAX(1, (1.3 * get_temp_dmg(spell_id, ME, YOU) - (YOUR._mdef + YOUR._buff_mpdef)));
		YOUR._HP -= YOUR._Action_HP;
		MY._Aggro += ABS(YOUR._Action_HP);
		MY._MP -= _mp_lightning;
	}
	IF (spell_id == 5) {	// earth
		WAITT (16);	// Wait until the effect has reached a certain point
		IF (!YOU) { RETURN; }

		YOUR._Action_HP = MAX(1, (1.15 * get_temp_dmg(spell_id, ME, YOU) - (YOUR._mdef + YOUR._buff_mpdef)));
		YOUR._HP -= YOUR._Action_HP;
		MY._Aggro += ABS(YOUR._Action_HP);
		MY._MP -= _mp_earth;
	}
	IF (spell_id == 6) {	// mpdef
		pain_switch = OFF;	// deactivate pain
		buff_actor(YOU, 6);
		MY._MP -= _mp_mpdef;
	}
	IF (spell_id == 7) {	// agi
		pain_switch = OFF;	// deactivate pain
		buff_actor(YOU, 7);
		MY._MP -= _mp_agi;
	}
	IF (spell_id == 8) {	// fire
		WAITT (24);	// Wait until the effect has reached a certain point

		VEC_SET(AoE_Position.X, target_position.X);
		area_of_effect(1.4, 70);
		MY._MP -= _mp_fire;
		YOU = NULL;
	}
	IF (spell_id == 9) {	// exploding arrow
		WAITT (4);	// Wait until the effect has reached a certain point

		attack_area(you, 1.5, 16);
		MY._MP -= _mp_explodingarrow;
	}
	IF (spell_id == 10) {	// laser inferno
		WAITT (20);	// Wait until the effect has reached a certain point

		VEC_SET(AoE_Position.X, target_position.X);
		area_of_effect(1.4, 16);
		MY._MP -= _mp_laserinferno;
		YOU = NULL;
	}
	IF (spell_id == 11) {	// summon ice
		WAITT (12);	// Wait until the effect has reached a certain point
		IF (!YOU) { RETURN; }

		YOUR._Action_HP = MAX(1, (1.5 * get_temp_dmg(spell_id, ME, YOU) - (YOUR._mdef + YOUR._buff_mpdef)));
		YOUR._HP -= YOUR._Action_HP;
		MY._Aggro += ABS(YOUR._Action_HP);
		MY._MP -= _mp_summonice;
	}
	IF (spell_id == 12) {	// meteor
		WAITT (24);	// Wait until the effect has reached a certain point
		IF (!YOU) { RETURN; }

		YOUR._Action_HP = MAX(1, (1.2 * get_temp_dmg(spell_id, ME, YOU) - (YOUR._mdef + YOUR._buff_mpdef)));
		YOUR._HP -= YOUR._Action_HP;
		MY._Aggro += ABS(YOUR._Action_HP);
		MY._MP -= _mp_meteor;
	}
	if (spell_id == 13) {	// fire rain and fire storm
		if (my._action == _action_regena) {
			// fire storm
			waitt(4);
			if (!you) { return; }

			vec_set(AoE_Position.X, target_position.X);
			area_of_effect(1.4, 96);	// Revenge Leap distance
			my._MP -= _mp_firestorm;

			you = me;
			pain_switch = OFF;	// deactivate pain

			my._Action_HP = -(my._Vit - my._HP);
			my._HP = my._Vit;
			my._Aggro += abs(my._Action_HP);
		} else {
			// fire rain
			WAITT (22);	// Wait until the effect has reached a certain point
			IF (!YOU) { RETURN; }

			YOUR._Action_HP = MAX(1, (1.3 * get_temp_dmg(spell_id, ME, YOU) - (YOUR._mdef + YOUR._buff_mpdef)));
			YOUR._HP -= YOUR._Action_HP;
			MY._Aggro += ABS(YOUR._Action_HP);
			MY._MP -= _mp_firerain;
		}
	}
	IF (spell_id == 14) {	// earthquake
		WAITT (24);	// Wait until the effect has reached a certain point

		VEC_SET(AoE_Position.X, target_position.X);
		MY._MP -= _mp_earthquake;
		SEND_SKILL(MY._MP, SEND_ALL); net_transfer += 4;	// Send MP, too after spellcast.

		cnt = 8;
		while (cnt > 0) {
			area_of_effect(0.8, 100);
			cnt -= 1;
		waitt(6);
		}
		YOU = NULL;
	}
	IF (spell_id == 15) {	// summon gaja
		WAITT (12);	// Wait until the effect has reached a certain point

		VEC_SET(AoE_Position.X, target_position.X);
		MY._MP -= _mp_summongaja;
		SEND_SKILL(MY._MP, SEND_ALL); net_transfer += 4;	// Send MP, too after spellcast.

		cnt = 5;
		while (cnt > 0) {
			area_of_effect(1, 80);
			cnt -= 1;
		waitt(6);
		}
		YOU = NULL;
	}

	IF (YOU) {
		YOUR._HP = MAX(0, MIN(YOUR._HP, YOUR._Vit));	// Can't get more hitpoints than vitality
		IF (pain_switch) {
			counter_calculation(YOU);
			SEND_SKILL(YOUR._ActReq_ID, SEND_ALL); net_transfer += 4;
		}

		SEND_SKILL(YOUR._Action_HP, SEND_ALL); net_transfer += 4;
		SEND_SKILL(YOUR._HP, SEND_ALL); net_transfer += 4;
	}

	SEND_SKILL(MY._MP, SEND_ALL); net_transfer += 4;	// Send MP, too after spellcast.

	return;
}


function FNCT_Emote()
{
	MY.UNLIT = ON;
	MY.AMBIENT = 100;
	MY.OVERLAY = ON;
	MY.TRANSPARENT = ON;
	MY.ALPHA = 0;
//	MY.BRIGHT = ON;
	MY.FACING = ON;
	MY.PASSABLE = ON;
	MY.FRAME = YOUR._emote_req;

	MY.LIGHT = ON;
	MY.RED = 64;
	MY.GREEN = MY.RED;
	MY.BLUE = MY.RED;

	object_to_camera(YOU, 4);
	proc_late();

	WHILE (MY.ALPHA < 100) {
		MY.ALPHA = MIN(100, MY.ALPHA + 32 * TIME);
		MY.Z += 32;
	WAIT (1);
	}

	WHILE (MY._temp < 24) {
		MY._temp += TIME;
		MY.Z += 32;
	WAIT (1);
	}

	WHILE (MY.ALPHA > 0) {
		MY.ALPHA = MAX(0, MY.ALPHA - 32 * TIME);
		MY.Z += 32;
	WAIT (1);
	}

	ENT_REMOVE(ME);
	RETURN;
}

function emotions()
{
	emoteicons.visible = ON;

	WHILE (ME) {
		MY._emote_timer -= TIME;
		IF ((KEY_LASTPRESSED >= 2) && (KEY_LASTPRESSED <= 11) && (MY._emote_timer <= 0) && (PLAYER == ME)) {
			MY._emote_req = -(KEY_LASTPRESSED - 1);
			SEND_SKILL(MY._emote_req, NULL); net_transfer += 4;
			MY._emote_timer = 32;

			KEY_LASTPRESSED = 0;
		}
		IF (MY._emote_req > 0) {
			ENT_CREATELOCAL("emotion+10.bmp", NULLVECTOR, FNCT_Emote);
			MY._emote_req = 0;
		}
	WAIT (1);
	}

	RETURN;
}


function getRealActorClass(class)
{
	if (class == _num_valkyrie) {
		return(_num_archer);
	} else {
		return(class);
	}
}

function getEquipmentValue(BasicValue, ItemLevel)
{
	return(BasicValue + 5 * (ItemLevel + 1));
}

function updateWeaponMenu(switch)
{
var real_Actor_class;
	real_Actor_class = getRealActorClass(player._Actor_class);

	if (switch) {
		TradeOffset[0] += 1;
		TradeOffset[0] %= weaponPrices.length;
	}

	while (player._pdam > getEquipmentValue(weaponpDam[real_Actor_class], TradeOffset[0])) {
		TradeOffset[0] += 1;
	}

	if (TradeOffset[0] < weaponPrices.length) {

		TradeOffset[2] = 75 * TradeOffset[0];

		str_cpy(show_WeaponText_string, weapon_names.string[TradeOffset[0]]);
		str_cat(show_WeaponText_string, " lvl ");
		str_for_num(TEMP_STRING, weaponLevels[TradeOffset[0]]);
		str_cat(show_WeaponText_string, TEMP_STRING);

		str_cat(show_WeaponText_string, "\np-att / m-att: ");
		str_for_num(TEMP_STRING, getEquipmentValue(weaponpDam[real_Actor_class], TradeOffset[0]));
		str_cat(show_WeaponText_string, TEMP_STRING);

		str_cat(show_WeaponText_string, " / ");
		str_for_num(TEMP_STRING, getEquipmentValue(weaponmDam[real_Actor_class], TradeOffset[0]));
		str_cat(show_WeaponText_string, TEMP_STRING);

		if (player._pdam == getEquipmentValue(weaponpDam[real_Actor_class], TradeOffset[0])) {
			str_cat(show_WeaponText_string, "\nEquipped");
		} else {
			if (player._pdam < getEquipmentValue(weaponpDam[real_Actor_class], TradeOffset[0]) - 5) {
				str_cat(show_WeaponText_string, "\nNot available yet");
			} else {
				str_cat(show_WeaponText_string, "\nPrice: ");
				str_for_num(TEMP_STRING, weaponPrices[TradeOffset[0]]);
				str_cat(show_WeaponText_string, TEMP_STRING);
			}
		}
	} else {

		str_cpy(show_WeaponText_string, "");

		show_swords.visible = off;
		show_bows.visible = off;
		show_wands.visible = off;
		show_spears.visible = off;

	}

	return;
}

function updateArmorMenu(switch)
{
var real_Actor_class;
	real_Actor_class = getRealActorClass(player._Actor_class);

	if (switch) {
		TradeOffset[1] += 1;
		TradeOffset[1] %= armorPrices.length;
	}

	while (player._pdef > getEquipmentValue(armorpDef[real_Actor_class], TradeOffset[1])) {
		TradeOffset[1] += 1;
	}

	if (TradeOffset[1] < armorPrices.length) {

		TradeOffset[3] = 75 * TradeOffset[1];

		str_cpy(show_ArmorText_string, armor_names.string[TradeOffset[1]]);
		str_cat(show_ArmorText_string, " lvl ");
		str_for_num(TEMP_STRING, armorLevels[TradeOffset[1]]);
		str_cat(show_ArmorText_string, TEMP_STRING);

		str_cat(show_ArmorText_string, "\np-def / m-def: ");
		str_for_num(TEMP_STRING, getEquipmentValue(armorpDef[real_Actor_class], TradeOffset[1]));
		str_cat(show_ArmorText_string, TEMP_STRING);

		str_cat(show_ArmorText_string, " / ");
		str_for_num(TEMP_STRING, getEquipmentValue(armormDef[real_Actor_class], TradeOffset[1]));
		str_cat(show_ArmorText_string, TEMP_STRING);

		if (player._pdef == getEquipmentValue(armorpDef[real_Actor_class], TradeOffset[1])) {
			str_cat(show_ArmorText_string, "\nEquipped");
		} else {
			if (player._pdef < getEquipmentValue(armorpDef[real_Actor_class], TradeOffset[1]) - 5) {
				str_cat(show_ArmorText_string, "\nNot available yet");
			} else {
				str_cat(show_ArmorText_string, "\nPrice: ");
				str_for_num(TEMP_STRING, armorPrices[TradeOffset[1]]);
				str_cat(show_ArmorText_string, TEMP_STRING);
			}
		}
	} else {

		str_cpy(show_ArmorText_string, "");

		show_heavy_armor.visible = off;
		show_light_armor.visible = off;
		show_priest_robes.visible = off;
		show_wizard_robes.visible = off;

	}

	return;
}

function nextWeapon()
{
	if (TradeOffset[0] < weaponPrices.length) {
		updateWeaponMenu(on);
	} else {
		snd_play(buy_no, 100, 0);
	}

	return;
}

function nextArmor()
{
	if (TradeOffset[1] < armorPrices.length) {
		updateArmorMenu(on);
	} else {
		snd_play(buy_no, 100, 0);
	}

	return;
}

function buyWeapon()
{
var real_Actor_class;
	real_Actor_class = getRealActorClass(player._Actor_class);

	if (TradeOffset[0] < weaponPrices.length) {
		if ((player._gold >= weaponPrices[TradeOffset[0]]) && (player._Level >= weaponLevels[TradeOffset[0]])) {
			// Only if currend dam is smaller than new dam.
			if (player._pdam == getEquipmentValue(weaponpDam[real_Actor_class], TradeOffset[0]) - 5) {
				player._gold -= weaponPrices[TradeOffset[0]];
				player._pdam = getEquipmentValue(weaponpDam[real_Actor_class], TradeOffset[0]);
				player._mdam = getEquipmentValue(weaponmDam[real_Actor_class], TradeOffset[0]);
	
				updateWeaponMenu(off);
				playerStats();
	
				send_skill(player._pdam, null);
				send_skill(player._mdam, null);
				send_skill(player._gold, null);
	
				snd_play(buy_ok, 100, 0);

				return;
			}
		}
	}

	snd_play(buy_no, 100, 0);
	return:
}

function playNAsound()
{
	snd_play(buy_no, 100, 0);

	return;
}

function buyArmor()
{
var real_Actor_class;
	real_Actor_class = getRealActorClass(player._Actor_class);

	if (TradeOffset[1] < armorPrices.length) {
		if ((player._gold >= armorPrices[TradeOffset[1]]) && (player._Level >= armorLevels[TradeOffset[1]])) {
			// Only if current def is smaller than new def.
			if (player._pdef == getEquipmentValue(armorpDef[real_Actor_class], TradeOffset[1]) - 5) {
				player._gold -= armorPrices[TradeOffset[1]];
				player._pdef = getEquipmentValue(armorpDef[real_Actor_class], TradeOffset[1]);
				player._mdef = getEquipmentValue(armormDef[real_Actor_class], TradeOffset[1]);
	
				updateArmorMenu(off);
				playerStats();
	
				send_skill(player._pdef, null);
				send_skill(player._mdef, null);
				send_skill(player._gold, null);
	
				snd_play(buy_ok, 100, 0);

				return;
			}
		}
	}

	snd_play(buy_no, 100, 0);
	return;
}

function playerStats()
{
	str_cpy(dialog_text, "Level ");
	str_for_num(TEMP_STRING, player._Level);
	str_cat(dialog_text, TEMP_STRING);

	str_cat(dialog_text, "  Gold: ");
	str_for_num(TEMP_STRING, int(player._Gold));
	str_cat(dialog_text, TEMP_STRING);

	str_cat(dialog_text, "\n");
	str_for_num(TEMP_STRING, int(player._HP + 0.5));
	str_cat(dialog_text, TEMP_STRING);

	str_cat(dialog_text, " / ");
	str_for_num(TEMP_STRING, int(player._Vit + 0.5));
	str_cat(dialog_text, TEMP_STRING);
	str_cat(dialog_text, " hits");

	str_cat(dialog_text, " | ");
	str_for_num(TEMP_STRING, int(player._MP + 0.5));
	str_cat(dialog_text, TEMP_STRING);

	str_cat(dialog_text, " / ");
	str_for_num(TEMP_STRING, int(player._Int + 0.5));
	str_cat(dialog_text, TEMP_STRING);
	str_cat(dialog_text, " mana");

//	str_cat(dialog_text, "\np-att/ m-att: ");
//	str_for_num(TEMP_STRING, int(player._pdam + 0.5));
//	str_cat(dialog_text, TEMP_STRING);
//	str_cat(dialog_text, "/ ");
//	str_for_num(TEMP_STRING, int(player._mdam + 0.5));
//	str_cat(dialog_text, TEMP_STRING);
//
//	str_cat(dialog_text, " | strength: ");
//	str_for_num(TEMP_STRING, int(player._Str + 0.5));
//	str_cat(dialog_text, TEMP_STRING);
//
//	str_cat(dialog_text, "\np-def/ m-def: ");
//	str_for_num(TEMP_STRING, int(player._pdef + 0.5));
//	str_cat(dialog_text, TEMP_STRING);
//	str_cat(dialog_text, "/ ");
//	str_for_num(TEMP_STRING, int(player._mdef + 0.5));
//	str_cat(dialog_text, TEMP_STRING);
//
//	str_cat(dialog_text, " | wisdom: ");
//	str_for_num(TEMP_STRING, int(player._Wis + 0.5));
//	str_cat(dialog_text, TEMP_STRING);

	str_cat(dialog_text, "\nstrength: ");
	str_for_num(TEMP_STRING, int(player._Str + 0.5));
	str_cat(dialog_text, TEMP_STRING);

	str_cat(dialog_text, " | dexterity: ");
	str_for_num(TEMP_STRING, int(player._Dex + 0.5));
	str_cat(dialog_text, TEMP_STRING);

	str_cat(dialog_text, "\nagility: ");
	str_for_num(TEMP_STRING, int(player._Agi + 0.5));
	str_cat(dialog_text, TEMP_STRING);

	str_cat(dialog_text, " | wisdom: ");
	str_for_num(TEMP_STRING, int(player._Wis + 0.5));
	str_cat(dialog_text, TEMP_STRING);

	return;
}

function startSpeech(class)
{
//	show_dialog.bmap = null;
	str_cpy(dialog_text, "");

	if (class == _num_knight) {
//		show_dialog.bmap = knight_dial;
		weapon_panel = show_swords;
		armor_panel  = show_heavy_armor;
	}

	if (getRealActorClass(class) == _num_archer) {
//		show_dialog.bmap = archer_dial;
		weapon_panel = show_bows;
		armor_panel  = show_light_armor;
	}

	if (class == _num_priest) {
//		show_dialog.bmap = priest_dial;
		weapon_panel = show_wands;
		armor_panel  = show_priest_robes;
	}

	if (class == _num_wizard) {
//		show_dialog.bmap = wizard_dial;
		weapon_panel = show_spears;
		armor_panel  = show_wizard_robes;
	}

	playerStats();
	show_dialog.visible = on;
	show_dialogtext.visible = on;

	weapon_panel.visible = on;
	armor_panel.visible = on;

	show_options.visible = on;
	show_dialoginfo.visible = on;
	show_WeaponNext.visible = on;
	show_WeaponBuy.visible = on;
	show_ArmorNext.visible = on;
	show_ArmorBuy.visible = on;
	show_WeaponText.visible = on;
	show_ArmorText.visible = on;

	if (connection == 3) {
		show_Next.visible = on;
		show_NextText.visible = on;
	}

	updateWeaponMenu(off);
	updateArmorMenu(off);

	return;
}

function closeTrade()
{
	show_wood_bg.visible = off;

	show_swords.visible = off;
	show_bows.visible = off;
	show_wands.visible = off;
	show_spears.visible = off;
	show_heavy_armor.visible = off;
	show_light_armor.visible = off;
	show_priest_robes.visible = off;
	show_wizard_robes.visible = off;

	show_dialog.visible = off;
	show_dialogtext.visible = off;

	show_options.visible = off;
	show_dialoginfo.visible = off;
	show_WeaponNext.visible = off;
	show_WeaponBuy.visible = off;
	show_ArmorNext.visible = off;
	show_ArmorBuy.visible = off;
	show_WeaponText.visible = off;
	show_ArmorText.visible = off;

	show_Next.visible = off;
	show_NextText.visible = off;

	save_player();
}

function writeLevelText(buttonID, panelptr)
{
	_temp_panel = panelptr;
	if (_temp_panel == show_place_forest) {
		str_cpy(dialog_text, "Forest\nDifficulty: easy\nEnemy level: ");
		temp = _lvl_Forest;
	}
	if (_temp_panel == show_place_waterfall) {
		str_cpy(dialog_text, "Waterfall\nDifficulty: medium\nEnemy level: ");
		temp = _lvl_Waterfall;
	}
	if (_temp_panel == show_place_frostfield) {
		str_cpy(dialog_text, "Frost Field\nDifficulty: medium\nEnemy level: ");
		temp = _lvl_Frostfield;
	}
	if (_temp_panel == show_place_valleyofthedead) {
		str_cpy(dialog_text, "Valley of the Dead\nDifficulty: medium\nEnemy level: ");
		temp = _lvl_Valleyofthedead;
	}
	if (_temp_panel == show_place_ancientforest) {
		str_cpy(dialog_text, "Ancient Forest\nDifficulty: hard\nEnemy level: ");
		temp = _lvl_Ancientforest;
	}
	if (_temp_panel == show_place_lostforest) {
		str_cpy(dialog_text, "Lost Forest\nDifficulty: very hard\nEnemy level: ");
		temp = _lvl_Lostforest;
	}
	
	str_for_num(TEMP_STRING, enemy_Level(cleared_levels[temp]));
	str_cat(dialog_text, TEMP_STRING);

	return;
}

function writeNAText()
{
	str_cpy(dialog_text, "Not available yet");

	return;
}

function clearLevelText()
{
	playerStats();

	return;
}

function openLevelSelect()
{
	closeTrade();

	show_wood_bg.visible = on;

	show_dialog.visible = on;
	show_dialogtext.visible = on;

	show_na_places.visible = on;
	show_place_forest.visible = on;

	if (cleared_Levels[_lvl_Forest]) {
		show_place_waterfall.visible = on;
	}

	if (cleared_Levels[_lvl_Waterfall]) {
		show_place_frostfield.visible = on;
	}

	if (cleared_Levels[_lvl_Frostfield]) {
		show_place_valleyofthedead.visible = on;
	}

	if (cleared_Levels[_lvl_Valleyofthedead]) {
		show_place_ancientforest.visible = on;
	}

	if (cleared_Levels[_lvl_Ancientforest]) {
		show_place_lostforest.visible = on;
	}

	return;
}

function closeLevelSelect()
{
	show_wood_bg.visible = off;

	show_dialog.visible = off;
	show_dialogtext.visible = off;

	show_na_places.visible = off;
	show_place_forest.visible = off;
	show_place_waterfall.visible = off;
	show_place_frostfield.visible = off;
	show_place_valleyofthedead.visible = off;
	show_place_ancientforest.visible = off;
	show_place_lostforest.visible = off;

	return;
}

function finalLoadOptions()
{
	morph_level(Level_ID);

	while (show_white.ALPHA < 100) { wait(1); }

	closeLevelSelect();
	Level_Select[0] = off;
	send_var(Level_ID);
	send_var(Level_Select);

	return;
}

function selectForest()
{
	Level_ID = _Level_Forest;
	enemies[4] = _lvl_Forest;
	finalLoadOptions();
}

function selectWaterfall()
{
	Level_ID = _Level_Forest;
	enemies[4] = _lvl_Waterfall;
	finalLoadOptions();
}

function selectFrostfield()
{
	Level_ID = _Level_Snow;
	enemies[4] = _lvl_Frostfield;
	finalLoadOptions();
}

function selectValleyofthedead()
{
	Level_ID = _Level_Rocks;
	enemies[4] = _lvl_Valleyofthedead;
	finalLoadOptions();
}

function selectAncientforest()
{
	Level_ID = _Level_Forest;
	enemies[4] = _lvl_Ancientforest;
	finalLoadOptions();
}

function selectLostforest()
{
	Level_ID = _Level_Forest;
	enemies[4] = _lvl_Lostforest;
	finalLoadOptions();
}


// This function is initiated by the server and runs on each client for every actor using proc_local()
function animate_actor()
{
var resurrect;

	activate_nosend(ME);

	MY._action = _action_stand;	// Initiate state machine
	MY.FACING = ON;
	MY.FRAME = 1;	// standing
	MY.INVISIBLE = ON;
	MY.Z = -MY.MIN_Z * MY.SCALE_Z;	// set Z Value
	MY._timer_battlerage = _mp_battlerage;
	MY._timer_drawaggro = _mp_drawaggro;
	MY._timer_revengeleap = _mp_revengeleap;
	MY._timer_thornaura = _mp_thornaura;
	MY._timer_transform = 0;
	my._buff_Str = 0;
	my._buff_Dex = 0;
	my._buff_Agi = 0;
	my._buff_mpdef = 0;

	// xxx hier h‰ngt es, wenn die valkyrie nicht erscheint!
	while (MY._Actor_ID == _ID_Undefined) { wait(1); }

	MY.TRANSPARENT = ON;
	MY.ALPHA = 0;

	while (my.alpha < 100) {
		my.invisible = off;
		my.alpha = min(100, my.alpha + 12.5 * time);
	wait(1);
	}

	set_stats(on);	// Stats do not have to be send since they're predefined, we only need them to avoid division by zero for the health bars.

	// create some local stuff which is multiplayer-independent
	ENT_CREATELOCAL("shadow.tga", MY.X, shadowsprite);

	TEMP = 1;
	ENT_CREATELOCAL("hpbar.bmp", MY.X, multibar);

	create_actor_pic();
	emotions();

	IF (PLAYER == ME) {	// MP and action bar only for the player
		IF (MY._Actor_class != _num_knight) {
			TEMP = 2;
			ENT_CREATELOCAL("mpbar.bmp", MY.X, multibar);

			TEMP = 3;
			ENT_CREATELOCAL("actionbar.bmp", MY.X, multibar);
		} ELSE {
			TEMP = 4;
			ENT_CREATELOCAL("actionbar.bmp", MY.X, multibar);
		}
	}

//	debug_panel.visible = ON;

	WHILE (ME) {
		MY.LIGHT = ON;
		MY._action = _action_stand;
		WHILE (ME) {

			while (Level_Select) { wait(1); }

			my.alpha = 100;
			MY.Z = -MY.MIN_Z * MY.SCALE_Z;	// set Z Value
//			MY._Aggro -= (0.005 * MY._Aggro) * TIME;
			MY._Aggro = MAX(0, MIN(10000, MY._Aggro - 0.5 * TIME));

			MY._timer_agi -= TIME;
			MY._timer_mpdef -= TIME;
			MY._timer_battlerage -= TIME;
			MY._timer_drawaggro -= TIME;
			MY._timer_revengeleap -= TIME;
			MY._timer_thornaura -= TIME;
			my._timer_transform -= time;

//			IF (MY._Actor_class == _num_wizard) { TEMPs.X = MY._Aggro; }
//			IF (MY._Actor_class == _num_knight) { TEMPs.Y = MY._Aggro; }

			IF (MY._Action_msg != 0) {
				Action_image(my._Action_msg);
				IF (MY._Action_msg == _msg_miss) {
//					Action_messages("Miss!");
				}
				IF (MY._Action_msg == _msg_critical) {
//					Action_messages("Critical!");
				}
				IF (MY._Action_msg == _msg_mpdef_up) {
//					Action_messages("Defence up!");
				}
				IF (MY._Action_msg == _msg_mpdef_dn) {
//					Action_messages("Defence down!");
				}
				IF (MY._Action_msg == _msg_agi_up) {
//					Action_messages("Agility up!");
				}
				IF (MY._Action_msg == _msg_agi_dn) {
//					Action_messages("Agility down!");
				}
				IF (MY._Action_msg == _msg_thorns) {
//					Action_messages("Thorns!");
				}
				if (my._Action_msg == _msg_raisebuffs) {
//					Action_messages("Raise Buffs!");
					victim = me;
					willow_wisp();
					willow_wisp();
				}
				MY._Action_msg = 0;
			}
			IF (MY._Action_HP != 0) {
				// > 0 means damage, otherwise healing, thus create a color-ID
//				IF (MY._Action_HP > 0) { TEMP = 1; } ELSE { TEMP = 2; }
//				Action_damage(MY._Action_HP, TEMP);
				Action_number();
				my._Action_HP = 0;
			}
			IF (MY._Action_MP != 0) {
//				Action_damage(MY._Action_MP, 3);
				Action_number();
				my._Action_MP = 0;
			}
			IF (MY._LevelUp != 0) {
//				Action_messages("Level up!");
				Action_image(_msg_levelup);
				MY._Level = MY._LevelUp;
				MY._LevelUp = 0;

				level_up();
				set_stats(on);
			}

			if (my._Actor_pretransform != 0) {
				if (my._timer_transform <= 0) {
					victim = me;
					FNCT_Flash_White();
					willow_wisp();
					willow_wisp();

					// Must not be sent, otherwise clients may not morph back!
					my._Actor_class = my._Actor_pretransform;
					my._Actor_pretransform = 0;

					create_morph_string(my._Actor_class, my._Actor_ID);
					ent_morph(me, TEMP_STRING);

					my._morphed = off;
					rescale_actor_pic(me);

					snd_play(gaja, 100, 0);

//					Action_messages("Form returned!");
					Action_image(_msg_formreturned);

					if (connection == 3) {
						set_stats(off);
						send_important_skills(me);
					}
				} else {
					if (my._morphed == off) {
						// A morph form has been chosen and sent, now apply morph.
						create_morph_string(my._Actor_class, my._Actor_ID);
						ent_morph(me, TEMP_STRING);

						my._morphed = on;
						rescale_actor_pic(me);
					}
				}
			}

			IF (MY._HP <= 0) { break; }

			IF ((ME == _mouse_ent) && (button_block == 0)) {
				MY.RED   = 24 + FSIN(total_ticks * 15, 24);
				MY.GREEN = MY.RED;
				MY.BLUE  = MY.RED;
			} ELSE {
				MY.RED   = 0;
				MY.GREEN = MY.RED;
				MY.BLUE  = MY.RED;
			}


			IF (MY._Action_ID != 0) {
				IF (MY._Action_ID == _action_jump) {
					MY._action = _action_jump;
					MY._Action_ID = 0;
				}
				IF ((MY._Action_ID == _action_attack) && (MY._action != _action_jump) && (MY._action != _action_attack)) {
					// If distance too far, go to the target position. Add further far-distance-attack actors here.
					IF ((rel_dist(MY.X, MY._Action_target_X) > 16) &&
						(MY._Actor_class != _num_Archer)) {

						MY._action = _action_jump;
					} ELSE {
						MY._action = _action_attack;
					}
				}
				IF (MY._Action_ID == _action_counter) {
					MY._action = _action_pain;
				}
				IF (MY._Action_ID == _action_regena) {
					MY._action = _action_regena;
					MY._Action_spell = MY._Spell_ID;
					MY._Action_ID = 0;
				}
				IF (MY._Action_ID == _action_cast) {
					MY._action = _action_cast;
					MY._Action_spell = MY._Spell_ID;
					MY._Action_ID = 0;
					IF (MY._Actor_class == _num_archer) { action_effect(15); }
					IF (MY._Actor_class == _num_priest) { action_effect(10); }
					IF (MY._Actor_class == _num_wizard) { action_effect(5); }
				}
				IF (MY._Action_ID == _action_pain) {
					MY._action = _action_pain;
					MY._Action_ID = 0;
				}
			}


			// Reset animation when action changed
			IF (MY._action != MY._last_action) {
				MY._last_action = MY._action;
				MY._anime = 0;
			}


			// Actor is standing
			IF (MY._action == _action_stand) {
				MY._counter_active = OFF;
				MY.FRAME = 1;
			}
			// Actor is movin to a certain position
			IF (MY._action == _action_jump) {
				VEC_DIFF(TEMP.X, MY._Action_target_X, MY.X);
				VEC_TO_ANGLE(TEMP.PAN, TEMP.X);
				MY._angle = TEMP.PAN;

				IF (MY._anime == 0) {
					snd_play(charge_enemy, 100, 0);
					MY._anime = 1;
				}

				TEMP = rel_dist(MY.X, MY._Action_target_X);
				// accelerate
				IF (TEMP >  64) {
					MY.FRAME = 2;
					MY._speed += (32 - MY._speed) * 0.7 * TIME;
				}

				// slow down
				IF ((TEMP > 16) && (TEMP <= 64)) {
					MY.FRAME = 3;
					MY._speed += (8  - MY._speed) * 0.7 * TIME;
				}

				// stop
				IF (TEMP <= 16) {
					MY._speed = 0;
					IF (MY._Action_ID == _action_attack) {
						MY._action = _action_attack;
					} ELSE {
						MY._action = _action_stand;
						MY._action_timer = _action_time;
					}
					MY._Action_ID = 0;
				}

				// finally move ("teleport")
				VEC_SET(TEMP.X, vector((MY._speed * TIME), 0 ,0));
				VEC_ROTATE(TEMP.X, vector(MY._angle, 0, 0));

				VEC_ADD(MY.X, TEMP.X);
			}
			// Actor is attacking
			IF (MY._action == _action_attack) {
				YOU = ptr_for_handle(MY._Action_handle);
				IF (!YOU) {	// The actor does not exist any more, return to _action_stand
					MY._action = _action_stand;
					WAIT (1); continue;
				}

				IF (MY._anime == 0) {
					snd_play(BBB_Sword, 100, 0);
					IF (MY._Actor_class == _num_knight) { action_effect(5); }
					if (my._Actor_class == _num_valkyrie) { action_effect(3); }
				}

				VEC_DIFF(TEMP.X, YOUR.X, MY.X);
				VEC_TO_ANGLE(TEMP.PAN, TEMP.X);
				MY._angle = TEMP.PAN;

				// Count frames from 8 to 11
				MY._anime += 12 * TIME;
				MY.FRAME = 8 + MY._anime / (100 / 4);

				IF (MY._anime >= 100) {
					MY._action = _action_stand;
					MY._Action_ID = 0;

					IF (MY._counter_active == ON) {
						MY._counter_active = OFF;
					} ELSE {
						MY._action_timer = _action_time;
					}

					// Create arrow, add further far-distance-attack actors here.
					IF (MY._Actor_class == _num_Archer) {
						create_arrow(ME, YOU);
					}

					// The server controls the damage
					IF (connection == 3) {
						YOU = ptr_for_handle(MY._Action_handle);
						IF (!YOU) { WAIT (1); continue; }

						victim = you;
						attack_area(you, 1, 1);	// 1 times damage, 1 quant range (just to avoid rounding errors)
					}
				}
			}
			// Actor was attacked
			IF (MY._action == _action_pain) {
				MY.FRAME = 4;

				IF (MY._anime == 0) {
					snd_play(rack, 100, 0);
				}

				MY._anime = MIN(180, MY._anime + 20 * TIME);
				MY.X += COS(MY._anime * 5) * TIME;
				MY.Z += SIN(MY._anime * 2) * TIME;

				IF (MY._anime == 180) {
					MY.Z = -MY.MIN_Z * MY.SCALE_Z;

					// For counter attack switch to attack after pain
					IF (MY._Action_ID == _action_counter) {
						MY._counter_active = ON;
						MY._Action_ID = _action_attack;

						if ((my._Actor_class == _num_priest) && (my._MP >= _mp_laserinferno)) {
							my._Action_ID = _action_cast;
							my._Spell_ID = 10;
						}
						if ((my._Actor_class == _num_wizard) && (my._MP >= _mp_firerain)) {
							my._Action_ID = _action_cast;
							my._Spell_ID = 13;
						}

//						Action_messages("Counter!");
						Action_image(_msg_counter);
					} ELSE {
						MY._Action_ID = 0;
					}
					MY._action = _action_stand;
				}
			}
			// Actor regenerates
			IF (MY._action == _action_regena) {
				// Count frames from 8 to 11
				MY._anime += 12 * TIME;
				MY.FRAME = 8 + MY._anime / (100 / 4);
				if (my._Actor_ID == _ID_Player) { my.frame += 4; }

				IF (MY._anime < 50) { MY._cast_active = 0; }
				IF ((MY._anime >= 50) && (MY._cast_active == 0)) {
					victim = ME;
					MY._cast_active = 1;

					snd_play(BBB_charge, 100, 0);

					IF (MY._Action_spell == 1) {
						willow_wisp();
						willow_wisp();

						IF (connection == 3) {	// hp regeneration
							MY._Action_HP = -MIN(MY._Vit - MY._HP, INT(MY._Vit * 0.2 + Random(MY._Vit * 0.1)));
							MY._HP -= MY._Action_HP;
							MY._Aggro += ABS(MY._Action_HP);

							SEND_SKILL(MY._Action_HP, SEND_ALL); net_transfer += 4;
							SEND_SKILL(MY._HP, SEND_ALL); net_transfer += 4;
						}
					}
					IF (MY._Action_spell == 2) {
						willow_wisp();
						willow_wisp();

						IF (connection == 3) {	// mp regeneration
							MY._Action_MP = MIN(MY._Int - MY._MP, INT(MY._Int * 0.2 + Random(MY._Int * 0.1)));
							MY._MP += MY._Action_MP;

							SEND_SKILL(MY._Action_MP, SEND_ALL); net_transfer += 4;
							SEND_SKILL(MY._MP, SEND_ALL); net_transfer += 4;
						}
					}
					IF ((MY._Action_spell == 10) || (MY._Action_spell == 6) || (MY._Action_spell == 5)) {
						FNCT_Flash_White();
						willow_wisp();
						willow_wisp();

						IF (MY._Action_spell == 5) {	// call skeleton
							snd_play(summonevil, 100, 0);
						}
						IF (MY._Action_spell == 6) {	// call battle lord
							snd_play(summongood, 100, 0);
						}
						if (MY._Action_spell == 10) {	// call blood pudding
							snd_play(summonevil, 100, 0);
						}

						IF (connection == 3) {
							IF (MY._Action_spell == 5) {	// call skeleton
								create_enemy(_num_skeleton);
								MY._MP -= _mp_callskeleton;
								SEND_SKILL(MY._MP, SEND_ALL); net_transfer += 4;
							}
							IF (MY._Action_spell == 6) {	// call battle lord
								create_enemy(_num_battle_lord);
								MY._MP -= _mp_callbattlelord;
								SEND_SKILL(MY._MP, SEND_ALL); net_transfer += 4;
							}
							if (MY._Action_spell == 10) {	// call blood pudding
								create_enemy(_num_blood_pudding);
								my._MP -= _mp_callbloodpudding;
								send_skill(my._MP, send_all); net_transfer += 4;
							}
						}
					}
					IF (MY._Action_spell == 7) {
						snd_play(BBB_Sword, 100, 0);

						revenge_leap();
						MY._timer_revengeleap = 0;
//						Action_messages("Revenge Leap!");
						Action_image(_msg_revleap);

						if (connection == 3) {	// Revenge Leap
							MY._Action_spell = -1;	// Important, no elemental weakness!
							attack_area(me, 1.2, 96);
						}
					}
					IF (MY._Action_spell == 8) {
						snd_play(daggro, 100, 0);

						aggro();
						willow_wisp();
//						Action_messages("Draw Aggro!");
						Action_image(_msg_drawaggro);

						if (connection == 3) {	// draw aggro
							buff_actor(ME, 8);
						}
					}
					IF (MY._Action_spell == 9) {
						snd_play(rage, 100, 0);

						willow_wisp();
						willow_wisp();
//						Action_messages("Battle Rage!");
						Action_image(_msg_battlerage);

						IF (connection == 3) {	// battle rage
							buff_actor(ME, 9);
						}
					}
					IF (MY._Action_spell == 11) {
						snd_play(thorns, 100, 0);

						willow_wisp();
						willow_wisp();
//						Action_messages("Thorn Aura!");
						Action_image(_msg_thornaura);

						IF (connection == 3) {	// thorn aura
							buff_actor(ME, 11);
						}
					}
					if (my._Action_spell == 12) {
						snd_play(summongood, 100, 0);

//						Action_messages("Valkyrie Might!");
						Action_image(_msg_valkmight);

						if (connection == 3) {
							my._MP -= _mp_selftransform;
							send_skill(my._MP, send_all); net_transfer += 4;
							transform_actor(me, _num_valkyrie);
						}
					}
					if (my._Action_spell == 13) {
						fire_storm();

						if (connection == 3) {
							// Activate a spell
							cast_damage_delay(MY._Action_spell);
						}
					}
					if (my._Action_spell == 14) {
						revenge_leap();
						aggro();

						snd_play(rage, 100, 0);

						if (connection == 3) {	// raise buffs
							buff_actor(me, 14);
						}
					}
				}

				IF (MY._anime >= 100) {
					MY._action = _action_stand;
					MY._action_timer = _action_time;
				}
			}
			// Actor casts a spell
			IF (MY._action == _action_cast) {
				YOU = ptr_for_handle(MY._Action_handle);
				IF (!YOU) {	// The actor does not exist any more, return to _action_stand
					MY._action = _action_stand;
					WAIT (1); continue;
				}

				IF (MY._anime == 0) {
					snd_play(BBB_zaubern2, 100, 0);
					victim = ME;
					charge();
				}

				VEC_DIFF(TEMP.X, YOUR.X, MY.X);
				VEC_TO_ANGLE(TEMP.PAN, TEMP.X);
				MY._angle = TEMP.PAN;

				// Count frames from 8 to 11
				MY._anime += 8 * TIME;
				MY.FRAME = 8 + MY._anime / (100 / 4);
				if (my._Actor_ID == _ID_Player) { my.frame += 4; }

				IF (MY._anime >= 100) {
					MY._action = _action_stand;

					IF (MY._counter_active == ON) {
						MY._counter_active = OFF;
					} ELSE {
						MY._action_timer = _action_time;
					}

					YOU = ptr_for_handle(MY._Action_handle);
					IF (!YOU) { WAIT (1); continue; }

					victim = YOU;
//					MY._cast_active = 1;

					// Activate a spell effect
					IF (MY._Action_spell == 1) {	// heal
						snd_play(heal, 100, 0);
						willow_wisp();
						willow_wisp();
						willow_wisp();
						healing();
					}
					IF (MY._Action_spell == 2) {	// light
						snd_play(holylight, 100, 0);
						light();
					}
					IF (MY._Action_spell == 3) {	// ice
						snd_play(water, 100, 0);
						ice();
					}
					IF (MY._Action_spell == 4) {	// lightning
						snd_play(bolt, 100, 0);
						lightning();
					}
					IF (MY._Action_spell == 5) {	// earth
						snd_play(earthspell, 100, 0);
						earth();
					}
					IF ((MY._Action_spell == 6) || (MY._Action_spell == 7)) {	// mpdef/ agi
						snd_play(BBB_charge, 100, 0);
						willow_wisp();
						willow_wisp();
						willow_wisp();
						buff_energy();
					}
					IF (MY._Action_spell == 8) {	// fire
						snd_play(hugefire, 100, 0);
						fire();
					}
					IF (MY._Action_spell == 9) {	// exploding arrow
						create_arrow(ME, YOU);
						EFKT_Explosion(0, YOUR.X);
					}
					IF (MY._Action_spell == 10) {	// laser inferno
						laserInferno();
					}
					IF (MY._Action_spell == 11) {	// summon ice
						summonIce();
					}
					IF (MY._Action_spell == 12) {	// meteor
						meteor();
					}
					IF (MY._Action_spell == 13) {	// fire rain
						fire_rain();
					}
					IF (MY._Action_spell == 14) {	// earthquake
						vulcano();
					}
					IF (MY._Action_spell == 15) {	// summon gaja
						photon();
					}

					// The server controls the damage
					IF (connection == 3) {
						// Activate a spell
						cast_damage_delay(MY._Action_spell);
					}
				}
			}

			right_direction();	// Let the player look to the right or the left

		WAIT (1);
		}

		MY.LIGHT = OFF;

		MY._action = _action_die;
		MY._Action_ID = 0;
		snd_play(enemy_die, 100, 0);

		if ((my._Actor_class == _num_phoenix_dragon) && (my._MP > _mp_firestorm) && (int(random(2)))) {
			resurrect = on;
		} else {
			resurrect = off;
		}

		MY._anime = 0;
		WHILE (ME) {
			if (my._HP > 0) {
				if (my._Actor_ID == _ID_Enemy) {
					create_actor_pic();
				}

				break;
			}

			// Count frames from 5 to 7
			MY._anime += 8 * TIME;
			MY.FRAME = MIN(7, (5 + MY._anime / (100 / 3)));

			right_direction();	// Let the player look to the right or the left

			IF ((getRealActorClass(my._Actor_class) > _num_wizard) && (MY._anime > 512)) {
				if ((resurrect == on) && (connection == 3)) {
					my._action_timer = 0;
					my._Action_ID = _action_regena;
					my._Spell_ID = 13;
					my._HP = 0.001;

					send_skill(my._action_timer, send_all);
					send_skill(my._Action_ID, send_all);
					send_skill(my._Spell_ID, send_all);
					send_skill(my._HP, send_all);
				} else {
					MY.ALPHA = MAX(0, MY.ALPHA - 4 * TIME);	// Fade enemy out
				}
			}

			// Resurrect player
			IF (connection == 3) {
				IF ((MY._Actor_ID == _ID_Player) && (MY._anime > 2048) && (fatal == 0)) {
					MY._HP = 0.5 * MY._Vit;
					SEND_SKILL(MY._HP, SEND_ALL); net_transfer += 4;
				}
			}

		wait(1);
		}
		MY._anime = 0;

	WAIT (1);
	}

	RETURN;
}

// Every actor runs this function on the server.
// When the function recieves any action request it'll send the needed data to the clients.
function data_flow()
{
	// This loop will "recieve" Action Requests, "convert" them to executable Action IDs and send them to the clients
	WHILE (ME) {
		IF (MY._HP <= 0) { MY._ActReq_ID = 0; }	// Avoid doing last action after resurrection

		// The server recieved an action request and the actor is ready to do something
		IF ((MY._ActReq_ID != 0) && (MY._action == _action_stand) ||(MY._ActReq_ID == _action_pain)) {
			// Create a level border by not allowing targets that are beyond this coordinates
			MY._Action_target_X = min(_level_size, max(-_level_size, MY._Action_target_X));
			MY._Action_target_Y = min(_level_size, max(-_level_size, MY._Action_target_Y));
			// We do not need the z-value, and yes it is wasted bandwidth to send the vector since only 2 values are needed.

// No need for this one, every client can (and should!) do this on its own.
//			IF (MY._ActReq_ID == _action_stand) {  }

			// The jump target in MY._Action_target_X has been sent by the client
			IF (MY._ActReq_ID == _action_jump) {
				MY._Action_ID = MY._ActReq_ID;

				SEND_SKILL(MY._Action_target_X, SEND_ALL + SEND_VEC); net_transfer += 12;
				SEND_SKILL(MY._Action_ID,       SEND_ALL); net_transfer += 4;
			}

			// Both need the same data
			IF ((MY._ActReq_ID == _action_attack) || (MY._ActReq_ID == _action_counter)) {
				YOU = ptr_for_handle(MY._ActReq_handle);	// Maybe the requested actor does not exist any more
				IF (!YOU) {
					MY._ActReq_ID = 0;
					WAIT (1); continue;
				}

				get_target_position(ME, MY._ActReq_handle);	// Get the position where the actor has to go to
				MY._Action_handle = MY._ActReq_handle;
				MY._Action_ID     = MY._ActReq_ID;

				send_skill(MY._Action_target_X, SEND_ALL + SEND_VEC); net_transfer += 12;
				send_skill(MY._Action_handle,   SEND_ALL); net_transfer += 4;
				send_skill(MY._Action_ID,       SEND_ALL); net_transfer += 4;
			}

			// Needs nothing more than the _Action_ID
			IF ((MY._ActReq_ID == _action_regena) || (MY._ActReq_ID == _action_pain)) {
				MY._Action_ID     = MY._ActReq_ID;
				MY._Spell_ID      = MY._SpReq_ID;

				send_skill(MY._Action_ID,       SEND_ALL); net_transfer += 4;
				send_skill(MY._Spell_ID,        SEND_ALL); net_transfer += 4;
			}

			// _Action_ID and the target entity is needed for this one
			IF (MY._ActReq_ID == _action_cast) {
				YOU = ptr_for_handle(MY._ActReq_handle);	// Maybe the requested actor does not exist any more
				if (!you) {
					my._ActReq_ID = 0;
					wait(1);
					continue;
				}

				MY._Action_handle = MY._ActReq_handle;
				MY._Action_ID     = MY._ActReq_ID;
				MY._Spell_ID      = MY._SpReq_ID;

				send_skill(MY._Action_handle,   SEND_ALL); net_transfer += 4;
				send_skill(MY._Action_ID,       SEND_ALL); net_transfer += 4;
				send_skill(MY._Spell_ID,        SEND_ALL); net_transfer += 4;
			}

			MY._ActReq_ID = 0;

		} ELSE {

			// A counter request is waiting but can not be performed yet => store it
			IF ((MY._ActReq_ID == _action_counter) && (MY._ActReq_counter == 0)) {
				MY._ActReq_counter = MY._ActReq_handle;
			}

			// An action has been finished, look for a stored counter request
			IF ((MY._ActReq_ID == _action_stand) && (MY._ActReq_counter != 0)) {
				MY._ActReq_handle = MY._ActReq_counter;
				MY._ActReq_ID = _action_counter;
				MY._ActReq_counter = 0;
			}

		}

		IF (MY._emote_req < 0) {
			MY._emote_req = -MY._emote_req;
			SEND_SKILL(MY._emote_req, SEND_ALL); net_transfer += 4;
		}

	WAIT (1);
	}
}

// for far-distance attacks we'll create arrows, of course only local entities. ;-)
function create_arrow(ent_ptr_1, ent_ptr_2)
{
var vec_1;
var vec_2;

	ME = ENT_CREATELOCAL("arrow.mdl", MY.X, NULL);

	MY.PASSABLE = ON;

	YOU = ent_ptr_1;
	VEC_SET(vec_1.X, YOUR.X);
	YOU = ent_ptr_2;
	VEC_SET(vec_2.X, YOUR.X);

	MY._temp = VEC_DIST(vec_2.X, vec_1.X);
	VEC_DIFF(TEMP.X, vec_2.X, vec_1.X);
	VEC_TO_ANGLE(MY.PAN, TEMP.X);
	MY.TILT = 0;	// we only need the pan angle

	VEC_NORMALIZE(MY.SCALE_X, 2);

	WHILE (MY._temp > 160 * TIME) {
		VEC_SET(TEMP.X, vector((160 * TIME), 0, 0));
		VEC_ROTATE(TEMP.X, MY.PAN);
		VEC_ADD(MY.X, TEMP.X);

		MY._temp -= 160 * TIME;
	WAIT (1);
	}

	ENT_REMOVE(ME);
	RETURN;
}

function create_enemy(ID)
{
	IF (ME) {
		VEC_SET(TEMP.X, MY.X);
		YOU = ME;
	} ELSE {
		// Spawn position
		TEMP.X = 256 + Random(256);
		TEMP.Y = Random(256) -128;
		TEMP.Z = 50;
	}

	IF (ID == _num_slime)       { ME = ENT_CREATE("slime+12.bmp",       TEMP.X, NULL); }
	IF (ID == _num_raptor)      { ME = ENT_CREATE("raptor+12.bmp",      TEMP.X, NULL); }
	IF (ID == _num_allosaur)    { ME = ENT_CREATE("allosaur+12.bmp",    TEMP.X, NULL); }
	IF (ID == _num_decay_jelly) { ME = ENT_CREATE("decay jelly+12.bmp", TEMP.X, NULL); }
	IF (ID == _num_dragon)      { ME = ENT_CREATE("dragon+12.bmp",      TEMP.X, NULL); }
	IF (ID == _num_oktion)      { ME = ENT_CREATE("oktion+12.bmp",      TEMP.X, NULL); }
	IF (ID == _num_old_spirit)  { ME = ENT_CREATE("old spirit+12.bmp",  TEMP.X, NULL); }
	IF (ID == _num_frost_ooze)  { ME = ENT_CREATE("frost ooze+12.bmp",  TEMP.X, NULL); }
	IF (ID == _num_blue_dragon) { ME = ENT_CREATE("blue dragon+12.bmp", TEMP.X, NULL); }
	IF (ID == _num_cold_jelli)  { ME = ENT_CREATE("cold jelli+12.bmp",  TEMP.X, NULL); }
	IF (ID == _num_wraith)      { ME = ENT_CREATE("wraith+12.bmp",      TEMP.X, NULL); }
	IF (ID == _num_beholder_twins1)  { ME = ENT_CREATE("beholder twins1+12.bmp", TEMP.X, NULL); }
	IF (ID == _num_beholder_twins2)  { ME = ENT_CREATE("beholder twins2+12.bmp", TEMP.X, NULL); }
	IF (ID == _num_skeleton)    { ME = ENT_CREATE("skeleton+12.bmp",    TEMP.X, NULL); }
	IF (ID == _num_skeleton_poleman) { ME = ENT_CREATE("skeleton poleman+12.bmp",TEMP.X, NULL); }
	IF (ID == _num_dark_galert) { ME = ENT_CREATE("dark galert+12.bmp", TEMP.X, NULL); }
	IF (ID == _num_samurai_zombie)   { ME = ENT_CREATE("samurai zombie+12.bmp",  TEMP.X, NULL); }
	IF (ID == _num_little_death)     { ME = ENT_CREATE("little death+12.bmp",    TEMP.X, NULL); }
	IF (ID == _num_doom_dragon) { ME = ENT_CREATE("doom dragon+12.bmp", TEMP.X, NULL); }
	IF (ID == _num_ghost_lord)  { ME = ENT_CREATE("ghost lord+12.bmp",  TEMP.X, NULL); }
	IF (ID == _num_battle_lord) { ME = ENT_CREATE("battle lord+15.bmp", TEMP.X, NULL); }
	IF (ID == _num_evil_spirit) { ME = ENT_CREATE("evil spirit+12.bmp", TEMP.X, NULL); }
	IF (ID == _num_green_wizard)     { ME = ENT_CREATE("green wizard+12.bmp",    TEMP.X, NULL); }
	IF (ID == _num_ice_frog)   { ME = ENT_CREATE("ice frog+12.bmp",     TEMP.X, NULL); }
	IF (ID == _num_viscous_slime)    { ME = ENT_CREATE("viscous slime+12.bmp",   TEMP.X, NULL); }
	IF (ID == _num_succubus_twins1)  { ME = ENT_CREATE("succubus twins1+12.bmp", TEMP.X, NULL); }
	IF (ID == _num_succubus_twins2)  { ME = ENT_CREATE("succubus twins2+12.bmp", TEMP.X, NULL); }
	IF (ID == _num_risen_muck)   { ME = ENT_CREATE("risen muck+12.bmp",   TEMP.X, NULL); }
	IF (ID == _num_the_ring)  { ME = ENT_CREATE("the ring+12.bmp",  TEMP.X, NULL); }
	IF (ID == _num_acid_flan)  { ME = ENT_CREATE("acid flan+12.bmp",  TEMP.X, NULL); }
	IF (ID == _num_blood_rex)  { ME = ENT_CREATE("blood rex+12.bmp",  TEMP.X, NULL); }
	IF (ID == _num_white_dragon)     { ME = ENT_CREATE("white dragon+12.bmp",    TEMP.X, NULL); }
	IF (ID == _num_abyss_mage) { ME = ENT_CREATE("abyss mage+12.bmp", TEMP.X, NULL); }
	IF (ID == _num_doppelganger1)    { ME = ENT_CREATE("doppelganger1+12.bmp",   TEMP.X, NULL); }
	IF (ID == _num_doppelganger2)    { ME = ENT_CREATE("doppelganger2+12.bmp",   TEMP.X, NULL); }
	IF (ID == _num_blood_pudding)    { ME = ENT_CREATE("blood pudding+12.bmp",   TEMP.X, NULL); }
	IF (ID == _num_blade_demon)      { ME = ENT_CREATE("blade demon+12.bmp",     TEMP.X, NULL); }
	IF (ID == _num_phoenix_dragon)   { ME = ENT_CREATE("phoenix dragon+12.bmp",  TEMP.X, NULL); }
	IF (ID == _num_dawn_of_souls)    {
		ME = ENT_CREATE("dawn of souls+12.bmp",   TEMP.X, NULL);
		BOSS_PTR = ME;
	}
	IF (ID == _num_elder_ghost)      { ME = ENT_CREATE("elder ghost+12.bmp",     TEMP.X, NULL); }
	IF (ID == _num_damned_sorcerer)  { ME = ENT_CREATE("damned sorcerer+12.bmp", TEMP.X, NULL); }
	IF (ID == _num_zombie_witch)     { ME = ENT_CREATE("zombie witch+12.bmp",    TEMP.X, NULL); }
	if (ID == _num_zombie_dragon)		{ me = ent_create("zombie dragon+11.bmp",   temp.x, null); }


	IF (YOU) {
		MY._Actor_ID = YOUR._Actor_ID;
		MY._Level = YOUR._Level;
		SEND_SKILL(MY._Level, SEND_ALL); net_transfer += 4;
	} ELSE {
		MY._Actor_ID = _ID_Enemy;
		MY._Level = enemy_Level(enemies[3]);
		MY._dist_or_aggro = INT(Random(2));
	}

	MY._Actor_class = ID;
	MY._action_timer = Random(_action_time);	// Initiate the action timer

	activate_nosend(ME);	// First of all deactivate automatic sending
	set_stats(on);

	// Activate flags, the server will send the settings to the clients automatically.
	MY.FACING = ON;	// Always face the camera
	MY.FRAME = 1;	// standing
	MY.TRANSPARENT = ON;	// The next 2 fade the sprite border
	MY.ALPHA = 0;

//	WAIT (1);	// We'll give the server some time to do that stuff

	proc_local(ME, animate_actor);
	animate_actor();	// No need to check if we're on the server because we only can be since this function has been started from a server function

	SEND_SKILL(MY._Actor_class, SEND_ALL); net_transfer += 4;
	SEND_SKILL(MY._Actor_ID,    SEND_ALL); net_transfer += 4;
	SEND_SKILL(MY._Level,       SEND_ALL); net_transfer += 4;
	SEND_SKILL(MY._HP,			 SEND_ALL); net_transfer += 4;	// Needed for the death-detection on the clients
	SEND_SKILL(MY._MP,			 SEND_ALL); net_transfer += 4;	// Needed for clients to define if they still can cast spells
	SEND_SKILL(MY.X,            SEND_ALL + SEND_VEC); net_transfer += 12;	// Send the position of the actor

	data_flow();
	WAIT (1);

	// Here's some simple AI for this bot
	WHILE (MY._HP > 0) {
		MY._action_timer -= (1 + MY._Agi / 200) * TIME;
		IF (MY._action_timer < 0) {

			TEMP[0] = IIf(MY._dist_or_aggro, 9999, 0);	// distance/ aggro
			TEMP[1] = NULL;	// entity

			YOU = ENT_NEXT(NULL);
			WHILE (YOU) {
				// Only check alive players
				IF ((MY._Actor_ID == _ID_Enemy) && (YOUR._Actor_ID == _ID_Player) && (YOUR._HP > 0) ||
					 (MY._Actor_ID == _ID_Player) && (YOUR._Actor_ID == _ID_Enemy) && (YOUR._HP > 0)) {

					IF (MY._dist_or_aggro) {
						TEMP[2] = rel_dist(MY.X, YOUR.X);

						// Player closer than others
						IF (TEMP[2] < TEMP[0]) {
							TEMP[0] = TEMP[2];
							TEMP[1] = YOU;
						}
					} ELSE {
						// Player  with most aggro
						IF (TEMP[2] <= YOUR._Aggro) {
							TEMP[0] = rel_dist(MY.X, YOUR.X);
							TEMP[1] = YOU;
							TEMP[2] = YOUR._Aggro;
						}
					}
				}
			YOU = ENT_NEXT(YOU);
			}
			IF (TEMP[1] != NULL) {	// Player found
				IF (TEMP[0] < _action_range) {	// Player within action range
					MY._ActReq_handle = handle(TEMP[1]);
					MY._ActReq_ID = _action_attack;

					// define spells or stuff by checking MY._Actor_class

					// Decay Jelly heals if below 50% hits, enought MP avail. with 70% chance.
					IF ((MY._Actor_class == _num_decay_jelly) && (MY._HP < MY._Vit * 0.5) && (Random(100) < 70)) {
						MY._ActReq_ID = _action_regena;
						my._SpReq_ID = 1;
					}

					// Dragon heals if below 50% hits, enought MP avail. with 80% chance.
					IF ((MY._Actor_class == _num_dragon) && (MY._HP < MY._Vit * 0.5) && (Random(100) < 80)) {
						MY._ActReq_ID = _action_regena;
						my._SpReq_ID = 1;
					}

					// Oktion casts light spell 70% chance
					IF ((MY._Actor_class == _num_oktion) && (MY._MP >= _mp_light) && (Random(100) < 45)) {
						MY._ActReq_ID = _action_cast;
						my._SpReq_ID = 2;
					}

					// Old Spirit casts spells
					IF (MY._Actor_class == _num_old_spirit) {
						TEMP = Random(100);
						IF (MY._HP < MY._Vit * 0.5) {
							IF ((TEMP < 40) && (MY._MP >= _mp_heal)) {	// Heal 40%
								MY._ActReq_handle = handle(ME);
								MY._ActReq_ID = _action_cast;
								my._SpReq_ID = 1;
							}
							IF ((TEMP > 60) && (MY._MP >= _mp_light)) {	// Light spell 40%
								MY._ActReq_ID = _action_cast;
								my._SpReq_ID = 2;
							}
						} ELSE {
							IF ((TEMP < 60) && (MY._MP >= _mp_light)) {	// Light spell 60%
								MY._ActReq_ID = _action_cast;
								my._SpReq_ID = 2;
							}
						}
						IF ((MY._MP < MY._Int * 0.25) && (Random(100) < 10)) {	// Regenerate MP
							MY._ActReq_ID = _action_regena;
							my._SpReq_ID = 2;
						}
					}

					// Frost Ooze heals if below 50% hits, enought MP avail. with 70% chance.
					IF ((MY._Actor_class == _num_frost_ooze) && (MY._HP < MY._Vit * 0.5) && (Random(100) < 70)) {
						MY._ActReq_ID = _action_regena;
						my._SpReq_ID = 1;
					}

					// Blue Dragon casts spells
					IF (MY._Actor_class == _num_blue_dragon) {
						TEMP = Random(100);
						IF (MY._HP < MY._Vit * 0.5) {
							IF (TEMP < 60) {	// Regenerate 60%
								MY._ActReq_ID = _action_regena;
								my._SpReq_ID = 1;
							}
							IF ((TEMP > 80) && (MY._MP >= _mp_ice)) {	// Ice spell 20%
								MY._ActReq_ID = _action_cast;
								my._SpReq_ID = 3;
							}
						} ELSE {
							IF ((TEMP < 60) && (MY._MP >= _mp_ice)) {	// Ice spell 60%
								MY._ActReq_ID = _action_cast;
								my._SpReq_ID = 3;
							}
						}
					}

					// Cold Jelli casts spells.
					IF ((MY._Actor_class == _num_cold_jelli) && (Random(100) < 50) && (MY._MP >= _mp_lightning)) {
						MY._ActReq_ID = _action_cast;
						my._SpReq_ID = 4;
					}

					// Wraith casts spells
					IF (MY._Actor_class == _num_wraith) {
						TEMP = Random(100);
						IF (MY._buff_agi == 0) {
							IF ((TEMP < 50) && (MY._MP >= _mp_agi)) {	// Agi buff 50%
								MY._ActReq_handle = handle(ME);
								MY._ActReq_ID = _action_cast;
								my._SpReq_ID = 7;
							}
							IF ((TEMP > 60) && (MY._MP >= _mp_lightning)) {	// Lightning spell 40%
								MY._ActReq_ID = _action_cast;
								my._SpReq_ID = 4;
							}
						} ELSE {
							IF ((TEMP > 50) && (MY._MP >= _mp_lightning)) {	// Lightning spell 50%
								MY._ActReq_ID = _action_cast;
								my._SpReq_ID = 4;
							}
						}
					}

					// Beholder Twin 1 casts spells
					IF (MY._Actor_class == _num_beholder_twins1) {
						TEMP = Random(100);
						IF ((MY._buff_agi == 0) && (TEMP < 15) && (MY._MP >= _mp_agi)) {	// Agi buff 15%
							MY._ActReq_handle = handle(ME);
							MY._ActReq_ID = _action_cast;
							my._SpReq_ID = 7;
						}
						IF ((MY._HP < MY._Vit * 0.5) && (TEMP > 30)) {	// regena 70%
							MY._ActReq_ID = _action_regena;
							my._SpReq_ID = 1;
						}
						IF ((MY._MP < MY._Int * 0.25) && (Random(100) < 10)) {	// Regenerate MP
							MY._ActReq_ID = _action_regena;
							my._SpReq_ID = 2;
						}
					}

					// Beholder Twin 2 casts spells
					IF (MY._Actor_class == _num_beholder_twins2) {
						TEMP = Random(100);
						IF ((TEMP < 40) && (MY._MP >= _mp_lightning)) {	// Lightning spell 40%
							MY._ActReq_ID = _action_cast;
							my._SpReq_ID = 4;
						}
						IF ((TEMP > 60) && (MY._MP >= _mp_earth)) {	// Earth spell 40%
							MY._ActReq_ID = _action_cast;
							my._SpReq_ID = 5;
						}
						IF ((MY._MP < MY._Int * 0.25) && (Random(100) < 10)) {	// Regenerate MP
							MY._ActReq_ID = _action_regena;
							my._SpReq_ID = 2;
						}
					}

					// Dark Galert casts spells.
					IF ((MY._Actor_class == _num_dark_galert) && (Random(100) < 50) && (MY._MP >= _mp_earth)) {
						MY._ActReq_ID = _action_cast;
						my._SpReq_ID = 5;
					}

					// Samurai Zombie casts spells.
					IF ((MY._Actor_class == _num_samurai_zombie) && (Random(100) < 50) && (MY._MP >= _mp_earth)) {
						MY._ActReq_ID = _action_cast;
						my._SpReq_ID = 5;
					}

					// Doom Dragon casts spells
					IF (MY._Actor_class == _num_doom_dragon) {
						TEMP = Random(100);
						IF ((TEMP < 40) && (MY._MP >= _mp_lightning)) {	// Lightning spell 40%
							MY._ActReq_ID = _action_cast;
							my._SpReq_ID = 4;
						}
						IF ((MY._HP < MY._Vit * 0.5) && (TEMP < 50)) {	// regena instead of lightning
							MY._ActReq_ID = _action_regena;
							my._SpReq_ID = 1;
						}
						IF ((TEMP > 70) && (MY._MP >= _mp_earth)) {	// Earth spell 30%
							MY._ActReq_ID = _action_cast;
							my._SpReq_ID = 5;
						}
					}

					// Ghost Lord casts spells
					IF (MY._Actor_class == _num_ghost_lord) {
						TEMP = Random(100);
						IF ((TEMP < 80) && (MY._MP >= _mp_callskeleton)) {	// Call Skeleton 20%
							MY._ActReq_ID = _action_regena;
							my._SpReq_ID = 5;
						}
						IF ((TEMP < 60) && (MY._MP >= _mp_lightning)) {	// Lightning spell 20%
							MY._ActReq_ID = _action_cast;
							my._SpReq_ID = 4;
						}
						IF ((TEMP < 40) && (MY._MP >= _mp_earth)) {	// Earth spell 20%
							MY._ActReq_ID = _action_cast;
							my._SpReq_ID = 5;
						}
						IF ((TEMP < 20) && (MY._MP >= _mp_ice)) {	// Ice spell 20%
							MY._ActReq_ID = _action_cast;
							my._SpReq_ID = 3;
						}
						IF ((MY._MP < MY._Int * 0.25) && (Random(100) < 50)) {	// Regenerate MP
							MY._ActReq_ID = _action_regena;
							my._SpReq_ID = 2;
						}
						IF ((MY._HP < MY._Vit * 0.25) && (Random(100) < 35)) {	// Regenerate HP
							MY._ActReq_ID = _action_regena;
							my._SpReq_ID = 1;
						}
					}

					// Battle Lord heals if below 50% hits, enought MP avail. with 70% chance.
					IF ((MY._Actor_class == _num_battle_lord) && (MY._HP < MY._Vit * 0.5) && (Random(100) < 70)) {
						MY._ActReq_ID = _action_regena;
						my._SpReq_ID = 1;
					}

					// Evil Spirit casts spells
					IF (MY._Actor_class == _num_evil_spirit) {
						TEMP = Random(100);
						if ((MY._MP < MY._Int * 0.25) && (TEMP < 10)) {	// Regenerate MP
							MY._ActReq_ID = _action_regena;
							my._SpReq_ID = 2;
						}
						if ((TEMP < 40) && (MY._MP >= _mp_firerain)) {	// Fire rain 40%
							MY._ActReq_ID = _action_cast;
							my._SpReq_ID = 13;
						}
						if ((MY._HP < MY._Vit * 0.5) && (TEMP > 60)) {
							my._ActReq_ID = _action_regena;
							my._SpReq_ID = 1;
						}
					}

					// Green Wizard casts spells
					IF (MY._Actor_class == _num_green_wizard) {
						TEMP = Random(100);
						IF ((TEMP < 40) && (MY._MP >= _mp_laserinferno)) {	// Laser Inferno spell 40%
							MY._ActReq_ID = _action_cast;
							my._SpReq_ID = 10;
						}
						IF ((MY._MP < MY._Int * 0.5) && (TEMP < 50)) {	// regena MP instead of laser inferno
							MY._ActReq_ID = _action_regena;
							my._SpReq_ID = 2;
						}
						IF ((TEMP > 70) && (MY._MP >= _mp_earth)) {	// Earth spell 30%
							MY._ActReq_ID = _action_cast;
							my._SpReq_ID = 5;
						}
					}

					// Ice Frog casts spells.
					IF ((MY._Actor_class == _num_ice_frog) && (Random(100) < 40) && (MY._MP >= _mp_summonice)) {
						MY._ActReq_ID = _action_cast;
						my._SpReq_ID = 11;
					}

					// Succubus Twins 1 casts spells
					IF (MY._Actor_class == _num_succubus_twins1) {
						TEMP = Random(100);
						IF ((TEMP < 80) && (MY._MP >= _mp_firerain)) {	// Fire Rain spell 50%
							MY._ActReq_ID = _action_cast;
							my._SpReq_ID = 13;
						}
						IF ((TEMP < 30) && (MY._MP >= _mp_lightning)) {	// Lightning spell 30%
							MY._ActReq_ID = _action_cast;
							my._SpReq_ID = 4;
						}
						IF ((MY._MP < MY._Int * 0.25) && (TEMP < 50)) {	// Regenerate MP
							MY._ActReq_ID = _action_regena;
							my._SpReq_ID = 2;
						}
						IF ((MY._HP < MY._Vit * 0.25) && (TEMP < 35)) {	// Regenerate HP
							MY._ActReq_ID = _action_regena;
							my._SpReq_ID = 1;
						}
					}

					// Succubus Twins 2 casts spells
					IF (MY._Actor_class == _num_succubus_twins2) {
						TEMP = Random(100);
						IF ((TEMP < 40) && (my._timer_revengeleap <= _mp_revengeleap)) {	// Revenge Leap 80%
							MY._ActReq_ID = _action_regena;
							my._SpReq_ID = 7;
						}
						IF ((MY._HP < MY._Vit * 0.25) && (TEMP < 35)) {	// Regenerate HP
							MY._ActReq_ID = _action_regena;
							my._SpReq_ID = 1;
						}
					}

					// Risen Muck casts light spell 60% chance
					IF ((MY._Actor_class == _num_risen_muck) && (MY._MP >= _mp_light) && (Random(100) < 60)) {
						MY._ActReq_ID = _action_cast;
						my._SpReq_ID = 2;
					}

					// Scum Claw casts spells
					IF (MY._Actor_class == _num_the_ring) {
						TEMP = Random(100);
						if ((TEMP < 90) && (MY._MP >= _mp_meteor)) {	// Meteor 90%
							MY._ActReq_ID = _action_cast;
							my._SpReq_ID = 12;
						}
						if ((MY._HP < MY._Vit * 0.5) && (TEMP > 40)) {
							my._ActReq_ID = _action_regena;
							my._SpReq_ID = 1;
						}
					}

					// Acid Flan casts spells
					IF (MY._Actor_class == _num_acid_flan) {
						TEMP = Random(100);
						if ((TEMP < 40) && (MY._MP >= _mp_light)) {
							my._ActReq_ID = _action_cast;
							my._SpReq_ID = 2;
						}
						if ((TEMP < 80) && (MY._MP >= _mp_firerain)) {	// Fire rain 40%
							MY._ActReq_ID = _action_cast;
							my._SpReq_ID = 13;
						}
					}

					// White Dragon casts spells
					IF (MY._Actor_class == _num_white_dragon) {
						TEMP = Random(100);
						if (MY._buff_agi == 0) {
							if ((TEMP < 50) && (MY._MP >= _mp_agi)) {	// Agi buff 50%
								MY._ActReq_handle = handle(ME);
								MY._ActReq_ID = _action_cast;
								my._SpReq_ID = 7;
							}
							if ((TEMP > 60) && (MY._MP >= _mp_summonice)) {	// Summon Ice 40%
								MY._ActReq_ID = _action_cast;
								my._SpReq_ID = 11;
							}
						} else {
							if ((TEMP < 60) && (MY._MP >= _mp_summonice)) {	// Summon Ice 60%
								MY._ActReq_ID = _action_cast;
								my._SpReq_ID = 11;
							}
							if ((TEMP > 80) && (MY._MP >= _mp_ice)) {	// Ice spell 20%
								MY._ActReq_ID = _action_cast;
								my._SpReq_ID = 3;
							}
						}

						if ((MY._MP < MY._Int * 0.25) && (TEMP < 40)) {	// Regenerate MP 40%
							MY._ActReq_ID = _action_regena;
							my._SpReq_ID = 2;
						}
						if ((MY._HP < MY._Vit * 0.25) && (TEMP > 70)) {	// Regenerate HP 30%
//							my._ActReq_handle = handle(me);
							my._ActReq_ID = _action_regena;
							my._SpReq_ID = 1;
						}
					}

					// Abyss Mage casts spells
					IF (MY._Actor_class == _num_abyss_mage) {
						TEMP = Random(100);
						IF ((TEMP < 40) && (MY._MP >= _mp_light)) {	// Light spell 40%
							MY._ActReq_ID = _action_cast;
							my._SpReq_ID = 2;
						}
						IF ((TEMP > 60) && (MY._MP >= _mp_earth)) {	// Earth spell 40%
							MY._ActReq_ID = _action_cast;
							my._SpReq_ID = 5;
						}
						IF ((MY._HP < MY._Vit * 0.5) && (Random(100) < 90)) {	// Regenerate HP
							MY._ActReq_handle = handle(ME);
							MY._ActReq_ID = _action_cast;
							my._SpReq_ID = 1;
						}
					}

					// Doppelganger 1 casts spells
					IF (MY._Actor_class == _num_doppelganger1) {
						TEMP = Random(100);
						IF ((TEMP < 80) && (MY._MP >= _mp_earth)) {	// Earth spell 20%
							MY._ActReq_ID = _action_cast;
							my._SpReq_ID = 5;
						}
						IF ((TEMP < 60) && (MY._MP >= _mp_fire)) {	// Fire spell 20%
							MY._ActReq_ID = _action_cast;
							my._SpReq_ID = 8;
						}
						IF ((TEMP < 40) && (MY._MP >= _mp_lightning)) {	// Lightning spell 20%
							MY._ActReq_ID = _action_cast;
							my._SpReq_ID = 4;
						}
						IF ((TEMP < 20) && (MY._MP >= _mp_ice)) {	// Ice spell 20%
							MY._ActReq_ID = _action_cast;
							my._SpReq_ID = 3;
						}
						IF ((MY._MP < MY._Int * 0.25) && (TEMP < 50)) {	// Regenerate MP
							MY._ActReq_ID = _action_regena;
							my._SpReq_ID = 2;
						}
						IF ((MY._HP < MY._Vit * 0.25) && (TEMP < 35)) {	// Regenerate HP
							MY._ActReq_ID = _action_regena;
							my._SpReq_ID = 1;
						}
					}

					// Doppelganger 2 casts spells
					IF (MY._Actor_class == _num_doppelganger2) {
						TEMP = Random(100);
						IF ((TEMP < 40) && (my._timer_revengeleap <= _mp_revengeleap)) {	// Revenge Leap 80%
							MY._ActReq_ID = _action_regena;
							my._SpReq_ID = 7;
						}
						IF ((MY._HP < MY._Vit * 0.25) && (TEMP < 35)) {	// Regenerate HP
							MY._ActReq_ID = _action_regena;
							my._SpReq_ID = 1;
						}
					}

					// Blood Pudding heals Boss
					if (my._Actor_class == _num_blood_pudding) {
						TEMP = Random(100);
						if ((my._HP < my._Vit * 0.5) && (TEMP < 35)) {	// Regenerate HP
							my._ActReq_ID = _action_regena;
							my._SpReq_ID = 1;
						}
						if (BOSS_PTR) {
							if ((TEMP < 80) && (BOSS_PTR._HP < BOSS_PTR._Vit * 0.95)) {
								my._ActReq_handle = handle(BOSS_PTR);
								my._ActReq_ID = _action_cast;
								my._SpReq_ID = 1;
							}
						}
						if ((TEMP < 20) && (my._MP >= _mp_callbloodpudding) && (my._doubled == off)) {	// Call Blood Pudding 20%
							my._ActReq_ID = _action_regena;
							my._SpReq_ID = 10;
							my._doubled = on;
						}
					}

					// Blade Demon casts spells
					IF (MY._Actor_class == _num_blade_demon) {
						TEMP = Random(100);
						IF ((MY._HP < MY._Vit * 0.25) && (TEMP < 40)) {	// Regenerate HP
							MY._ActReq_ID = _action_regena;
							my._SpReq_ID = 1;
						}
					}

					// Phoenix Dragon casts spells
					if (MY._Actor_class == _num_phoenix_dragon) {
						TEMP = Random(100);
						IF ((TEMP < 40) && (MY._MP >= _mp_firerain)) {	// Fire Rain spell 40%
							MY._ActReq_ID = _action_cast;
							my._SpReq_ID = 13;
						}
						IF ((MY._HP < MY._Vit * 0.5) && (TEMP < 50)) {	// regena instead of lightning
							MY._ActReq_ID = _action_regena;
							my._SpReq_ID = 1;
						}
					}

					// Dawn of Souls casts spells
					IF (MY._Actor_class == _num_dawn_of_souls) {
						TEMP = Random(100);
						IF ((TEMP < 90) && (my._timer_revengeleap <= _mp_revengeleap)) {	// Revenge Leap 90%
							MY._ActReq_ID = _action_regena;
							my._SpReq_ID = 7;
						}
						IF ((TEMP < 80) && (MY._MP >= _mp_firerain)) {	// Fire rain 20%
							MY._ActReq_ID = _action_cast;
							my._SpReq_ID = 13;
						}
						IF ((TEMP < 60) && (MY._MP >= _mp_fire)) {	// Fire spell 25%
							MY._ActReq_ID = _action_cast;
							my._SpReq_ID = 8;
						}
						IF ((TEMP < 35) && (MY._MP >= _mp_earth)) {	// Earth spell 10%
							MY._ActReq_ID = _action_cast;
							my._SpReq_ID = 5;
						}
						IF ((TEMP < 25) && (MY._MP >= _mp_callskeleton)) {	// Call Skeleton 25%
							MY._ActReq_ID = _action_regena;
							my._SpReq_ID = 5;
						}
						IF ((MY._HP < MY._Vit * 0.25) && (TEMP < 20)) {	// Regenerate HP
							MY._ActReq_ID = _action_regena;
							my._SpReq_ID = 1;
						}
						IF ((MY._MP < MY._Int * 0.25) && (TEMP < 10)) {	// Regenerate MP
							MY._ActReq_ID = _action_regena;
							my._SpReq_ID = 2;
						}
					}

					// Elder Ghost casts spells
					IF (MY._Actor_class == _num_elder_ghost) {
						TEMP = Random(100);
						IF (MY._buff_agi == 0) {
							IF ((TEMP < 50) && (MY._MP >= _mp_agi)) {	// Agi buff 50%
								MY._ActReq_handle = handle(ME);
								MY._ActReq_ID = _action_cast;
								my._SpReq_ID = 7;
							}
							IF ((TEMP > 65) && (MY._MP >= _mp_lightning)) {	// Lightning spell 40%
								MY._ActReq_ID = _action_cast;
								my._SpReq_ID = 4;
							}
						} ELSE {
							IF ((TEMP > 55) && (MY._MP >= _mp_lightning)) {	// Lightning spell 50%
								MY._ActReq_ID = _action_cast;
								my._SpReq_ID = 4;
							}
						}
					}

					// Damned Sorcerer casts spells
					IF (MY._Actor_class == _num_damned_sorcerer) {
						TEMP = Random(100);
						IF ((TEMP < 40) && (MY._MP >= _mp_laserinferno)) {	// Laser Inferno spell 40%
							MY._ActReq_ID = _action_cast;
							my._SpReq_ID = 10;
						}
						IF ((TEMP > 60) && (MY._MP >= _mp_earth)) {	// Earth spell 40%
							MY._ActReq_ID = _action_cast;
							my._SpReq_ID = 5;
						}
						IF ((MY._HP < MY._Vit * 0.5) && (Random(100) < 90)) {	// Regenerate HP
							MY._ActReq_handle = handle(ME);
							MY._ActReq_ID = _action_cast;
							my._SpReq_ID = 1;
						}
					}

					// Zombie Witch casts spells
					IF (MY._Actor_class == _num_zombie_witch) {
						TEMP = Random(100);
						IF (MY._MP >= _mp_ice) {	// Ice spell 25%
							MY._ActReq_ID = _action_cast;
							my._SpReq_ID = 3;
						}
						IF ((TEMP < 75) && (MY._MP >= _mp_earth)) {	// Earth spell 50%
							MY._ActReq_ID = _action_cast;
							my._SpReq_ID = 5;
						}
						IF ((TEMP < 25) && (MY._MP >= _mp_callskeleton)) {	// Call Skeleton 25%
							MY._ActReq_ID = _action_regena;
							my._SpReq_ID = 5;
						}
					}

					// Zombie Dragon casts spells
					IF (MY._Actor_class == _num_zombie_dragon) {
						TEMP = Random(100);
						if (MY._buff_agi == 0) {
							if ((TEMP < 50) && (MY._MP >= _mp_agi)) {	// Agi buff 50%
								MY._ActReq_handle = handle(ME);
								MY._ActReq_ID = _action_cast;
								my._SpReq_ID = 7;
							}
							IF ((TEMP > 60) && (MY._MP >= _mp_laserinferno)) {	// Laser Inferno spell 40%
								MY._ActReq_ID = _action_cast;
								my._SpReq_ID = 10;
							}
						} else {
							IF ((TEMP < 20) && (MY._MP >= _mp_firerain)) {	// Fire rain 20%
								MY._ActReq_ID = _action_cast;
								my._SpReq_ID = 13;
							}
							IF ((TEMP > 70) && (MY._MP >= _mp_earth)) {	// Earth spell 30%
								MY._ActReq_ID = _action_cast;
								my._SpReq_ID = 5;
							}
						}

						if ((MY._MP < MY._Int * 0.25) && (TEMP < 40)) {	// Regenerate MP 40%
							MY._ActReq_ID = _action_regena;
							my._SpReq_ID = 2;
						}
						if ((MY._HP < MY._Vit * 0.25) && (TEMP > 75)) {	// Regenerate HP 25%
							my._ActReq_ID = _action_regena;
							my._SpReq_ID = 1;
						}
					}

				} ELSE {	// Beyond action range, move to target
					YOU = TEMP[1];
					VEC_DIFF(MY._Action_target_X, YOUR.X, MY.X);
					VEC_NORMALIZE(MY._Action_target_X, _action_range);
					VEC_ADD(MY._Action_target_X, MY.X);
					MY._ActReq_ID = _action_jump;

					// Wraith or White Dragon casts spells
					IF ((MY._Actor_class == _num_wraith) || (MY._Actor_class == _num_white_dragon) || (MY._Actor_class == _num_elder_ghost)) {
						IF ((MY._buff_agi == 0) && (Random(100) < 70) && (MY._MP >= _mp_agi)) {	// Agi buff 70%
							MY._ActReq_handle = handle(ME);
							MY._ActReq_ID = _action_cast;
							my._SpReq_ID = 7;
						}
					}

				}
			} else {
				if ((MY._Actor_class == _num_battle_lord) && (my._HP < my._Vit * 0.9)) {
					my._ActReq_ID = _action_regena;
					my._SpReq_ID = 1;
				}
			}

			MY._reset_timer = 0;
			WHILE ((MY._action_timer < 0) && (MY._HP > 0)) {
				// Avoid dead-lock
				IF ((MY._ActReq_ID == 0) && (MY._action == _action_stand)) {
					MY._reset_timer += TIME;
					IF (MY._reset_timer > 24) { break; }
				} ELSE {
					MY._reset_timer = 0;
				}
			WAIT (1);
			}
			IF (MY._reset_timer > 24) { continue; }	// No action performed yet, thus don't reset the action timer but create a new action request.

			MY._action_timer = _action_time;
		}
	WAIT (1);
	}

	MY.PASSABLE = ON;
	WHILE (MY.ALPHA > 0) { WAIT (1); }	// Wait until enemy is faded out.

	ENT_REMOVE(ME);
	RETURN;
}

function serverside_playerfunction()
{
	activate_nosend(ME);	// First of all deactivate automatic sending

	// Wait until the client sent his values that define the type of the entity
	WHILE (MY._Actor_ID == _ID_Undefined) { WAIT (1); }

	// Now that we've got the _Actor_ID and _Actor_class we cen set the actors stats
	if (my._Level == 0) { set_stats(on); }
	MY._player_number = -1;
//	MY._Level = INT(Random(4)) + 8;set_stats();
//	MY._Level = 20;
//	set_stats();
//	my._pdam += 20;
//	my._mdam += 20;
//	my._pdef += 20;
//	my._mdef += 20;

	// Set the player handle
	TEMP = 0;
	WHILE (TEMP < 4) {
		IF (current_player[TEMP] == 0) {
			IF (MY._player_number == -1) {
				MY._player_number = TEMP;
				current_player[TEMP] = handle(ME);	// Well... we'll see what this handels could be useful for.

				// Use the string we've got from the client
//				STR_CPY(player_names.string[TEMP], player_name_to_server);

				// Send the player number to everyone so that every client can use this number to refer to the player's name
				SEND_SKILL(MY._player_number, SEND_ALL); net_transfer += 4;
//				SEND_STRING(player_names.string[TEMP]); net_transfer += STR_LEN(player_names.string[TEMP]);
			}
		} ELSE {
			// Send the same stuff from all players who are already online to the new player
			you = ptr_for_handle(current_player[temp]);
			send_skill(your._player_number, send_all); net_transfer += 4;
//			SEND_STRING(player_names.string[TEMP]); net_transfer += STR_LEN(player_names.string[TEMP]);
		}
	temp += 1;
	}

	you = ent_next(null);
	while (you) {
		// If this is any kind of actor
		if (your._Actor_ID) {
			send_important_skills(me);
		}
	you = ent_next(you);
	}

	if (Level_Select) { send_var_to(me, Level_Select); }	// If someone loggs in during trade, activate his trade menue
	if (freeze_game) { send_var(freeze_game); net_transfer += 12; }

	// Activate flags, the server will send the settings to the clients automatically.
	MY.FACING   = ON;	// Always face the camera
	MY.FRAME = 1;
	MY.TRANSPARENT = ON;	// The next 2 fade the sprite border
	MY.ALPHA = 0;

	// Each client has to animate all actors on his own. The server will distribute the values that are needed to animate them.
	proc_local(me, animate_actor);
	animate_actor();	// No need to check if we're on the server because we only can be since this function has been started within an ent_create() instruction

	data_flow();
}


///////////////////////////////////////////////////////
// The player and what else is needed
function move_camera()
{
var cam_dist;
camera_angle.PAN = -57;

	WHILE (1) {
		IF (PLAYER) {
			// Rotate view angle
//			IF (MOUSE_POS.X <=    1) { camera_angle.PAN += 8 * TIME; }
//			IF (MOUSE_POS.X >= 1021) { camera_angle.PAN -= 8 * TIME; }
			camera_angle.PAN -= ((MOUSE_POS.X >= 1021) - (MOUSE_POS.X <= 1)) * 8 * TIME;


			VEC_SET(cam_dist.X, vector(-640, 0, 192));
			VEC_ROTATE(cam_dist.X, camera_angle.PAN);

			VEC_TO_ANGLE(CAMERA.PAN, cam_dist.X);
			CAMERA.PAN  += 180;
			CAMERA.TILT *= -1;

			if (_cam_target) {
				camera.x = _cam_target.x;
				camera.y = _cam_target.y;
				camera.z = 50;
			} else {
				vec_set(camera.x, nullvector);
			}
			vec_add(camera.x, cam_dist.x);

			IF (Camtramble[1] < 1800) {
				CAMERA.Z += FSIN(Camtramble[1], Camtramble[2] * (1 - (Camtramble[1] / 1800)));
				Camtramble[1] += 180 * TIME;
			}
			if (Camquake[0] > 0) {
				Camquake[1] += time;
				if (Camquake[1] > 0.8) {
					Camquake[1] -= 0.8;
					Camquake[2] *= -0.99;
				}
				camera.z += Camquake[2];
				Camquake -= time;
			}
		}
	WAIT (1);
	}
	RETURN;
}

function mouse_toggle() // switches the mouse on and off
{ 
	MOUSE_MAP = mouse; // standard arrow
	MOUSE_MODE += 2;

	IF (MOUSE_MODE > 2) { MOUSE_MODE = 0; }

	WHILE (MOUSE_MODE > 0) { 
		MOUSE_POS.X = MIN(1022, MAX(0, POINTER.X));
		MOUSE_POS.Y = MIN( 766, MAX(0, POINTER.Y));

		mouse_to_level();
		IF (_mouse_ent) {
			IF (_mouse_ent._you_save != 0) {
				_mouse_ent = _mouse_ent._you_save;
			}

			IF ((_mouse_ent._player_number != -1) && (_mouse_ent._Actor_ID != 0)) {
				show_actor_class.visible = ON;

				VEC_SET (TEMP.X, _mouse_ent.X);
				VEC_TO_SCREEN (TEMP.X, CAMERA);

				show_actor_class.pos_x = TEMP.X;
				show_actor_class.pos_y = TEMP.Y - 54;

				IF (_mouse_ent._Actor_ID == _ID_Player) {
					STR_CPY(show_actor_string, actor_class.string[_mouse_ent._Actor_class]);
					IF (_mouse_ent._Actor_class == _num_knight) { STR_CPY(show_actor_string, "Stahn"); }
					IF (_mouse_ent._Actor_class == _num_archer) { STR_CPY(show_actor_string, "Lenna"); }
					IF (_mouse_ent._Actor_class == _num_priest) { STR_CPY(show_actor_string, "Kim"); }
					IF (_mouse_ent._Actor_class == _num_wizard) { STR_CPY(show_actor_string, "Xia"); }
					if (_mouse_ent._Actor_class == _num_valkyrie) { str_cpy(show_actor_string, "Lenna [Valkyrie]"); }
					STR_CAT(show_actor_string, " lvl ");
					STR_FOR_NUM(TEMP_STRING, _mouse_ent._Level);
					STR_CAT(show_actor_string, TEMP_STRING);
					STR_CAT(show_actor_string, "\nHits ");
					STR_FOR_NUM(TEMP_STRING, INT(_mouse_ent._HP + 0.5));
					STR_CAT(show_actor_string, TEMP_STRING);
					STR_CAT(show_actor_string, "/ ");
					STR_FOR_NUM(TEMP_STRING, INT(_mouse_ent._Vit + 0.5));
					STR_CAT(show_actor_string, TEMP_STRING);
					STR_CAT(show_actor_string, "\nKills ");
					STR_FOR_NUM(TEMP_STRING, _mouse_ent._kills);
					STR_CAT(show_actor_string, TEMP_STRING);

					IF (_mouse_ent._buff_Agi   != 0) {
						STR_CAT(show_actor_string, "\n+ Agility [");
						STR_FOR_NUM(TEMP_STRING, MAX(0, INT(_mouse_ent._timer_Agi / 16 + 0.5)));
						STR_CAT(show_actor_string, TEMP_STRING);
						STR_CAT(show_actor_string, "]");
					}
					IF (_mouse_ent._buff_mpdef != 0) {
						STR_CAT(show_actor_string, "\n+ Defence [");
						STR_FOR_NUM(TEMP_STRING, MAX(0, INT(_mouse_ent._timer_mpdef / 16 + 0.5)));
						STR_CAT(show_actor_string, TEMP_STRING);
						STR_CAT(show_actor_string, "]");
					}
					IF ((_mouse_ent._buff_Str != 0) && (_mouse_ent._buff_Dex != 0)) {
						STR_CAT(show_actor_string, "\n+ Battle Rage [");
						STR_FOR_NUM(TEMP_STRING, MAX(0, INT(_mouse_ent._timer_battlerage / 16 + 0.5)));
						STR_CAT(show_actor_string, TEMP_STRING);
						STR_CAT(show_actor_string, "]");
					}
					if (_mouse_ent._timer_thornaura > 0) {
						str_cat(show_actor_string, "\n+ Thorn Aura [");
						str_for_num(TEMP_STRING, max(0, int(_mouse_ent._timer_thornaura / 16 + 0.5)));
						str_cat(show_actor_string, TEMP_STRING);
						str_cat(show_actor_string, "]");
					}
					if (_mouse_ent._timer_transform > 0) {
						str_cat(show_actor_string, "\n+ Transformed [");
						str_for_num(TEMP_STRING, max(0, int(_mouse_ent._timer_transform / 16 + 0.5)));
						str_cat(show_actor_string, TEMP_STRING);
						str_cat(show_actor_string, "]");
					}
				} ELSE {
					STR_CPY(show_actor_string, actor_class.string[_mouse_ent._Actor_class]);
					STR_CAT(show_actor_string, " lvl ");
					STR_FOR_NUM(TEMP_STRING, _mouse_ent._Level);
					STR_CAT(show_actor_string, TEMP_STRING);

					IF ((_mouse_ent._Weakness != 0) && (PLAYER)) {
						IF ((_mouse_ent._Weakness == 2) && (PLAYER._Actor_class == _num_priest)) { STR_CAT(show_actor_string, "\nWeakness: Light"); }
						IF ((_mouse_ent._Weakness == 3) && (PLAYER._Actor_class == _num_wizard)) { STR_CAT(show_actor_string, "\nWeakness: Ice"); }
						IF ((_mouse_ent._Weakness == 4) && (PLAYER._Actor_class == _num_wizard)) { STR_CAT(show_actor_string, "\nWeakness: Lightning"); }
						IF ((_mouse_ent._Weakness == 5) && (PLAYER._Actor_class == _num_wizard)) { STR_CAT(show_actor_string, "\nWeakness: Earth"); }
						IF ((_mouse_ent._Weakness == 8) && ((PLAYER._Actor_class == _num_wizard) || (PLAYER._Actor_class == _num_valkyrie))) { STR_CAT(show_actor_string, "\nWeakness: Fire"); }
					}
				}
			} ELSE {
				show_actor_class.visible = OFF;
			}
		} ELSE {
			show_actor_class.visible = OFF;
		}
	WAIT (1);
	}

	RETURN;
}

function mouse_to_level()
{
var vecTo;
var vecFrom;

		vecFrom.X = MOUSE_POS.X;
		vecFrom.Y = MOUSE_POS.Y;
		vecFrom.Z = 10;
		VEC_SET (vecTo.X, vecFrom.X);
		VEC_FOR_SCREEN (vecFrom.X, CAMERA);

		vecTo.Z = 2000;
		VEC_FOR_SCREEN (vecTo, CAMERA);

//		TRACE_MODE = 0;
//		TRACE (vecFrom, vecTo);
		RESULT = C_TRACE (vecFrom.X, vecTo.X, IGNORE_PASSABLE + IGNORE_PASSENTS + _ignore_sprites);

		IF (RESULT) { VEC_SET(pos_target.X, TARGET.X);
		} ELSE { VEC_SET(pos_target.X, NULLVECTOR); }
		_mouse_ent = YOU;
//			RETURN (C_TRACE (vecFrom, vecTo, IGNORE_PASSABLE + IGNORE_SPRITES));
}

function object_to_camera(entptr, dist)
{
	YOU = entptr;
	WHILE ((ME) && (YOU)) {
		VEC_SET(MY.X, vector(-dist, 0, 0));
		VEC_ROTATE(MY.X, CAMERA.PAN);
		VEC_ADD(MY.X, YOUR.X);
	WAIT (1);
	}

	RETURN;
}

function right_direction()
{
/*	TEMP[0] = 180 - ang(CAMERA.PAN);
	TEMP[1] = 180 - ang(MY._angle);

	IF (TEMP[0] > TEMP[1]) { MY.SCALE_X = 1;
	} ELSE { MY.SCALE_X = -1; }*/

	VEC_SET(TEMP.X, vector(1, 0, 0));	// create normal vector

//	VEC_ROTATE(TEMP.X, vector(MY._angle,   0, 0));
//	VEC_ROTATE(TEMP.X, vector(-CAMERA.PAN, 0, 0));

	VEC_ROTATE(TEMP.X, vector(MY._angle - CAMERA.PAN,   0, 0));

	MY.SCALE_X = IIf(TEMP.Y > 0, 1, -1);
}

// since everything works on the same z-layer I need to calculate distances with ignoring the z-value if there are differences
function rel_dist(&vec_1, &vec_2)
{
	return(vec_dist(vector(vec_1[0], vec_1[1], 0), vector(vec_2[0], vec_2[1], 0)));
}

// only for players
function setBasicValues()
{
var class;
	class = getRealActorClass(my._Actor_class);

	my._pdam = weaponpDam[class];
	my._mdam = weaponmDam[class];

	my._pdef = armorpDef[class];
	my._mdef = armormDef[class];

	return;
}

function set_stats(heal)
{
	TEMP = pow(1.05, MY._Level);
	IF (MY._Actor_class == _num_knight) {
		MY._Str =  70 * TEMP;	//  80
		MY._Dex =  80 * TEMP;	//  95
		MY._Agi =  70 * TEMP;	//  85
		MY._Vit = 100 * TEMP;	// 120
		MY._Int =  40 * TEMP;	//  50
		MY._Wis =  15 * TEMP;

		if (MY._Level == 0) {
			setBasicValues();
//			MY._pdam = 50;
//			MY._mdam =  5;
//
//			MY._pdef = 25;
//			MY._mdef = 10;
		}

		MY._weakness = 0;
	}
	IF (MY._Actor_class == _num_archer) {
		MY._Str =  65 * TEMP;	//  70
		MY._Dex =  80 * TEMP;	//  95
		MY._Agi =  75 * TEMP;	//  90
		MY._Vit =  85 * TEMP;	// 100
		MY._Int =  60 * TEMP;	//  70
		MY._Wis =  20 * TEMP;

		if (MY._Level == 0) {
			setBasicValues();
//			MY._pdam = 50;
//			MY._mdam =  5;
//
//			MY._pdef = 20;
//			MY._mdef = 15;
		}

		MY._weakness = 0;
	}
	IF (MY._Actor_class == _num_priest) {
		MY._Str =  50 * TEMP;	//  60
		MY._Dex =  70 * TEMP;	//  80
		MY._Agi =  70 * TEMP;	//  85
		MY._Vit =  85 * TEMP;	// 100
		MY._Int =  90 * TEMP;	// 105
		MY._Wis =  65 * TEMP;	//  75

		if (MY._Level == 0) {
			setBasicValues();
//			MY._pdam = 30;
//			MY._mdam = 45;
//
//			MY._pdef = 20;
//			MY._mdef = 20;
		}

		MY._weakness = 0;
	}
	IF (MY._Actor_class == _num_wizard) {
		MY._Str =  50 * TEMP;	//  50
		MY._Dex =  65 * TEMP;	//  75
		MY._Agi =  70 * TEMP;	//  80
		MY._Vit =  75 * TEMP;	//  90
		MY._Int = 100 * TEMP;	// 120
		MY._Wis =  70 * TEMP;	//  80

		if (MY._Level == 0) {
			setBasicValues();
//			MY._pdam = 25;
//			MY._mdam = 50;
//
//			MY._pdef = 15;
//			MY._mdef = 30;
		}

		MY._weakness = 0;
	}
	IF (MY._Actor_class == _num_slime) {
		MY._Str =  30 * (0.8 + Random(0.4)) * TEMP;
		MY._Dex =  60 * (0.8 + Random(0.4)) * TEMP;
		MY._Agi =  70 * (0.8 + Random(0.4)) * TEMP;
		MY._Vit =  30 * TEMP;
		MY._Int =   5 * (0.8 + Random(0.4)) * TEMP;
		MY._Wis =   5 * (0.8 + Random(0.4)) * TEMP;

		MY._pdam = 25 * (0.8 + Random(0.4)) * TEMP;
		MY._mdam =  5 * (0.8 + Random(0.4));

		MY._pdef =  5 * (0.8 + Random(0.4));
		MY._mdef =  5 * (0.8 + Random(0.4));

		MY._weakness = 3;
	}
	IF (MY._Actor_class == _num_raptor) {
		MY._Str =  50 * (0.8 + Random(0.4)) * TEMP;
		MY._Dex =  70 * (0.8 + Random(0.4)) * TEMP;
		MY._Agi =  95 * (0.8 + Random(0.4)) * TEMP;
		MY._Vit =  45 * TEMP;
		MY._Int =  10 * (0.8 + Random(0.4)) * TEMP;
		MY._Wis =  10 * (0.8 + Random(0.4)) * TEMP;

		MY._pdam = 30 * (0.8 + Random(0.4));
		MY._mdam =  5 * (0.8 + Random(0.4));

		MY._pdef = 10 * (0.8 + Random(0.4));
		MY._mdef = 10 * (0.8 + Random(0.4));
	}
	IF (MY._Actor_class == _num_allosaur) {
		MY._Str =  95 * (0.8 + Random(0.4)) * TEMP;
		MY._Dex =  75 * (0.8 + Random(0.4)) * TEMP;
		MY._Agi =  35 * (0.8 + Random(0.4)) * TEMP;
		MY._Vit =  80 * TEMP;
		MY._Int =  10 * (0.8 + Random(0.4)) * TEMP;
		MY._Wis =   5 * (0.8 + Random(0.4)) * TEMP;

		MY._pdam = 25 * (0.8 + Random(0.4));
		MY._mdam =  5 * (0.8 + Random(0.4));

		MY._pdef = 15 * (0.8 + Random(0.4));
		MY._mdef =  5 * (0.8 + Random(0.4));

		MY._weakness = 3;
	}
	IF (MY._Actor_class == _num_decay_jelly) {
		MY._Str =  50 * (0.8 + Random(0.4)) * TEMP;
		MY._Dex =  65 * (0.8 + Random(0.4)) * TEMP;
		MY._Agi =  60 * (0.8 + Random(0.4)) * TEMP;
		MY._Vit =  45 * TEMP;
		MY._Int =  25 * (0.8 + Random(0.4)) * TEMP;
		MY._Wis =  20 * (0.8 + Random(0.4)) * TEMP;

		MY._pdam = 30 * (0.8 + Random(0.4));
		MY._mdam = 10 * (0.8 + Random(0.4));

		MY._pdef = 10 * (0.8 + Random(0.4));
		MY._mdef = 10 * (0.8 + Random(0.4));

		MY._weakness = 3;
	}
	IF (MY._Actor_class == _num_dragon) {
		MY._Str =  70 * (0.8 + Random(0.4));
		MY._Dex =  80 * (0.8 + Random(0.4)) * TEMP;
		MY._Agi =  60 * (0.8 + Random(0.4)) * TEMP;
		MY._Vit =  75 * TEMP;
		MY._Int =  10 * (0.8 + Random(0.4)) * TEMP;
		MY._Wis =  30 * (0.8 + Random(0.4)) * TEMP;

		MY._pdam = 35 * (0.8 + Random(0.4));
		MY._mdam = 25 * (0.8 + Random(0.4));

		MY._pdef = 15 * (0.8 + Random(0.4));
		MY._mdef = 10 * (0.8 + Random(0.4));
	}
	IF (MY._Actor_class == _num_oktion) {
		MY._Str =  65 * (0.8 + Random(0.4)) * TEMP;
		MY._Dex =  65 * (0.8 + Random(0.4));
		MY._Agi =  55 * (0.8 + Random(0.4));
		MY._Vit =  80 * TEMP;
		MY._Int =  60 * (0.8 + Random(0.4));
		MY._Wis =  55 * (0.8 + Random(0.4));

		MY._pdam = 20 * (0.8 + Random(0.4));
		MY._mdam = 25 * (0.8 + Random(0.4));

		MY._pdef = 15 * (0.8 + Random(0.4));
		MY._mdef = 25 * (0.8 + Random(0.4));

		MY._weakness = 4;
	}
	IF (MY._Actor_class == _num_old_spirit) {
		MY._Str =  80 * (0.8 + Random(0.4)) * TEMP;
		MY._Dex =  75 * (0.8 + Random(0.4)) * TEMP;
		MY._Agi =  70 * (0.8 + Random(0.4)) * TEMP;
		MY._Vit = 500 * TEMP;
		MY._Int =  60 * (0.8 + Random(0.4)) * TEMP;
		MY._Wis =  55 * (0.8 + Random(0.4)) * TEMP;

		MY._pdam = 35 * (0.8 + Random(0.4));
		MY._mdam = 30 * (0.8 + Random(0.4));

		MY._pdef =  5 * (0.8 + Random(0.4));
		MY._mdef =  5 * (0.8 + Random(0.4));
	}
	IF (MY._Actor_class == _num_frost_ooze) {
		MY._Str =  60 * (0.8 + Random(0.4));
		MY._Dex =  70 * (0.8 + Random(0.4)) * TEMP;
		MY._Agi =  50 * (0.8 + Random(0.4)) * TEMP;
		MY._Vit =  55 * TEMP;
		MY._Int =  25 * (0.8 + Random(0.4));
		MY._Wis =  20 * (0.8 + Random(0.4));

		MY._pdam = 35 * (0.8 + Random(0.4));
		MY._mdam = 10 * (0.8 + Random(0.4));

		MY._pdef = 10 * (0.8 + Random(0.4));
		MY._mdef = 10 * (0.8 + Random(0.4));

		MY._weakness = 8;
	}
	IF (MY._Actor_class == _num_blue_dragon) {
		MY._Str =  70 * (0.8 + Random(0.4));
		MY._Dex =  75 * (0.8 + Random(0.4)) * TEMP;
		MY._Agi =  60 * (0.8 + Random(0.4));
		MY._Vit = 100 * TEMP;
		MY._Int =  20 * (0.8 + Random(0.4)) * TEMP;
		MY._Wis =  50 * (0.8 + Random(0.4));

		MY._pdam = 35 * (0.8 + Random(0.4));
		MY._mdam = 30 * (0.8 + Random(0.4));

		MY._pdef = 20 * (0.8 + Random(0.4));
		MY._mdef = 15 * (0.8 + Random(0.4));

		MY._weakness = 4;
	}
	IF (MY._Actor_class == _num_cold_jelli) {
		MY._Str =  75 * (0.8 + Random(0.4));
		MY._Dex =  70 * (0.8 + Random(0.4));
		MY._Agi =  60 * (0.8 + Random(0.4)) * TEMP;
		MY._Vit =  70 * TEMP;
		MY._Int =  50 * (0.8 + Random(0.4)) * TEMP;
		MY._Wis =  45 * (0.8 + Random(0.4)) * TEMP;

		MY._pdam = 30 * (0.8 + Random(0.4));
		MY._mdam = 30 * (0.8 + Random(0.4));

		MY._pdef = 20 * (0.8 + Random(0.4));
		MY._mdef = 25 * (0.8 + Random(0.4));

		MY._weakness = 8;
	}
	IF (MY._Actor_class == _num_wraith) {
		MY._Str =  65 * (0.8 + Random(0.4));
		MY._Dex =  75 * (0.8 + Random(0.4)) * TEMP;
		MY._Agi =  70 * (0.8 + Random(0.4));
		MY._Vit =  80 * TEMP;
		MY._Int =  70 * (0.8 + Random(0.4));
		MY._Wis =  60 * (0.8 + Random(0.4));

		MY._pdam = 30 * (0.8 + Random(0.4));
		MY._mdam = 30 * (0.8 + Random(0.4));

		MY._pdef = 25 * (0.8 + Random(0.4));
		MY._mdef = 30 * (0.8 + Random(0.4));

		MY._weakness = 2;
	}
	IF (MY._Actor_class == _num_beholder_twins1) {
		MY._Str =  80 * (0.8 + Random(0.4)) * TEMP;
		MY._Dex =  75 * (0.8 + Random(0.4)) * TEMP;
		MY._Agi =  65 * (0.8 + Random(0.4)) * TEMP;
		MY._Vit = 450 * TEMP;
		MY._Int =  30 * (0.8 + Random(0.4)) * TEMP;
		MY._Wis =  30 * (0.8 + Random(0.4)) * TEMP;

		MY._pdam = 35 * (0.8 + Random(0.4));
		MY._mdam = 15 * (0.8 + Random(0.4));

		MY._pdef =  5 * (0.8 + Random(0.4)) * TEMP;
		MY._mdef =  5 * (0.8 + Random(0.4)) * TEMP;
	}
	IF (MY._Actor_class == _num_beholder_twins2) {
		MY._Str =  50 * (0.8 + Random(0.4)) * TEMP;
		MY._Dex =  65 * (0.8 + Random(0.4)) * TEMP;
		MY._Agi =  75 * (0.8 + Random(0.4)) * TEMP;
		MY._Vit = 400 * TEMP;
		MY._Int =  60 * (0.8 + Random(0.4)) * TEMP;
		MY._Wis =  60 * (0.8 + Random(0.4)) * TEMP;

		MY._pdam = 20 * (0.8 + Random(0.4));
		MY._mdam = 35 * (0.8 + Random(0.4));

		MY._pdef =  5 * (0.8 + Random(0.4)) * TEMP;
		MY._mdef =  5 * (0.8 + Random(0.4)) * TEMP;
	}
	IF (MY._Actor_class == _num_skeleton) {
		MY._Str =  60 * (0.8 + Random(0.4));
		MY._Dex =  75 * (0.8 + Random(0.4)) * TEMP;
		MY._Agi =  70 * (0.8 + Random(0.4));
		MY._Vit =  80 * TEMP;
		MY._Int =  10 * (0.8 + Random(0.4));
		MY._Wis =  10 * (0.8 + Random(0.4));

		MY._pdam = 30 * (0.8 + Random(0.4));
		MY._mdam =  5 * (0.8 + Random(0.4));

		MY._pdef = 10 * (0.8 + Random(0.4));
		MY._mdef = 10 * (0.8 + Random(0.4));

		MY._weakness = 2;
	}
	IF (MY._Actor_class == _num_skeleton_poleman) {
		MY._Str =  70 * (0.8 + Random(0.4));
		MY._Dex =  70 * (0.8 + Random(0.4));
		MY._Agi =  70 * (0.8 + Random(0.4)) * TEMP;
		MY._Vit =  75 * TEMP;
		MY._Int =  10 * (0.8 + Random(0.4));
		MY._Wis =  10 * (0.8 + Random(0.4));

		MY._pdam = 35 * (0.8 + Random(0.4));
		MY._mdam =  5 * (0.8 + Random(0.4));

		MY._pdef = 15 * (0.8 + Random(0.4));
		MY._mdef = 15 * (0.8 + Random(0.4));

		MY._weakness = 2;
	}
	IF (MY._Actor_class == _num_dark_galert) {
		MY._Str =  75 * (0.8 + Random(0.4));
		MY._Dex =  70 * (0.8 + Random(0.4)) * TEMP;
		MY._Agi =  50 * (0.8 + Random(0.4));
		MY._Vit =  75 * TEMP;
		MY._Int =  35 * (0.8 + Random(0.4));
		MY._Wis =  30 * (0.8 + Random(0.4));

		MY._pdam = 35 * (0.8 + Random(0.4));
		MY._mdam = 25 * (0.8 + Random(0.4));

		MY._pdef = 15 * (0.8 + Random(0.4));
		MY._mdef = 15 * (0.8 + Random(0.4));

		MY._weakness = 2;
	}
	IF (MY._Actor_class == _num_samurai_zombie) {
		MY._Str =  70 * (0.8 + Random(0.4));
		MY._Dex =  80 * (0.8 + Random(0.4));
		MY._Agi =  70 * (0.8 + Random(0.4)) * TEMP;
		MY._Vit =  95 * TEMP;
		MY._Int =  50 * (0.8 + Random(0.4));
		MY._Wis =  50 * (0.8 + Random(0.4));

		MY._pdam = 35 * (0.8 + Random(0.4));
		MY._mdam = 35 * (0.8 + Random(0.4));

		MY._pdef = 20 * (0.8 + Random(0.4));
		MY._mdef = 20 * (0.8 + Random(0.4));

		MY._weakness = 2;
	}
	IF (MY._Actor_class == _num_little_death) {
		MY._Str =  60 * (0.8 + Random(0.4));
		MY._Dex =  75 * (0.8 + Random(0.4));
		MY._Agi =  70 * (0.8 + Random(0.4));
		MY._Vit =  75 * TEMP;
		MY._Int =  10 * (0.8 + Random(0.4));
		MY._Wis =  10 * (0.8 + Random(0.4));

		MY._pdam = 50 * (0.8 + Random(0.4));
		MY._mdam =  5 * (0.8 + Random(0.4));

		MY._pdef = 20 * (0.8 + Random(0.4));
		MY._mdef = 20 * (0.8 + Random(0.4));

		MY._weakness = 2;
	}
	IF (MY._Actor_class == _num_doom_dragon) {
		MY._Str =  90 * (0.8 + Random(0.4));
		MY._Dex =  80 * (0.8 + Random(0.4));
		MY._Agi =  55 * (0.8 + Random(0.4)) * TEMP;
		MY._Vit = 150 * TEMP;
		MY._Int =  50 * (0.8 + Random(0.4));
		MY._Wis =  50 * (0.8 + Random(0.4));

		MY._pdam = 35 * (0.8 + Random(0.4));
		MY._mdam = 35 * (0.8 + Random(0.4));

		MY._pdef =  5 * (0.8 + Random(0.4));
		MY._mdef =  5 * (0.8 + Random(0.4));

		MY._weakness = 5;
	}
	IF (MY._Actor_class == _num_ghost_lord) {
		MY._Str =   90 * (0.8 + Random(0.4)) * TEMP;
		MY._Dex =   85 * (0.8 + Random(0.4)) * TEMP;
		MY._Agi =   80 * (0.8 + Random(0.4)) * TEMP;
		MY._Vit = 1500 * TEMP;
		MY._Int =  200 * (0.8 + Random(0.4)) * TEMP;
		MY._Wis =   50 * (0.8 + Random(0.4)) * TEMP;

		MY._pdam =  40 * (0.8 + Random(0.4));
		MY._mdam =  40 * (0.8 + Random(0.4));

		MY._pdef =   5 * (0.8 + Random(0.4)) * TEMP;
		MY._mdef =   5 * (0.8 + Random(0.4)) * TEMP;

		MY._weakness = 2;
	}
	IF (MY._Actor_class == _num_battle_lord) {
		MY._Str =  80 * TEMP;	//  80
		MY._Dex =  90 * TEMP;	//  95
		MY._Agi =  80 * TEMP;	//  85
		MY._Vit = 150;
		MY._Int =  50 * TEMP;	//  50
		MY._Wis =  30 * TEMP;

		MY._pdam = 60;
		MY._mdam = 10;

		MY._pdef = 30;
		MY._mdef = 10;
	}
	IF (MY._Actor_class == _num_evil_spirit) {
		MY._Str =  75 * (0.8 + Random(0.4)) * TEMP;
		MY._Dex =  80 * (0.8 + Random(0.4)) * TEMP;
		MY._Agi =  60 * (0.8 + Random(0.4)) * TEMP;
		MY._Vit = 650 * TEMP;
		MY._Int =  30 * (0.8 + Random(0.4)) * TEMP;
		MY._Wis =  55 * (0.8 + Random(0.4)) * TEMP;

		MY._pdam = 40 * (0.8 + Random(0.4));
		MY._mdam = 35 * (0.8 + Random(0.4));

		MY._pdef = 10 * (0.8 + Random(0.4));
		MY._mdef =  5 * (0.8 + Random(0.4));
	}
	IF (MY._Actor_class == _num_green_wizard) {
		MY._Str =  70 * (0.8 + Random(0.4));
		MY._Dex =  60 * (0.8 + Random(0.4));
		MY._Agi =  65 * (0.8 + Random(0.4)) * TEMP;
		MY._Vit =  65 * TEMP;
		MY._Int =  70 * (0.8 + Random(0.4)) * TEMP;
		MY._Wis =  40 * (0.8 + Random(0.4)) * TEMP;

		MY._pdam = 30 * (0.8 + Random(0.4));
		MY._mdam = 35 * (0.8 + Random(0.4));

		MY._pdef = 20 * (0.8 + Random(0.4));
		MY._mdef = 25 * (0.8 + Random(0.4));
	}
	IF (MY._Actor_class == _num_ice_frog) {
		MY._Str =  70 * (0.8 + Random(0.4));
		MY._Dex =  70 * (0.8 + Random(0.4));
		MY._Agi =  70 * (0.8 + Random(0.4)) * TEMP;
		MY._Vit = 100 * TEMP;
		MY._Int =  40 * (0.8 + Random(0.4)) * TEMP;
		MY._Wis =  45 * (0.8 + Random(0.4));

		MY._pdam = 30 * (0.8 + Random(0.4));
		MY._mdam = 35 * (0.8 + Random(0.4));

		MY._pdef = 15 * (0.8 + Random(0.4));
		MY._mdef = 20 * (0.8 + Random(0.4));

		MY._weakness = 4;
	}
	IF (MY._Actor_class == _num_viscous_slime) {
		MY._Str =  40 * (0.8 + Random(0.4));
		MY._Dex =  60 * (0.8 + Random(0.4)) * TEMP;
		MY._Agi =  70 * (0.8 + Random(0.4)) * TEMP;
		MY._Vit =  60 * TEMP;
		MY._Int =   5 * (0.8 + Random(0.4));
		MY._Wis =   5 * (0.8 + Random(0.4));

		MY._pdam = 30 * (0.8 + Random(0.4));
		MY._mdam =  5 * (0.8 + Random(0.4));

		MY._pdef = 10 * (0.8 + Random(0.4));
		MY._mdef =  5 * (0.8 + Random(0.4));

		MY._weakness = 3;
	}
	IF (MY._Actor_class == _num_succubus_twins1) {
		MY._Str =   50 * (0.8 + Random(0.4)) * TEMP;
		MY._Dex =   65 * (0.8 + Random(0.4)) * TEMP;
		MY._Agi =   75 * (0.8 + Random(0.4)) * TEMP;
		MY._Vit = 2400 * TEMP;
		MY._Int =  150 * (0.8 + Random(0.4)) * TEMP;
		MY._Wis =   60 * (0.8 + Random(0.4)) * TEMP;

		MY._pdam = 20 * (0.8 + Random(0.4));
		MY._mdam = 50 * (0.8 + Random(0.4));

		MY._pdef =  5 * (0.8 + Random(0.4)) * TEMP;
		MY._mdef =  5 * (0.8 + Random(0.4)) * TEMP;
	}
	IF (MY._Actor_class == _num_succubus_twins2) {
		MY._Str =   85 * (0.8 + Random(0.4)) * TEMP;
		MY._Dex =   75 * (0.8 + Random(0.4)) * TEMP;
		MY._Agi =   65 * (0.8 + Random(0.4)) * TEMP;
		MY._Vit = 2400 * TEMP;
		MY._Int =   30 * (0.8 + Random(0.4)) * TEMP;
		MY._Wis =   30 * (0.8 + Random(0.4)) * TEMP;

		MY._pdam = 60 * (0.8 + Random(0.4));
		MY._mdam = 15 * (0.8 + Random(0.4));

		MY._pdef =  5 * (0.8 + Random(0.4)) * TEMP;
		MY._mdef =  5 * (0.8 + Random(0.4)) * TEMP;
	}
	IF (MY._Actor_class == _num_risen_muck) {
		MY._Str =  70 * (0.8 + Random(0.4));
		MY._Dex =  80 * (0.8 + Random(0.4));
		MY._Agi =  55 * (0.8 + Random(0.4)) * TEMP;
		MY._Vit = 100 * TEMP;
		MY._Int =  50 * (0.8 + Random(0.4));
		MY._Wis =  55 * (0.8 + Random(0.4)) * TEMP;

		MY._pdam = 35 * (0.8 + Random(0.4));
		MY._mdam = 40 * (0.8 + Random(0.4));

		MY._pdef = 20 * (0.8 + Random(0.4));
		MY._mdef = 25 * (0.8 + Random(0.4));

		MY._weakness = 4;
	}
	IF (MY._Actor_class == _num_the_ring) {
		MY._Str =  80 * (0.8 + Random(0.4));
		MY._Dex =  80 * (0.8 + Random(0.4));
		MY._Agi = 120 * (0.8 + Random(0.4)) * TEMP;
		MY._Vit = 250 * TEMP;
		MY._Int = 200 * (0.8 + Random(0.4)) * TEMP;
		MY._Wis =  50 * (0.8 + Random(0.4));

		MY._pdam = 35 * (0.8 + Random(0.4));
		MY._mdam = 35 * (0.8 + Random(0.4));

		MY._pdef = 30 * (0.8 + Random(0.4));
		MY._mdef = 30 * (0.8 + Random(0.4));
	}
	IF (MY._Actor_class == _num_acid_flan) {
		MY._Str =  70 * (0.8 + Random(0.4)) * TEMP;
		MY._Dex =  60 * (0.8 + Random(0.4));
		MY._Agi =  90 * (0.8 + Random(0.4)) * TEMP;
		MY._Vit = 100 * TEMP;
		MY._Int = 100 * (0.8 + Random(0.4));
		MY._Wis =  50 * (0.8 + Random(0.4));

		MY._pdam = 40 * (0.8 + Random(0.4));
		MY._mdam = 30 * (0.8 + Random(0.4));

		MY._pdef = 25 * (0.8 + Random(0.4));
		MY._mdef = 25 * (0.8 + Random(0.4));
	}
	IF (MY._Actor_class == _num_blood_rex) {
		MY._Str =  90 * (0.8 + Random(0.4)) * TEMP;
		MY._Dex =  80 * (0.8 + Random(0.4)) * TEMP;
		MY._Agi =  60 * (0.8 + Random(0.4)) * TEMP;
		MY._Vit = 180 * TEMP;
		MY._Int =  20 * (0.8 + Random(0.4)) * TEMP;
		MY._Wis =  15 * (0.8 + Random(0.4)) * TEMP;

		MY._pdam = 40 * (0.8 + Random(0.4));
		MY._mdam =  5 * (0.8 + Random(0.4));

		MY._pdef = 25 * (0.8 + Random(0.4));
		MY._mdef = 25 * (0.8 + Random(0.4));

		MY._weakness = 3;
	}
	IF (MY._Actor_class == _num_white_dragon) {
		MY._Str =   80 * (0.8 + Random(0.4));
		MY._Dex =   85 * (0.8 + Random(0.4));
		MY._Agi =   90 * (0.8 + Random(0.4)) * TEMP;
		MY._Vit = 1750 * TEMP;
		MY._Int =  200 * (0.8 + Random(0.4)) * TEMP;
		MY._Wis =   60 * (0.8 + Random(0.4)) * TEMP;

		MY._pdam = 40 * (0.8 + Random(0.4));
		MY._mdam = 40 * (0.8 + Random(0.4));

		MY._pdef = 15 * (0.8 + Random(0.4));
		MY._mdef = 15 * (0.8 + Random(0.4));
	}
	IF (MY._Actor_class == _num_abyss_mage) {
		MY._Str =  75 * (0.8 + Random(0.4));
		MY._Dex =  65 * (0.8 + Random(0.4));
		MY._Agi =  75 * (0.8 + Random(0.4)) * TEMP;
		MY._Vit =  90 * TEMP;
		MY._Int =  80 * (0.8 + Random(0.4)) * TEMP;
		MY._Wis =  45 * (0.8 + Random(0.4)) * TEMP;

		MY._pdam = 35 * (0.8 + Random(0.4));
		MY._mdam = 40 * (0.8 + Random(0.4));

		MY._pdef = 20 * (0.8 + Random(0.4));
		MY._mdef = 40 * (0.8 + Random(0.4));
	}
	IF (MY._Actor_class == _num_doppelganger1) {
		MY._Str =   50 * (0.8 + Random(0.4)) * TEMP;
		MY._Dex =   65 * (0.8 + Random(0.4));
		MY._Agi =   60 * (0.8 + Random(0.4)) * TEMP;
		MY._Vit = 2000 * TEMP;
		MY._Int =  150 * (0.8 + Random(0.4)) * TEMP;
		MY._Wis =   60 * (0.8 + Random(0.4)) * TEMP;

		MY._pdam = 20 * (0.8 + Random(0.4));
		MY._mdam = 50 * (0.8 + Random(0.4));

		MY._pdef =  5 * (0.8 + Random(0.4)) * TEMP;
		MY._mdef =  5 * (0.8 + Random(0.4)) * TEMP;
	}
	IF (MY._Actor_class == _num_doppelganger2) {
		MY._Str =   80 * (0.8 + Random(0.4)) * TEMP;
		MY._Dex =   70 * (0.8 + Random(0.4)) * TEMP;
		MY._Agi =   65 * (0.8 + Random(0.4));
		MY._Vit = 2000 * TEMP;
		MY._Int =   30 * (0.8 + Random(0.4));
		MY._Wis =   30 * (0.8 + Random(0.4));

		MY._pdam = 60 * (0.8 + Random(0.4));
		MY._mdam = 15 * (0.8 + Random(0.4));

		MY._pdef =  5 * (0.8 + Random(0.4)) * TEMP;
		MY._mdef =  5 * (0.8 + Random(0.4)) * TEMP;
	}
	IF (MY._Actor_class == _num_blood_pudding) {
		MY._Str =  40 * (0.8 + Random(0.4));
		MY._Dex =  50 * (0.8 + Random(0.4)) * TEMP;
		MY._Agi =  70 * (0.8 + Random(0.4)) * TEMP;
		MY._Vit =  80 * TEMP;
		MY._Int =  75 * (0.8 + Random(0.4));
		MY._Wis =  50 * (0.8 + Random(0.4));

		MY._pdam = 45 * (0.8 + Random(0.4));
		MY._mdam = 45 * (0.8 + Random(0.4));

		MY._pdef = 30 * (0.8 + Random(0.4));
		MY._mdef = 35 * (0.8 + Random(0.4));
	}
	IF (MY._Actor_class == _num_blade_demon) {
		MY._Str =  65 * (0.8 + Random(0.4));
		MY._Dex =  70 * (0.8 + Random(0.4));
		MY._Agi =  90 * (0.8 + Random(0.4)) * TEMP;
		MY._Vit = 120 * TEMP;
		MY._Int =  40 * (0.8 + Random(0.4)) * TEMP;
		MY._Wis =  45 * (0.8 + Random(0.4));

		MY._pdam = 35 * (0.8 + Random(0.4));
		MY._mdam = 30 * (0.8 + Random(0.4));

		MY._pdef = 20 * (0.8 + Random(0.4));
		MY._mdef = 20 * (0.8 + Random(0.4));

		MY._weakness = 5;
	}
	IF (MY._Actor_class == _num_phoenix_dragon) {
		MY._Str =  90 * (0.8 + Random(0.4));
		MY._Dex =  80 * (0.8 + Random(0.4));
		MY._Agi =  55 * (0.8 + Random(0.4)) * TEMP;
		MY._Vit = 275 * TEMP;
		MY._Int = 100 * (0.8 + Random(0.4));
		MY._Wis =  55 * (0.8 + Random(0.4));

		MY._pdam = 35 * (0.8 + Random(0.4));
		MY._mdam = 35 * (0.8 + Random(0.4));

		MY._pdef =  5 * (0.8 + Random(0.4));
		MY._mdef =  5 * (0.8 + Random(0.4));

		MY._weakness = 3;
	}
	IF (MY._Actor_class == _num_dawn_of_souls) {
		MY._Str =   80 * (0.8 + Random(0.4));
		MY._Dex =   90 * (0.8 + Random(0.4));
		MY._Agi =   85 * (0.8 + Random(0.4)) * TEMP;
		MY._Vit = 3000 * TEMP;
		MY._Int =  500 * (0.8 + Random(0.4)) * TEMP;
		MY._Wis =   60 * (0.8 + Random(0.4)) * TEMP;

		MY._pdam = 40 * (0.8 + Random(0.4));
		MY._mdam = 40 * (0.8 + Random(0.4));

		MY._pdef = 10 * (0.8 + Random(0.4));
		MY._mdef = 10 * (0.8 + Random(0.4));
	}
	IF (MY._Actor_class == _num_elder_ghost) {
		MY._Str =  70 * (0.8 + Random(0.4));
		MY._Dex =  75 * (0.8 + Random(0.4)) * TEMP;
		MY._Agi =  70 * (0.8 + Random(0.4));
		MY._Vit = 100 * TEMP;
		MY._Int = 150 * (0.8 + Random(0.4));
		MY._Wis =  60 * (0.8 + Random(0.4));

		MY._pdam = 35 * (0.8 + Random(0.4));
		MY._mdam = 40 * (0.8 + Random(0.4));

		MY._pdef = 55 * (0.8 + Random(0.4));
		MY._mdef = 30 * (0.8 + Random(0.4));

		MY._weakness = 2;
	}
	IF (MY._Actor_class == _num_damned_sorcerer) {
		MY._Str =  85 * (0.8 + Random(0.4));
		MY._Dex =  70 * (0.8 + Random(0.4));
		MY._Agi =  75 * (0.8 + Random(0.4)) * TEMP;
		MY._Vit = 150 * TEMP;
		MY._Int =  90 * (0.8 + Random(0.4)) * TEMP;
		MY._Wis =  45 * (0.8 + Random(0.4)) * TEMP;

		MY._pdam = 35 * (0.8 + Random(0.4));
		MY._mdam = 40 * (0.8 + Random(0.4));

		MY._pdef = 20 * (0.8 + Random(0.4));
		MY._mdef = 40 * (0.8 + Random(0.4));
	}
	IF (MY._Actor_class == _num_zombie_witch) {
		MY._Str =  60 * (0.8 + Random(0.4));
		MY._Dex =  75 * (0.8 + Random(0.4));
		MY._Agi =  70 * (0.8 + Random(0.4)) * TEMP;
		MY._Vit = 175 * TEMP;
		MY._Int = 200 * (0.8 + Random(0.4));
		MY._Wis =  45 * (0.8 + Random(0.4));

		MY._pdam = 20 * (0.8 + Random(0.4));
		MY._mdam = 40 * (0.8 + Random(0.4));

		MY._pdef = 15 * (0.8 + Random(0.4));
		MY._mdef = 35 * (0.8 + Random(0.4));

		MY._weakness = 2;
	}
	IF (MY._Actor_class == _num_valkyrie) {
		MY._Str =  65 * TEMP;
		MY._Dex =  95 * TEMP;
		MY._Agi =  95 * TEMP;
		MY._Vit =  95 * TEMP;
		MY._Int =  60 * TEMP;
		MY._Wis =  60 * TEMP;	// Compensate "low" magic attack

		if (MY._Level == 0) {
			setBasicValues();
//			MY._pdam = 50;
//			MY._mdam =  5;
//
//			MY._pdef = 20;
//			MY._mdef = 15;
		}

		MY._weakness = _ice;
	}
	IF (MY._Actor_class == _num_zombie_dragon) {
		MY._Str =   85 * (0.8 + Random(0.4));
		MY._Dex =   85 * (0.8 + Random(0.4)) * TEMP;
		MY._Agi =   90 * (0.8 + Random(0.4)) * TEMP;
		MY._Vit = 2000 * TEMP;
		MY._Int =  200 * (0.8 + Random(0.4)) * TEMP;
		MY._Wis =   55 * (0.8 + Random(0.4)) * TEMP;

		MY._pdam = 40 * (0.8 + Random(0.4));
		MY._mdam = 40 * (0.8 + Random(0.4));

		MY._pdef = 15 * (0.8 + Random(0.4));
		MY._mdef = 15 * (0.8 + Random(0.4));

		MY._weakness = 2;
	}

	if (heal) {
		MY._HP = MY._Vit;
		MY._MP = MY._Int;
	} else {
		my._HP = min(my._HP, my._Vit);
		my._MP = min(my._MP, my._Int);
	}

	return;
}

// show the range within which player actions can be performed
function Action_circle()
{
	MY.FLARE = ON;
	MY.TRANSPARENT = ON;
	MY.ALPHA = 100;
	MY.BRIGHT = ON;
	MY.PASSABLE = ON;
	MY.ORIENTED = ON;
	MY.TILT = 90;

	VEC_NORMALIZE(MY.SCALE_X, 3);

	MY.Z = 1;	// Set it 1 quant above the ground
	WHILE (ME) {
		// Keep the position when the player moves during an counter attack
		IF (PLAYER) {
			MY.X = PLAYER.X;
			MY.Y = PLAYER.Y;
		}
	WAIT (1);
	}

	RETURN;
}

function back_input()
{
	snd_play(selection1, 100, 0);

	PLAYER._input_state = _state_select;
	button_block = ON;
	show_opt_back.visible = OFF;
//	action_input_options(ON);
}

// Button actions for the input option buttons
function action_input(button_number, panel_ptr)
{
	proc_late();

	snd_play(selection1, 100, 0);

	PLAYER._input_state = _state_confirm;
	hide_action_text();
	action_input_options(OFF);
	show_opt_back.visible = ON;
	_action_circle = ENT_CREATELOCAL("circle.bmp", PLAYER.X, Action_circle);

	WHILE (MOUSE_LEFT) { WAIT (1); }	// When clicking on the button the mouse is already pressed and thus would suddenly trigger the move instruction.

	// Move when mouse is pressed on a traceable target within the _action_range
	IF (panel_ptr == show_opt_move) {
		_ignore_sprites = IGNORE_SPRITES;
		while ((player) && (show_opt_back.visible == on)) {
			IF (button_block) { WAIT(1); continue; }

			MOUSE_MAP = IIf((rel_dist(player.x, pos_target.x) < _action_range) && (abs(pos_target.x) <= _level_size) && (abs(pos_target.y) <= _level_size), mouse, mousena);

			IF ((MOUSE_LEFT) && (VEC_LENGTH(pos_target.X) > 0) && (rel_dist(PLAYER.X, pos_target.X) < _action_range)) {
				VEC_SET(PLAYER._Action_target_X, pos_target.X);
				PLAYER._ActReq_ID = _action_jump;

				SEND_SKILL(PLAYER._Action_target_X, SEND_ALL + SEND_VEC); net_transfer += 12;
				SEND_SKILL(PLAYER._ActReq_ID, NULL); net_transfer += 4;

				break;
			}
		WAIT (1);
		}
		_ignore_sprites = 0;
	}
	// Attack when there is an entity (actor) behind the mouse, it is not the player, it is not dead and it is within the _action_range
	IF (panel_ptr == show_opt_attack) {
		// Wait for an attack input
		WHILE (show_opt_back.visible == ON) {
			IF (button_block) { WAIT(1); continue; }

			IF (_mouse_ent) {
				MOUSE_MAP = IIf(rel_dist(PLAYER.X, _mouse_ent.X) < _action_range, mouse, mousena);

				// Pointing an entity and clicking
				IF (MOUSE_LEFT) {
					IF ((_mouse_ent._Actor_ID == _ID_Enemy) && (_mouse_ent._HP > 0) && (rel_dist(PLAYER.X, _mouse_ent.X) < _action_range)) {
						// Set the wanted action and send the request to the server
						PLAYER._ActReq_handle = handle(_mouse_ent);
						PLAYER._ActReq_ID = _action_attack;

						SEND_SKILL(PLAYER._ActReq_handle, NULL); net_transfer += 4;
						SEND_SKILL(PLAYER._ActReq_ID, NULL); net_transfer += 4;

						break;
					}
				}

			} ELSE {
				MOUSE_MAP = mouse;
			}
		WAIT (1);
		}
	}
	IF ((panel_ptr == show_opt_hpreg) || (panel_ptr == show_opt_callbattlelord) || (panel_ptr == show_opt_mpreg) || (panel_ptr == show_opt_drawaggro) || (panel_ptr == show_opt_battlerage) || (panel_ptr == show_opt_revengeleap) || (panel_ptr == show_opt_thornaura) || (panel_ptr == show_opt_selftransform) || (panel_ptr == show_opt_firestorm) || (panel_ptr == show_opt_raisebuffs)) {
		PLAYER._ActReq_ID = _action_regena;
		IF (panel_ptr == show_opt_hpreg)          { PLAYER._SpReq_ID = 1; }
		IF (panel_ptr == show_opt_mpreg)          { PLAYER._SpReq_ID = 2; }
		IF (panel_ptr == show_opt_callbattlelord) { PLAYER._SpReq_ID = 6; }
		IF (panel_ptr == show_opt_revengeleap)    { PLAYER._SpReq_ID = 7; }
		IF (panel_ptr == show_opt_drawaggro)      { PLAYER._SpReq_ID = 8; }
		IF (panel_ptr == show_opt_battlerage)     { PLAYER._SpReq_ID = 9; }
		// 10 = call blood pudding
		IF (panel_ptr == show_opt_thornaura)		{ PLAYER._SpReq_ID = 11; }
		if (panel_ptr == show_opt_selftransform)	{ player._SpReq_ID = 12; }
		if (panel_ptr == show_opt_firestorm)		{ player._SpReq_ID = 13; }
		if (panel_ptr == show_opt_raisebuffs)     { player._SpReq_ID = 14; }

		SEND_SKILL(PLAYER._ActReq_ID, NULL); net_transfer += 4;
		SEND_SKILL(PLAYER._SpReq_ID,  NULL); net_transfer += 4;
	}
	IF ((panel_ptr == show_opt_heal) || (panel_ptr == show_opt_light) || (panel_ptr == show_opt_ice) || (panel_ptr == show_opt_lightning) || (panel_ptr == show_opt_earth) || (panel_ptr == show_opt_fire) || (panel_ptr == show_opt_mpdef) || (panel_ptr == show_opt_agi) || (panel_ptr == show_opt_explodingarrow) || (panel_ptr == show_opt_earthquake) || (panel_ptr == show_opt_summongaja)) {
		// Wait for a spell input
		WHILE (show_opt_back.visible == ON) {
			IF (button_block) { WAIT(1); continue; }

			IF (_mouse_ent) {
				MOUSE_MAP = IIf(rel_dist(PLAYER.X, _mouse_ent.X) < _action_range, mouse, mousena);

				// Pointing an entity and clicking
				IF (MOUSE_LEFT) {
					// Only healing, and the 2 buffs can be cast on a player
					IF (_mouse_ent._Actor_ID == _ID_Player) {
						IF ((panel_ptr == show_opt_light) || (panel_ptr == show_opt_ice) || (panel_ptr == show_opt_lightning) || (panel_ptr == show_opt_earth) || (panel_ptr == show_opt_fire) || (panel_ptr == show_opt_explodingarrow) || (panel_ptr == show_opt_earthquake) || (panel_ptr == show_opt_summongaja)) { wait(1); continue; }
					}

					IF ((_mouse_ent._Actor_ID != _ID_Undefined) && (_mouse_ent._HP > 0) && (rel_dist(PLAYER.X, _mouse_ent.X) < _action_range)) {
						// Set the wanted action and send the request to the server
						PLAYER._ActReq_handle = handle(_mouse_ent);
						PLAYER._ActReq_ID = _action_cast;

						// The fractional part defines the spell
						IF (panel_ptr == show_opt_heal)           { PLAYER._SpReq_ID = 1; }
						IF (panel_ptr == show_opt_light)          { PLAYER._SpReq_ID = 2; }
						IF (panel_ptr == show_opt_ice)            { PLAYER._SpReq_ID = 3; }
						IF (panel_ptr == show_opt_lightning)      { PLAYER._SpReq_ID = 4; }
						IF (panel_ptr == show_opt_earth)          { PLAYER._SpReq_ID = 5; }
						IF (panel_ptr == show_opt_mpdef)          { PLAYER._SpReq_ID = 6; }
						IF (panel_ptr == show_opt_agi)            { PLAYER._SpReq_ID = 7; }
						IF (panel_ptr == show_opt_fire)           { PLAYER._SpReq_ID = 8; }
						IF (panel_ptr == show_opt_explodingarrow) { PLAYER._SpReq_ID = 9; }
						IF (panel_ptr == show_opt_earthquake)		{ PLAYER._SpReq_ID = 14; }
						IF (panel_ptr == show_opt_summongaja)		{ PLAYER._SpReq_ID = 15; }

						SEND_SKILL(PLAYER._ActReq_handle, NULL); net_transfer += 4;
						SEND_SKILL(PLAYER._ActReq_ID, NULL); net_transfer += 4;
						SEND_SKILL(PLAYER._SpReq_ID,  NULL); net_transfer += 4;

						break;
					}
				}

			} ELSE {
				MOUSE_MAP = mouse;
			}
		WAIT (1);
		}
	}

	MOUSE_MAP = mouse;

	IF (PLAYER._input_state == _state_confirm) {
		snd_play(selection3, 100, 0);
		PLAYER._input_state = _state_disabled;
	}

	action_input_options(OFF);	// switch input menu off

	IF (_action_circle) {
		ENT_REMOVE(_action_circle);
		_action_circle = NULL;
	}

	RETURN;
}
function hide_action_text()
{
	action_text.visible = OFF;
	WAIT (1);
	button_block = OFF;
}
function show_action_text(button_number, panel_ptr)
{
	_temp_panel = panel_ptr;

	button_block = ON;
	action_text.visible = ON;
	action_text.pos_x = _temp_panel.pos_x + 24;
	action_text.pos_y = _temp_panel.pos_y + 50;

	IF (_temp_panel == show_opt_move) {
		action_text.string = "Move [a]";
	}
	IF (_temp_panel == show_opt_attack) {
		action_text.string = "Attack [s]";
	}
	IF (_temp_panel == show_opt_hpreg) {
		action_text.string = "Regenerate Hits [d]";
	}
	IF (_temp_panel == show_opt_mpreg) {
		action_text.string = "Regenerate Mana [f]";
	}
	IF (_temp_panel == show_opt_heal) {
		action_text.string = "Heal [w]";
	}
	IF (_temp_panel == show_opt_light) {
		action_text.string = "Holy Light [e]";
	}
	IF (_temp_panel == show_opt_callbattlelord) {
		action_text.string = "Call Battle Lord [r]";
	}
	IF (_temp_panel == show_opt_summongaja) {
		action_text.string = "Summon Gaja [t]";
	}
	IF (_temp_panel == show_opt_ice) {
		action_text.string = "Freezer [w]";
	}
	IF (_temp_panel == show_opt_earth) {
		action_text.string = "Earth Rage [e]";
	}
	IF (_temp_panel == show_opt_lightning) {
		action_text.string = "Lightning [r]";
	}
	IF (_temp_panel == show_opt_fire) {
		action_text.string = "Summon Fire [t]";
	}
	IF (_temp_panel == show_opt_earthquake) {
		action_text.string = "Vulcano [z]";
	}
	IF (_temp_panel == show_opt_agi) {
		action_text.string = "Burst of Speed [e]";
	}
	IF (_temp_panel == show_opt_mpdef) {
		action_text.string = "Stone Skin [r]";
	}
	IF (_temp_panel == show_opt_drawaggro) {
		action_text.string = "Draw Aggro [w]";
	}
	IF (_temp_panel == show_opt_revengeleap) {
		action_text.string = "Revenge Leap [e]";
	}
	IF (_temp_panel == show_opt_battlerage) {
		action_text.string = "Battle Rage [r]";
	}
	IF (_temp_panel == show_opt_thornaura) {
		action_text.string = "Thorn Aura [t]";
	}
	IF (_temp_panel == show_opt_explodingarrow) {
		action_text.string = "Exploding Arrow [t]";
	}
	if (_temp_panel == show_opt_selftransform) {
		action_text.string = "Self Transform [z]";
	}
	if (_temp_panel == show_opt_firestorm) {
		action_text.string = "Fire Sword [e]";
	}
	if (_temp_panel == show_opt_raisebuffs) {
		action_text.string = "Raise Buffs [r]";
	}
	IF (_temp_panel == show_opt_back) {
		action_text.string = "Back [tab]";
	}
}

function short_opt_move()
{
	IF (show_opt_move.visible == ON) {
		action_input(1, show_opt_move);
	}
}
on_a = short_opt_move;

function short_opt_attack()
{
	IF (show_opt_attack.visible == ON) {
		action_input(1, show_opt_attack);
	}
}
on_s = short_opt_attack;

function short_opt_hpreg()
{
	IF (show_opt_hpreg.visible == ON) {
		action_input(1, show_opt_hpreg);
	}
}
on_d = short_opt_hpreg;

function short_opt_mpreg()
{
	IF (show_opt_mpreg.visible == ON) {
		action_input(1, show_opt_mpreg);
	}
}
on_f = short_opt_mpreg;

function short_opt_heal_ice()
{
var class;

	if (player) {
		class = getRealActorClass(player._Actor_class);

		IF ((class == _num_knight) || (class == _num_archer)) {
			IF (show_opt_drawaggro.visible == ON) {
				action_input(1, show_opt_drawaggro);
			}
		}
		IF (class == _num_priest) {
			IF (show_opt_heal.visible == ON) {
				action_input(1, show_opt_heal);
			}
		}
		IF (class == _num_wizard) {
			IF (show_opt_ice.visible == ON) {
				action_input(1, show_opt_ice);
			}
		}
	}
}
on_w = short_opt_heal_ice;

function short_opt_light_lightning()
{
	IF (PLAYER) {
		IF (PLAYER._Actor_class == _num_knight) {
			IF (show_opt_revengeleap.visible == ON) {
				action_input(1, show_opt_revengeleap);
			}
		}
		IF (PLAYER._Actor_class == _num_archer) {
			IF (show_opt_agi.visible == ON) {
				action_input(1, show_opt_agi);
			}
		}
		IF (PLAYER._Actor_class == _num_priest) {
			IF (show_opt_light.visible == ON) {
				action_input(1, show_opt_light);
			}
		}
		IF (PLAYER._Actor_class == _num_wizard) {
			IF (show_opt_earth.visible == ON) {
				action_input(1, show_opt_earth);
			}
		}
		if (player._Actor_class == _num_valkyrie) {
			if (show_opt_firestorm.visible == on) {
				action_input(1, show_opt_firestorm);
			}
		}
	}
}
on_e = short_opt_light_lightning;

function short_opt_earth()
{
	IF (PLAYER) {
		IF (PLAYER._Actor_class == _num_knight) {
			IF (show_opt_battlerage.visible == ON) {
				action_input(1, show_opt_battlerage);
			}
		}
		IF (PLAYER._Actor_class == _num_archer) {
			IF (show_opt_mpdef.visible == ON) {
				action_input(1, show_opt_mpdef);
			}
		}
		IF (PLAYER._Actor_class == _num_priest) {
			IF (show_opt_callbattlelord.visible == ON) {
				action_input(1, show_opt_callbattlelord);
			}
		}
		IF (PLAYER._Actor_class == _num_wizard) {
			IF (show_opt_lightning.visible == ON) {
				action_input(1, show_opt_lightning);
			}
		}
		if (player._Actor_class == _num_valkyrie) {
			if (show_opt_raisebuffs.visible == on) {
				action_input(1, show_opt_raisebuffs);
			}
		}
	}
}
on_r = short_opt_earth;

function short_opt_fire()
{
	IF (PLAYER) {
		IF (PLAYER._Actor_class == _num_knight) {
			IF (show_opt_thornaura.visible == ON) {
				action_input(1, show_opt_thornaura);
			}
		}
		IF (PLAYER._Actor_class == _num_archer) {
			IF (show_opt_explodingarrow.visible == ON) {
				action_input(1, show_opt_explodingarrow);
			}
		}
		IF (PLAYER._Actor_class == _num_wizard) {
			IF (show_opt_fire.visible == ON) {
				action_input(1, show_opt_fire);
			}
		}
		IF (PLAYER._Actor_class == _num_priest) {
			IF (show_opt_summongaja.visible == ON) {
				action_input(1, show_opt_summongaja);
			}
		}
	}
}
on_t = short_opt_fire;

function short_opt_earthquake()
{
	IF (PLAYER) {
		IF (PLAYER._Actor_class == _num_wizard) {
			IF (show_opt_earthquake.visible == ON) {
				action_input(1, show_opt_earthquake);
			}
		}
		if (player._Actor_class == _num_archer) {
			if (show_opt_selftransform.visible == on) {
				action_input(1, show_opt_selftransform);
			}
		}
	}
}
on_z = short_opt_earthquake;
on_y = short_opt_earthquake;

function short_opt_back()
{
	IF (PLAYER) {
		IF (show_opt_back.visible == ON) {
			back_input();
		}
	}
}
on_tab = short_opt_back;

function pause_game()
{
	if (Level_Select) { return; }	// No pause during trade

	IF ((connection == 3) && (PLAYER)) {
		freeze_mode = (freeze_mode + 2) % 4;
		freeze_game = freeze_mode;
		SEND_VAR(freeze_game); net_transfer += 12;
	} ELSE {
		freeze_mode = freeze_game;
		IF ((key_pause) && (PLAYER)) {
			pause_request = 1;
			SEND_VAR(pause_request); net_transfer += 12;
		}
	}

	IF (freeze_mode) {
		show_black.visible = ON;
		show_black.alpha = 40;

		WHILE (freeze_mode) {
			pause_text.visible = IIf(pause_text.visible, OFF, ON);
		WAITT (8);
		}
	} ELSE {
		show_black.visible = OFF;
		pause_text.visible = OFF;
	}
}
on_pause = pause_game;

function nothing()
{
	RETURN;
}
on_0 = nothing;
on_f5 = nothing;
on_f10 = nothing;
on_f12 = nothing;

function action_input_options(val)
{
	show_opt_move.visible = OFF;
	show_opt_attack.visible = OFF;
	show_opt_hpreg.visible = OFF;
	show_opt_mpreg.visible = OFF;
	show_opt_heal.visible = OFF;
	show_opt_light.visible = OFF;
	show_opt_ice.visible = OFF;
	show_opt_lightning.visible = OFF;
	show_opt_earth.visible = OFF;
	show_opt_fire.visible = OFF;
	show_opt_mpdef.visible = OFF;
	show_opt_agi.visible = OFF;
	show_opt_battlerage.visible = OFF;
	show_opt_drawaggro.visible = OFF;
	show_opt_revengeleap.visible = OFF;
	show_opt_callbattlelord.visible = OFF;
	show_opt_explodingarrow.visible = OFF;
	show_opt_earthquake.visible = OFF;
	show_opt_summongaja.visible = OFF;
	show_opt_thornaura.visible = OFF;
	show_opt_selftransform.visible = off;
	show_opt_firestorm.visible = off;
	show_opt_raisebuffs.visible = off;
	show_opt_back.visible = OFF;

	IF (val != 0) {
		TEMP[0] = 0;
		TEMP[1] = 0;

		WHILE (TEMP[0] < 2) {
			IF (TEMP[0] == 0) {
				val = 2;	// move and attack always
			} ELSE {
				TEMP[2] = 514 - 26 * val;	// 512 - (52 * val) - 2; position of the first button

				show_opt_move.visible = ON;
				show_opt_move.pos_x = TEMP[2] + TEMP[1] * 52;
				TEMP[1] += 1;	// Increase amount of already placed buttons

				show_opt_attack.visible = ON;
				show_opt_attack.pos_x = TEMP[2] + TEMP[1] * 52;
				TEMP[1] += 1;	// Increase amount of already placed buttons
			}

			IF (PLAYER._HP < PLAYER._Vit) {	// add hp regeneration
				IF (TEMP[0] == 0) {
					val += 1;
				} ELSE {
					show_opt_hpreg.visible = ON;
					show_opt_hpreg.pos_x = TEMP[2] + TEMP[1] * 52;
					TEMP[1] += 1;	// Increase amount of already placed buttons
				}
			}
			IF (PLAYER._MP < PLAYER._Int) {	// add mp regeneration
				IF (TEMP[0] == 0) {
					val += 1;
				} ELSE {
					show_opt_mpreg.visible = ON;
					show_opt_mpreg.pos_x = TEMP[2] + TEMP[1] * 52;
					TEMP[1] += 1;	// Increase amount of already placed buttons
				}
			}

			// If there are different commands for different actor classes
			IF (PLAYER._Actor_class == _num_knight) {
				IF ((PLAYER._timer_drawaggro <= _mp_drawaggro) && (PLAYER._Level >= 1)) {	// add battle rage buff
					IF (TEMP[0] == 0) {
						val += 1;
					} ELSE {
						show_opt_drawaggro.visible = ON;
						show_opt_drawaggro.pos_x = TEMP[2] + TEMP[1] * 52;
						TEMP[1] += 1;	// Increase amount of already placed buttons
					}
				}
				IF ((PLAYER._timer_revengeleap <= _mp_revengeleap) && (PLAYER._Level >= 6)) {	// add battle rage buff
					IF (TEMP[0] == 0) {
						val += 1;
					} ELSE {
						show_opt_revengeleap.visible = ON;
						show_opt_revengeleap.pos_x = TEMP[2] + TEMP[1] * 52;
						TEMP[1] += 1;	// Increase amount of already placed buttons
					}
				}
				IF ((PLAYER._timer_battlerage <= _mp_battlerage) && (PLAYER._Level >= 10)) {	// add battle rage buff
					IF (TEMP[0] == 0) {
						val += 1;
					} ELSE {
						show_opt_battlerage.visible = ON;
						show_opt_battlerage.pos_x = TEMP[2] + TEMP[1] * 52;
						TEMP[1] += 1;	// Increase amount of already placed buttons
					}
				}

				if ((PLAYER._timer_thornaura <= _mp_thornaura) && (PLAYER._Level >= 15)) {	// add thorn aura buff
					IF (TEMP[0] == 0) {
						val += 1;
					} ELSE {
						show_opt_thornaura.visible = ON;
						show_opt_thornaura.pos_x = TEMP[2] + TEMP[1] * 52;
						TEMP[1] += 1;	// Increase amount of already placed buttons
					}
				}

			}
			IF (PLAYER._Actor_class == _num_archer) {
				IF ((PLAYER._timer_drawaggro <= _mp_drawaggro) && (PLAYER._Level >= 1)) {	// add draw aggro
					IF (TEMP[0] == 0) {
						val += 1;
					} ELSE {
						show_opt_drawaggro.visible = ON;
						show_opt_drawaggro.pos_x = TEMP[2] + TEMP[1] * 52;
						TEMP[1] += 1;	// Increase amount of already placed buttons
					}
				}
				IF ((PLAYER._MP >= _mp_agi) && (PLAYER._Level >= 4)) {	// add agi buff
					IF (TEMP[0] == 0) {
						val += 1;
					} ELSE {
						show_opt_agi.visible = ON;
						show_opt_agi.pos_x = TEMP[2] + TEMP[1] * 52;
						TEMP[1] += 1;	// Increase amount of already placed buttons
					}
				}
				IF ((PLAYER._MP >= _mp_mpdef) && (PLAYER._Level >= 8)) {	// add def buff
					IF (TEMP[0] == 0) {
						val += 1;
					} ELSE {
						show_opt_mpdef.visible = ON;
						show_opt_mpdef.pos_x = TEMP[2] + TEMP[1] * 52;
						TEMP[1] += 1;	// Increase amount of already placed buttons
					}
				}
				IF ((PLAYER._MP >= _mp_explodingarrow) && (PLAYER._Level >= 10)) {
					IF (TEMP[0] == 0) {
						val += 1;
					} ELSE {
						show_opt_explodingarrow.visible = ON;
						show_opt_explodingarrow.pos_x = TEMP[2] + TEMP[1] * 52;
						TEMP[1] += 1;	// Increase amount of already placed buttons
					}
				}
				if ((player._MP >= _mp_selftransform) && (player._Level >= 15)) {
					if (temp[0] == 0) {
						val += 1;
					} else {
						show_opt_selftransform.visible = on;
						show_opt_selftransform.pos_x = temp[2] + temp[1] * 52;
						temp[1] += 1;	// Increase amount of already placed buttons
					}
				}
			}
			IF (PLAYER._Actor_class == _num_priest) {
				IF (PLAYER._MP >= _mp_heal) {	// add heal spell
					IF (TEMP[0] == 0) {
						val += 1;
					} ELSE {
						show_opt_heal.visible = ON;
						show_opt_heal.pos_x = TEMP[2] + TEMP[1] * 52;
						TEMP[1] += 1;	// Increase amount of already placed buttons
					}
				}
				IF ((PLAYER._MP >= _mp_light) && (PLAYER._Level >= 5)) {	// add light spell
					IF (TEMP[0] == 0) {
						val += 1;
					} ELSE {
						show_opt_light.visible = ON;
						show_opt_light.pos_x = TEMP[2] + TEMP[1] * 52;
						TEMP[1] += 1;	// Increase amount of already placed buttons
					}
				}

				YOU = ENT_NEXT(NULL);
				WHILE (YOU) {
					IF ((YOUR._Actor_class == _num_battle_lord) && (YOUR._HP > 0)) { break; }
					YOU = ENT_NEXT(YOU);
				}

				IF ((PLAYER._MP >= _mp_callbattlelord) && (PLAYER._Level >= 10) && (!YOU)) {	// add call battle lord
					IF (TEMP[0] == 0) {
						val += 1;
					} ELSE {
						show_opt_callbattlelord.visible = ON;
						show_opt_callbattlelord.pos_x = TEMP[2] + TEMP[1] * 52;
						TEMP[1] += 1;	// Increase amount of already placed buttons
					}
				}

				IF ((PLAYER._MP >= _mp_summongaja) && (PLAYER._Level >= 15)) {	// add summon gaja
					IF (TEMP[0] == 0) {
						val += 1;
					} ELSE {
						show_opt_summongaja.visible = ON;
						show_opt_summongaja.pos_x = TEMP[2] + TEMP[1] * 52;
						TEMP[1] += 1;	// Increase amount of already placed buttons
					}
				}
			}
			IF (PLAYER._Actor_class == _num_wizard) {
				IF (PLAYER._MP >= _mp_ice) {	// add ice spell
					IF (TEMP[0] == 0) {
						val += 1;
					} ELSE {
						show_opt_ice.visible = ON;
						show_opt_ice.pos_x = TEMP[2] + TEMP[1] * 52;
						TEMP[1] += 1;	// Increase amount of already placed buttons
					}
				}
				IF ((PLAYER._MP >= _mp_earth) && (PLAYER._Level >= 3)) {	// add earth spell
					IF (TEMP[0] == 0) {
						val += 1;
					} ELSE {
						show_opt_earth.visible = ON;
						show_opt_earth.pos_x = TEMP[2] + TEMP[1] * 52;
						TEMP[1] += 1;	// Increase amount of already placed buttons
					}
				}
				IF ((PLAYER._MP >= _mp_lightning) && (PLAYER._Level >= 6)) {	// add lightning spell
					IF (TEMP[0] == 0) {
						val += 1;
					} ELSE {
						show_opt_lightning.visible = ON;
						show_opt_lightning.pos_x = TEMP[2] + TEMP[1] * 52;
						TEMP[1] += 1;	// Increase amount of already placed buttons
					}
				}
				IF ((PLAYER._MP >= _mp_fire) && (PLAYER._Level >= 10)) {	// add earth spell
					IF (TEMP[0] == 0) {
						val += 1;
					} ELSE {
						show_opt_fire.visible = ON;
						show_opt_fire.pos_x = TEMP[2] + TEMP[1] * 52;
						TEMP[1] += 1;	// Increase amount of already placed buttons
					}
				}
				IF ((PLAYER._MP >= _mp_earthquake) && (PLAYER._Level >= 15)) {	// add earthquake spell
					IF (TEMP[0] == 0) {
						val += 1;
					} ELSE {
						show_opt_earthquake.visible = ON;
						show_opt_earthquake.pos_x = TEMP[2] + TEMP[1] * 52;
						TEMP[1] += 1;	// Increase amount of already placed buttons
					}
				}
			}
			IF (PLAYER._Actor_class == _num_valkyrie) {
				IF ((PLAYER._timer_drawaggro <= _mp_drawaggro) && (PLAYER._Level >= 1)) {	// add draw aggro
					IF (TEMP[0] == 0) {
						val += 1;
					} ELSE {
						show_opt_drawaggro.visible = ON;
						show_opt_drawaggro.pos_x = TEMP[2] + TEMP[1] * 52;
						TEMP[1] += 1;	// Increase amount of already placed buttons
					}
				}
				if ((player._MP >= _mp_firestorm) && (player._Level >= 15)) {	// add fire sword skill
					if (temp[0] == 0) {
						val += 1;
					} else {
						show_opt_firestorm.visible = on;
						show_opt_firestorm.pos_x = temp[2] + temp[1] * 52;
						temp[1] += 1;	// Increase amount of already placed buttons
					}
				}
				if ((player._MP >= _mp_raisebuffs) && (player._Level >= 18)) {	// add raise buffs spell
					if (temp[0] == 0) {
						val += 1;
					} else {
						show_opt_raisebuffs.visible = on;
						show_opt_raisebuffs.pos_x = temp[2] + temp[1] * 52;
						temp[1] += 1;	// Increase amount of already placed buttons
					}
				}
			}
		TEMP += 1;
		}
	} ELSE {
		hide_action_text();

		IF (_action_circle) {
			ENT_REMOVE(_action_circle);
			_action_circle = null;
		}
	}
}

function initEquipmentNames(class)
{
	if (class == _num_knight) {
		str_cpy(weapon1, "Long Sword");
		str_cpy(weapon2, "Zweihander");
		str_cpy(weapon3, "Flamberge");
		str_cpy(weapon4, "Dragon Slayer");
		str_cpy(weapon5, "Lunar Blade");
		str_cpy(armor1, "Wooden Mail");
		str_cpy(armor2, "Scale Armor");
		str_cpy(armor3, "Knight Armor");
		str_cpy(armor4, "Elven Armor");
		str_cpy(armor5, "Full Plate Armor");
	}
	if ((class == _num_archer) || (class == _num_valkyrie)) {
		str_cpy(weapon1, "Forest Bow");
		str_cpy(weapon2, "Hunter Bow");
		str_cpy(weapon3, "Elven Bow");
		str_cpy(weapon4, "Dragon Bow");
		str_cpy(weapon5, "Angelic Bow");
		str_cpy(armor1, "Archer Suite");
		str_cpy(armor2, "Wooden Mail");
		str_cpy(armor3, "Light Scale Mail");
		str_cpy(armor4, "Spirit Armor");
		str_cpy(armor5, "Valkyrie Armor");
	}
	if (class == _num_priest) {
		str_cpy(weapon1, "Wooden Staff");
		str_cpy(weapon2, "Holy Staff");
		str_cpy(weapon3, "Mighty Staff");
		str_cpy(weapon4, "Winged Staff");
		str_cpy(weapon5, "Angelic Staff");
		str_cpy(armor1, "Journeyman's Robe");
		str_cpy(armor2, "Priest Robe");
		str_cpy(armor3, "Robe of Faith");
		str_cpy(armor4, "Saint's Robe");
		str_cpy(armor5, "Holy Robe");
	}
	if (class == _num_wizard) {
		str_cpy(weapon1, "Spear");
		str_cpy(weapon2, "Guisarme");
		str_cpy(weapon3, "Long Spear");
		str_cpy(weapon4, "Dragon Lance");
		str_cpy(weapon5, "Gaia Lance");
		str_cpy(armor1, "Mantle");
		str_cpy(armor2, "Mage Coat");
		str_cpy(armor3, "Robe of Casting");
		str_cpy(armor4, "Lord's Robe");
		str_cpy(armor5, "Wizard's Robe");
	}

	return;
}


function create_player(character_offset)
{
var position;

	STR_CPY(TEMP_STRING, actor_class.string[character_offset]);
	STR_CAT(TEMP_STRING, "+15.bmp");

	position.x = -(256 + Random(256));
	position.y = Random(256) -128;
	position.z = 50;

	me = ent_create(TEMP_STRING, position.x, serverside_playerfunction);

	// Activate flags until the server sends them.
	MY.FACING   = ON;	// Always face the camera
	MY.TRANSPARENT = ON;	// The next 2 fades the sprite border
	MY.ALPHA = 100;
	MY.INVISIBLE = ON;	// Will be reset in animate_actor() after everything is initiated

	MY._angle = Random(360);
	right_direction();
	initEquipmentNames(character_offset);
//	MY.Z = -MY.MIN_Z * MY.SCALE_Z;
//	IF (connection != 3) { MY.INVISIBLE = ON; } ELSE { WAIT (1); }

	// Wait until the entity is created on the server. If finished the server will automatically switch it's invisible flag back to ¥OFF¥ to synchronisize it.
//	WHILE (MY.INVISIBLE == ON) { WAIT (1); }

	player = me;	// Set the client's local `player` pointer
	activate_nosend(me);	// First of all deactivate automatic sending
	_cam_target = me;	// Set the player as camera target

	waitt(16);	// Wait for the entity to be created on the server

	// Set first values
	my._Actor_class = character_offset;
	my._Actor_ID = _ID_Player;

	// "Load"
	if (text_toggle[1] == 1) {
		load_character(my.skill1);
		send_important_skills(me);
		vec_set(my.x, position.x);

		send_skill(my._pdef, send_all); net_transfer += 4;
		send_skill(my._mdef, send_all); net_transfer += 4;
		send_skill(my._pdam, send_all); net_transfer += 4;
		send_skill(my._mdam, send_all); net_transfer += 4;

		send_skill(my._Str, send_all); net_transfer += 4;
		send_skill(my._Dex, send_all); net_transfer += 4;
		send_skill(my._Agi, send_all); net_transfer += 4;
		send_skill(my._Vit, send_all); net_transfer += 4;
		send_skill(my._Int, send_all); net_transfer += 4;
		send_skill(my._Wis, send_all); net_transfer += 4;
		send_skill(my._HP, send_all); net_transfer += 4;
		send_skill(my._MP, send_all); net_transfer += 4;
	}

	my._player_number = -1;
	if (my._gold == 0) { my._gold = 50; }

	// Send the values to the server at the end of this frame
	send_skill(my._Actor_class, null); net_transfer += 4;
	send_skill(my._Actor_ID,    null); net_transfer += 4;

	while (MY._player_number == -1) { WAIT (1); }

	screenshots();

	MY._action_timer = Random(_action_time);	// Initiate the action timer
	WHILE (ME) {
		IF (MY._HP > 0) {
//			MY.PASSABLE = OFF;
			MY._action_timer -= (1 + (MY._Agi + MY._buff_Agi) / 200) * TIME;
		} ELSE {
//			MY.PASSABLE = ON;
		}
		IF (MY._action_timer < 0) {
			MY._reset_timer = 0;
			MY._input_state = _state_select;

			WHILE ((MY._action_timer < 0) && (MY._HP > 0)) {
				if (Level_Select) {
					action_input_options(off);	// switch input menu on
					wait(1);
					continue;
				}
				if (MY._input_state == _state_select) {
					MY._reset_timer = 0;
					action_input_options(on);	// switch input menu on
				}
				if (MY._input_state == _state_confirm) {
					MY._reset_timer = 0;
					show_opt_back.visible = on;
				}
				if (MY._input_state == _state_disabled) {
					MY._reset_timer += time;
					if (MY._reset_timer > 24) { MY._input_state = _state_select; }
				}
			WAIT (1);
			}

			MY._input_state = _state_disabled;
			action_input_options(OFF);	// switch input menu off
			MY._action_timer = _action_time;
		}
	WAIT (1);
	}
}


function animate_grass()
{
	activate_nosend(ME);	// First of all deactivate automatic sending

	MY.PASSABLE = ON;
	MY.OVERLAY = ON;
	MY.ALBEDO = 10;
	MY.TRANSPARENT = ON;
	MY.ALPHA = 100;

	MY.PAN = Random(360);
	MY.AMBIENT += Random(32)-16;

	MY._anime = Random(100);
	ENT_ANIMATE (MY, "Base", MY._anime, ANM_CYCLE);

	MY.SCALE_X = 2 + (Random(6) / 10);
	MY.SCALE_Y = MY.SCALE_X;
	MY.SCALE_Z = MY.SCALE_X;

	MY.Z = -MY.MIN_Z * MY.SCALE_X;

	WHILE (1) {
		MY._anime += 0.5 * TIME;
		MY._anime %= 100;
		ENT_ANIMATE (MY, "Base", MY._anime, ANM_CYCLE);

		TEMP = VEC_DIST(MY.X, CAMERA.X) - 1536;
		IF (TEMP > 0) {
			MY.ALPHA = 100 - MIN(100, TEMP * 0.25);
		} ELSE {
			MY.ALPHA = 100;
		}
	WAIT (1);
	}
}

ACTION grass
{
	TEMP = INT(Random(16));
	WAITT (TEMP);

	proc_local(ME, animate_grass);
	animate_grass();
}

// To change the level we just morph the terrain and switch to another background
function morph_level(ID)
{
	if (player) {
		BGM_Start(1);

		FNCT_Flash_white();
		while (show_white.alpha < 100) { wait(1); }	// Wait until the screen is totally white
	}

	background_forest.visible = OFF;
	background_snow.visible = OFF;
	background_rocks.visible = OFF;

	IF (ID == _Level_Forest) {
		ENT_MORPH(Terrain, "terrain_forest.hmp");
		background_forest.visible = ON;
	}
	IF (ID == _Level_Snow) {
		ENT_MORPH(Terrain, "terrain_snow.hmp");
		background_snow.visible = ON;
	}
	IF (ID == _Level_Rocks) {
		ENT_MORPH(Terrain, "terrain_rocks.hmp");
		background_rocks.visible = ON;
	}

	Terrain._temp = ID;
}

function save_character(&skillptr)
{
var file_handle;
var class;
	class = getRealActorClass(player._Actor_class);


	str_cpy(str_save_file, actor_class.string[class]);
	str_cat(str_save_file, ".sav");

	file_handle = file_open_write(str_save_file);

	temp = 0;
	while (temp < 100) {
		file_var_write(file_handle, skillptr[temp]);
	temp += 1;
	}

	file_asc_write(file_handle, 13);
	file_asc_write(file_handle, 10);

	temp = 0;
	while (temp < cleared_levels.length) {
		file_var_write(file_handle, cleared_levels[temp]);
	temp += 1;
	}

	file_close(file_handle);
}

function save_player()
{
	me = null;
	if (player) {
		if (player._Level > 1) { save_character(player.skill1); }
	}
	return;
}

function load_character(&skillvar)
{
var cnt;
var file_handle;
var class;
	class = getRealActorClass(player._Actor_class);

	file_handle = get_character_file(class);

	cnt = 0;
	while (cnt < 100) {
		skillvar[cnt] = file_var_read(file_handle);
	cnt += 1;
	}

//	file_str_read(file_handle, TEMP_STRING);

	cnt = 0;
	while (cnt < cleared_levels.length) {
		cleared_levels[cnt] = file_var_read(file_handle);
	cnt += 1;
	}

	file_close(file_handle);
}

function get_character_file(class)
{
	str_cpy(str_save_file, actor_class.string[class]);
	str_cat(str_save_file, ".sav");

	return(file_open_read(str_save_file));
}

function event_client()
{
	if (Serverlogout) {
		save_player();
		exit;
	}
	if (Level_ID) {
		while (!Terrain) { wait(1); }	// Wait until the level is loaded at game start
		while (player == null) { wait(1); }	// Wait until a player has been selected

		// otherwise every wave the level will be morphed
		if (Level_ID != Terrain._temp) {
			morph_level(Level_ID);

			while (show_white.ALPHA < 100) { wait(1); }
		}
		closeTrade();	// Always, since it would not be closed when selecting 2 equal level types in a row
	}
	if ((Level_Select) && (show_wood_bg.visible == off)) {
		open_trade();
	}

	pause_game();
}
on_client = event_client;

function event_server()
{
	IF (EVENT_TYPE == EVENT_JOIN) {
		SEND_VAR(Level_ID);
	}
	IF (pause_request) {
		pause_request = 0;
		pause_game();
	}
}
on_server = event_server;

function leave_game()
{
	IF (PLAYER) {
		save_player();

		Clientlogout = PLAYER._player_number;
		SEND_VAR (Clientlogout);

		ENT_REMOVE (PLAYER);
	}

	IF (connection == 3) {	// Server closed
		Serverlogout = 1;
		SEND_VAR (Serverlogout);
	}

	WAIT (1);

	exit;
}
on_Esc = leave_game;



//function loool()
//{
//	victim = player;
//	snd_play(chaos, 100, 0);
//	laserInferno();
//}
//on_p = loool;
//
//function looool()
//{
//	victim = player;
//	summonIce();
//}
//on_o = looool;
//
//function loooool()
//{
//	victim = player;
//	meteor();
//}
//on_i = loooool;
//function looooool()
//{
//	victim = player;
//	fire_rain();
//}
//on_u = looooool;

/*
string olio;

function lll(&ptr, ent_ptr)
{
var filehandle;
var zaehler;

	me = ent_ptr;

	my.x = 111.111;
	my.pan = 22.222;
	my.skill1 = 333.333;
	my.bright = on;

	wait(1);

	filehandle = file_open_write("test3.txt");
	while (1) {
		str_for_num(temp_string, zaehler);
		str_cpy(olio, temp_string);
		str_cat(olio, ": ");
		str_for_num(temp_string, ptr[zaehler]);
		str_cat(olio, temp_string);
		while (1) {
			if (ptr[zaehler] == 111.111) {
				str_cat(olio, " - x");
				break;
			}
			if (ptr[zaehler] == 22.222) {
				str_cat(olio, " - pan");
				break;
			}
			if (ptr[zaehler] == 333.333) {
				str_cat(olio, " - skill1");
				break;
			}
			break;
		}
		file_str_write(filehandle, olio);
		FILE_ASC_WRITE (filehandle, 13);
		FILE_ASC_WRITE (filehandle, 10);
	zaehler += 1;
	}
	file_close(filehandle);
}

function ll()
{
	lll(player.x, player);
}
on_p = ll;*/