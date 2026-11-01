- Instead of keeping alerted enemies as secondary camera target, just have the camera pan for only a bit
	- Add temp PoI (like 1.5 seconds or something)
- Add look-ahead panning(?); might not want it this time since there's MGS wallhugging
- Check later if making enemies part of World collision layer has any negatives

- Refactor TestEnemy components(?)
	- things feel kind of all over the place
- Need better standardization for the vectors that need to be 'y = 0'd

- Need to make Vision work based on its placement and not at every enemy's feet
	- Vision.is_unobstructed should not need to add y+0.2
- Ally alert should place them in Suspicion first
	- They only alert after seeing the target themselves
	- Suspicion will need to be tweaked to travel directly to last_seen_pos first

- Speech text popups
