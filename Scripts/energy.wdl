entity* victim;

function FNCT_Small_Stones();

MATERIAL MAT_Doublealpha_fluid { }
MATERIAL MAT_Doublealpha_fluid_2 { }
starter MAT_Doublealpha_start
{
	Effect_load (MAT_Doublealpha_fluid, "MAT_Doublealpha_fluid.fx");
	Effect_load (MAT_Doublealpha_fluid_2, "MAT_Doublealpha_fluid_2.fx");
}

/////////////////////////////////////////////////////////////////
// Camera tramble

var Camtramble;

function FNCT_Camtramble()
{
//var Camtramble;

//	Camtramble = CAMERA.Z;
	Camtramble[1] = 0;
	Camtramble[2] = 5;

//	WHILE (Camtramble[1] < 1800) {
//		CAMERA.Z = Camtramble + FSIN(Camtramble[1], Camtramble[2] * (1 - (Camtramble[1] / 1800)));
//		Camtramble[1] += 180 * TIME;
//	WAIT (1);
//	}

//	CAMERA.Z = Camtramble;
}

function FNCT_Camquake()
{
	Camquake[0] = 80;
	Camquake[1] = 0;
	Camquake[2] = 8;
}


function shining_light(color, scalation)
{
you = me;
	if (color == 1) { me = ent_createlocal("white_dot.tga", your.x, null); }

	my.passable = on;
	my.transparent = on;
	my.bright = on;
	my.unlit = on;
	my.nofog = on;
	my.ambient = 100;
	my.facing = on;

	vec_normalize (MY.SCALE_X, scalation);

	while (me) {
		VEC_SET (MY.X, YOU.X);
		VEC_DIFF (TEMP.X, CAMERA.X, YOU.X);
		VEC_NORMALIZE (TEMP.X, 50);
		VEC_ADD (MY.X, TEMP.X);
	wait(1);
	}

	return;
}

function FNCT_Hervorsetzen()
{
var Position;
	vec_set(Position.x, my.x);
	while (me) {
		vec_diff(temp.x, camera.x, Position.x);
		vec_normalize(temp.x, 48);

		vec_set(my.x, Position.x);
		vec_add(my.x, temp.x);
	wait(1);
	}

	return;
}


/////////////////////////////////////////////////////////////////
// Willow wisp

function FNCT_Energy_Flash(&position, maxalpha, entptr, length)
{
	YOU = entptr;

	ME = ENT_CREATELOCAL("e_eff_a.mdl", position, NULL);
	MY.SKILL2 = INT(Random(2)) + 1;

	MY.PASSABLE = ON;
//	MY.ORIENTED = ON;
	MY.TRANSPARENT = ON;
	MY.BRIGHT = ON;
	MY.FLARE = ON;
	MY.ALPHA = 0;
	MY.UNLIT = ON;
	MY.NOFOG = ON;
	MY.AMBIENT = 100;
	MY.SCALE_X = 0.125 * MY.SKILL2 * length;
	MY.SCALE_Y = 0.25 * MY.SKILL2 * length;

	TEMP.X = 0; TEMP.Y = 1; TEMP.Z = 0;
	VEC_ROTATE(TEMP.X, CAMERA.PAN);
	VEC_TO_ANGLE (MY.PAN, TEMP.X);
	MY.ROLL -= CAMERA.TILT + 90;
	ANG_ROTATE(MY.PAN, vector(Random(360), 0, 0));


	WHILE (MY.SKILL1 < 180) {
		VEC_SET(MY.X, YOU.X);

		MY.ALPHA = FSIN(MY.SKILL1, maxalpha);
		MY.SCALE_X += 0.025 * MY.SKILL2 * TIME;
		MY.SCALE_Y -= 0.020 * MY.SKILL2 * TIME;

		MY.SKILL1 += 33.75 * TIME;
	WAIT (1);
	}

	ENT_REMOVE(ME);
}

// Get Position as -Reference-
function FNCT_Energy(&Position, Span)
{
	ME = ENT_CREATELOCAL("Enlight.tga", Position.X, NULL);
	Position[0] = ME;	// Store the ME Pointer in Position[0] so that the calling function can access the entity for movement for example

	MY.PASSABLE = ON;
	MY.FACING = ON;
	MY.TRANSPARENT = ON;
	MY.BRIGHT = ON;
	MY.ALPHA = 0;
	MY.UNLIT = ON;
	MY.NOFOG = ON;
	MY.AMBIENT = 100;
//	MY.SCALE_X = 0.75;
//	MY.SCALE_Y = 0.75;

	WHILE (MY.ALPHA < 100) {
		MY.ALPHA += 50 * TIME;
	WAIT (1);
	}

	WHILE (Span > 0) {
		MY.SCALE_X = 1 + FSIN(total_ticks * 150, 0.02);
		MY.SCALE_Y = MY.SCALE_X;

		MY.SKILL3 += TIME;
		IF ((MY.SKILL3 > 0.7) && (Span > 4)) {
			MY.SKILL3 = 0;
			FNCT_Energy_Flash(MY.X, 100, ME, 1);
		}
		Span -= TIME;
	WAIT (1);
	}

	WHILE (MY.ALPHA > 0) {
		MY.ALPHA -= 25 * TIME;
	WAIT (1);
	}

	ENT_REMOVE(ME);
}

function willow_wisp()
{
	TEMP.X = Random(64) - 32;
	TEMP.Y = Random(64) - 32;
	TEMP.Z = Random(32);
	VEC_ADD(TEMP.X, victim.X);

	FNCT_Energy(TEMP, 32);
	ME = TEMP[0];	// FNCT_Energy writes the Entity-Pointer into the reference Variable of TEMP (thus into TEMP)

	// Just to show, that the pointer works
	WHILE (ME) {
		MY.Z -= TIME;
	WAIT (1);
	}
}

//on_p = willow_wisp();



/////////////////////////////////////////////////////////////////
// Ice

var Icecount;

BMAP Flare2  = <Flare2.tga>;
BMAP icedust = <icedust.tga>;
BMAP white   = <white.bmp>;
BMAP black   = <black.bmp>;

PANEL show_white
{
	BMAP white;
	SCALE_X = 128;
	SCALE_Y = 96;
	LAYER = 500;
	FLAGS = TRANSPARENT;
}
PANEL show_black
{
	BMAP black;
	SCALE_X = 128;
	SCALE_Y = 96;
	LAYER = 500;
	FLAGS = TRANSPARENT;
}

function FNCT_Flash_white()
{
var timer;

ME = NULL;
	show_white.VISIBLE = ON;
	show_white.ALPHA = 0;
	WHILE (timer < 100) {
		timer += 50 * TIME;
		show_white.ALPHA = MIN(100, timer);
	WAIT (1);
	}
	WAITT (4);
	WAIT (5);	// If you want to load a level while the screen flashes up in white
	WHILE (timer > 0) {
		timer -= 6.25 * TIME;
		show_white.ALPHA = MAX(0, timer);
	WAIT (1);
	}
	show_white.VISIBLE = OFF;
	show_white.ALPHA = 50;
}


// Energy charge effect
function Charge_Fader()
{
	MY.ALPHA -= 25 * TIME;
}
function EFKT_Charge_Init()
{

	TEMP.X = 80;
	TEMP.Y = 0;
	TEMP.Z = 0;
	VEC_ROTATE(TEMP.X, vector(Random(360), Random(360), 0));
	VEC_ADD(MY.X, TEMP.X);
	VEC_SCALE(TEMP.X, -0.24);
	VEC_SET(MY.VEL_X, TEMP.X);

	MY.MOVE = ON;
	MY.SIZE = 2;
	MY.BMAP = Flare2;
	MY.BRIGHT = ON;
	MY.STREAK = ON;
	MY.ALPHA = 100;
	MY.LIFESPAN = 4;
	MY.FUNCTION = Charge_Fader;
}

