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

## Mobile perf pass (2026-09-11, all three)
- Phones skip EffectComposer entirely (renderer.render direct; bloom = 4 fullscreen passes). Desktop unchanged.
- Adaptive pixel ratio on mobile: fps<38 steps DPR -0.1 (floor 0.6), fps>56 steps +0.05 (cap 1.0), evaluated every 0.5s in the fps block.
- Mobile budgets: fog BANDS n x0.45, BFLY 40, RAIN_N 1400, webcam 320x240, hand detection every other frame (hand.last reused).
- powerPreference high-performance on the renderer.

## Sunflower v4 (2026-09-11, minions only)
- Reference: Wikipedia Common sunflower. Rough hairy stem 2-4 cm on 2-3 m; leaves broad, coarsely toothed, heart-shaped, alternate, lowest largest; head 7.5-12.5 cm wild (garden cultivars bigger); MATURE HEADS FACE EAST FIXED, only buds track the sun (Atamian 2016).
- sunStemG(h, r): ridged 3-ring stem, 5 alternate cordate leaves at golden angle on petioles, drooping, largest low. Stem greens dark (0.13,0.28,0.10).
- Head: 21+17 ligules halfW 0.16/0.14, disc 6 rings seg 28, colours 3-4x darker than they should look (noon sun + specular lift them; mid-brown rendered as GOLD in v3 close-ups, that was the bug). Sunflower bloomMat shininess 5 specular 0x0c0c0c. Green receptacle disc + 14 phyllaries behind. g.scale 0.62, rotateX -1.0 (nods 55 deg), translate (0,0.07,-0.12) so the receptacle sits on the stem top.
- Shader: age = clamp((instance scale - 1.35)/0.3): young mix to uSunYaw, mature to uEastYaw (0.9 rad, the garden's east).
- Drifting petals: radial-gradient CanvasTexture sprite, size 0.22 (untextured Points drew as pink squares).
- Debug handles now in all three: window.CAM, window.DBG {dronePos, look(yaw,pitch)}, minions window.TD (tulipData). Teleport: mFree click, DBG.dronePos.set, DBG.look. yaw -PI/2 looks +x, PI/2 looks -x, 0 looks -z, PI looks +z.

## White cast, real root cause (2026-09-11, all three)
- Earlier log claimed scene.fog far 980. Wrong: updateSky overwrote it EVERY FRAME with `far = rain ? 260 : 420`. World is 800 wide, treeline r 480+, so trees rendered at 100% fog colour (pale sky stop) in front of the ridge whose material has fog:false and stayed green: white tree cutouts on green hills, at ground level and from the drone.
- Fix: updateSky near 220 / far 1100 (rain 60 / 300). Verified at noon from ground and 70u drone in the pane.
- Lesson: grep for every writer of a value before declaring it fixed; the init line is not the value.

## Full screen + reactive mobile flag (2026-09-11, all three)
- #fsBtn under the sun icon: requestFullscreen on documentElement, screen.orientation.lock('landscape') on phones, button becomes ✕ in fullscreen (fullscreenchange), hidden on iOS Safari (no element fullscreen API).
- MOBILE is now `let`; fitViewport re-evaluates (pointer:coarse || width<820) and toggles body.mobile, DPR cap, setMode(mode) for the hint. Instance budgets stay from load.
- Landscape (max-height 460): hint at top centre, max-width 46vw; was overlapping the basket.
- Black dome the user saw once at the lake shore: not reproduced from any angle/time on either render path; no NaN in position/normal/color of 467 meshes. Parked.

## White blink + walk cam (2026-09-11, all three)
- White blink on phones = adaptive DPR: each renderer.setPixelRatio recreates the buffer and paints one cleared frame of the page bg (#cfe6f5, near white). Now: step only after 2 slow windows (<34) or 6 fast (>58), min 6s between steps, page bg #4a5e66 so any cleared frame is dusk-grey.
- Phone walk cam: dist +4, side 3.6 (was 2.6). Hint fades (opacity 0) 5s after each setMode on body.mobile.
- Domain: minionbageecha.in LIVE with SSL on Vercel project minions-garden (A @ 76.76.21.21 at GoDaddy, www 308-redirects to bare domain). WHOIS validate still on user.
- Sunflower v4.1: plant rot for sunflowers is +-0.25 rad only (random yaw was fighting the sun/east yaw, heads faced every way); head scale 0.85; rays 24+20 halfW 0.19/0.17; disc dome halved (was a ball from the side); plaza loop 1700 tries. Hint pill fades after 5 s on every device (user circled it).

## 2026-09-11 late
- Minions: basket + bouquet + plucking REMOVED (CSS display none on #basket/#bouquetModal, pluckAtNDC returns false, hint text scrubbed). Flowers stay in the ground there.
- Sunflower v4.1: plant rot near 0 so the shader yaw (sun/east) rules facing; head scale 0.85; whorl() got `tip` opt (0.9 = blunt oblong ligules, NU4 NV3); disc dome halved.
- Hint pill fades 5s after every setMode on all devices. Bouquet caption per garden (was "Tulipa" in the forks).

## Security headers (2026-09-11, all three, vercel.json)
- CSP: default-src self; script-src self 'unsafe-inline' 'wasm-unsafe-eval' + unpkg, jsdelivr, cdnjs; style self inline fonts.googleapis; font self data gstatic; img self data blob; media self blob; connect self + unpkg jsdelivr cdnjs storage.googleapis.com (mediapipe model); worker/child self blob; object none; base-uri self; form-action self; frame-ancestors none; upgrade-insecure-requests.
- HSTS 2y preload, nosniff, X-Frame DENY, Referrer strict-origin-when-cross-origin, Permissions-Policy camera=(self) only, COOP same-origin.
- 'unsafe-inline' stays because the whole app is one inline module + importmap; a nonce needs a build step. Vercel preview deployments log ONE CSP violation for vercel.live feedback.js: preview only, ignore.
- Verified MediaPipe wasm + model load under the CSP via console import on the preview.
- minions index.html has description/og/theme-color meta.

## Start screen (2026-09-11, all three)
- #intro overlay (z 20, blur over the live reel), body.intro hides #hud. Buttons data-m drone/free/walk/hands disabled until introReady() (called when the girl GLB resolves or fails, plus a 15s failsafe). 70% bar after fitViewport(). Hands button = setMode('free') + enableHands() inside the click = valid user gesture for the camera prompt.
- Copy per garden in the HTML; CSS/JS identical. Grid 4 cols, 2 cols under 560px, compact under 460px tall.
- Sunflower v4.2: rays 17+14, halfW .105/.095, len .78/.68, tip .86 (were 24+20 wide blunt = solid yellow band around a black cup). Disc RING radii x0.8 (max .37), colours warmer (centre .11/.06/.03, rim .85/.60/.10). Head scale .78. Plaza loop 1000 tries (was 1700). Lesson: distinct countable petals matter more than petal count fidelity.
