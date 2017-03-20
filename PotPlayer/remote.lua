local win = libs.win;
local keyboard = libs.keyboard;
local timer = libs.timer
local utf8 = libs.utf8;
local server = libs.server;

-- Commands
local WM_COMMAND 				= 0x111;
local CMD_PREVIOUS				= 10123;
local CMD_NEXT					= 10124;
local CMD_PLAY_PAUSE			= 10014;
local CMD_FULLSCREEN			= 10013;
	
local CMD_5SEC_BACKWARD			= 10059;
local CMD_5SEC_FORWARD			= 10060;
local CMD_30SEC_BACKWARD		= 10061;
local CMD_30SEC_FORWARD			= 10062;
local CMD_1MIN_BACKWARD			= 10063;
local CMD_1MIN_FORWARD			= 10064;
local CMD_5MIN_BACKWARD			= 10065;
local CMD_5MIN_FORWARD 			= 10066;

local CMD_SETTINGS				= 10010;
local CMD_OPTIONS				= 20011;
local CMD_OPEN_FILE				= 10158;
local CMD_OPEN_FOLDER			= 10160;
local CMD_OSD_TOGGLE			= 10351;
local CMD_AUDIO_STREAM			= 10173;
local CMD_SUBS_STREAM			= 10172;
	
local CMD_SUBS_INCREASE_TEXT	= 10137;
local CMD_SUBS_DECREASE_TEXT	= 10138;
local CMD_SUBS_FASTER			= 10140;
local CMD_SUBS_SLOWER			= 10141;
local CMD_SUBS_ON_OFF 			= 10126;
local CMD_SUBS_CENTER 			= 10127;
local CMD_SUBS_UP 				= 10128;
local CMD_SUBS_DOWN 			= 10129;
local CMD_SUBS_LEFT 			= 10130;
local CMD_SUBS_RIGHT 			= 10131;
local CMD_SUBS_INCREASE_WIDTH	= 10132;
local CMD_SUBS_DECREASE_WIDTH	= 10133;
local CMD_SUBS_INCREASE_HEIGHT	= 10134;
local CMD_SUBS_DECREASE_HEIGHT	= 10135;
	
local CMD_VIDEO_ZOOM_IN			= 10047;
local CMD_VIDEO_ZOOM_OUT		= 10048;
local CMD_VIDEO_WIDTH_INCREASE 	= 10049;
local CMD_VIDEO_WIDTH_DECREASE	= 10050;
local CMD_VIDEO_HEIGHT_INCREASE = 10051;
local CMD_VIDEO_HEIGHT_DECREASE = 10052;
local CMD_VIDEO_MOVE_RIGHT		= 10053;
local CMD_VIDEO_MOVE_LEFT		= 10054;
local CMD_VIDEO_MOVE_UP			= 10055;
local CMD_VIDEO_MOVE_DOWN		= 10056;
local CMD_VIDEO_MOVE_CENTER 	= 10057;
local CMD_VIDEO_MOVE_ZOOM_RESET = 10058;
	
local CMD_ASPECT_RATIO_START 	= 10015;
local CMD_ASPECT_RATIO_END		= 10022;

local tid = -1;
local title = "";
local ar = CMD_ASPECT_RATIO_START + 1;

events.detect = function ()
	return 
		libs.fs.exists("C:\\Program Files (x86)\\Daum\\PotPlayer") or
		libs.fs.exists("C:\\Program Files\\Daum\\PotPlayer");
end

events.focus = function ()
	tid = timer.interval(actions.update, 500);
end

events.blur = function ()
	timer.cancel(tid);
end

--@help Update status information
actions.update = function ()
	local hwnd = win.find("PotPlayer", nil);
	if (hwnd == 0) then
		hwnd = win.find("PotPlayer64", nil);
	end
	local _title = win.title(hwnd);
	_title = utf8.replace(_title, " - Daum PotPlayer", "");
	if (_title == "") then
		_title = "[Not Playing]";
	end
	
	if (_title ~= title) then
		title = _title;
		server.update({ id = "info", text = title });
	end
end

--@help Send raw command to PotPlayer
--@param cmd:number Raw PotPlayer command number
actions.command = function(cmd)
	local hwnd = win.find("PotPlayer", nil);
	if (hwnd == 0) then
		hwnd = win.find("PotPlayer64", nil);
	end
	win.post(hwnd, WM_COMMAND, cmd, 0);
	actions.update();
end

--@help Launcher PotPlayer application
actions.launch = function()
	pcall(function ()
		os.start("C:\\Program Files (x86)\\Daum\\PotPlayer\\PotPlayerMini.exe");
	end);
	pcall(function ()
		os.start("C:\\Program Files\\Daum\\PotPlayer\\PotPlayerMini64.exe");
	end);
end

function vol_down(i)
	for i = 1, i do
		keyboard.press("volumedown");
	end
end

function vol_up(i)
	for i = 1, i do
		keyboard.press("volumeup");
	end
end

function vol_mute()
	if OS_WINDOWS then
		vol_down(50);
	else
		vol_down(16);
	end
end

--@help Lower volume
actions.volume_down = function ()
	vol_down(1);
end

--@help Mute volume
actions.volume_mute = function()
	vol_mute();
end

--@help Raise volume
actions.volume_up = function()
	vol_up(1);
end

--@help Previous track
actions.previous = function()
	actions.command(CMD_PREVIOUS);
end

--@help Next track
actions.next = function()
	actions.command(CMD_NEXT);
end

--@help Toggle play/pause state
actions.play_pause = function()
	actions.command(CMD_PLAY_PAUSE);
end

--@help Toggle fullscreen
actions.fullscreen = function ()
	actions.command(CMD_FULLSCREEN);
