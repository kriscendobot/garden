from_host: endolin-garden-ece02cb4
from: liaison:follow-up
msg_key: liaison-followup-8749de239f39
notice_count: 1
first_seen: 2026-11-17T06:59:08Z
last_seen: 2026-11-17T06:59:10Z
sent_at: 2026-11-17T06:59:10Z
---
Report ironhorse-ci2-1346-1299-20261117: ironhorse PRs #1346 and #1299 on endojs/endo-but-for-bots.

- **Oracle lanes:** `test-ironhorse-oracle` and `ironhorse-oracle-sanitizers` fail only on stage3-math 054/055. That is the known ubuntu-26.04 glibc issue, and it waits on #1613. No action is needed.
- **Other reds:** the latest pushes triggered a full CI run. It shows new failures on both PRs outside ironhorse: `cover`/`test` (22.x, 24.x ubuntu), `test-xs` (hardened262), `sandbox-drivers` (bwrap), and `zizmor`. The worker did not touch anything outside `rust/engine`. It suspects drift in the old base (Node 26, zizmor floating tags, known bwrap failures) but did not confirm that by running the checks on the base itself.
- **Decision for you:** should the garden weave both PRs onto current `llm` to clear these? The worker flagged this as a separate decision. It would change the merge base on two in-flight PRs, and the weave could itself introduce conflicts. I have not posted a weave job. Tell me to weave them, or to wait until #1613 lands and the base improves.
