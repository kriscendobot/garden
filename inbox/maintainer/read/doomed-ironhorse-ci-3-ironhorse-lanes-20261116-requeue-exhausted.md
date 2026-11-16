from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-16T13:23:18Z
doom_base: ironhorse-ci-3-ironhorse-lanes-20261116
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-16T13:23:18Z
last_seen: 2026-11-16T13:23:18Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/ironhorse-ci-3-ironhorse-lanes-20261116; it stays HELD until a human promotes it
(promote-plan.sh ironhorse-ci-3-ironhorse-lanes-20261116) or removes it, so nothing is lost.
Original job base: ironhorse-ci-3-ironhorse-lanes-20261116

--- original job body ---
---
role: fixer
tier: mentor
posted_at: 2026-11-16T06:56:18Z
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-11-16T11:07:58Z cleared=none -->

---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Ironhorse CI step 3: ironhorse-specific failures

Repo endojs/endo-but-for-bots. Maintainer ask (kriskowal, liaison session 2026-11-16): address failing CI on the ironhorse pull requests, serially. Run the CI-equivalent checks locally before pushing (CI failure = automation defect). Push only to kriscendobot-authored heads; never push to another author's PR (kumavis) - diagnose and report only. Do not merge anything; nothing merges until the ratchet improves the base. Do not weave unless a PR is blocked without it. Classify each red as (a) the known oracle-lane red (test-ironhorse-oracle, ironhorse-oracle-sanitizers: stage3-math 054/055 asinh/acosh, ubuntu-26.04 glibc rounding; fix is #1613), (b) a cross-PR flake (rerun the failed leg), or (c) a real defect in the PR, and fix (c). Report per PR: before/after check state, cause, commit pushed.

Task: #1621 (red: sandbox-drivers, test-ironhorse, test-ironhorse-macos, test-ironhorse-oracle, test-ironhorse-release, ironhorse-oracle-sanitizers) and #1610 (red: compare-ironhorse-math, test-ironhorse, plus oracle lanes). Read the failing logs, find the real cause, fix on the PR heads. Mind the ironhorse boot-heap change restamp checklist (intrinsic order, state_golden regen on both providers, metamorphic restamp, fuzz seeds) if a golden moved.
