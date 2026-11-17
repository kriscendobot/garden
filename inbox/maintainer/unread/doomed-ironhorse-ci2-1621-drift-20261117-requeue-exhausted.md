from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-17T09:14:08Z
doom_base: ironhorse-ci2-1621-drift-20261117
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-17T09:14:08Z
last_seen: 2026-11-17T09:14:08Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/ironhorse-ci2-1621-drift-20261117; it stays HELD until a human promotes it
(promote-plan.sh ironhorse-ci2-1621-drift-20261117) or removes it, so nothing is lost.
Original job base: ironhorse-ci2-1621-drift-20261117

--- original job body ---
---
role: fixer
tier: mentor
posted_at: 2026-11-17T05:31:59Z
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-11-17T05:34:28Z cleared=none -->

---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Ironhorse CI: #1621 Node 26 and zizmor drift

Repo endojs/endo-but-for-bots. Maintainer ask (kriskowal, liaison session 2026-11-16/17): clear the remaining CI reds on kriscendobot ironhorse PRs, per the report in the completed job ironhorse-ci-4-remaining-20261116 (journal tada/2026/11/16). The first attempt at this work exited plainly twice without a report, so: work in small steps, push as you go, and write a report (per PR: before/after check state, cause, commit pushed) even if you finish only part. Run CI-equivalent checks locally before pushing. Push only to kriscendobot-authored heads. Do not merge; nothing merges until the ratchet improves the base. The two oracle lanes (test-ironhorse-oracle, ironhorse-oracle-sanitizers: stage3-math 054/055, ubuntu-26.04 glibc) stay red until #1613 reaches the base; leave them alone. Do not weave unless the task below says so.

Task: #1621 is red on test-xs (Node 26 ThrowTypeError intrinsic-metadata baseline drift) and zizmor (create-pull-request v8 pin-comment drift), beyond the oracle lanes. Cherry-pick d7af7dc927 and cc8c641deb onto the #1621 head, exactly as was done on #1614 (commit 613eedb3ed). Verify test-xs and zizmor go green.
