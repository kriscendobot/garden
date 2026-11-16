from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-16T08:03:20Z
doom_base: ironhorse-ci-1-oracle-fix-20261116
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-16T08:03:20Z
last_seen: 2026-11-16T08:03:20Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/ironhorse-ci-1-oracle-fix-20261116; it stays HELD until a human promotes it
(promote-plan.sh ironhorse-ci-1-oracle-fix-20261116) or removes it, so nothing is lost.
Original job base: ironhorse-ci-1-oracle-fix-20261116

--- original job body ---
---
role: shepherd
tier: mentor
posted_at: 2026-11-16T06:56:17Z
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-11-16T07:00:47Z cleared=none -->

---
role: shepherd
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Ironhorse CI step 1: get the oracle-lane fix #1613 ready

Repo endojs/endo-but-for-bots. Maintainer ask (kriskowal, liaison session 2026-11-16): address failing CI on the ironhorse pull requests, serially. Run the CI-equivalent checks locally before pushing (CI failure = automation defect). Push only to kriscendobot-authored heads; never push to another author's PR (kumavis) - diagnose and report only. Do not merge anything; nothing merges until the ratchet improves the base. Do not weave unless a PR is blocked without it. Classify each red as (a) the known oracle-lane red (test-ironhorse-oracle, ironhorse-oracle-sanitizers: stage3-math 054/055 asinh/acosh, ubuntu-26.04 glibc rounding; fix is #1613), (b) a cross-PR flake (rerun the failed leg), or (c) a real defect in the PR, and fix (c). Report per PR: before/after check state, cause, commit pushed.

Task: #1613 (fix(ci): run the XS oracle lanes on Ubuntu 24.04, base llm-9a14ddf) is green (38/38 pass) and is the fix for the oracle red that appears on nearly every ironhorse PR (#1548, #1599-#1624, #1535 and others). Verify it still is green and mergeable, confirm its root cause (glibc on ubuntu-26.04) against a fresh failing run, and bring it to ready-for-review state (un-draft is not needed: it is already ready). Do not merge. Then, for each ironhorse PR whose ONLY red is the two oracle lanes (#1599-#1609, #1611, #1617, #1619, #1624, ...), state in your report whether it will go green once its base carries #1613, and what base/weave step that needs. Do not weave them here.
