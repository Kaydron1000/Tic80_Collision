-- TIC-80 API Definition File
-- This file documents all TIC-80 functions for IntelliSense and reference
-- Version: TIC-80 v1.1

---@meta

-- GRAPHICS FUNCTIONS

---Draw a filled circle
---@param x number center x coordinate
---@param y number center y coordinate
---@param radius number circle radius
---@param color number color index (0-15)
function circ(x, y, radius, color) end

---Draw a circle border
---@param x number center x coordinate
---@param y number center y coordinate
---@param radius number circle radius
---@param color number color index (0-15)
function circb(x, y, radius, color) end

---Clear the screen
---@param color? number color index (0-15), default 0
function cls(color) end

---Copy a memory region
---@param toaddr number destination address
---@param fromaddr number source address
---@param length number number of bytes to copy
function memcpy(toaddr, fromaddr, length) end

---Set a memory region to a value
---@param addr number destination address
---@param value number byte value to set (0-255)
---@param length number number of bytes to set
function memset(addr, value, length) end

---Draw a line
---@param x0 number start x coordinate
---@param y0 number start y coordinate
---@param x1 number end x coordinate
---@param y1 number end y coordinate
---@param color number color index (0-15)
function line(x0, y0, x1, y1, color) end

---Draw a map region
---@param x? number x coordinate, default 0
---@param y? number y coordinate, default 0
---@param w? number width in tiles, default 30
---@param h? number height in tiles, default 17
---@param sx? number screen x, default 0
---@param sy? number screen y, default 0
---@param colorkey? number|number[] transparent color(s), default -1 (none)
---@param scale? number scale, default 1
---@param remap? function(tile, x, y) remapping callback
function map(x, y, w, h, sx, sy, colorkey, scale, remap) end

---Get a tile from the map
---@param x number tile x coordinate
---@param y number tile y coordinate
---@return number tile tile ID
function mget(x, y) end

---Set a tile in the map
---@param x number tile x coordinate
---@param y number tile y coordinate
---@param tile number tile ID to set
function mset(x, y, tile) end

---Read a byte from memory
---@param addr number memory address (0-98303)
---@return number value byte value (0-255)
function peek(addr) end

---Read a 4-bit value from memory
---@param addr number memory address in 4-bit units
---@return number value 4-bit value (0-15)
function peek4(addr) end

---Read a 2-bit value from memory
---@param addr number memory address in 2-bit units
---@return number value 2-bit value (0-3)
function peek2(addr) end

---Read a 1-bit value from memory
---@param addr number memory address in bit units
---@return number value 1-bit value (0-1)
function peek1(addr) end

---Get a pixel color
---@param x number x coordinate
---@param y number y coordinate
---@return number color color index (0-15)
function pix(x, y) end

---Set a pixel color (or get if only x,y provided)
---@param x number x coordinate
---@param y number y coordinate
---@param color? number color index (0-15)
---@return number color current/previous color
function pix(x, y, color) end

---Write a byte to memory
---@param addr number memory address (0-98303)
---@param value number byte value to write (0-255)
function poke(addr, value) end

---Write a 4-bit value to memory
---@param addr number memory address in 4-bit units
---@param value number 4-bit value (0-15)
function poke4(addr, value) end

---Write a 2-bit value to memory
---@param addr number memory address in 2-bit units
---@param value number 2-bit value (0-3)
function poke2(addr, value) end

---Write a 1-bit value to memory
---@param addr number memory address in bit units
---@param value number 1-bit value (0-1)
function poke1(addr, value) end

---Print text to screen
---@param text string text to print
---@param x? number x coordinate, default 0
---@param y? number y coordinate, default 0
---@param color? number color index (0-15), default 15
---@param fixed? boolean use fixed width font, default false
---@param scale? number text scale, default 1
---@param smallfont? boolean use small font (5x5), default false
---@return number width text width in pixels
function print(text, x, y, color, fixed, scale, smallfont) end

---Draw a filled rectangle
---@param x number x coordinate
---@param y number y coordinate
---@param w number width
---@param h number height
---@param color number color index (0-15)
function rect(x, y, w, h, color) end

---Draw a rectangle border
---@param x number x coordinate
---@param y number y coordinate
---@param w number width
---@param h number height
---@param color number color index (0-15)
function rectb(x, y, w, h, color) end

---Draw a sprite
---@param id number sprite ID (0-511)
---@param x number x coordinate
---@param y number y coordinate
---@param colorkey? number|number[] transparent color(s), default -1 (none)
---@param scale? number scale, default 1
---@param flip? number flip (0=none, 1=horizontal, 2=vertical, 3=both), default 0
---@param rotate? number rotation (0=0°, 1=90°, 2=180°, 3=270°), default 0
---@param w? number width in sprites, default 1
---@param h? number height in sprites, default 1
function spr(id, x, y, colorkey, scale, flip, rotate, w, h) end

---Draw a filled triangle
---@param x1 number first vertex x
---@param y1 number first vertex y
---@param x2 number second vertex x
---@param y2 number second vertex y
---@param x3 number third vertex x
---@param y3 number third vertex y
---@param color number color index (0-15)
function tri(x1, y1, x2, y2, x3, y3, color) end

