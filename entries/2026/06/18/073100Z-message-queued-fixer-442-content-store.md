---
ts: 2026-06-18T07:31:00Z
kind: message
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 442
    role: subject
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/442#discussion_r3433946262
  - https://github.com/endojs/endo-but-for-bots/pull/442#pullrequestreview-4522672586
---

# queued: fixer for #442 content-store relocation (kriskowal CHANGES_REQUESTED)

kriskowal at 07:29:39Z submitted CHANGES_REQUESTED review (id
4522672586, empty body) with one inline ask at id 3433946262
on `packages/daemon-cas/src/content-store.js`:

> This belongs in the daemon proper since it encodes
> configuration opinions not specific to the CAS implementation.

Added 👀 reactji on the inline comment (id 403905645).

## Why queued, not folded into shepherd f9204c

Shepherd `f9204c` is in flight on #442's CI failures. A
fixer addressing the inline ask would push to the same branch
(`feat/daemon-cas-extraction`) — append-only push means the
second pusher races and gets non-fast-forward-rejected.
Sequencing avoids the race.

## Fix shape

Some code currently in `packages/daemon-cas/src/content-store.js`
encodes daemon-specific configuration opinions and should be
relocated to `packages/daemon/src/` (or similar daemon location).
The fixer should:
- Read the cited content-store.js to identify the
  configuration-opinion code (likely a default content-store
  path, max-bytes limit, or similar).
- Move that code to the daemon proper.
- Update the daemon-cas content-store to accept the
  configuration as a parameter (factory pattern).
- Update the daemon's wiring to pass the config in.
- Reply inline on comment 3433946262 confirming the fix +
  citing the new commit SHA.

## Next-tick action

After shepherd `f9204c` returns:
- If shepherd touched content-store.js: review for conflict
  shape, may need to rebase or fold.
- If not: dispatch fixer with the brief above.
