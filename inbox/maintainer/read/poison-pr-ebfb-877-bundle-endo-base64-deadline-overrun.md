from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-08-01T11:53:40Z
poison_base: pr-ebfb-877-bundle-endo-base64
poison_signature: deadline-overrun
notice_count: 1
first_seen: 2026-08-01T11:53:40Z
last_seen: 2026-08-01T11:53:40Z
---
POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 DEADLINE-OVERRUN cycles on endolin-garden2-5bcdff64.
Its handler hit its OWN wall-clock budget every cycle (rc=124, elapsed≈GARDEN_HANDLER_TIMEOUT=2400s):
this job EXCEEDS THE HANDLER BUDGET and would be killed identically on every requeue,
so the reaper surfaced it after 1 overrun cycles (not the full 5-cycle poison threshold).
The work is preserved at jobs/plan/pr-ebfb-877-bundle-endo-base64; it stays HELD until a human promotes it
(promote-plan.sh pr-ebfb-877-bundle-endo-base64) or removes it. Triage: split the job, raise GARDEN_HANDLER_TIMEOUT
for this work, or fix what makes it run long.
Original job base: pr-ebfb-877-bundle-endo-base64

--- original job body ---
---
tier: minion
model-burned: mentor mentor
fallback-tier: 
dispatch: automatic
---
repo: endojs/endo-but-for-bots
PR: https://github.com/endojs/endo-but-for-bots/pull/877
inline review comment: https://github.com/endojs/endo-but-for-bots/pull/877#discussion_r3678862624
role: fixer
Address the inline CHANGES_REQUESTED feedback on rust/endo/xsnap/src/lib.rs: get substantially more leverage from the existing @endo/base64 implementation through bundling instead of duplicating base64 behavior in Rust. Inspect the surrounding dual-build execution and text-endowment boundary, choose a bundle/interface that preserves confinement, deterministic startup, error semantics, byte/text distinctions, and clean-checkout reproducibility, and minimize bespoke Rust codec logic. Reuse shared fixtures or parity assertions so @endo/base64 remains the behavioral oracle, including valid encodings, malformed input, padding/alphabet edge cases, and relevant SES/XS behavior. Rebase before an additive review-feedback commit, run affected Rust/JS tests and canonical lint, push with CAS discipline, reply in the inline thread with the change and evidence, update the PR completion summary, and keep the PR draft until its normal gauntlet completes.


<!-- garden-deadline-overrun: 1 -->
