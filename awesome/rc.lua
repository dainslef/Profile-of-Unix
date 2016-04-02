-- Load library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")



-- {{{ Init
---- Custom command
-- awful.util.spawn("synclient VertScrollDelta=-66") -- Mate-settings-daemon offer the touchpad settings

---- Function to build the titlebar
function create_titlebar(c)

	-- Widgets that are aligned to the left
	local left_layout = wibox.layout.fixed.horizontal()
	left_layout:add(awful.titlebar.widget.iconwidget(c))
	left_layout:buttons(buttons)

	-- Widgets that are aligned to the right
	local right_layout = wibox.layout.fixed.horizontal()
	right_layout:add(awful.titlebar.widget.floatingbutton(c))
	right_layout:add(awful.titlebar.widget.maximizedbutton(c))
	right_layout:add(awful.titlebar.widget.stickybutton(c))
	right_layout:add(awful.titlebar.widget.ontopbutton(c))
	right_layout:add(awful.titlebar.widget.closebutton(c))

	-- The title goes in the middle
	local middle_layout = wibox.layout.flex.horizontal()
	local title = awful.titlebar.widget.titlewidget(c)
	title:set_align("center")
	middle_layout:add(title)
	middle_layout:buttons(buttons)

	-- Now bring it all together
	local layout = wibox.layout.align.horizontal()
	layout:set_left(left_layout)
	layout:set_right(right_layout)
	layout:set_middle(middle_layout)

	awful.titlebar(c):set_widget(layout)

end
-- }}}



-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors
	})
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		-- Make sure we don't go into an endless error loop
		if in_error then return end
		in_error = true

		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = err
		})
		in_error = false
	end)
end
-- }}}



-- {{{ Variable definitions
---- Use theme
beautiful.init("/usr/share/awesome/themes/zenburn/theme.lua")

---- Custom theme settings
-- theme.border_width = 4
theme.font = "Dejavu Sans 9"
theme.bg_normal = "#3F3F3FAA" 
theme.bg_focus = "#1E2320AA"
theme.taglist_bg_focus = "#666666AA"

---- This is used later as the default terminal and editor to run
mail = "thunderbird"
terminal = "mate-terminal"
browser = "google-chrome-stable"
dictionary = "stardict"
file_manager = "caja"

editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

---- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
	awful.layout.suit.magnifier,
	-- awful.layout.suit.floating,
	-- awful.layout.suit.tile,
	-- awful.layout.suit.tile.left,
	awful.layout.suit.tile.bottom,
	-- awful.layout.suit.tile.top,
	-- awful.layout.suit.fair,
	-- awful.layout.suit.fair.horizontal,
	awful.layout.suit.spiral,
	-- awful.layout.suit.spiral.dwindle,
	-- awful.layout.suit.max,
	-- awful.layout.suit.max.fullscreen
}
-- }}}



---- Load auto run apps.
do
	function run_once(prg)
		awful.util.spawn_with_shell("pgrep -u $USER -x " .. prg .. " || (" .. prg .. ")")
	end

	local auto_run_list =
	{
		"fcitx", -- Use input method
		"nm-applet", -- Show network status
		"xcompmgr", -- For transparent support
		"blueman-applet", -- Use bluetooth
		"mate-power-manager", -- Show power and set backlights
		-- "mate-screensaver", -- Lock screen need to load it first
		"light-locker", -- Lock screen need to load it first
		"/usr/lib/mate-settings-daemon/mate-settings-daemon", -- For keyboard binding support
		"/usr/lib/mate-polkit/polkit-mate-authentication-agent-1",
		"mate-volume-control-applet"
	}

	for _, cmd in pairs(auto_run_list) do
		run_once(cmd)
	end
end



-- {{{ Wallpaper
if beautiful.wallpaper then
	for s = 1, screen.count() do
		gears.wallpaper.maximized("/home/dainslef/Pictures/EVA.png", s, true)
	end
end
-- }}}



-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {
	names = { "Ⅰ", "Ⅱ", "Ⅲ", "Ⅳ" },
	layouts = { layouts[1], layouts[1], layouts[3], layouts[2] }
}
for s = 1, screen.count() do
	-- Each screen has its own tag table.
	tags[s] = awful.tag(tags.names, s, tags.layouts)
end
-- }}}



