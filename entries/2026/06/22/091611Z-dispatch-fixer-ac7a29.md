---
kind: dispatch
role: fixer
host: endolinbot
posture: liaison
short_id: ac7a29
dispatch_root: dispatches/fixer--ac7a29
repo: endojs/endo-but-for-bots
branch: feat/narrow-bytearray-to-uint8
pr_number: 475
model: haiku
---

Fix CI lint failure on PR #475: Prettier flagged
`packages/patterns/src/patterns/patternMatchers.js` after the prior
builder's "fix: pre-push gate cleanup" commit touched that file's
inline-import JSDoc. Run `yarn format`, commit, force-push with
lease anchor 820601d1d.