// Ice dust effect
function Icedust_Fader()
{
	MY.ALPHA = FSIN(MY.LIFESPAN * 5.625, 25);
}
function EFKT_Icedust_Init()
{

	MY.X += Random(16) - 8;
	MY.Y += Random(16) - 8;
//	MY.Z += Random(8);

	MY.VEL_X = Random(1.5) - 0.75;
	MY.VEL_Y = Random(1.5) - 0.75;
	MY.VEL_Z = -1.5;

	MY.MOVE = ON;
	MY.SIZE = 60;
	MY.BMAP = icedust;
	MY.BRIGHT = ON;
	MY.ALPHA = 0;
	MY.LIFESPAN = 32;
	MY.FUNCTION = Icedust_Fader;
}

// Water dust effect
function Waterdust_Fader()
{
	my.size += 4 * time;
	MY.ALPHA = FSIN(MY.LIFESPAN * 5.625, 25);
}
function EFKT_Waterdust_Init()
{

	MY.X += Random(256) - 128;
	MY.Y += Random(64)  - 32;

	MY.VEL_X = Random(4) - 2;
	MY.VEL_Y = Random(1);
	MY.VEL_Z = 2 + random(2);

	MY.MOVE = ON;
	MY.SIZE = 80;
	MY.BMAP = icedust;
	MY.BRIGHT = ON;
	MY.ALPHA = 0;
	MY.LIFESPAN = 32;
	MY.FUNCTION = Waterdust_Fader;
}


// Ice shards
function FNCT_Iceshard()
{
	MY.X += Random(32) - 16;
	MY.Y += Random(32) - 16;
	MY.Z += Random(64) - 32;

	MY.SKILL1 = Random(32) - 16;
	MY.SKILL2 = Random(32) - 16;
	MY.SKILL3 = Random(9) + 9;

	MY.PAN  = Random(360);
	MY.TILT = Random(360);

	MY.SKILL4 = 32;
	WHILE (MY.SKILL4 > 0) {
		MY.SKILL4 -= TIME;

		MY.PAN  += 60 * TIME;
		MY.TILT += 60 * TIME;

		MY.X += MY.SKILL1 * TIME;
		MY.Y += MY.SKILL2 * TIME;
		MY.Z += MY.SKILL3 * TIME;

		MY.SKILL3 -= 1.84 * TIME;

	WAIT (1);
	}
	ENT_REMOVE(ME);
}

// Ice flare
function FNCT_Iceflare(&Position)
{
	ME = ENT_CREATELOCAL("Flare3.tga", Position.X, NULL);

	MY.PASSABLE = ON;
	MY.FACING = ON;
	MY.TRANSPARENT = ON;
	MY.BRIGHT = ON;
	MY.ALPHA = 0;
	MY.UNLIT = ON;
	MY.NOFOG = ON;
	MY.AMBIENT = 100;
	MY.ROLL = 45;
	MY.SCALE_X = 0;
	MY.SCALE_Y = 0;

	WHILE (MY.ALPHA < 100) {
		MY.ALPHA += 50 * TIME;
		MY.SCALE_X += 0.25 * TIME;
		MY.SCALE_Y = MY.SCALE_X;
	WAIT (1);
	}

	MY.SKILL1 = 0.5;
	WHILE (MY.SKILL1 < 2) {
		MY.SCALE_X = MY.SKILL1 + FSIN(total_ticks * 83, 0.5) * FCOS(total_ticks * 57, 0.5);
		MY.SCALE_Y = MY.SCALE_X;

		MY.SKILL1 += 0.06 * TIME;
		MY.SKILL2 += TIME;
		MY.SKILL3 -= TIME;
		IF (MY.SKILL2 > 0.25) {
			MY.SKILL2 = 0;
			Effect_local(EFKT_Charge_Init, 1, MY.X, NULLVECTOR);
		}
		IF (MY.SKILL3 < 0) {
			MY.SKILL3 = 6;
			Effect_local(EFKT_Icedust_Init, 1, vector(MY.X, MY.Y, MY.Z + MY.MAX_Z), NULLVECTOR);
		}
	WAIT (1);
	}

	WHILE (MY.SCALE_X > 0) {
		MY.SCALE_X = MAX(0, MY.SCALE_X - 0.6 * TIME);
		MY.SCALE_Y = MY.SCALE_X;
	WAIT (1);
	}

	FNCT_Flash_white();

	ENT_REMOVE(ME);
}

function FNCT_Ice(&Position)
{
	ME = ENT_CREATELOCAL("Ice.mdl", Position.X, NULL);

	MY.PASSABLE = ON;
	MY.TRANSPARENT = ON;
	MY.ALPHA = 50;
	MY.UNLIT = ON;
	MY.NOFOG = ON;
	MY.AMBIENT = 50;
	MY.PAN = Random(360);
//	MY.SCALE_X = 0;
//	MY.SCALE_Y = 0;

	TEMP.X = -64; TEMP.Y = 0; TEMP.Z = 0;
	VEC_ROTATE(TEMP.X, CAMERA.PAN);
	VEC_ADD(TEMP.X, MY.X);

	FNCT_Iceflare(TEMP.X);

	MY.MATERIAL = MAT_Doublealpha_fluid;

	WHILE (MY.SKILL1 < 128) {
		MY.SKILL1 += 4 * TIME;
		MY.SKILL43 = MY.SKILL1;
		mat_identity(MAT_Doublealpha_fluid.matrix);
		MAT_Doublealpha_fluid.matrix23 = floatd(MY.SKILL43, 255);
	WAIT (1);
	}

//	WHILE (show_white.ALPHA < 100) { WAIT (1); }
	WAITT (4);

	MY.SKILL1 = 20;
	WHILE (MY.SKILL1 > 0) {
		ENT_CREATELOCAL("iceshard.mdl", MY.X, FNCT_Iceshard);
	MY.SKILL1 -= 1;
	}

ENT_REMOVE(ME);

WAITT (6);

FNCT_Camtramble();
}

function ice()
{
	TEMP.X = Random(8) - 4;
	TEMP.Y = Random(8) - 4;
	TEMP.Z = Random(8) - 8;
	VEC_ADD(TEMP.X, victim.X);

	FNCT_Ice(TEMP);
}

//on_o = ice();


/////////////////////////////////////////////////////////////////
// Light

function FNCT_Fast_Flash_white()
{
var timer;

ME = NULL;

	IF (show_white.VISIBLE == ON) { RETURN; }

	show_white.VISIBLE = ON;
	show_white.ALPHA = 0;
	WHILE (timer < 100) {
		timer += 50 * TIME;
		show_white.ALPHA = MIN(100, timer);
	WAIT (1);
	}
	WAITT (1);
	WHILE (timer > 0) {
		timer -= 50 * TIME;
		show_white.ALPHA = MAX(0, timer);
	WAIT (1);
	}
	show_white.VISIBLE = OFF;
	show_white.ALPHA = 50;
}

function Lightemit_Fader()
{
	MY.ALPHA = MAX(0, MY.ALPHA - 12.5 * TIME);
}

function EFKT_Lightemit_init()
{
	MY.X += Random(32) - 16;
	MY.Y += Random(32) - 16;

	MY.VEL_X = Random(2) - 1;
	MY.VEL_Y = Random(2) - 1;
	VEC_NORMALIZE(MY.VEL_X, 15);
	MY.VEL_Z = Random(4) + 4;

	MY.MOVE = ON;
	MY.SIZE = 7;
	MY.BMAP = Flare2;
	MY.BRIGHT = ON;
	MY.ALPHA = 100;
	MY.LIFESPAN = 8;
	MY.FUNCTION = Lightemit_Fader;
}

