---
kind: dispatch
role: fixer
host: endolinbot
posture: liaison
short_id: 8d3e8c
dispatch_root: dispatches/fixer--8d3e8c
repo: endojs/endo-but-for-bots
branch: feat/narrow-bytearray-to-uint8
pr_number: 475
model: haiku
---

Fix CI lint failure on PR #475: composite tsconfig drift in
`packages/bytes/tsconfig.composite.json` and
`packages/pass-style/tsconfig.composite.json`. The prior builder
moved deps between the two packages but didn't regenerate composite
tsconfigs. Fix: `yarn build:types:gen`, commit, force-push.
