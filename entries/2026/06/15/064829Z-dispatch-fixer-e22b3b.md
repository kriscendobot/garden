---
ts: 2026-06-15T06:48:29Z
kind: dispatch
role: fixer
host: endolinbot
repo: kriscendobot/agoric-sdk
project: agoric-sdk
to: "*"
dispatch_root: /home/kris/dispatches/fixer--e22b3b
short_id: e22b3b
prs:
  - { repo: kriscendobot/agoric-sdk, pr: 5, role: target }
refs:
  - https://github.com/kriscendobot/agoric-sdk/pull/5
  - https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4702277125
  - https://github.com/kriscendobot/agoric-sdk/pull/5#discussion_r3411327956
  - https://github.com/kriscendobot/agoric-sdk/pull/5#discussion_r3411330424
---

# dispatch: fixer — rsvp kriscendobot/agoric-sdk#5 "Continue": apply LogStore + Bijection hand-written typedefs

kriskowal posted "@kriscendobot Continue." at 2026-06-14
15:56Z, approving the bot's review-thread replies (2026-06-15
06:04-06:05Z) committing to:

1. `packages/async-flow/src/log-store.js:278` — replace
   `@typedef {any} LogStore` with hand-written 13-property
   typedef (consumer-side surface enumerated by `LogStoreI`).
2. `packages/async-flow/src/bijection.js:215` — replace
   `@typedef {any} Bijection` with hand-written 7-property
   typedef (consumer-side surface enumerated by `BijectionI`).

The bot's own reply explicitly scopes broader call-site
narrowing AS A SEPARATE Endo-upgrade hygiene task — NOT in
this dispatch. Only the two hand-written typedefs land here.

PR #5 base `master-57c6564`, head
`mirror/12527-endo-sync-refresh` sha b0c0d727ee, DRAFT.
