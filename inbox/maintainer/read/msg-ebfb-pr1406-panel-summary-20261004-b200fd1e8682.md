from_host: endolin-garden2-5bcdff64
from: gardener:ebfb-pr1406-panel-summary-20261004
reply_to: ebfb-pr1406-panel-summary-20261004
msg_key: msg-ebfb-pr1406-panel-summary-20261004-b200fd1e8682
notice_count: 1
first_seen: 2026-10-04T04:50:54Z
last_seen: 2026-10-04T04:51:18Z
sent_at: 2026-10-04T04:51:18Z
---
endojs/endo-but-for-bots#1406 (pin Claude Code 2.1.280, dontAsk, no builtin plugins): merge-decision summary

https://github.com/endojs/endo-but-for-bots/pull/1406 · draft · head 6bae6af851 · base llm-d4124e6 · mergeable/clean

Panel coverage: the latest head has NOT been panelled. Round 6 reviewed 9e94a3d99d. The two commits after it (094b7b09b fix, 6bae6af85 docs) are the round-6 fix round: about +168/-39 in argv.js plus README, changeset and tests. I read that delta myself. It closes each round-6 item as claimed.
CI: green on 6bae6af85 (lint, test 22.x/24.x on ubuntu and macOS). No inline review threads are open.

Round-6 objections (8 request-changes seats out of 33), and where they stand at head:
- packager, releaser: changeset and README were stale. They now list all nine required flags and every refusal. Closed. (taste/noise from here on)
- breaker: a bare `--` was accepted, and `--allowedTools`/`--disallowedTools` were optional. Now `assertNoEndOfOptions` and both flags are required. Closed. This was must-fix class, and it is fixed.
- corner-prober: `--model --bare` hid a presence-only flag, empty values were accepted, and nothing tested an identical-value repeat. Now `assertPresenceOnlyFlags`, `assertNonEmptyValue`, `assertUncheckedFlagValues` and a property test cover these. Closed.
- wire-watcher: empty `--settings` value. Closed. Its comment-only item, that nothing re-reads the written settings.json for `enabledPlugins` at spawn, is still open. That is FOLLOW-UP-WORTHY: it is disclosed in README § Known gaps, and the harness generates the file itself.
- integrator: Documentation Considerations section was missing. Added. Closed.
- pruner: drop the "None." sections and condense the README prose. Kept on purpose, because the integrator treats a missing heading as blocking. TASTE/NOISE.
- scribe: no completion-summary comment for round 5. Posted. Closed.

Still open, from my own read of the head (no panel seat raised it):
- `assertConfinedArgv` enumerates bad shapes but does not refuse UNKNOWN flags. For example, `--dangerously-skip-permissions`, `--add-dir`, `--plugin-dir` and `--append-system-prompt` all pass the gate. FOLLOW-UP-WORTHY, not must-fix: `buildArgv` is the only producer and never emits them, so the gate is defence in depth. Still, the gate claims to be "the full structural" check, and an allowlist of exactly the emitted flags would close that whole class. That class is what fed six rounds of whack-a-mole.
- Out of scope by design: endojs/endo-but-for-bots#1371 follow-ups 1–4 and 6 (storeIdentifier minting, unpruned catalog, kernel sandbox, credential in memory), already disclosed. minion.town pins 2.1.268, so it fails closed until it gets its own bump.

Bottom line: MERGE AS IS (un-draft, then merge). The six rounds stopped converging because they were finding ever-smaller argv corners, not because the design was wrong. The one sizeable residual, the unknown-flag allowlist, is better as a small follow-up PR than a seventh round. If you want the residual cleared first, the alternative is "merge after a named small fix": add a known-flag allowlist to `assertConfinedArgv`, about 20 lines plus one property test.
