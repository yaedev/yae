map = undefined
pressed = undefined
client = undefined
server = undefined
lastMsg = undefined
non.load "testText.coffee"

non.ready = ->
  map = non.tiled.newMap("../data/map.tmx")
  non.audio.play non.audio.newMusic("../data/music.ogg")
  non.network.connected = (conn) ->
    lastMsg = "client connected: " + conn.toString()
    return

  non.network.disconnected = (conn) ->
    lastMsg = "client disconnected"
    return

  non.network.received = (data, conn) ->
    lastMsg = "data received: " + data.read()
    return

  non.network.setHost("localhost").setPort(15600).init()
  (server = non.network.newServer()).listen()
  (client = non.network.newClient()).connect()
  non.physics.setTimeScale(2).setGravity(0,10).init()
  non.physics.newShape(non.math.newRectangle(32,10,20,20))
  non.physics.newShape(non.math.newRectangle(100,10,20,20))
  non.physics.newShape(non.math.newRectangle(0,150,20,20), "static")
  non.physics.newShape(non.math.newRectangle(240,300,200,20), "static")
  non.physics.newShape(non.math.newCircle(32,64,20), "dynamic", 0.5, 0.4, 0.6)
  return

non.update = ->
  non.physics.update non.getDelta()
  if non.keyboard.isKeyJustPressed("Space")
    buffer = non.network.newBuffer()
    buffer.write 1
    client.send buffer
  if non.keyboard.isKeyPressed("Space")
    pressed = "Key pressed: Spacebar (release Spacebar to test)"
  else
    pressed = "Key pressed: None (press Spacebar to test)"
  return

non.draw = ->
  non.graphics.draw map
  non.physics.draw non.graphics # draw debug physics, do not use this in production
  non.graphics.draw "Author: YourBestNightmare", 10, 10, non.graphics.newColor("yellow")
  non.graphics.draw "Engine: non (no nonsense) framework", 10, 34
  non.graphics.draw "Description: In this example we are testing music, input, tmx rendering, images and text displaying.", 10, 58
  non.graphics.draw pressed, 10, 82, non.graphics.newColor("cyan")
  non.graphics.draw "FPS: " + non.getFPS(), 10, 104
  non.graphics.draw lastMsg, 10, 126, non.graphics.newColor("red")
  return