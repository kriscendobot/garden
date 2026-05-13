---
title: Unreal logging
source: docs/errors.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-13
ingested_by: liaison
topics: [errors, hardened-javascript]
status: current
notes: Speculative; describes an alternative model where logging exists only under offline deterministic replay.
---

> Abstract: A speculative model where "real" computation never logs; logging happens only under instrumented deterministic replay of recorded traces. No side tables means no memory pressure; no examination of logged objects means no communications-channel risk. On-chain determinism rules need no logging carve-out because there is no on-chain logging.

## Unreal logging

For deterministically replayable computation, we could support the full debugging experience even if the "real" computation never logs anything. Such a no-op logging system would not need any side tables, and so has no problem with side table memory pressure. Such a no-op logging system never examines logged objects, and so does not create a communications channel. Instead, all logging only happens offline, under instrumented deterministic replay, and only for computation containing a mystery to be diagnosed. Under this scenario, even expensive instrumentation may be very affordable. Under this scenario, if Alice gives Bob enough information to deterministically replay the relevant chain A computation, she's effectively given Bob all the logging information he could ever want. Under this scenario, no mechanism is needed to exempt logging output for on-chain determinism rules, since there would be no on-chain logging output.

Source: [docs/errors.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/errors.md) at commit `fe81477b`.
