(() ->
	requestAnimationFrame = window.requestAnimationFrame || window.mozRequestAnimationFrame || window.webkitRequestAnimationFrame || window.msRequestAnimationFrame
	window.requestAnimationFrame = requestAnimationFrame
)();

elem = document.getElementById('draw-shapes')
params = { fullscreen: true }
pos = {
	x: 200
	y: 200
}
two = new Two(params).appendTo(elem)

getCircles = (int) ->
	iter = (circles, r) ->
		if int < 0
			circles
		else
			circle = two.makeCircle(pos.x, pos.y, r)
			circle.fill = '#FF8000'
			circle.stroke = 'orangered'
			circle.linewidth = 5
			circle.acceleration = 0.0
			circle.rotation = 0.0
			circles.push(circle)
			int -= 1
			iter(circles, r / 1.5)

	iter([], 30)

circles = getCircles(3)
circle = circles[0]

timeout = (index, transform) ->
	setTimeout(transform(index), index * 100)
	true

foreach = (transform) ->
	for i in [0...circles.length]
		timeout(i, (i) -> () -> transform(circles[i]))
	true

keys = {
	37: {
		pressed: false
		execute: () ->
			foreach((c) ->
				c.rotation -= 0.1 * Math.PI
			)
	}
	39: {
		pressed: false
		execute: () ->
			foreach((c) ->
				c.rotation += 0.1 * Math.PI
			)
	}
	38: {
		pressed: false
		execute: () ->
			foreach((c) ->
				c.acceleration += 0.5
			)
	}
	40: {
		pressed: false
		execute: () ->
			foreach((c) ->
				c.acceleration -= 0.5
			)
	}
	82: {
		pressed: false
		execute: () ->
			for circle in circles
				circle.translation.x = pos.x
				circle.translation.y = pos.y
			true
	}
}

window.addEventListener "keydown", (e) ->
	if keys.hasOwnProperty(e.keyCode)
		keys[e.keyCode].pressed = true

window.addEventListener "keyup", (e) ->
	if keys.hasOwnProperty(e.keyCode)
		keys[e.keyCode].pressed = false

keysEvents = ->
	for key of keys
		if keys[key].pressed
			do keys[key].execute
		else
			# nothing

two.bind('update', (frameCount) ->
	do keysEvents

	for c in circles
		c.translation.x += c.acceleration * Math.cos(c.rotation)
		c.translation.y += c.acceleration * Math.sin(c.rotation)
		c.acceleration = if c.acceleration < 0.1 then 0 else (c.acceleration - 0.1)
).play()