function FNCT_Lightshock()
{
	MY.PAN = Random(360);

	MY.PASSABLE = ON;
	MY.BRIGHT = ON;	
	MY.TRANSPARENT = ON;
	MY.ALPHA = 0;
	MY.UNLIT = ON;
	MY.NOFOG = ON;
	MY.AMBIENT = 100;

	WHILE (MY.SKILL1 < 180) {
		MY.SKILL1 += 22.5 * TIME;

		MY.ALPHA = FSIN(MY.SKILL1, 80);
		MY.SCALE_X += TIME;
		MY.SCALE_Y = MY.SCALE_X;
		MY.SCALE_Z = MY.SCALE_X;
	WAIT (1);
	}

ENT_REMOVE(ME);
}

function FNCT_Lightsource()
{
	MY.FACING = ON;
	MY.SCALE_X = 2.5;
	MY.SCALE_Y = MY.SCALE_X;

	MY.PAN += 90;
	MY.PASSABLE = ON;
	MY.BRIGHT = ON;	
	MY.TRANSPARENT = ON;
	MY.ALPHA = 0;
	MY.UNLIT = ON;
	MY.NOFOG = ON;
	MY.AMBIENT = 100;

	FNCT_Hervorsetzen();

	WHILE (MY.ALPHA < 100) {
		MY.ALPHA += 50 * TIME;
	WAIT (1);
	}

	WHILE (YOU.SKILL1 < 32) {
		MY.SCALE_X = 1.5 + YOU.SCALE_X;
		MY.SCALE_Y = MY.SCALE_X;
	WAIT (1);
	}

	WHILE (MY.ALPHA > 0) {
		MY.ALPHA -= 50 * TIME;
	WAIT (1);
	}

	ENT_REMOVE(ME);
}

function FNCT_Lightbeam(&Position)
{
	ME = ENT_CREATELOCAL("Beam.tga", Position.X, NULL);
	ENT_CREATELOCAL("Flare2.tga", MY.X, FNCT_Lightsource);

	MY.SCALE_X = 1;
	MY.SCALE_Y = 80;

	MY.Z -= MY.MIN_Z * MY.SCALE_Y;

	MY.PAN += 90;
	MY.PASSABLE = ON;
	MY.BRIGHT = ON;	
	MY.TRANSPARENT = ON;
	MY.ALPHA = 0;
	MY.UNLIT = ON;
	MY.NOFOG = ON;
	MY.AMBIENT = 100;

	WHILE (MY.ALPHA < 100) {
		MY.ALPHA += 50 * TIME;
	WAIT (1);
	}

	WHILE (MY.SKILL1 < 32) {
		MY.SKILL1 += TIME;
		MY.SKILL2 -= TIME;

		MY.SCALE_X = 1 + FSIN(total_ticks * 122, 0.5) * FCOS(total_ticks * 53, 0.5);

		IF ((MY.SKILL2 < 0) && (MY.SKILL1 < 28)) {
			MY.SKILL2 = 3;
			IF (Int(Random(3))) {
				FNCT_Fast_Flash_white();
				FNCT_Camtramble();
			}
			ent_createlocal("shock.mdl", vector(my.x, my.y, my.z + my.min_z * my.scale_y), FNCT_Lightshock);
			ent_createlocal("smlstone.mdl", vector(my.x, my.y, my.z + my.min_z * my.scale_y), FNCT_Small_Stones);
			Effect_local(EFKT_Lightemit_init, 5, vector(my.x, my.y, my.z + my.min_z * my.scale_y), nullvector);
		}
	WAIT (1);
	}

	WHILE (MY.ALPHA > 0) {
		MY.ALPHA -= 50 * TIME;
	WAIT (1);
	}

ENT_REMOVE(ME);
}

function light()
{
	TEMP.X = Random(8) - 4;
	TEMP.Y = Random(8) - 4;
	TEMP.Z = victim.MIN_Z + 1;
	VEC_ADD(TEMP.X, victim.X);

	FNCT_Lightbeam(TEMP);
}

//on_i = light();


/////////////////////////////////////////////////////////////////
// Stone

BMAP dust = <dust.tga>;

// Ice dust effect
function Dust_Fader()
{
	MY.ALPHA = FSIN(MY.LIFESPAN * 5.625, 50);
}
function EFKT_Dust_Init()
{

	MY.X += Random(16) - 8;
	MY.Y += Random(16) - 8;
	MY.Z += Random(8) + 16;

	MY.VEL_X = Random(3) - 1.5;
	MY.VEL_Y = Random(3) - 1.5;

	MY.MOVE = ON;
	MY.SIZE = 60;
	MY.BMAP = dust;
	MY.ALPHA = 0;
	MY.LIFESPAN = 32;
	MY.FUNCTION = Dust_Fader;
}

// The same function as FNCT_Iceshard
function FNCT_Small_Stones()
{
	MY.X += Random(32) - 16;
	MY.Y += Random(32) - 16;
	MY.Z += Random(16);

	MY.SKILL1 = Random(32) - 16;
	MY.SKILL2 = Random(32) - 16;
	MY.SKILL3 = Random(9) + 9;

	MY.PAN  = Random(360);
	MY.TILT = Random(360);

	MY.SKILL4 = 32;
	WHILE (MY.SKILL4 > 0) {
		MY.SKILL4 -= TIME;

		MY.PAN  += 60 * TIME;
		MY.TILT += 60 * TIME;

		MY.X += MY.SKILL1 * TIME;
		MY.Y += MY.SKILL2 * TIME;
		MY.Z += MY.SKILL3 * TIME;

		MY.SKILL3 -= 1.84 * TIME;

	WAIT (1);
	}
	ENT_REMOVE(ME);
	RETURN;
}

function FNCT_Stones(Angle)
{
	YOU = ME;
	ME = ENT_CREATELOCAL("stone.mdl", YOUR.X, NULL);

	TEMP.X = 24; TEMP.Y = 0; TEMP.Z = 0;
	VEC_ROTATE(TEMP.X, vector(Angle, 0, 0));
	VEC_ADD(MY.X, TEMP.X);

	MY.PAN = YOUR.PAN + Angle;
	MY.TILT = Random(10) + 10;
	MY.SCALE_X = Random(0.2) + 0.9;
	MY.SCALE_Y = MY.SCALE_X;
	MY.SCALE_Z = MY.SCALE_X;
	MY.PASSABLE = ON;
	MY.UNLIT = ON;
	MY.AMBIENT = 50;

	WAITT (Angle / 30);

	MY.SKILL1 = 6;
	WHILE (MY.SKILL1 > 0) {
		ENT_CREATELOCAL("smlstone.mdl", vector(MY.X, MY.Y, MY.Z + MY.MAX_Z), FNCT_Small_Stones);
	MY.SKILL1 -= 1;
	}

	FNCT_Camtramble();
	WHILE (MY.SKILL1 < 100) {
		MY.SKILL1 += 25 * TIME;
		ENT_ANIMATE(ME, "Frame", MY.SKILL1, NULL);
	WAIT (1);
	}

	WAITT (24);

	WHILE (MY.SKILL1 > 0) {
		MY.SKILL1 -= 5 * TIME;
		ENT_ANIMATE(ME, "Frame", MY.SKILL1, NULL);
	WAIT (1);
	}

ENT_REMOVE(ME);
}

