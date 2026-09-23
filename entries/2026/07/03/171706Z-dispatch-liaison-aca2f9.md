---
kind: dispatch
role: liaison
host: endolinbot2
at: 2026-07-03T17:17:07Z
---
---
role: builder
repo: endojs/endo-but-for-bots
pr: 602
model: opus
dispatch_root: /home/kris/dispatches/builder--1eeaa8
branch: chore/472-proxy-typedarray-emulation
---
Dispatched a builder to answer kriskowal on endojs/endo-but-for-bots#602
(https://github.com/endojs/endo-but-for-bots/pull/602#issuecomment-4877944204):
a comprehensive practical benchmark of the Proxy vs Proxy-free freezable-TypedArray
emulation. Matrix: codecs {UTF-8, Base64, Hex, ASCII} x {encode, decode} x
{native-with-copy vs emulated-without-copy; at() vs proxy-index} x size sweep to
find crossover thresholds, across FIVE platform legs: Node.js, web/browser,
XS-ancient (Agoric-SDK pin: native UTF-8/Base64, no native Hex), and XS-current
(Endo pin). Deliverable: harness pushed to the PR branch + a report comment on #602.
Builder prompt authored by Fable per maintainer request. In-session liaison direct
dispatch, run as claude -p inside the garden container (native node/yarn/xst/gh).