-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
	-- { "manual", terminal .. " -e man awesome" },
	-- { "edit config", editor_cmd .. " " .. awesome.conffile },
	{ "Restart", awesome.restart },
	{ "Quit", awesome.quit }
}

developmenu = {
	{ "QtCreator", "qtcreator" },
	{ "QtAssistant", "assistant-qt5" },
	{ "QtDesigner", "designer-qt5" },
	{ "Emacs", "emacs" },
	{ "GVIM", "gvim" }
}

toolsmenu = {
	{ "Terminal", terminal },
	{ "StarDict", dictionary },
	{ "GParted", "gparted" },
	{ "Disks", "gnome-disks" },
	{ "Monitor", "mate-system-monitor" }
}

mymainmenu = awful.menu({
	items = {
		{ "Awesome", myawesomemenu, beautiful.awesome_icon },
		{ "Develop", developmenu },
		{ "Tools", toolsmenu },
		{ "Mail", mail },
		{ "Files", file_manager },
		{ "Browser", browser }
	}
})

mylauncher = awful.widget.launcher({
	image = beautiful.awesome_icon,
	menu = mymainmenu
})

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}



-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock(" %a %b %d ☪ %H : %M ")

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
	awful.button({ }, 1, awful.tag.viewonly),
	awful.button({ modkey }, 1, awful.client.movetotag),
	awful.button({ }, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, awful.client.toggletag),
	awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
	awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
)
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
	awful.button({ }, 1, function(c)
			if c == client.focus then
				c.minimized = true
			else
				-- Without this, the following
				-- :isvisible() makes no sense
				c.minimized = false
				if not c:isvisible() then awful.tag.viewonly(c:tags()[1]) end
				-- This will also un-minimize
				-- the client, if needed
				client.focus = c
				c:raise()
			end
		end),
	awful.button({ }, 3, function()
			if instance then
				instance:hide()
				instance = nil
			else
				instance = awful.menu.clients({ theme = { width = 250 } })
			end
		end),
	awful.button({ }, 4, function()
			awful.client.focus.byidx(1)
			if client.focus then client.focus:raise() end
		end),
	awful.button({ }, 5, function()
			awful.client.focus.byidx(-1)
			if client.focus then client.focus:raise() end
		end)
)

for s = 1, screen.count() do
	-- Create a promptbox for each screen
	mypromptbox[s] = awful.widget.prompt()
	-- Create an imagebox widget which will contains an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	mylayoutbox[s] = awful.widget.layoutbox(s)
	mylayoutbox[s]:buttons(awful.util.table.join(
		awful.button({ }, 1, function() awful.layout.inc(layouts, 1) end),
		awful.button({ }, 3, function() awful.layout.inc(layouts, -1) end),
		awful.button({ }, 4, function() awful.layout.inc(layouts, 1) end),
		awful.button({ }, 5, function() awful.layout.inc(layouts, -1) end)
	))
	-- Create a taglist widget
	mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

	-- Create a tasklist widget
	mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

	-- Create the wibox
	mywibox[s] = awful.wibox({ position = "top", screen = s, height = 25 })

	-- Widgets that are aligned to the left
	local left_layout = wibox.layout.fixed.horizontal()
	-- left_layout:add(mylauncher)
	left_layout:add(mylayoutbox[s])
	left_layout:add(mytaglist[s])
	left_layout:add(mypromptbox[s])

	-- Widgets that are aligned to the right
	local right_layout = wibox.layout.fixed.horizontal()
	if s == 1 then right_layout:add(wibox.widget.systray()) end
	right_layout:add(mytextclock)
	-- right_layout:add(mylayoutbox[s])

	-- Now bring it all together (with the tasklist in the middle)
	local layout = wibox.layout.align.horizontal()
	layout:set_left(left_layout)
	layout:set_middle(mytasklist[s])
	layout:set_right(right_layout)

	mywibox[s]:set_widget(layout)
end
-- }}}



-- {{{ Mouse bindings
root.buttons(
	awful.util.table.join(
		awful.button({ }, 3, function() mymainmenu:toggle() end),
		awful.button({ }, 4, awful.tag.viewnext),
		awful.button({ }, 5, awful.tag.viewprev)
	)
)
-- }}}



