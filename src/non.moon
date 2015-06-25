-- Easy type checking for MoonScript classes
old_type = type
export type = (value) ->
  base_type = old_type value
  if base_type == "table"
    cls = value.__class
    return cls.__name if cls
  base_type

-- Initialize java library
export java = require "java"

-- Initialize main non table
export non = {}

-- Initialize the modules
print "Initializing the accelerometer module"
non.accelerometer = require "non.accelerometer"

print "Initializing the audio module"
non.audio = require "non.audio"

print "Initializing the compass module"
non.compass = require "non.compass"

print "Initializing the filesystem module"
non.filesystem = require "non.filesystem"

print "Initializing the keyboard module"
non.keyboard = require "non.keyboard"

print "Initializing the mouse module"
non.mouse = require "non.mouse"

print "Initializing the system module"
non.system = require "non.system"

print "Initializing the timer module"
non.timer = require "non.timer"

print "Initializing the touch module"
non.touch = require "non.touch"

print "Initializing the window module"
non.window = require "non.window"

-- Wrap the callbacks to be usefull for the engine
c = require "non.internal.constants"

non._keypressed = (keycode) ->
  if non.keypressed then non.keypressed c.keycodes[keycode]

non._keyreleased = (keycode) ->
  if non.keyreleased then non.keyreleased c.keycodes[keycode]

non._mousepressed = (x, y, buttoncode) ->
  if non.mousepressed then non.mousepressed c.buttoncodes[buttoncode]

non._mousereleased = (x, y, buttoncode) ->
  if non.mousereleased then non.mousereleased c.buttoncodes[buttoncode]

non._quit = ->
  if non.quit then non.quit!
  non.audio.stop_all!

-- Main loop function
non.run = () ->
  dt = 0
  if non.timer then dt = non.timer.get_delta!
  if non.update then non.update dt

  if non.graphics
    non.graphics.clear!
    non.graphics.origin!
    non.draw!
    non.graphics.present!

require "main"