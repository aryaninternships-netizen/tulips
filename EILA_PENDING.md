# Pending for EILA (drive was unmounted 2026-09-11)
When /Volumes/EILA is back: rsync ~/tulips, ~/khushi-garden, ~/minions-garden (exclude .git .vercel) to "/Volumes/EILA/Personal projects/<name>/", then append the section below to "/Volumes/EILA/Personal projects/tulips/latest.md" and delete this file.

## Mobile view + compact HUD (2026-09-11, all three gardens)
- `MOBILE` = pointer:coarse || innerWidth<820, set right after scene creation; body.mobile class scopes all mobile CSS.
- Budgets on mobile: tulips COUNT 30k (was 92k), grass 60k (was 200k), minions species caps x0.38, DPR cap 1.0, shadowMap off, CSS canvas filter + grain off (filter on fullscreen canvas halves mobile fps).
- Touch: #stick virtual joystick (dead 0.12, run at >0.94 deflection) writes window.JOY {x,y,up,run}; free/walk movement blocks add joy next to WASD; #alt ▲▼ altitude in free mode. Look-drag on canvas tracks its own pointerId (lookId) so thumb-on-stick never yaws the camera. pointerup/cancel scoped to lookId.
- Rotation: fitViewport() on resize + orientationchange (refit at 150/500ms, iOS reports stale sizes) + visualViewport + screen.orientation. Portrait: camera.zoom 0.78 (zoom scales projection, fov code untouched). body.portrait class; #rotHint toast 5s on portrait load. Landscape CSS keyed on @media (max-height:460px) scoped by body.mobile (pane does not emulate coarse pointer at 812 wide; do not key on pointer:coarse).
- Compact HUD (desktop too): mode buttons icon-only, label <span> shown only on .on; time+weather chips hidden inside #skybar, sun icon toggles .open, any chip click folds it.
- launch.json now has khushi-garden (8644) and minions-garden (8645).
- Browser-pane gotcha: synthetic PointerEvents throw on setPointerCapture (no active pointer); guarded with try/catch, console error is from tests not real touches.
