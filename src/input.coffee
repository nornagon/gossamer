# input.mouseTarget = canvas
#
# if input.down 'space'
#   test()
#
# if input.pressed 'lmouse'
#   input.mouse.x

normalized = (name) ->
  name = name.toLowerCase()
  if k = specials[name] then k else name

specials =
  space: 'key:32'
  spc: 'key:32'
  backspace: 'key:8'
  bksp: 'key:8'
  tab: 'key:9'
  enter: 'key:13'
  return: 'key:13'
  esc: 'key:27'
  escape: 'key:27'
  left: 'key:37'
  left_arrow: 'key:37'
  'left arrow': 'key:37'
  up: 'key:38'
  up_arrow: 'key:38'
  'up arrow': 'key:38'
  right: 'key:39'
  right_arrow: 'key:39'
  'right arrow': 'key:39'
  down: 'key:40'
  down_arrow: 'key:40'
  'down arrow': 'key:40'

  'left mouse': 'mouse:0'
  'lmouse': 'mouse:0'
  'middle mouse': 'mouse:1'
  'mmouse': 'mouse:1'
  'right mouse': 'mouse:2'
  'rmouse': 'mouse:2'

for c in [65..90]
  specials[String.fromCharCode c] = 'key:'+c

input =
  mouseTarget: undefined
  _down: {}
  _pressed: {}
  _released: {}
  mouse: { x:0, y:0 }
  quiet: ['space', 'tab', 'esc', 'enter', 'bksp', 'left', 'right', 'up', 'down'].map normalized

  clearPressed: ->
    for k,v of @_released when v
      @_released[k] = false
      @_pressed[k] = false
      @_down[k] = false

  pressed: (action) -> @_pressed[@normalized action]
  down: (action) -> @_down[@normalized action]
  released: (action) -> @_released[@normalized action]

  _actiondown: (action) ->
    input._pressed[action] = true unless input._down[action]
    input._down[action] = true

  _actionup: (action) ->
    input._released[action] = true

  reset: ->
    @_released[k] = v for k,v of @_down

  normalized: normalized

down = (e, action) ->
  input._actiondown action
  if action in input.quiet
    e.preventDefault()
    e.stopPropagation()
    false
up = (e, action) ->
  input._actionup action
  if action in input.quiet
    e.preventDefault()
    e.stopPropagation()
    false
window.addEventListener 'keydown', (e) -> down e, 'key:'+e.keyCode
window.addEventListener 'keyup', (e) -> up e, 'key:'+e.keyCode

window.addEventListener 'mousedown', (e) -> down e, 'mouse:'+e.button
window.addEventListener 'mouseup', (e) -> up e, 'mouse:'+e.button

window.addEventListener 'mousemove', (e) ->
  { top, left } = if input.mouseTarget?
    r = input.mouseTarget.getBoundingClientRect()
    r.top += window.scrollY
    r.left += window.scrollX
    r
  else { top: 0, left: 0 }
  input.mouse.x = e.pageX - left
  input.mouse.y = e.pageY - top

window.addEventListener 'blur', (e) ->
  input.reset()

((es) -> if module? then module.exports = es else window.input = es) input
