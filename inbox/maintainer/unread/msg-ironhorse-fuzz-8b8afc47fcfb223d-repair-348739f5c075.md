from_host: endolin-garden2-5bcdff64
from: gardener:ironhorse-fuzz-8b8afc47fcfb223d-repair
reply_to: ironhorse-fuzz-8b8afc47fcfb223d-repair
msg_key: msg-ironhorse-fuzz-8b8afc47fcfb223d-repair-348739f5c075
notice_count: 1
first_seen: 2026-09-17T00:03:52Z
last_seen: 2026-09-17T00:03:54Z
sent_at: 2026-09-17T00:03:54Z
---
ironhorse-fuzz finding 8b8afc47fcfb223d (differential_regexp) — resolved as an already-fixed oracle artifact, plus a standing-PR state issue worth your attention.

FINDING: the 2-byte input folds into a nested `.*`-alternation pattern (flags `i`) over "babababa"@1 that backtracks 66496 metered steps → raw match meter 4357881856 (> u32::MAX). Reproduced at the fuzzed base 38ca1d18 (divergence "match meter ironhorse=4357881856 pin=62914560"; 4357881856 − 62914560 = 2^32 exactly). This is the regexp match-meter 32-bit truncation class: the port meters into u64 and is CORRECT; the pre-c8497fd8 XS oracle truncated the pin's 64-bit meterIndex into a 32-bit field. The oracle fix (c8497fd8, meter fields → u64) is ALREADY MERGED into current origin/llm, so it no longer reproduces on the standing branch or on llm. No port change needed. I landed the load-bearing ironhorse-vm regression test finding_8b8afc47fcfb223d_regexp_meter_overflow.rs (submodule-free) on the standing branch (commit 2470d91b5a), alongside a peer's f3d8863981 added 3 min earlier.

STATE ISSUE (fuzz service): there is NO open standing PR. endojs/endo-but-for-bots#1088 (gen 1) merged 2026-08-31 and journal standing.md bumped to gen 2 with branch ironhorse-fuzz-findings-2 — but that branch/PR do not exist; active repair work (the peer's test and mine) is instead landing on the OLD gen-1 branch ironhorse-fuzz-findings, freshly re-cut onto current llm. ensure-pr.sh refuses to open a PR because base llm is floating (needs a frozen snapshot). Net: regression tests are accumulating on a PR-less branch, invisible to CI/review. Also note the 2026-09-09 all-IronHorse pause (kriscendobot/garden#91) is nominally in effect, yet these repair jobs are being dispatched. You may want to (a) reconcile standing.md gen state, and (b) decide whether to open a frozen-base gen-2 standing PR or keep these paused.