---Draw a triangle border
---@param x1 number first vertex x
---@param y1 number first vertex y
---@param x2 number second vertex x
---@param y2 number second vertex y
---@param x3 number third vertex x
---@param y3 number third vertex y
---@param color number color index (0-15)
function trib(x1, y1, x2, y2, x3, y3, color) end

---Draw a textured triangle
---@param x1 number first vertex x
---@param y1 number first vertex y
---@param x2 number second vertex x
---@param y2 number second vertex y
---@param x3 number third vertex x
---@param y3 number third vertex y
---@param u1 number first texture u coordinate
---@param v1 number first texture v coordinate
---@param u2 number second texture u coordinate
---@param v2 number second texture v coordinate
---@param u3 number third texture u coordinate
---@param v3 number third texture v coordinate
---@param texsrc? number texture source (0=SCREEN, 1=SPRITES), default 0
---@param chromakey? number transparent color, default -1 (none)
---@param z1? number first vertex depth, default 0
---@param z2? number second vertex depth, default 0
---@param z3? number third vertex depth, default 0
function ttri(x1, y1, x2, y2, x3, y3, u1, v1, u2, v2, u3, v3, texsrc, chromakey, z1, z2, z3) end

-- INPUT FUNCTIONS

---Get button state
---@param id? number button ID (0-31), default checks all
---@return boolean pressed true if button is pressed
function btn(id) end

---Get button pressed this frame
---@param id? number button ID (0-31), default checks all
---@return boolean pressed true if button was just pressed
function btnp(id) end

---Get button pressed with repeat
---@param id? number button ID (0-31)
---@param hold? number frames to hold before repeat, default 48
---@param period? number frames between repeats, default 8
---@return boolean pressed true if button triggers
function btnp(id, hold, period) end

---Get keyboard key state
---@param code? number key code, default checks any key
---@return boolean pressed true if key is pressed
function key(code) end

---Get keyboard key pressed this frame
---@param code? number key code, default checks any key
---@return boolean pressed true if key was just pressed
function keyp(code) end

---Get keyboard key pressed with repeat
---@param code? number key code
---@param hold? number frames to hold before repeat, default 48
---@param period? number frames between repeats, default 8
---@return boolean pressed true if key triggers
function keyp(code, hold, period) end

---Get mouse state
---@return number x, number y, boolean left, boolean middle, boolean right, number scrollx, number scrolly
function mouse() end

-- AUDIO FUNCTIONS

---Play music track
---@param track? number track number (0-7), -1 to stop, default -1
---@param frame? number start frame, default 0
---@param row? number start row, default 0
---@param loop? boolean loop playback, default true
---@param sustain? boolean sustain notes, default false
---@param tempo? number tempo (-4 to 3), default 0
---@param speed? number speed (-4 to 3), default 0
function music(track, frame, row, loop, sustain, tempo, speed) end

---Play sound effect
---@param id number sound ID (0-63), -1 to stop channel
---@param note? number|string note (0-95 or "C-0" to "B-7"), default 0
---@param duration? number duration in frames, default -1 (until end)
---@param channel? number channel (0-3), default 0
---@param volume? number volume (0-15), default 15
---@param speed? number speed (0-255), default 0
function sfx(id, note, duration, channel, volume, speed) end

-- TIMING FUNCTIONS

---Get current time
---@return number time time in milliseconds since start
function time() end

---Get timestamp
---@return number timestamp Unix timestamp in seconds
function tstamp() end

---Exit the program
function exit() end

---Reset the cartridge
function reset() end

-- SYSTEM FUNCTIONS

---Trace output to console
---@param message any message to print
---@param color? number text color (0-15), default 15
function trace(message, color) end

---Get/set palette map
---@param index? number color index (0-15)
---@param value? number palette value to set
---@return number value current palette value
function pmem(index, value) end

---Get font character
---@param char string character to get
---@param x number x coordinate to draw at
---@param y number y coordinate to draw at
---@param colorkey? number transparent color, default -1
---@param w? number character width in pixels, default 8
---@param h? number character height in pixels, default 8
---@param fixed? boolean use fixed width, default false
---@param scale? number scale factor, default 1
---@return number width character width in pixels
function font(char, x, y, colorkey, w, h, fixed, scale) end

---Synchronize with screen refresh
---@param mask? number sprite layer mask, default 0
---@param bank? number sprite bank (0-1), default 0
---@param keepPalette? boolean keep palette changes, default false
---@return number bank current sprite bank
function sync(mask, bank, keepPalette) end

-- CALLBACK FUNCTIONS (to be implemented by user)

---Main update callback, called 60 times per second
function TIC() end

---Screen scanline callback
---@param line number current scanline (0-135)
function SCN(line) end

---Overlay callback, called after TIC()
function OVR() end

---Boot sequence callback
function BOOT() end

---Menu item callback
---@param index number menu item index
function MENU(index) end

-- GLOBAL VARIABLES

---Current frame counter
---@type number
_G.FRAME = 0
