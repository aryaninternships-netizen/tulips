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
- Start screen v2: liquid-glass .card (blur 26 saturate 1.7, inset top highlight, animated sheen ::before), overlay only 10-34% dark so the reel shows, sunrise chip clicked via setTimeout 0 while intro is up, live chip on enter. .about paragraph per garden. Tagline "a digital interactive garden containing these flowers".
- HARD RULE (memory gardens_no_crosslink): the three gardens never link to each other. A "more gardens" row existed for ~20 min and was removed.
- Start screen v3: four mode buttons replaced by one 'Explore garden' pill (enters drone reel on live clock). Modes live in the HUD only.

## Start screen v4, editorial + calligraphy (2026-09-11 evening)
- Card: left-aligned, eyebrow / h1 / italic Fraunces deck / hr / prose / flower line / "Explore the garden →" pill / footnote / 1px loader hairline at the card bottom. Fraunces link now ital,opsz,wght@0,9..144,400..600;1,... Copy is per garden, written in plain human voice (no chips, no monospace status).
- Minions title = "Minion" (Fraunces, letters in <b>) + inline SVG "बगीचा": glyph outlines shaped with uharfbuzz + fontTools from Kalam-Bold (pip --user --break-system-packages), viewBox -40 -1080 3120 1420, plus two hand-authored swash paths (underline loop, headline curl). Path data kept at minions-garden/assets/bageecha_paths.txt. CSS: .hiw height 1.28em, margin-bottom -.38em (baseline sits 24% up the box).
- GSAP 3.12.5 from cdnjs (CSP already allows). Timeline: eyebrow → letters rise (rotateX) → glyph strokes draw (dashoffset) → gold fill → swashes → deck/body/button stagger → looping soft gold drop-shadow. No GSAP = CSS default shows the finished title.
- HUD title "Minion बगीचा" uses Rozha One (Google) for the Hindi span. Tab title "Minion Bageecha".
- Phones (<560px): card centred, .body.short one-liner replaces .body.long, flower line hidden, button stacked. Desktop unchanged.

## Sunflower v5 (2026-09-11 night) - what v4.2 got wrong
- Rays were 7:1 straps with squared tips (tip .86) = dandelion. Real ray floret is ~3:1, lanceolate, pointed, overlapping at the base, separated at the tips. Now 21+16 rays, len .70/.58, halfW .118/.10, tip 1, curl -.09/-.04 (slight droop back), cup .05, jit .14.
- whorl() got `jit`: per-petal hash jitters angle (+-0.6*jit rad), length (+-0.8*jit), curl. Use it on anything that looked stamped.
- Disc notch/heart: the inner ray row had y0 .03 + spread 85 and poked up through the dome rim. Inner row now flat (y0 0, spread 90). Floret contrast k 0.90-1.06.
- Head diameter was ~34% of plant height (g.scale .78). Now g.scale .58 = ~23% (garden cultivar). Stem r .042, greens .09/.21/.07. Leaves L .85-.45, W .78-.44, NU 6 cordate outline (lobes peak at 28%, long taper).
- Shader: per-instance hash from instanceMatrix translation: yaw +-15 deg, nod +-12 deg pivoting at y 3.52 (LIFT+0.07). Without this every head nodded identically = wall of clones.
- Verified at noon: path view, eye level from the east, under the heads.

## SEO / AEO, minions ONLY (2026-09-11 night). User: "SEO only for minionbageecha.in". khushi + tulips reverted, do not add SEO there.
- Head: title with keywords, description, canonical, robots max-image-preview, author, keywords, app/PWA metas, OG (site_name, locale en_IN, image 1200x630 + alt) + Twitter summary_large_image, icons (assets/favicon.png, icon-192/512, apple-touch-icon), manifest.webmanifest, preconnects to fonts/unpkg/jsdelivr/cdnjs.
- JSON-LD @graph: Person (Aryan Singh), WebSite, WebApplication (EntertainmentApplication, free, featureList), FAQPage (7 Q/A). Same Q/A appear on the page in #about (hidden until "About this garden" link in the intro footer, or #about in the URL; Esc/click-out closes).
- HUD title is now <p class="brand"> so the intro h1 is the only h1 (noscript has its own, fine).
- Root files: robots.txt (allows all + GPTBot/ClaudeBot/PerplexityBot/Google-Extended, Sitemap line), sitemap.xml (with image), llms.txt (definition, contents, controls, FAQ), manifest.webmanifest.
- OG image: captured IN the pane. Method: window.R/SCENE/CAM handles; R.setSize(1200,630,false) + R.render(SCENE,CAM) + 2D canvas drawImage right after (preserveDrawingBuffer is false, same task is fine) + text via page fonts + fetch POST no-cors to a local python receiver (scratchpad og_receiver.py on 127.0.0.1:9977). For a composer-faithful frame hook R.render and grab when getRenderTarget()===null. Best minions frame: noon, dronePos (0,13,62), look(PI, -0.24).
- Camera convention, EMPIRICAL: camera.rotation.y = yaw + PI, three faces -z at rotation.y 0. So DBG.look(PI) faces -z, look(0) faces +z, look(PI/2) faces +x, look(-PI/2) faces -x. Earlier log lines saying the opposite were wrong.
- Sunflower v5.1: rays 24+18 halfW .14/.125 (no gaps), disc radius .30 (43% of head), warmer browns, face rotateX(-1.62) = ~3 deg below horizontal (was tilted 33 deg UP, which read as dark eyes from a drone).
- Still to do by user: Google Search Console verification + submit sitemap; Bing Webmaster.
- Sunflower v5.2: g.scale .72 (head ~28% of plant), rotateX -1.75 (10 deg below horizontal), stem r .05, plaza 1400 tries. v5.1's .58/level heads were correct but read as specks from a drone; garden impact needs the big cultivar. Captures: scratchpad sunflower_*.jpg via window.grab hook (tab must be FRONTED or rAF pauses and the hook never fires).