-- {{{ Key bindings
globalkeys = awful.util.table.join(
	awful.key({ modkey }, "Left", awful.tag.viewprev),
	awful.key({ modkey }, "Right", awful.tag.viewnext),
	awful.key({ modkey }, "Escape", awful.tag.history.restore),

	awful.key({ modkey }, "j", function()
			awful.client.focus.byidx(1)
			if client.focus then client.focus:raise() end
		end),
	awful.key({ modkey }, "k", function()
			awful.client.focus.byidx(-1)
			if client.focus then client.focus:raise() end
		end),
	awful.key({ modkey }, "w", function() mymainmenu:show() end),

	-- Layout manipulation
	awful.key({ modkey, "Shift"  }, "j", function() awful.client.swap.byidx(1) end),
	awful.key({ modkey, "Shift"  }, "k", function() awful.client.swap.byidx( -1) end),
	awful.key({ modkey, "Control" }, "j", function() awful.screen.focus_relative( 1) end),
	awful.key({ modkey, "Control" }, "k", function() awful.screen.focus_relative(-1) end),
	awful.key({ modkey }, "u", awful.client.urgent.jumpto),
	awful.key({ modkey }, "Tab", function()
			awful.client.focus.history.previous()
			if client.focus then client.focus:raise() end
		end),

	-- Standard program
	awful.key({ modkey }, "Return", function() awful.util.spawn(terminal) end),
	awful.key({ modkey, "Control" }, "r", awesome.restart),
	awful.key({ modkey, "Shift"   }, "q", awesome.quit),

	awful.key({ modkey }, "l", function() awful.tag.incmwfact( 0.05) end),
	awful.key({ modkey }, "h", function() awful.tag.incmwfact(-0.05) end),
	awful.key({ modkey, "Shift" }, "h", function() awful.tag.incnmaster( 1) end),
	awful.key({ modkey, "Shift" }, "l", function() awful.tag.incnmaster(-1) end),
	awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol( 1) end),
	awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol(-1) end),

	awful.key({ modkey }, "space", function()
			awful.layout.inc(layouts, 1)
			naughty.notify({
				title = 'Layout Change',
				text = "The current layout is "..awful.layout.getname()..". ",
				timeout = 1
			})
		end),
	awful.key({ modkey, "Shift" }, "space", function()
			awful.layout.inc(layouts, -1)
			naughty.notify({
				title = 'Layout Change',
				text = "The current layout is "..awful.layout.getname()..". ",
				timeout = 1
			})
		end),

	-- Prompt
	awful.key({ modkey }, "r", function() mypromptbox[mouse.screen]:run() end),
	awful.key({ modkey }, "x", function()
			awful.prompt.run({ prompt = "Run Lua code: " },
			mypromptbox[mouse.screen].widget,
			awful.util.eval, nil,
			awful.util.getdir("cache") .. "/history_eval")
		end),

	-- Menubar
	awful.key({ modkey }, "p", function() menubar.show() end),

	---- Custom key bindings
	awful.key({ modkey, "Control" }, "l", function() awful.util.spawn("xdg-screensaver lock") end),
	awful.key({ modkey }, "b", function() awful.util.spawn(browser) end),
	awful.key({ modkey }, "d", function() awful.util.spawn(dictionary) end),
	-- awful.key({ }, "XF86AudioRaiseVolume", function() end),
	-- awful.key({ }, "XF86AudioLowerVolume", function() end),
	--[[
	awful.key({ }, "Power", function()
			os.execute("zenity --question --text 'Shut down?' && systemctl poweroff")
		end),
	]]
	awful.key({ modkey, "Control" }, "n", function()
			c_restore = awful.client.restore() -- Restore the minimize window and focus it
			if c_restore then awful.client.jumpto(c_restore) end
		end),
	awful.key({ }, "Print", function()
			awful.util.spawn("import -window root ~/Pictures/$(date -Iseconds).png") -- Use imagemagick tools
			naughty.notify({
				title = "Screen Shot",
				text = "Take the fullscreen screenshot success!\n"..
					"Screenshot saved in ~/Pictures."
			})
		end),
	awful.key({ modkey }, "Print", function()
			awful.util.spawn("import ~/Pictures/$(date -Iseconds).png")
			naughty.notify({
				title = "Screen Shot",
				text = "Please select window to take the screenshot...\n"..
					"Screenshot will be saved in ~/Pictures."
			})
		end)
)

clientkeys = awful.util.table.join(
	awful.key({ modkey }, "f", function(c) c.fullscreen = not c.fullscreen end),
	awful.key({ modkey, "Shift" }, "c", function(c) c:kill() end),
	awful.key({ modkey, "Control" }, "space",
		function(c)
			awful.client.floating.toggle(c)
			---- If the window is flating, show the titlebar, else hide titlebar
			if awful.client.floating.get(c) == true then
				create_titlebar(c)
				awful.titlebar.show(c)
			else
				awful.titlebar.hide(c)
			end
		end),
	awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end),
	awful.key({ modkey }, "o", awful.client.movetoscreen),
	awful.key({ modkey }, "t", function(c) c.ontop = not c.ontop end),
	awful.key({ modkey }, "n", function(c)
			-- The client currently has the input focus, so it cannot be
			-- minimized, since minimized clients can't have the focus.
			c.minimized = true
		end),
	awful.key({ modkey }, "m", function(c)
			c.maximized_horizontal = not c.maximized_horizontal
			c.maximized_vertical   = not c.maximized_vertical
		end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 4 do
	globalkeys = awful.util.table.join(globalkeys,
		-- View tag only
		awful.key({ modkey }, "#" .. i + 9, function()
				local screen = mouse.screen
				local tag = awful.tag.gettags(screen)[i]
				if tag then awful.tag.viewonly(tag) end
			end),
		-- Toggle tag
		awful.key({ modkey, "Control" }, "#" .. i + 9, function()
				local screen = mouse.screen
				local tag = awful.tag.gettags(screen)[i]
				if tag then awful.tag.viewtoggle(tag) end
			end),
		-- Move client to tag
		awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
				if client.focus then
					local tag = awful.tag.gettags(client.focus.screen)[i]
					if tag then awful.client.movetotag(tag) end
				end
			end),
		-- Toggle tag
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
				if client.focus then
					local tag = awful.tag.gettags(client.focus.screen)[i]
					if tag then awful.client.toggletag(tag) end
				end
			end))