end

--@help Jump back 5 seconds
actions.small_back = function ()
	actions.command(CMD_5SEC_BACKWARD);
end

--@help Jump forward 5 seconds
actions.small_forward = function ()
	actions.command(CMD_5SEC_FORWARD);
end

--@help Jump back 30 seconds
actions.big_back = function ()
	actions.command(CMD_30SEC_BACKWARD);
end

--@help Jump forward 30 seconds
actions.big_forward = function ()
	actions.command(CMD_30SEC_FORWARD);
end

--@help Toggle OSD detailed information
actions.osd_toggle = function ()
	actions.command(CMD_OSD_TOGGLE);
end

--@help Toggle subtitles stream
actions.subs_toggle = function ()
	actions.command(CMD_SUBS_STREAM);
end

--@help Toggle audio stream
actions.audio_toggle = function ()
	actions.command(CMD_AUDIO_STREAM);
end

--@help Open a file dialog box
actions.open_file = function ()
	actions.command(CMD_OPEN_FILE);
end

--@help Open a folder dialog box
actions.open_folder = function ()
	actions.command(CMD_OPEN_FOLDER);
end

--@help Open settings menu
actions.settings = function ()
	actions.command(CMD_SETTINGS);
end

--@help Open options menu
actions.options = function ()
	actions.command(CMD_OPTIONS);
end
--@help Turn ON/OFF subtitles
actions.subs_on_off = function ()
	actions.command(CMD_SUBS_ON_OFF);
end

--@help Move subtitles to center
actions.subs_center = function ()
	actions.command(CMD_SUBS_CENTER);
end

--@help Increase subtitles text size
actions.subs_increase_text = function ()
	actions.command(CMD_SUBS_INCREASE_TEXT);
end

--@help Decrease subtitles text size
actions.subs_decrease_text = function ()
	actions.command(CMD_SUBS_DECREASE_TEXT);
end

--@help Faster subtitles timing
actions.subs_faster = function ()
	actions.command(CMD_SUBS_FASTER);
end

--@help Slower subtitles timing
actions.subs_slower = function ()
	actions.command(CMD_SUBS_SLOWER);
end

--@help Move subtitles up
actions.subs_up = function ()
	actions.command(CMD_SUBS_UP);
end

--@help Move subtitles down
actions.subs_down = function ()
	actions.command(CMD_SUBS_DOWN);
end

--@help Move subtitles left
actions.subs_left = function ()
	actions.command(CMD_SUBS_LEFT);
end

--@help Move subtitles right
actions.subs_right = function ()
	actions.command(CMD_SUBS_RIGHT);
end

--@help Decrease subtitles width field size
actions.subs_decrease_width = function ()
	actions.command(CMD_SUBS_DECREASE_WIDTH);
end

--@help Increase subtitles width field size
actions.subs_increase_width = function ()
	actions.command(CMD_SUBS_INCREASE_WIDTH);
end

--@help Decrease subtitles height field size
actions.subs_decrease_height = function ()
	actions.command(CMD_SUBS_DECREASE_HEIGHT);
end

--@help Increase subtitles height field size
actions.subs_increase_height = function ()
	actions.command(CMD_SUBS_INCREASE_HEIGHT);
end

--@help Up arrow button
actions.button_up = function ()
	keyboard.stroke("up");
end

--@help Down arrow button
actions.button_down = function ()
	keyboard.stroke("down");
end

--@help Left arrow button
actions.button_left = function ()
	keyboard.stroke("left");
end

--@help Right arrow button
actions.button_right = function ()
	keyboard.stroke("right");
end

--@help Enter button
actions.button_enter = function ()
	keyboard.stroke("enter");
end

--@help Escape button
actions.button_escape = function ()
	keyboard.stroke("escape");
end

--@help Zoom in video
actions.video_zoom_in = function ()
	actions.command(CMD_VIDEO_ZOOM_IN);
end

--@help Zoom out video
actions.video_zoom_out = function ()
	actions.command(CMD_VIDEO_ZOOM_OUT);
end

--@help Increase video width
actions.video_width_increase = function ()
	actions.command(CMD_VIDEO_WIDTH_INCREASE);
end

--@help Decrease video width
actions.video_width_decrease = function ()
	actions.command(CMD_VIDEO_WIDTH_DECREASE);
end

--@help Increase video height
actions.video_height_increase = function ()
	actions.command(CMD_VIDEO_HEIGHT_INCREASE);
end

--@help Decrease video height
actions.video_height_decrease = function ()
	actions.command(CMD_VIDEO_HEIGHT_DECREASE);
end

--@help Move video right
actions.video_move_right = function ()
	actions.command(CMD_VIDEO_MOVE_RIGHT);
end

--@help Move video left
actions.video_move_left = function ()
	actions.command(CMD_VIDEO_MOVE_LEFT);
end

--@help Move video up
actions.video_move_up = function ()
	actions.command(CMD_VIDEO_MOVE_UP);
end

--@help Move video down
actions.video_move_down = function ()
	actions.command(CMD_VIDEO_MOVE_DOWN);
end

--@help Move video to center
actions.video_move_center = function ()
	actions.command(CMD_VIDEO_MOVE_CENTER);
end

--@help Reset zoom and move
actions.video_move_zoom_reset = function ()
	actions.command(CMD_VIDEO_MOVE_ZOOM_RESET);
end

--@help Aspect ratio switch;
actions.aspect_ratio_switch = function ()
	actions.command(ar);
	
	if(ar<CMD_ASPECT_RATIO_END) then
		ar = ar + 1;
	else
		ar = CMD_ASPECT_RATIO_START;
	end
end