## Sunflower v5.8, the settled state (2026-09-11 ~20:45). Read this before touching sunflowers again.
Proportions come from the plant, NOT from whichever screenshot the user sent last (that loop cost 8 iterations today):
- head diameter = 25% of plant height (g.scale .62 with ray len .72); disc = 50% of head (RING max r .36, green back disc .43).
- rays 22 + 16, halfW .12/.11, tip .95, NU 5 NV 3, jit .05, curl -.03/-.02: dense overlapping ring, clean pointed tips, no sawtooth.
- face rotateX(-1.25) = 18 deg ABOVE horizontal (ornamental habit) so both a drone and a walker see the face; level or downward faces looked like edge-on slivers from the air.
- heliotropism damped: yawH = uEastYaw + (uSunYaw-uEastYaw)*0.35*(1-age) + hash*0.35. Full tracking left ~40% of heads sideways at any hour.
- s: [1.45, 1.72] (one sowing = flat canopy). Varied heights showed stems between heads from the air.
- sunStemG: r .05, 8 cordate leaves L 1.10-.60 W .95-.50 from 14% to 80% of the stem (leafy plant = green canopy, not a stem hedge).
- plaza: 1900 tries on r 24-41, cap 2000, mobile keeps 80%.
- "east" in this world is -x (sunrise side): faces point toward -x. Camera on the -x side facing +x (DBG.look(PI/2)) sees faces.
- Verified renders: eye level (-36,8.2,2) look(PI/2,-.05) at noon; drone (-52,24,4) look(PI/2,-.62) noon + sunset.

## Sunflower FINAL (2026-09-11 ~21:15) - the real root cause, after 10 failed iterations
THE BUG was in whorl(), not in any parameter: `w = pow(sin(PI * min(u*1.12, tip)), 0.72)`
peaks at u=0.45 and tapers to 0 at the tip. A sunflower's petal base is HIDDEN UNDER
THE DISC (disc r 0.30 of head r 0.72, i.e. u<0.45), so the only visible part was the
tapering half = a triangle. Every "fix" that widened halfW just merged the triangles
into one solid yellow plate. Real ray florets are STRAPS: near-constant width, blunt tip.
FIX: whorl() now takes `wexp` (default 0.72, unchanged for every other species).
wexp 0.34 flattens the curve: width is ~85% at u=0.2, 100% at u=0.45, ~70% at the tip.
Settled sunflower numbers (do not "improve" without rendering a close-up first):
- rays: 15 @ len .72 halfW .105 spread 88 + 13 @ len .62 halfW .10 spread 84 az0 .209,
  both tip .88 wexp .34 jit .03 cup .05, NU 5 NV 3.
- petal colour: rgb [.93,.66,.05] shade0 .86 (outer) / [.90,.60,.04] shade0 .90 (inner).
  High shade0 = EVEN gold; low shade0 blew the tips to cream at noon.
- disc: 8 rings to r .30, small green core (r<.055), hard edge at .070 into chocolate,
  wide warm rust band, bright pollen rim at .285, tuck-under at .30.
- head g.scale .74, rotateX(-0.88) = 40 deg above horizontal, stem r .042.
Reference used: user's close-up photo + a Pinterest grid. Open the reference FIRST.
Verified: close-up 2.2u off the face, eye level, drone at (52,24,4) look(-PI/2,-.62).

## Minion Bageecha moved to the aryaninternships Vercel account (2026-09-11 ~21:00)
- WAS: team aryansingh-8099s-projects, project "minions-garden" (that project still exists there, now domainless; user may delete it).
- NOW: team aryaninternships-netizens-projects (aryaninternships@gmail.com, same identity as the GitHub rule),
  project "minion-bageecha" prj_tSavWQRqcIFNS4Wn9wxPrIQcxRPV / team_wWV3CyrH9ojFNXCEnvPFcdN5.
  Sibling projects there: duo-space, lenz.
