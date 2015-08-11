--init random function
math.randomseed(os.time())
math.random()        --bug in first use

--############################## ADVICE START
--[[ GLOBAL-EVENT CROSS-MODULE FIRING (aka the 'runtime ghost touch')

Placing Runtime event listeners in modules or lua-files can effect other modules/files.
a Runtime (aka 'global') touch event in another scene can still fire even after a scene change.
one way to deal with this is to make touch events non-runtime (aka 'local'), object based touch events,
on the deletion of the object the event is no longer accessible to the other scenes.
This can be a difficult bug to track and figure out it was discovered when making use of Storyboard Scene System
--]]
--############################## ADVICE END