function FNCT_Earthstrike(&Position)
{
	ME = ENT_CREATELOCAL("stone.mdl", Position.X, NULL);

	MY.PAN = Random(360);
	MY.SCALE_X = Random(0.3) + 1.3;
	MY.SCALE_Y = MY.SCALE_X;
	MY.SCALE_Z = MY.SCALE_X;
	MY.PASSABLE = ON;
	MY.UNLIT = ON;
	MY.AMBIENT = 50;

	MY.SKILL1 = 0;
	WHILE (MY.SKILL1 < 16) {
		MY.SKILL1 += 1;
		Effect_local(EFKT_Dust_Init, 1, MY.X, NULLVECTOR);
	WAITT (1);
	}

	FNCT_Stones(0);
	FNCT_Stones(120);
	FNCT_Stones(240);

	MY.SKILL1 = 0;
	WHILE (MY.SKILL1 < 12) {
		MY.SKILL1 += 1;
		Effect_local(EFKT_Dust_Init, 1, MY.X, NULLVECTOR);
	WAITT (1);
	}

	MY.SKILL1 = 20;
	WHILE (MY.SKILL1 > 0) {
		ENT_CREATELOCAL("smlstone.mdl", vector(MY.X, MY.Y, MY.Z + MY.MAX_Z), FNCT_Small_Stones);
	MY.SKILL1 -= 1;
	}

	FNCT_Camtramble();
	MY.SKILL1 = 0;
	WHILE (MY.SKILL1 < 100) {
		MY.SKILL1 += 25 * TIME;
		MY.SKILL2 += TIME;
		ENT_ANIMATE(ME, "Frame", MY.SKILL1, NULL);

		IF (MY.SKILL2 > 1) {
			MY.SKILL2 = 0;
			Effect_local(EFKT_Dust_Init, 1, MY.X, NULLVECTOR);
		}
	WAIT (1);
	}

	MY.SKILL1 = 0;
	WHILE (MY.SKILL1 < 32) {
		MY.SKILL1 += 1;
		Effect_local(EFKT_Dust_Init, 1, MY.X, NULLVECTOR);
	WAITT (1);
	}

	MY.SKILL1 = 100;
	WHILE (MY.SKILL1 > 0) {
		MY.SKILL1 -= 5 * TIME;
		ENT_ANIMATE(ME, "Frame", MY.SKILL1, NULL);
	WAIT (1);
	}

ENT_REMOVE(ME);
}

function earth()
{
	TEMP.X = Random(8) - 4;
	TEMP.Y = Random(8) - 4;
	TEMP.Z = victim.MIN_Z;
	VEC_ADD(TEMP.X, victim.X);

	FNCT_Earthstrike(TEMP);
}

//on_u = earth();


/////////////////////////////////////////////////////////////////
// Lightning

BMAP smoke3 = <Rauch03.tga>;

// Light dust effect
function Lightdust_Fader()
{
	MY.ALPHA = FSIN(MY.LIFESPAN * 7.5, 25);
}
function EFKT_Lightdust_Init()
{

	MY.X += Random(16) - 8;
	MY.Y += Random(16) - 8;
//	MY.Z += Random(8);

	MY.VEL_X = Random(3) - 1.5;
	MY.VEL_Y = Random(3) - 1.5;
	MY.VEL_Z = 1;

	MY.MOVE = ON;
	MY.SIZE = 60;
	MY.BMAP = icedust;
	MY.BRIGHT = ON;
	MY.ALPHA = 0;
	MY.LIFESPAN = 24;
	MY.FUNCTION = Lightdust_Fader;
}
function EFKT_Explosion_Init()
{

	MY.X += Random(16) - 8;
	MY.Y += Random(16) - 8;
	MY.Z += Random(16) - 8;

	MY.VEL_X = Random(2) - 1;
	MY.VEL_Y = Random(2) - 1;
	MY.VEL_Z = 2;

	MY.MOVE = ON;
	MY.SIZE = 100;
	MY.BMAP = smoke3;
//	MY.BRIGHT = ON;
	MY.ALPHA = 0;
	MY.LIFESPAN = 24;
	MY.FUNCTION = Lightdust_Fader;
}

function FNCT_Lightningshock()
{
	MY.PAN = Random(360);

	MY.PASSABLE = ON;
	MY.BRIGHT = ON;	
	MY.TRANSPARENT = ON;
	MY.ALPHA = 0;
	MY.UNLIT = ON;
	MY.NOFOG = ON;
	MY.AMBIENT = 100;

	WHILE (MY.SKILL1 < 180) {
		MY.SKILL1 += 25 * TIME;

		MY.ALPHA = FSIN(MY.SKILL1, 80);
		MY.SCALE_X += 0.5 * TIME;
		MY.SCALE_Y = MY.SCALE_X;
		MY.SCALE_Z = MY.SCALE_X;
	WAIT (1);
	}

ENT_REMOVE(ME);
}

function FNCT_Lightning_Light()
{
	MY.PASSABLE = ON;
	MY.FACING = ON;
	MY.TRANSPARENT = ON;
	MY.BRIGHT = ON;
	MY.ALPHA = 100;
	MY.UNLIT = ON;
	MY.NOFOG = ON;
	MY.AMBIENT = 100;
	MY.SCALE_X = 2;
	MY.SCALE_Y = 2;

	TEMP.X = -64; TEMP.Y = 0; TEMP.Z = 0;
	VEC_ROTATE(TEMP.X, CAMERA.PAN);
	VEC_ADD(MY.X, TEMP.X);

	WHILE (YOU) {
		MY.SCALE_X = YOUR.SCALE_X * 2;
		MY.SCALE_Y = MY.SCALE_X;
		MY.ALPHA = 50 + YOUR.ALPHA * 0.5;
	WAIT (1);
	}

	MY.ALPHA = 50;
	WHILE (MY.ALPHA > 0) {
		MY.ALPHA -= 5 * TIME;
	WAIT (1);
	}

	ENT_REMOVE(ME);
}

function FNCT_Lightning(&Position)
{
	ME = ENT_CREATELOCAL("Blitz+3.tga", Position.X, NULL);
	ENT_CREATELOCAL("Enlight.tga", vector(MY.X, MY.Y, MY.Z), FNCT_Lightning_Light);

//	MY.SCALE_X = 1;
	MY.SCALE_Y = 2;

	MY.Z -= MY.MIN_Z * MY.SCALE_Y;

//	MY.PAN += 90;
	MY.PASSABLE = ON;
	MY.BRIGHT = ON;	
	MY.TRANSPARENT = ON;
	MY.ALPHA = 0;
	MY.UNLIT = ON;
	MY.NOFOG = ON;
	MY.AMBIENT = 100;

	WHILE (MY.SKILL1 < 12) {
		MY.SKILL1 += TIME;
		MY.SKILL2 += 45 * TIME;
		MY.SKILL4 -= TIME;

		IF (MY.SKILL4 < 0) {
			MY.SKILL4 = 1;
			Effect_local(EFKT_Lightdust_Init, 1, vector(MY.X, MY.Y, MY.Z + MY.MIN_Z * MY.SCALE_Y), NULLVECTOR);
		}

		MY.ALPHA = FSIN(MY.SKILL2, 100);
		IF (MY.SKILL2 > 180) {
			MY.SKILL2 = 0;
			MY.SKILL3 = OFF;
			MY.FRAME += 1;
		} ELSE {
			IF ((MY.SKILL2 > 80) && (!MY.SKILL3)) {
				MY.SKILL3 = ON;
				FNCT_Fast_Flash_white();
				FNCT_Camtramble();

				ENT_CREATELOCAL("shock.mdl", vector(MY.X, MY.Y, MY.Z + MY.MIN_Z * MY.SCALE_Y), FNCT_Lightningshock);

				MY.SKILL5 = 7;
				WHILE (MY.SKILL5 > 0) {
					ENT_CREATELOCAL("smlstone.mdl", vector(MY.X, MY.Y, MY.Z + MY.MIN_Z * MY.SCALE_Y), FNCT_Small_Stones);
				MY.SKILL5 -= 1;
				}
			}
		}
	WAIT (1);
	}

	WHILE (MY.ALPHA > 0) {
		MY.ALPHA -= 50 * TIME;
	WAIT (1);
	}

ENT_REMOVE(ME);
}

function lightning()
{
	TEMP.X = Random(8) - 4;
	TEMP.Y = Random(8) - 4;
	TEMP.Z = victim.MIN_Z;
	VEC_ADD(TEMP.X, victim.X);

	FNCT_Lightning(TEMP);
}

//on_t = lightning();


// holy something

