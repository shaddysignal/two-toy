(() ->
	requestAnimationFrame = window.requestAnimationFrame || window.mozRequestAnimationFrame || window.webkitRequestAnimationFrame || window.msRequestAnimationFrame
	window.requestAnimationFrame = requestAnimationFrame
)();

elem = document.getElementById('draw-shapes')
params = { fullscreen: true }
two = new Two(params).appendTo(elem)

rect = two.makeRectangle(213, 100, 100, 100)

getCircles = (int) ->
	iter = (circles, r) ->
		if int < 0
			circles
		else
			circle = two.makeCircle(72, 100, r)
			circle.fill = '#FF8000'
			circle.stroke = 'orangered'
			circle.linewidth = 5
			circle.acceleration = 0.0
			circle.rotation = 0.0
			circles.push(circle)
			int -= 1
			iter(circles, r / 2)

	iter([], 30)

circles = getCircles(3)
circle = circles[0]

rect.fill = 'rgb(0, 200, 255)'
rect.opacity = 0.75
rect.noStroke()
rect.custom = 0

keys = {
	37: {
		pressed: false
		execute: () ->
			for circle in circles
				circle.rotation -= 0.05 * Math.PI
			true
	}
	39: {
		pressed: false
		execute: () ->
			for circle in circles
				circle.rotation += 0.05 * Math.PI
			true
	}
	38: {
		pressed: false
		execute: () ->
			for circle in circles
				circle.acceleration += 0.5
			true
	}
	40: {
		pressed: false
		execute: () ->
			for circle in circles
				circle.acceleration -= 0.5
			true
	}
	82: {
		pressed: false
		execute: () ->
			for circle in circles
				circle.translation.x = 72
				circle.translation.y = 100
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

	if (rect.custom > 0.9999)
		rect.custom = rect.rotation = 0
	t = (1 - rect.custom) * 0.05
	rect.custom += t
	rect.rotation += t * 4 * Math.PI

	for c in circles
		c.translation.x += c.acceleration * Math.cos(c.rotation)
		c.translation.y += c.acceleration * Math.sin(c.rotation)
		c.acceleration = if c.acceleration < 0.1 then 0 else (c.acceleration - 0.1)
).play()