- Domain move needs NO DNS change: every Vercel project uses the same apex IP 76.76.21.21.
  Sequence: DELETE /v9/projects/{old}/domains/{d} (both apex + www) -> DELETE /v6/domains/{d} (release from the
  old ACCOUNT, this step is the one people miss) -> POST /v10/projects/{new}/domains. Verified instantly, cert in <1 min.
- Token is a project token (vcp_...): `vercel whoami` returns "Not authorized" but teams/deploy/API all work. Do not
  conclude the token is bad from whoami. Stored in macOS Keychain: service "vercel-aryaninternships".
- ~/minions-garden/deploy.sh: one command = stamp build time, commit, push to GitHub (inline aryaninternships token),
  vercel deploy --prod with the Keychain token, then print the live build stamp. Use this instead of the manual dance.
- "Deploy didn't work" was actually browser cache: vercel.json now sends
  Cache-Control: no-cache, no-store, must-revalidate for "/" and "/index.html" (the whole app is in that one file).
  The visible build stamp under "About this garden" is the ground truth for which version a device has.
- Sunflower v10 (final): the last two defects were (a) the disc ramp went bright gold from
  r=0.19, so only 26% of the head read brown = rudbeckia, not a sunflower. Brown now runs to
  r=0.28 of 0.33 with one thin pollen rim at 0.315. (b) every head faced ONE compass direction,
  so from any viewpoint a whole arc of the ring was edge-on and rendered as thin yellow brooms.
  Heads now face radially OUT from the plaza centre: `float outward = atan(-wp0.x, -wp0.z);`
  (display-bed planting), young ones still lean toward the sun. Tilt 22 deg above horizontal
  (rotateX -1.19): 40 deg looked edge-on to anyone standing a few metres away. Petals 14+12,
  halfW .132/.126, spread 79/75 (cupped forward so an edge-on head still has body).
- Stale-build detector (2026-09-11 21:08): /version.json holds the same stamp deploy.sh writes
  into index.html. The page reads its own stamp from #build, fetches version.json with
  cache:'no-store' 4s after load, every 5 min, and on visibilitychange; on a mismatch it slides
  up a "A newer version of the garden is live / Refresh" toast. Refresh (and the "Clear cache and
  reload" button in the About sheet) deletes every Cache Storage entry, unregisters any service
  worker, clears sessionStorage, then reloads with a ?v=<epoch> the browser has never cached and
  strips that param back out via replaceState. version.json is no-store in vercel.json, otherwise
  the freshness check would itself go stale. deploy.sh writes both stamps, so they cannot drift.

## Sunflower, the two bugs that caused 10 rounds of "still wrong" (2026-09-11 21:2x)
Both were only visible once I framed ONE head filling the screen (window.aim below). Do that FIRST.
1) whorl() built every petal from the AXIS outward. A composite flower's ray florets attach at the
   DISC RIM. With 14+ petals all starting at r=0 their bases overlapped ~5 deep, folded over each
   other into crumpled cones, and buried the disc. Fix: whorl option `inner` = radius where the
   petal starts (default 0, every other species unchanged). Sunflower uses inner .29/.27.
   With `inner` set, wexp goes back up to .55 (narrow at attachment, widest mid, blunt tip = a real
   ligule). wexp .34 was a workaround for the wrong bug and made the crumpling worse.
2) The radial-facing term had the sign inverted: `atan(-wp0.x,-wp0.z)` points heads INWARD, so from
   anywhere outside the ring every head showed its green receptacle. Correct is `atan(wp0.x, wp0.z)`.
   My derivation said otherwise; the render is the authority. VERIFY FACING BY RENDERING, not algebra.
Settled: rays 16 @ len .78 halfW .100 spread 75 inner .29 + 14 @ len .68 halfW .094 spread 70
inner .27, both tip .92 wexp .55 jit .04 cup .045. Disc r .33, brown to the rim, thin pollen ring.
Camera helper that made this findable (paste in console):
  window.aim=(sf,D)=>{const T=G3.THREE,r=Math.hypot(sf.x,sf.z),ox=sf.x/r,oz=sf.z/r,
  ch=Math.cos(0.384),sh=Math.sin(0.384),head=new T.Vector3(sf.x,sf.y+3.52*sf.scale,sf.z),
  cam=head.clone().addScaledVector(new T.Vector3(ox*ch,sh,oz*ch),D);DBG.dronePos.copy(cam);
  const d=head.clone().sub(cam).normalize(),p=Math.asin(d.y),cp=Math.cos(p);
  DBG.look(Math.atan2(d.x/cp,d.z/cp),p);};
CAMERA AIMING (this cost time too): camera forward is (cos p * sin yaw, sin p, cos p * cos yaw),
so yaw = atan2(d.x, d.z) and pitch = asin(d.y). The `fwd` vector in updateCamera's WASD code is the
horizontal NEGATIVE of this - do not copy it for aiming. Confirm with head.project(CAM) -> ndc 0,0.
