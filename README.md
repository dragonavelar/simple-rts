# simple-rts
MVP RTS for LD41 warmup made with [LÖVE](https://love2d.org/).

# Information
* This uses the [middleclass library](https://github.com/kikito/middleclass/) for object orientation.
* Object initializers have named arguments [PIL link](https://www.lua.org/pil/5.3.html). 

# TO-DO

To-Do List to achieve the MVP, items with a dollar sign at the end are extras:

* Have a "selected units" structure so that orders are sent only to those units.
  * Make minimal UI stating what each input causes a unit to do.
  * Make control-selection expansion.
  * Make box-selection.
  * Make shift-selection.
  * Add control-groups $
* Add a resource to be collected.
  * Add a counter for the resource.
  * Make units built from buildings cost resources.
  * Make units build from buildings take time to construct, and to be able to be cancelled.
* Add multiple teams.
  * Make units be hostile between teams.
  * Add unit and structure health.
  * Make a way for units to attack.
  * Make a way to control unit line-of-sight
  * Make teams have "diplomacy tables". $
  * Create a "fog of war" outside unit vision. $
* Make an endgame objective: Kill all buildings
* Separate gamestates. $
  * Splashscreen. $
  * Title Menu. $
  * Skirmish Menu. $
  * Game state. $
* Computer AI: Make a basic computer AI that collects resources, builds troops and attacks once a treshold in units is reached. $
* LAN Networking for multiplayer $