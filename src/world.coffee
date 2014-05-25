class TimerBox
  constructor: (@world) ->
    @timers = []
  after: (seconds, fn) ->
    @timers.push { time: @world.time + seconds, fn }
  tick: ->
    for t in @timers
      if @world.time >= t.time
        t.fn()
    @timers = (t for t in @timers when @world.time < t.time)

class GameObject
  constructor: (@_args...) ->
    @age = 0

  _added: (@world) ->
    @timers = new TimerBox @world
    @init? @_args...
    delete @_args

  _update: (dt) ->
    @age += dt
    @timers.tick()

  remove: ->
    return if @removeMe
    @removeMe = yes

  after: (seconds, fn) ->
    @timers.after seconds, fn

class World
  constructor: ->
    @entities = []
    @time = 0
    @timers = new TimerBox this

  add: (e) ->
    e._added @
    @entities.push e
    e

  after: (seconds, fn) -> @timers.after seconds, fn

  update: (dt) ->
    @time += dt
    @timers.tick()

    for e in @entities
      e._update dt
      e.update? dt

    @entities = (e for e in @entities when not e.removeMe)

  draw: ->
    es = @entities[..].sort (a, b) -> (a.z?() ? Infinity) - (b.z?() ? Infinity)
    for e in es
      e.draw?()
    return

module.exports = {GameObject, World}