function level_up()
{
	YOU = ME;
	ME = ENT_CREATELOCAL("wings+4.bmp", NULLVECTOR, NULL);

	MY.FACING   = ON;	// Always face the camera
	MY.TRANSPARENT = ON;	// The next 2 fades the sprite border
	MY.ALPHA = 100;

	snd_play(newlevel, 100, 0);

	victim = YOU;
	willow_wisp();
	willow_wisp();
	willow_wisp();

	WHILE (MY._anime < 100) {
		IF (!YOU) { break; }

		VEC_SET(MY.X, vector(1, 0, 16));
		VEC_ROTATE(MY.X, CAMERA.PAN);
		VEC_ADD(MY.X, YOUR.X);

		MY._anime += 5 * TIME;
		MY.FRAME = 1 + MY._anime / (100 / 4);
	WAIT (1);
	}

	ENT_REMOVE(ME);
	RETURN;
}


function healing()
{
ME = ENT_CREATELOCAL("sparc+16.tga", victim.X, NULL);

	MY.Z += MY.MIN_Z * 0.5;

	MY.FLARE = ON;
	MY.TRANSPARENT = ON;
	MY.UNLIT = ON;
	MY.AMBIENT = 100;
	MY.ALPHA = 100;
	MY.BRIGHT = ON;
	MY.FACING = ON;
	MY.Z += 16;
	MY.PASSABLE = ON;

	MY.SCALE_X = 0.6 + Random(4)/20;
	MY.SCALE_Y = MY.SCALE_X;
	MY.SCALE_Z = MY.SCALE_X;

	object_to_camera(victim, 4);

	WHILE (MY.FRAME < 17) {
		MY.FRAME += 0.75 * TIME;
		MY.SCALE_Y = MY.SCALE_X;
		MY.SCALE_Z = MY.SCALE_X;
		MY.Z -= TIME;
	WAIT (1);
	}

	ent_remove(me);
	return;
}

function buff_energy()
{
	me = ent_createlocal("buff+10.tga", victim.x, null);

	MY.Z += MY.MIN_Z * 0.5;

	MY.FLARE = ON;
	MY.TRANSPARENT = ON;
	MY.UNLIT = ON;
	MY.AMBIENT = 100;
	MY.ALPHA = 100;
	MY.BRIGHT = ON;
	MY.FACING = ON;
	MY.Z += 16;
	MY.PASSABLE = ON;

	MY.SCALE_X = 1.2 + Random(4) /20;
	MY.SCALE_Y = MY.SCALE_X;
	MY.SCALE_Z = MY.SCALE_X;

	object_to_camera(victim, 4);

	WHILE (MY.FRAME < 11) {
		MY.FRAME += 0.8 * TIME;
		MY.SCALE_Y = MY.SCALE_X;
		MY.SCALE_Z = MY.SCALE_X;
	WAIT (1);
	}

	ent_remove(me);
	return;
}

function charge()
{
ME = ENT_CREATELOCAL("charge+10.bmp", victim.X, NULL);

	MY.Z += MY.MIN_Z * 0.5;

	MY.FLARE = ON;
	MY.TRANSPARENT = ON;
	MY.UNLIT = ON;
	MY.AMBIENT = 100;
	MY.ALPHA = 100;
	MY.BRIGHT = ON;
	MY.FACING = ON;
	MY.PASSABLE = ON;

	MY.SCALE_X = 0.6 + Random(4)/20;
	MY.SCALE_Y = MY.SCALE_X;
	MY.SCALE_Z = MY.SCALE_X;

	object_to_camera(victim, 4);

	WHILE (MY.FRAME < 11) {
		MY.FRAME += TIME;
	WAIT (1);
	}

	ent_remove(me);
	return;
}



function EFKT_Explosion(delay, &position)
{
	ME = ENT_CREATELOCAL("exp+16.tga", position.X, NULL);
	MY.INVISIBLE = ON;

	MY.X += Random(120) - 60;
	MY.Y += Random(120) - 60;
	MY.Z += Random(16) - 8;

	WAITT(delay);

	snd_play(explo, 100, 0);
	Effect_local(EFKT_Explosion_Init, 2, MY.X, NULLVECTOR);
	FNCT_Energy_Flash(MY.X, 50, ME, 2);
	FNCT_Energy_Flash(MY.X, 50, ME, 2);
	FNCT_Energy_Flash(MY.X, 50, ME, 2);

	FNCT_Camtramble();
	IF (Random(2) < 1) { FNCT_Fast_Flash_White(); }

	MY.INVISIBLE = OFF;

	MY.FLARE = ON;
	MY.TRANSPARENT = ON;
	MY.UNLIT = ON;
	MY.AMBIENT = 100;
	MY.ALPHA = 100;
	MY.BRIGHT = ON;
	MY.FACING = ON;
	MY.PASSABLE = ON;

	MY.SCALE_X = 1.5;
	MY.SCALE_Y = MY.SCALE_X;
	MY.SCALE_Z = MY.SCALE_X;

	WHILE (MY.FRAME < 17) {
		MY.FRAME += TIME;
	WAIT (1);
	}

ENT_REMOVE(MY);
RETURN;
}

function EFKT_Flames()
{
	MY.Z = -MY.MIN_Z * 1.2;

//	MY.X += Random(16) - 8;
//	MY.Y += Random(16) - 8;
//	MY.Z += Random(16) - 8;

	MY.UNLIT = ON;
	MY.AMBIENT = 100;
	MY.OVERLAY = ON;
	MY.TRANSPARENT = ON;
	MY.ALPHA = 0;
	MY.BRIGHT = ON;
	MY.FACING = ON;
	MY.PASSABLE = ON;

	MY.FRAME = Random(6) + 1;

	MY.SCALE_X = 1.2;
	MY.SCALE_Y = MY.SCALE_X;
	MY.SCALE_Z = MY.SCALE_X;

	WHILE (YOU) {
		MY.ALPHA = MIN(100, MY.ALPHA + 16 * TIME);

		MY.FRAME += 0.5 * TIME;
		IF (MY.FRAME > 7) { MY.FRAME -= 6; }
	WAIT (1);
	}

	WHILE (MY.ALPHA > 0) {
		MY.ALPHA = MAX(0, MY.ALPHA - 8 * TIME);

		MY.FRAME += 0.5 * TIME;
		IF (MY.FRAME > 7) { MY.FRAME -= 6; }

	WAIT (1);
	}

	ENT_REMOVE(ME);
	RETURN;
}

function fire()
{
var position;

	VEC_SET(position.X, victim.X);

	FNCT_Fast_Flash_White();
	WAITT (2);

	ME = ENT_CREATELOCAL("fire_spirit.bmp", position.X, NULL);
	ENT_CREATELOCAL("flames+6.tga", position.X, EFKT_Flames);
	ENT_CREATELOCAL("flames+6.tga", position.X, EFKT_Flames);

	MY.Z = -MY.MIN_Z * 1.2;
	MY.LIGHT = ON;
	MY.RED   = 255;
	MY.GREEN = 255;
	MY.BLUE  = 255;

	MY.UNLIT = ON;
	MY.AMBIENT = 100;
	MY.OVERLAY = ON;
	MY.TRANSPARENT = ON;
	MY.ALPHA = 100;
	MY.BRIGHT = ON;
	MY.FACING = ON;
	MY.PASSABLE = ON;

	WHILE (MY.RED > 0) {
		MY.RED = MAX(0, MY.RED - 24 * TIME);
		MY.GREEN = MY.RED;
		MY.BLUE  = MY.RED;
	WAIT (1);
	}

	EFKT_Explosion(0, position.X);
	EFKT_Explosion(6, position.X);
	EFKT_Explosion(12, position.X);
	EFKT_Explosion(20, position.X);
	EFKT_Explosion(28, position.X);

	WHILE (MY.ALPHA > 0) {
		MY.ALPHA = MAX(0, MY.ALPHA - 12 * TIME);
	WAIT (1);
	}

	ENT_REMOVE(ME);
	RETURN;
}



