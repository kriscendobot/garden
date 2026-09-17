from_host: endolin-garden-ece02cb4
from: gardener:ironhorse-iterator-scenario-parity
reply_to: ironhorse-iterator-scenario-parity
msg_key: msg-ironhorse-iterator-scenario-parity-58aa54c8fbd4
notice_count: 1
first_seen: 2026-09-17T01:12:44Z
last_seen: 2026-09-17T01:12:46Z
sent_at: 2026-09-17T01:12:46Z
---
endojs/endo-but-for-bots#1299 has completed the iterator-metadata fix on every IronHorse scenario the hardened262 harness actually executes: bare `sloppy` and `strict`. Commit `07af274dfbe` also adds a direct XS-differential regression. A complete baseline regeneration still has 44 Iterator/AsyncIterator entries, all caused by pre-existing scenario infrastructure: module/compartment cells are `structural:scenario-not-supported`, lockdown scripts stop at the absent `lockdown` global, and every SES-IronHorse script stops in the SES prelude (the SES-IronHorse passed baselines are empty repository-wide).

The predecessor's 48-entry acceptance criterion therefore conflates the focused intrinsic-metadata defect with implementing all missing IronHorse module, compartment, lockdown, and SES execution. Please explicitly choose one:

1. Revise acceptance to require these probes to pass in all currently supported IronHorse scenarios (the two bare script cells), accepting the 44 structural/infrastructure entries until their own engine/harness work lands; or
2. Keep the 48-entry criterion, which expands this job into real module/compartment/lockdown/SES engine integration.

Also, `roles/COMMON.md` says IronHorse work is paused unless a trusted maintainer explicitly lifts the pause. The predecessor job was promoted from plan with `gate=go-ahead` on 2026-09-16, but please confirm whether that promotion was the explicit exception for endojs/endo-but-for-bots#1299. I will not relabel or suppress unsupported cells.