end

clientbuttons = awful.util.table.join(
	awful.button({ }, 1, function(c) client.focus = c; c:raise() end),
	awful.button({ modkey }, 1, awful.mouse.client.move),
	awful.button({ modkey }, 3, awful.mouse.client.resize)
)

-- Set keys
root.keys(globalkeys)
-- }}}



-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal)
awful.rules.rules = {
	-- All clients will match this rule
	{ rule = { },
	  properties = { border_width = beautiful.border_width,
					 border_color = beautiful.border_normal,
					 focus = awful.client.focus.filter,
					 raise = true,
					 keys = clientkeys,
					 buttons = clientbuttons } },
	{ rule = { class = "MPlayer" },
	  properties = { floating = true } },
	{ rule = { class = "pinentry" },
	  properties = { floating = true } },
	{ rule = { class = "gimp" },
	  properties = { floating = true } },
	-- Set Firefox to always map on tags number 2 of screen 1.
	-- { rule = { class = "Firefox" },
	--	 properties = { tag = tags[1][2] } },
}
-- }}}



-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c, startup)
	-- Enable sloppy focus
	c:connect_signal("mouse::enter", function(c)
			if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
				and awful.client.focus.filter(c) then
				client.focus = c
			end
		end)

	if not startup then
		-- Set the windows at the slave,
		-- i.e. put it at the end of others instead of setting it master.
		-- awful.client.setslave(c)

		-- Put windows in a smart way, only if they does not set an initial position.
		if not c.size_hints.user_position and not c.size_hints.program_position then
			awful.placement.no_overlap(c)
			awful.placement.no_offscreen(c)
		end
	end

	local titlebars_enabled = true
	if titlebars_enabled and (c.type == "normal" or c.type == "dialog")
		and awful.layout.get(c.screen) == awful.layout.suit.floating then

		-- buttons for the titlebar
		local buttons = awful.util.table.join(
			awful.button({ }, 1, function()
					client.focus = c
					c:raise()
					awful.mouse.client.move(c)
				end),
			awful.button({ }, 3, function()
					client.focus = c
					c:raise()
					awful.mouse.client.resize(c)
				end)
		)

		create_titlebar(c)
	end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}