function aggro()
{
	ME = ENT_CREATELOCAL("Aggro.tga", victim.X, NULL);
	object_to_camera(victim, 4);

	MY.ROLL = Random(360);

	MY.PASSABLE = ON;
	MY.BRIGHT = ON;	
	MY.TRANSPARENT = ON;
	MY.ALPHA = 100;
	MY.UNLIT = ON;
	MY.NOFOG = ON;
	MY.AMBIENT = 100;

	MY.SCALE_X = 0.2;

	WHILE (MY.ALPHA > 0) {
		MY.ALPHA -= 15 * TIME;

		MY.SCALE_X += 0.2 * TIME;
		MY.SCALE_Y = MY.SCALE_X;
		MY.SCALE_Z = MY.SCALE_X;

		MY.ROLL += 6 * TIME;
	WAIT (1);
	}

	ENT_REMOVE(ME);
	RETURN;
}


function revenge_leap()
{
	VEC_SET(TEMP.X, vector(MY.X, MY.Y, MY.Z + MY.MIN_Z * MY.SCALE_Y));

	FNCT_Camtramble();
	snd_play(explo, 100, 0);

	ent_createlocal("shock.mdl", TEMP.X, FNCT_Lightshock);
	ent_createlocal("smlstone.mdl", TEMP.X, FNCT_Small_Stones);
	ent_createlocal("smlstone.mdl", TEMP.X, FNCT_Small_Stones);
	Effect_local(EFKT_Dust_Init, 5, TEMP.X, NULLVECTOR);

	RETURN;
}


/////////////////////////////////////////////////////////////////
// Laser Inferno

bmap heat = <heat.tga>;
sound laserfire = <fire.wav>;

function Heat_Fader()
{
	MY.ALPHA = FSIN(MY.LIFESPAN * 5.625, 25);
}

function EFKT_Heat()
{
	MY.X += Random(16) - 8;
	MY.Y += Random(16) - 8;
	MY.Z += Random(16) - 8;

	MY.VEL_X = Random(1) - 0.5;
	MY.VEL_Y = Random(1) - 0.5;
	MY.VEL_Z = Random(1) - 0.5;

	MY.MOVE = ON;
	MY.SIZE = 50;
	MY.BMAP = heat;
	MY.BRIGHT = ON;
	MY.ALPHA = 0;
	MY.LIFESPAN = 32;
	MY.FUNCTION = Heat_Fader;
}

function FNCT_HeatGround()
{
	MY.PASSABLE = ON;
	MY.BRIGHT = ON;	
	MY.TRANSPARENT = ON;
	MY.ALPHA = 250;
	MY.UNLIT = ON;
	MY.NOFOG = ON;
	MY.AMBIENT = 100;
	my.oriented = on;
	my.scale_x = 1.2;
	my.scale_y = my.scale_x;
	my.scale_z = my.scale_x;

	my.tilt = 90;
	my.roll = Random(360);
	my.z = 1;

	while (my.alpha > 0) {
		my.alpha -= 10 * time;
	wait(1);
	}

	ent_remove(me);
	return;
}

// Ice flare
function FNCT_Laserflare(&Position)
{
	ME = ENT_CREATELOCAL("Energyflare.tga", Position.X, NULL);

	MY.PASSABLE = ON;
	MY.FACING = ON;
	MY.TRANSPARENT = ON;
	MY.BRIGHT = ON;
	MY.ALPHA = 0;
	MY.UNLIT = ON;
	MY.NOFOG = ON;
	MY.AMBIENT = 100;
	MY.ROLL = 45;
	MY.SCALE_X = 0;
	MY.SCALE_Y = 0;

	WHILE (MY.ALPHA < 100) {
		MY.ALPHA += 50 * TIME;
		MY.SCALE_X += 0.25 * TIME;
		MY.SCALE_Y = MY.SCALE_X;
	WAIT (1);
	}

	MY.SKILL1 = 0.5;
	WHILE (MY.SKILL1 < 2.5) {
		MY.SCALE_X = MY.SKILL1 + FSIN(total_ticks * 83, 0.5) * FCOS(total_ticks * 57, 0.5);
		MY.SCALE_Y = MY.SCALE_X;

		MY.SKILL1 += 0.06 * TIME;
	WAIT (1);
	}

	WHILE (MY.SCALE_X > 0) {
		MY.SCALE_X = MAX(0, MY.SCALE_X - 0.1 * TIME);
		MY.SCALE_Y = MY.SCALE_X;
	WAIT (1);
	}

	ENT_REMOVE(ME);
	return;
}

function FNCT_Laser()
{
	MY.PASSABLE = ON;
	MY.BRIGHT = ON;	
	MY.TRANSPARENT = ON;
	MY.ALPHA = 200;
	MY.UNLIT = ON;
	MY.NOFOG = ON;
	MY.AMBIENT = 100;

	temp.x = Random(150) - 75;
	temp.y = Random(150) - 75;
	temp.z = -150;

	vec_to_angle(my.pan, temp.x);
	vec_add(temp.x, my.x);
	temp.z = -1;

	trace_mode = ignore_passable + ignore_passents + ignore_me + ignore_sprites;
	vec_scale(my.scale_x, trace(my.x, temp.x));

	ent_createlocal("heat.tga", target.x, FNCT_HeatGround);
	ent_createlocal("shock.mdl", target.x, FNCT_Lightningshock);

	snd_play(laserfire, 100, 0);

	while (my.alpha > 0) {
		my.alpha -= 20 * time;

		my.scale_y = 0.6 + fsin(total_ticks * 122, 0.5) * fcos(total_ticks * 53, 0.2);
		my.scale_z = my.scale_y;
	wait(1);
	}

	ent_remove(me);
	return;
}

function FNCT_HeatBall(&Position)
{
var timer;
var temp_pos;

	snd_play(chaos, 100, 0);

	vec_set(temp.x, Position.x);
	temp.z = 150;

	FNCT_Laserflare(temp.x);

	vec_set(temp_pos.x, temp.x);

	while (timer < 16) {
		timer += 1;
		Effect_local(EFKT_Heat, 1, temp_pos.x, nullvector);
		if ((timer > 6) && (timer < 14)) {
			ent_createlocal("laser.mdl", temp_pos.x, FNCT_Laser);
			if (Int(Random(3))) {
				FNCT_Fast_Flash_white();
				FNCT_Camtramble();
			}
		}
	waitt(3);
	}

	return;
}

function laserInferno()
{
	FNCT_HeatBall(victim.x);
}


/////////////////////////////////////////////////////////////////
// summon ice

sound ice_summon = <ice_summon.wav>;

function FNCT_IceSpike(&Position)
{
var temp_pos;
var move_dir;

	vec_set(temp_pos.x, Position.x);
	vec_diff(move_dir.x, Position.x, my.x);
	move_dir.x += Random(32) - 16;
	move_dir.y += Random(32) - 16;
	move_dir.z += Random(32) - 16;
	vec_normalize(move_dir.x, 32);

	me = ent_createlocal("ice_spike+4.bmp", my.x, null);

	my.scale_x = 0.25;
	my.scale_y = my.scale_x;
	my.scale_z = my.scale_x;

	my.light = on;
	my.red   = 64;
	my.green = my.red;
	my.blue  = my.red;

	my.roll = 43 + Random(4);

	MY.UNLIT = ON;
	MY.AMBIENT = 100;
	MY.OVERLAY = ON;
	MY.TRANSPARENT = ON;
	MY.ALPHA = 100;
	MY.FACING = ON;
	MY.PASSABLE = ON;

	while (1) {
		vec_set(temp.x, move_dir.x);
		vec_scale(temp.x, time);

		vec_add(my.x, temp.x);
		temp = vec_dist(my.x, temp_pos.x);
		if ((temp < 32) || (temp > 300)) { break; }
	wait(1);
	}

	snd_play(laserfire, 100, 0);
	FNCT_Camtramble();
	FNCT_Fast_Flash_White();
	Effect_local(EFKT_Icedust_Init, 2, MY.X, NULLVECTOR);
	ent_createlocal("iceshard.mdl", my.x, FNCT_Iceshard);
	ent_createlocal("iceshard.mdl", my.x, FNCT_Iceshard);
	ent_createlocal("iceshard.mdl", my.x, FNCT_Iceshard);

	while (my.frame < 5) {
		my.frame += 0.5 * time;
	wait(1);
	}

	ent_remove(me);
	return;
}

