from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-07-29T23:23:11Z
poison_base: pr-ebfb-600-ironhorse-rename
poison_signature: deadline-overrun
notice_count: 1
first_seen: 2026-07-29T23:23:11Z
last_seen: 2026-07-29T23:23:11Z
---
POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 DEADLINE-OVERRUN cycles on endolin-garden2-5bcdff64.
Its handler hit its OWN wall-clock budget every cycle (rc=124, elapsed≈GARDEN_HANDLER_TIMEOUT=2400s):
this job EXCEEDS THE HANDLER BUDGET and would be killed identically on every requeue,
so the reaper surfaced it after 1 overrun cycles (not the full 5-cycle poison threshold).
The work is preserved at jobs/plan/pr-ebfb-600-ironhorse-rename; it stays HELD until a human promotes it
(promote-plan.sh pr-ebfb-600-ironhorse-rename) or removes it. Triage: split the job, raise GARDEN_HANDLER_TIMEOUT
for this work, or fix what makes it run long.
Original job base: pr-ebfb-600-ironhorse-rename

--- original job body ---
---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
repo: endojs/endo-but-for-bots
PR: https://github.com/endojs/endo-but-for-bots/pull/600
role: builder
Perform the full architectural rename on PR #600 (branch xs2rust-endor, base llm; keep DRAFT): the new Rust engine is Ironhorse, while Endor is the binding of an engine to a platform, and the existing engine is simply XS (never C-XS in current-facing prose). Rename the complete live code surface accordingly, including Rust crates/modules/types where they denote the engine, Cargo package/dependency names, engine selectors such as endor-rs, CLI help and diagnostics, test labels/fixtures, README/design terminology, generated references, and CI or scripts. Choose names that express the boundary: Ironhorse owns language execution; Endor owns platform binding/integration. Preserve historical job basenames, branch names, commit messages, quoted evidence, and immutable provenance where rewriting would be misleading, but explain any retained transitional identifiers. Update PR title/body to describe Ironhorse and the Endor binding. Use rename-aware moves, update all consumers atomically, prove no unintended live xs2rust/Rust-XS/C-XS/endor-vm naming remains with an explicit search audit, and run the affected Rust, daemon build, CLI smoke, and clean-checkout checks. Do not broaden into remaining test:rust or test262 completion work. Rebase and push with lease/CAS discipline, keep the PR draft, and report the exact before-to-after naming map plus verification.

<!-- garden-deadline-overrun: 1 -->
