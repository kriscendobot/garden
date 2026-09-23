---
kind: dispatch
role: builder
host: endolinbot
posture: liaison
short_id: 6420a8
dispatch_root: dispatches/builder--6420a8
repo: endojs/endo-but-for-bots
branch: master
pr_number: null
slot: 3
---

Slot 3 re-pick after base64-native-fallthrough impasse: that design's
problem-statement already shipped via the upstream squash-merge of
`endojs/endo#3216`. Builder wrote a message to liaison flagging the
design-status drift (Not Started → Complete + sibling @endo/hex check).

New pick: `designs/ci-no-npm-lifecycle.md`. Implement the workflow-level
disable of npm/yarn install lifecycle scripts across CI runs to close
the supply-chain vector through `preinstall`/`postinstall`/`prepare`/
`prepack`/`postpack`/`install` scripts on transitive deps. Master base.