function summonIce()
{
var position;

	vec_set(position.X, victim.X);

	snd_play(ice_summon, 100, 0);

	FNCT_Fast_Flash_White();
	WAITT (2);

	me = ent_createlocal("ice_spirit.bmp", position.X, null);

	MY.Z = -MY.MIN_Z * 1.2;
	MY.LIGHT = ON;
	MY.RED   = 255;
	MY.GREEN = 255;
	MY.BLUE  = 255;
	my.scale_x = 0.75;
	my.scale_y = my.scale_x;
	my.scale_z = my.scale_x;

	MY.UNLIT = ON;
	MY.AMBIENT = 100;
	MY.OVERLAY = ON;
	MY.TRANSPARENT = ON;
	MY.ALPHA = 100;
	MY.FACING = ON;
	MY.PASSABLE = ON;

	while (my.red > 64) {
		my.x = 0;
		my.y = 192;
		my.z = 192;
		vec_rotate(my.x, vector(camera.pan, 0, 0));
		vec_add(my.x, position.x);

		MY.RED = MAX(64, MY.RED - 16 * TIME);
		MY.GREEN = MY.RED;
		MY.BLUE  = MY.RED;

		my.skill1 += time;
		if (my.skill1 > 3) {
			my.skill1 = 0;
			vec_set(temp.x, position.x);
			FNCT_IceSpike(temp.x);
		}

		my.skill 2 -= time;
		if (my.skill2 < 0) {
			my.skill2 += 1;
			Effect_local(EFKT_Charge_Init, 1, my.x, nullvector);
		}
	wait(1);
	}

	while (my.alpha > 0) {
		my.x = 0;
		my.y = 192;
		my.z = 192;
		vec_rotate(my.x, vector(camera.pan, 0, 0));
		vec_add(my.x, position.x);

		my.alpha -= 10 * time;
	wait(1);
	}

	ent_remove(me);
	return;
}

/////////////////////////////////////////////////////////////////
// meteor

function meteorschweif()
{
	proc_late();

	my.transparent = on;
	my.alpha = 100;

	vec_scale(my.scale_x, 1.5);

	my.material = MAT_Doublealpha_fluid_2;

	while (your.invisible == off) {
		vec_set(my.x, your.x);
		my.pan = camera.pan - 90;
		my.tilt = 225;

		my.skill43 -= 48 * time;
		mat_identity(MAT_Doublealpha_fluid_2.matrix);
		MAT_Doublealpha_fluid_2.matrix23 = floatd(my.skill43, 255);
	wait(1);
	}

	ent_remove(me);
	return;
}
sound big_shot = <big_shot.wav>;
function meteor()
{
var position;
var move_dir;

	vec_set(position.x, victim.x);
	position.z += victim.min_z;

	snd_play(big_shot, 100, 0);

	me = ent_createlocal("smlstone.mdl", nullvector, null);

	vec_scale(my.scale_x, 5);

	my.skill1 = Random(60) - 30;
	my.skill2 = Random(60) - 30;

	// Startup position
	my.x = 0;
	my.y = -672;
	my.z = 672;
	vec_rotate(my.x, vector(camera.pan, 0, 0));
	vec_add(my.x, position.x);

	ent_createlocal("meteorschweif.mdl", my.x, meteorschweif);

	// Move direction
	vec_diff(move_dir.x, position.x, my.x);
	move_dir.x += Random(32) - 16;
	move_dir.y += Random(32) - 16;
	vec_normalize(move_dir.x, 40);

	while (my.z > 0) {
		ang_rotate(my.pan, vector(my.skill1 * time, my.skill2 * time, 0));

		vec_set(temp.x, move_dir.x);
		vec_scale(temp.x, time);

		vec_add(my.x, temp.x);
	wait(1);
	}

	my.z = 1;

	snd_play(explo, 100, 0);

	FNCT_Energy_Flash(MY.X, 50, ME, 2);
	FNCT_Energy_Flash(MY.X, 50, ME, 2);
	FNCT_Energy_Flash(MY.X, 50, ME, 2);

	FNCT_Camtramble();
	FNCT_Fast_Flash_White();

	ent_createlocal("smlstone.mdl", my.x, FNCT_Small_Stones);
	ent_createlocal("smlstone.mdl", my.x, FNCT_Small_Stones);
	ent_createlocal("smlstone.mdl", my.x, FNCT_Small_Stones);
	ent_createlocal("smlstone.mdl", my.x, FNCT_Small_Stones);
	ent_createlocal("smlstone.mdl", my.x, FNCT_Small_Stones);
	ent_createlocal("smlstone.mdl", my.x, FNCT_Small_Stones);
	ent_createlocal("shock.mdl", my.x, FNCT_Lightningshock);

//	Effect_local(EFKT_Lightdust_Init, 2, my.x, nullvector);
	Effect_local(EFKT_Dust_Init, 8, my.x, nullvector);

	my.invisible = on;

	waitt(40);

	ent_remove(me);
	return;
}


/////////////////////////////////////////////////////////////////
// fire rain

function fireball(&position)
{
var target_pos;
var move_dir;
var impact;

	vec_set(target_pos.x, position.x);

	me = ent_createlocal("fireball+12.tga", target_pos.x, null);
	you = ent_createlocal("fireball+12.tga", target_pos.x, null);

	my.z -= my.min_z;
	target_pos.z = my.z;

	move_dir.x = 0;
	move_dir.y = -300;
	move_dir.z = 300;
	vec_rotate(move_dir.x, vector(camera.pan, 0, 0));

	vec_add(my.x, move_dir.x);
	vec_set(your.x, my.x);

	MY.LIGHT = ON;
	MY.RED   = 255;
	MY.GREEN = 255;
	MY.BLUE  = 255;

	MY.UNLIT = ON;
	MY.AMBIENT = 100;
	MY.OVERLAY = ON;
	MY.TRANSPARENT = ON;
	MY.ALPHA = 100;
	MY.FACING = ON;
	MY.PASSABLE = ON;

	your.LIGHT = ON;
	your.RED   = 255;
	your.GREEN = 255;
	your.BLUE  = 255;

	your.UNLIT = ON;
	your.AMBIENT = 100;
	your.OVERLAY = ON;
	your.TRANSPARENT = ON;
	your.ALPHA = 100;
	your.FACING = ON;
	your.PASSABLE = ON;

	snd_play(big_shot, 100, 0);

	while (my.frame < 13) {
		if (my.z > target_pos.z) {
			temp.x = (move_dir.x / 20) * time;
			temp.y = (move_dir.y / 20) * time;
			temp.z = (move_dir.z / 20) * time;

			vec_sub(my.x, temp.x);
			vec_set(your.x, my.x);
		}
		my.z = max(target_pos.z, my.z);

		my.frame += 0.3 * time;
		your.frame = my.frame - 0.5;

		if (my.frame > 7) {
			if (impact == 0) {
				impact = 1;

				snd_play(explo, 100, 0);
				FNCT_Energy_Flash(MY.X, 50, ME, 2);
				FNCT_Energy_Flash(MY.X, 50, ME, 2);
				FNCT_Energy_Flash(MY.X, 50, ME, 2);

				ent_createlocal("smlstone.mdl", my.x, FNCT_Small_Stones);
				ent_createlocal("smlstone.mdl", my.x, FNCT_Small_Stones);
				ent_createlocal("smlstone.mdl", my.x, FNCT_Small_Stones);
				ent_createlocal("smlstone.mdl", my.x, FNCT_Small_Stones);

				FNCT_Camtramble();
				FNCT_Fast_Flash_White();
			}

			my.alpha -= 5 * time;
			your.alpha = my.alpha;
		}

		impact[1] += time;
		if (impact[1] > 2) {
			impact[1] -= 2;
			Effect_local(EFKT_Explosion_Init, 1, my.x, nullvector);
		}

	wait(1);
	}

	ent_remove(me);
	ent_remove(you);
	return;
}

