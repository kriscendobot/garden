---
role: designer
---

# design: Google Sheet pubsub (Drive files.watch push notification)

Follow-up requested by @kriskowal in review of endojs/endo-but-for-bots PR #612
(design/exo-google-sheets). Propose a design for **Google Sheet pubsub**:
push-based change notification for a Google Sheet, delivered via the Drive API
`files.watch` channel model over the endoclaw-webhooks gateway substrate,
plugging in behind the `follow(range)` async-iterator contract that
`designs/exo-google-sheets.md` already defines (polling is the v1
implementation; this is the push phase).

Cover: channel lifecycle (channels expire and must be re-armed), delivery
fan-out to multiple followers, the read-to-learn-what-changed step (Drive watch
says *that* a file changed, not *what*), and the sheet-as-queue motivation
(appendOnly() producers, readOnly()/follow() consumers). Decide whether this is
a mode of exo-google-sheets or its own package/design shared by all
Drive-family watchers. Repo: endojs/endo-but-for-bots. Reference:
designs/exo-google-sheets.md (Resolved Question 2), designs/endoclaw-webhooks.md.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 13
  claimed_at: 2026-07-07T00:12:03Z
