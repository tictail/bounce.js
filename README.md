# Bounce.js

[Bounce.js](http://bouncejs.com) is a tool and JS library for generating beautiful CSS3 powered keyframe animations. The tool on [bouncejs.com](http://bouncejs.com) allows you to generate static keyframes that can be used without any extra JavaScript, but if you'd like your application
to generate these on the fly, you can use the Bounce.js library.   

## Installation
The library is available to install from Bower or NPM:
```
$ bower install bounce.js 
# OR
$ npm install bounce.js
```
You can also view and download all releases [from here](https://github.com/tictail/bounce.js/releases).

## Usage
To create an animation, instantiate a new `Bounce` object:
```
var bounce = new Bounce();
```

The `Bounce` object is what you'll use to first build your animation from the different components `scale`, `rotate`, `translate` and `skew`. This can then either be defined as a named animation for later use, or directly applied to elements on the page.

### Adding Animation Components
As mentioned above, you'll use the `scale`, `rotate`, `translate` and `skew` methods to build your animation, just like with the Bounce.js tool. All of these methods accept a number of common options (explained further down) and `from` and `to` parameters that define the start and end points of the animation. Note that all of these methods are chainable.

#### scale
```
var bounce = new Bounce();
bounce.scale({
  from: { x: 0.5, y: 0.5 },
  to: { x: 1, y: 1 }
});
```
The `from` and `to` parameters define the scale of the element on X (width) and Y (height) as a ratio. The example above animates the element from half size to full. ([See it in action](http://goo.gl/W7f9he))

#### rotate
```
var bounce = new Bounce();
bounce.rotate({
  from: 0,
  to: 90
});
```
The `from` and `to` parameters define the rotation of the element in degrees. The example above animates the element a quarter rotation to the right. ([See it in action](http://goo.gl/WWyopK))

#### translate
```
var bounce = new Bounce();
bounce.translate({
  from: { x: 0, y: 0 },
  to: { x: 100, y: 0 }
});
```
The `from` and `to` parameters define the translation (position) of the element on X and Y in pixels. The example above animates the element 100 pixels to the right. ([See it in action](http://goo.gl/lVeiKO))

#### skew
```
var bounce = new Bounce();
bounce.skew({
  from: { x: 0, y: 0 },
  to: { x: 20, y: 0 }
});
```
The `from` and `to` parameters define the skew of the element on X and Y in degrees. The example above animates the skew of the element 20 degrees on the horizontal axis. ([See it in action](http://goo.gl/lQ5YPZ))

#### Common Animation Parameters
All of the above methods accept these additional parameters:

- **duration**: The duration of the animation in ms. *Defaults to 1000*.
- **delay**: The delay of the animation in ms. *Defaults to 0*.
- **easing**: One of `"bounce"`, `"sway"`, `"hardbounce"`,  `"hardsway"`. These are the same as in the "Easing" menu in the tool. *Defaults to "bounce"*.
- **bounces**: The number of bounces in the animation. *Defaults to 4*.
- **stiffness**: The stiffness of the bounces in the animation, should be a value between 1 and 5. *Defaults to 3*.

### Using the Animation
Once you've built your animation, you can either choose to define it as a named keyframe animation, or directly apply it to any element in the DOM.

#### define
```
var bounce = new Bounce();
bounce.rotate({
  from: 0,
  to: 90
});
bounce.define("my-animation");
```
Defines an animation with the given name. The animation can then be used in your CSS with `animation: my-animation 1s linear both;`.

#### applyTo
```
var bounce = new Bounce();
bounce.rotate({
  from: 0,
  to: 90
});
bounce.applyTo(document.querySelectorAll(".animation-target"));
// or with jQuery: bounce.applyTo($(".animation-target"));
```
Directly applies the animation to a single or a list of elements. This method also accepts a number of options:

- **loop**: Loops the animation infinitely if set to `true`. *Defaults to false.*
- **remove**: Removes the animation once it is complete. If your animation ends in a state different from what the element had before, the element will return to its original state **in some browsers**. *Defaults to false*
- **onComplete**: A callback function to be run after the animation is complete.

If you're using jQuery, the method will return a promise to be used instead of the `onComplete` parameter:
```
bounce.applyTo($(".animation-target")).then(function() { 
  console.log("Animation Complete"); 
});
```

#### Remove
An animation can also manually be removed once it has been defined:
```
bounce.remove()
```

### Browser Support
You can check for support in the current browser with:
```
Bounce.isSupported()
```
The library should work in all browser that support both [3D transforms](http://caniuse.com/#feat=transforms3d) and [keyframe animations](http://caniuse.com/#feat=transforms3d).

### Full Example
Here's a full example of building the [Splat animation preset](http://goo.gl/et2XBk) in the tool and applying it to an element with class `animation-target`.

```
var bounce = new Bounce();
bounce
  .translate({
    from: { x: -300, y: 0 },
    to: { x: 0, y: 0 },
    duration: 600,
    stiffness: 4
  })
  .scale({
    from: { x: 1, y: 1 },
    to: { x: 0.1, y: 2.3 },
    easing: "sway",
    duration: 800,
    delay: 65,
    stiffness: 2
  })
  .scale({
    from: { x: 1, y: 1},
    to: { x: 5, y: 1 },
    easing: "sway",
    duration: 300,
    delay: 30,
  })
  .applyTo(document.querySelectorAll(".animation-target"));
```

## Developing
If you'd like to run the Bounce.js site locally, and edit the JavaScript library, you can do so by cloning this repo and running the following commands (assuming that you have Node, NPM and Bower installed):

```
# Install dependencies
$ npm install
$ bower install

# Start the server on localhost:9000. Watches for changes, automatically recompiles files and refreshes the browser.
$ grunt serve 

# Run the tests
$ grunt test