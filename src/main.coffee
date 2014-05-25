cp = require '../lib/cp'

input = require './input'
{World, GameObject} = require './world'

canvas = document.body.appendChild document.createElement 'canvas'
canvas.width = 800
canvas.height = 600

ctx = canvas.getContext '2d'

class TitleScreen
  constructor: (@game) ->
  update: (dt) ->
    if input.pressed 'space'
      @game.screen = new GameScreen
  draw: ->
    ctx.clearRect 0, 0, canvas.width, canvas.height
    ctx.fillStyle = 'black'
    ctx.fillText 'title screen... press space to start.', 100, 100

class GameScreen
  constructor: (@game) ->
    @x = 100
    @y = 100

  update: (dt) ->
    if input.down 'left arrow'
      @x -= 100*dt
    if input.down 'right arrow'
      @x += 100*dt
    if input.down 'up arrow'
      @y -= 100*dt
    if input.down 'down arrow'
      @y += 100*dt
  draw: ->
    ctx.clearRect 0, 0, canvas.width, canvas.height
    ctx.fillStyle = 'black'
    ctx.fillText 'game screen!', @x, @y

class Game
  constructor: ->
    @screen = null

  update: (dt) ->
    @screen.update? dt
    input.clearPressed()

  draw: ->
    @screen.draw()

  run: ->
    return if @frameReq?
    requestAnimationFrame =>
      frameBegin = performance.now()
      @frameReq = requestAnimationFrame frame = (t) =>
        dt = (t - frameBegin)/1000
        frameBegin = t
        @frameReq = requestAnimationFrame frame
        @frame dt

  pause: ->
    return unless @frameReq?
    @drawPaused()
    cancelAnimationFrame(@frameReq)
    @frameReq = null

  drawPaused: ->
    ctx.fillStyle = 'hsla(0,0%,0%,0.2)'
    ctx.fillRect 0, 0, canvas.width, canvas.height

  frame: (dt) ->
    try
      @update dt
      @draw()
    catch e
      console.error e.stack

start = ->
  window.game = game = new Game
  game.screen = new TitleScreen game
  if document.hasFocus()
    game.run()
  else
    game.drawPaused()

window.onblur = ->
  game.pause()
window.onfocus = ->
  game.run()

start()
