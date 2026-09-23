---
ts: 2026-06-03T01:29:00Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
short_id: 765f0b
prs:
  - { repo: endojs/endo-but-for-bots, pr: 392, role: target }
refs:
  - entries/2026/06/03/012419Z-dispatch-fixer-765f0b.md
  - https://github.com/endojs/endo-but-for-bots/pull/392
  - https://github.com/endojs/endo-but-for-bots/issues/406
---

# result: fixer — #392 hack ack + issue #406 filed (no restack needed)

- #392 addressing SHA: `ee8297f0c`
- New follow-up issue: endo-but-for-bots#406 "OCapN/Noise:
  accept pre-read frames at session init (gateway hack carrier)"
- Review-thread reply: pull/392#discussion_r3345408045
- Top-level summary: pull/392#issuecomment-4608309253
- Restack NOT needed (comment-only commit). Successor PRs
  #393-#397 will rebase onto new #392 head as part of
  subsequent dispatches.

Issue #406's body identifies the OCapN/Noise refactor scope:
`packages/ocapn-noise/src/network.js:handleIncoming` does its
own `readFrame(stream.reader)` for the SYN; the bindings layer
already accepts pre-read SYN via `responderReadSynWriteSynack`,
so only network + exo layers need parallel shapes.

## Liaison disposition

Dispatch root torn down. Layer #392 settled. Next layer
#393 dispatched as fixer-bf3051 — Uint8Array sweep +
types.d.ts move across #393-#397.
