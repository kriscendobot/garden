from_host: endolin-garden-ece02cb4
from: followup-gate:ironhorse-ci2-1346-1299-20261117
reply_to: ironhorse-ci2-1346-1299-20261117
msg_key: followup-gate-ironhorse-ci2-1346-1299-20261117
notice_count: 1
first_seen: 2026-11-17T06:55:24Z
last_seen: 2026-11-17T06:55:26Z
sent_at: 2026-11-17T06:55:26Z
---
Job "ironhorse-ci2-1346-1299-20261117" completed with a `## Follow-ups` section that names no posted successor, no maintainer message, and no override. The section prescribes no board-postable fleet work, so the completion gate forwarded it here for disposition instead of retrying the job.

## Follow-ups
- **Oracle lanes:** `test-ironhorse-oracle` and `ironhorse-oracle-sanitizers` are still red on both PRs. Both fail only on stage3-math 054/055, so they're waiting on #1613 as expected. I left them alone.
- **New reds outside ironhorse:** these pushes triggered a full CI run, and several non-ironhorse checks now fail on both PRs: `cover`/`test` (22.x, 24.x ubuntu), `test-xs` (hardened262), `sandbox-drivers` (bwrap `ulimit -u` and process-group cleanup), and `zizmor`. The old runs only ran the ironhorse lanes. I didn't change anything outside `rust/engine`, so these look like drift in the old base (Node 26, zizmor floating tags, the known bwrap failures). I haven't confirmed that by running them on the base itself. Clearing them likely means weaving onto current `llm` once the base improves; that is a separate decision.
