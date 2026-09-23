from_host: oros-studio-garden-ce242c49
from: gardener:ironhorse-fuzz-fd8517d5f3071227-repair
reply_to: ironhorse-fuzz-fd8517d5f3071227-repair
msg_key: msg-ironhorse-fuzz-fd8517d5f3071227-repair-6602bc26dcbd
notice_count: 1
first_seen: 2026-09-17T01:07:09Z
last_seen: 2026-09-17T01:08:15Z
sent_at: 2026-09-17T01:08:15Z
---
BLOCKED / recommend DROP: job `ironhorse-fuzz-fd8517d5f3071227-repair` (target differential_regexp).

I claimed this on follower host oros-studio-garden-ce242c49 and found three hard blockers; I did NOT build, reproduce, or push any engine change.

1. STANDING PAUSE. context/operations/ironhorse-fuzz.md + kriscendobot/garden#91 (2026-09-09): the garden "does not run or advance any IronHorse work until a trusted maintainer explicitly lifts the pause." Units are in PAUSED_UNITS; the backlog migration never ran (empty manifest). Repairing the engine + amending the standing PR would advance paused IronHorse work. (This legacy job was promoted from plan gate=go-ahead on 2026-09-16 — that go-ahead conflicts with the still-active pause; only you can reconcile that.)

2. INFEASIBLE ON THIS HOST. This is a follower, not the leader (endolin-garden-ece02cb4). No cargo-fuzz, no nightly-2026-08-15, no project checkout under GARDEN_STATE, no c/moddable oracle build. The durable reproducer artifact is on the leader's garden2 host. The spec's own step 3 says: if it cannot be reproduced at the pinned SHA, report and STOP. I cannot reproduce here within budget.

3. STALE GENERATION. Standing PR has rolled to generation 2 (branch ironhorse-fuzz-findings-2); this job targets the gen-1 branch/marker ironhorse-fuzz-findings, which no longer receives amendments. This ironhorse-fuzz-<id>-repair job is the legacy shape the triage-and-batch backlog migration is meant to supersede.

Finding is NOT lost: journal/ironhorse-fuzz/findings/fd8517d5f3071227.md durably records it (input_base64 verified, sha256 matches). When the pause lifts and the migration runs, the triage-and-batch pipeline takes custody of the backlog including this id.

Recommendation: DROP this job (and any sibling legacy ironhorse-fuzz-*-repair jobs) from the board; let the triage/backlog pipeline own these findings once IronHorse is unpaused. If you instead want this specific finding repaired now, it must run on the LEADER host with the pause explicitly lifted for it.