function fire_rain()
{
var position;

	vec_set(position.x, victim.x);
	position.z += victim.min_z;

	vec_set(temp.x, position.x);

	fireball(temp);

	return;
}


/////////////////////////////////////////////////////////////////
// earthquake (vulcano)

function FNCT_Big_Stones()
{
	MY.X += Random(200) - 100;
	MY.Y += Random(200) - 100;
	MY.Z += 600 + Random(100);

	MY.PAN  = Random(360);
	MY.TILT = Random(360);

	MY.AMBIENT = -50;

	vec_scale(my.scale_x, 4);

	while (my.z > 0) {
		MY.PAN  += 20 * TIME;
		MY.TILT += 20 * TIME;

		my.z -= 30 * time;
	wait(1);
	}

	my.z = 0;
	snd_play(explo, 100, 0);
	FNCT_Camtramble();
//	FNCT_Fast_Flash_White();

	ent_createlocal("smlstone.mdl", my.x, FNCT_Small_Stones);
	ent_createlocal("smlstone.mdl", my.x, FNCT_Small_Stones);
	ent_createlocal("smlstone.mdl", my.x, FNCT_Small_Stones);
	ent_createlocal("smlstone.mdl", my.x, FNCT_Small_Stones);
	ent_createlocal("smlstone.mdl", my.x, FNCT_Small_Stones);
	ent_createlocal("smlstone.mdl", my.x, FNCT_Small_Stones);
	ent_createlocal("shock.mdl", my.x, FNCT_Lightningshock);

	ent_createlocal("flames+6.tga", my.x, EFKT_Flames);
	ent_createlocal("flames+6.tga", my.x, EFKT_Flames);

	my.invisible = on;
	waitt(8);

	ent_remove(me);
	return;
}

function vulcano()
{
var position;
var timer;

	vec_set(position.x, victim.x);

	snd_play(earthquake, 100, 0);
	FNCT_Camquake();

	timer = 10;
	while (timer > 0) {
		ent_createlocal("smlstone.mdl", position.x, FNCT_Big_Stones);
		timer -= 1;
	waitt(6);
	}

	return;
}


/////////////////////////////////////////////////////////////////
// Photon Strike

function FNCT_Photonshot()
{
var position;

	vec_set(position.x, my.x);

	position.x += Random(160) - 80;
	position.y += Random(160) - 80;

	me = ent_createlocal("blast+11.tga", position.x, null);

	MY.UNLIT = ON;
	MY.AMBIENT = 100;
	MY.OVERLAY = ON;
	MY.TRANSPARENT = ON;
	MY.ALPHA = 100;
	my.bright = on;
	MY.FACING = ON;
	MY.PASSABLE = ON;

	while (my.frame < 5) {
		my.frame += 0.5 * time;
		my.z = 500 - (100 * my.frame) - my.min_z;
	wait(1);
	}

	my.z = -my.min_z;

	snd_play(explo, 100, 0);
	FNCT_Photonstorm(1);
	FNCT_Fast_Flash_White();
	FNCT_Camtramble();
	ent_createlocal("smlstone.mdl", Position.x, FNCT_Small_Stones);
	ent_createlocal("smlstone.mdl", Position.x, FNCT_Small_Stones);
	ent_createlocal("smlstone.mdl", Position.x, FNCT_Small_Stones);
	ent_createlocal("smlstone.mdl", Position.x, FNCT_Small_Stones);

	while (my.frame < 12) {
		my.frame += 0.5 * time;
	wait(1);
	}

	ent_remove(me);
	return;
}

function FNCT_Photonstorm(colorID)
{
var position;

	vec_set(position.x, my.x);

	if (colorID == 1) {
		me = ent_createlocal("bluestorm+9.tga", position.x, null);
		you = ent_createlocal("bluestorm+9.tga", position.x, null);
	} else {
		me = ent_createlocal("firestorm+9.tga", position.x, null);
		you = ent_createlocal("firestorm+9.tga", position.x, null);
	}

	vec_scale(my.scale_x, 0.75);
	vec_set(your.scale_y, my.scale_x);

	my.z = -my.min_z * my.scale_z;
	your.z = -your.min_z * your.scale_z;

	MY.UNLIT = ON;
	MY.AMBIENT = 100;
	MY.OVERLAY = ON;
	MY.TRANSPARENT = ON;
	MY.ALPHA = 0;
	my.bright = on;
	MY.FACING = ON;
	MY.PASSABLE = ON;

	your.UNLIT = ON;
	your.AMBIENT = 100;
	your.OVERLAY = ON;
	your.TRANSPARENT = ON;
	your.ALPHA = 0;
	your.bright = on;
	your.FACING = ON;
	your.PASSABLE = ON;

	while (my.frame < 7) {
		my.alpha = min(100, my.alpha + 16 * time);
		your.alpha = my.alpha;

		my.frame += 0.75 * time;
		your.frame = my.frame - 0.5;
	wait(1);
	}

	while (my.alpha > 0) {
		my.alpha = max(0, my.alpha - 15 * time);
		your.alpha = my.alpha;

		my.frame += 0.75 * time;
		your.frame = my.frame - 0.5;
	wait(1);
	}

	ent_remove(me);
	ent_remove(you);
	return;
}

sound gaja = <gaja.wav>;
function FNCT_Photonstrike()
{
var position;

	vec_set(position.x, victim.x);
	position.z = 160;

	snd_play(gaja, 100, 0);

	FNCT_Fast_Flash_White();
	waitt(2);

	me = ent_createlocal("holy_spirit.bmp", position.x, null);

	MY.LIGHT = ON;
	MY.RED   = 64;
	MY.GREEN = 64;
	MY.BLUE  = 64;
	my.scale_x = 0.75;
	my.scale_y = my.scale_x;
	my.scale_z = my.scale_x;

	MY.UNLIT = ON;
	MY.AMBIENT = 100;
	MY.OVERLAY = ON;
	MY.TRANSPARENT = ON;
	MY.ALPHA = 100;
	MY.FACING = ON;
	MY.PASSABLE = ON;

	while (my.red > 16) {
		my.z += time;
		my.red = max(16, my.red - 2 * time);
		my.green = my.red;
		my.blue  = my.red;

		my.skill1 -= time;
		if (my.skill1 < 0) {
			my.skill1 += 6;
			FNCT_Photonshot();
		}

		my.skill 2 -= time;
		if (my.skill2 < 0) {
			my.skill2 += 1;
			Effect_local(EFKT_Charge_Init, 1, my.x, nullvector);
		}
	wait(1);
	}

	while (my.alpha > 0) {
		my.z += time;
		my.alpha -= 10 * time;
	wait(1);
	}

	ent_remove(me);
	return;
}

function photon()
{
	FNCT_Photonstrike();

	return;
}


///////////////////////////////////////////////////////////////////
// Fire Storm


function FNCT_Fire_Storm()
{
var position;

	me = victim;
	vec_set(position.x, victim.x);
	position.z += victim.min_z;

	snd_play(explo, 100, 0);
	FNCT_Photonstorm(2);
	FNCT_Fast_Flash_White();
	FNCT_Camtramble();
	ent_createlocal("shock.mdl", position.x, FNCT_Lightningshock);
	ent_createlocal("smlstone.mdl", position.x, FNCT_Small_Stones);
	ent_createlocal("smlstone.mdl", position.x, FNCT_Small_Stones);
	ent_createlocal("smlstone.mdl", position.x, FNCT_Small_Stones);

	return;
}

function fire_storm()
{
	FNCT_Fire_Storm();

	return;
}

//function ignition()
//{
//	victim = player;
//	fire_storm();
//}
//on_h = ignition;