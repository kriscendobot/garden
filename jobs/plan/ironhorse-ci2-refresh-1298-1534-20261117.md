---
gate: orchestrated
orchestrated_by: ironhorse-ci-failures-round2-20261117
priority: normal
posted_by: producer
posted_at: 2026-11-17T05:31:59Z
---

---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Ironhorse CI: refresh #1298 and #1534 onto llm

Repo endojs/endo-but-for-bots. Maintainer ask (kriskowal, liaison session 2026-11-16/17): clear the remaining CI reds on kriscendobot ironhorse PRs, per the report in the completed job ironhorse-ci-4-remaining-20261116 (journal tada/2026/11/16). The first attempt at this work exited plainly twice without a report, so: work in small steps, push as you go, and write a report (per PR: before/after check state, cause, commit pushed) even if you finish only part. Run CI-equivalent checks locally before pushing. Push only to kriscendobot-authored heads. Do not merge; nothing merges until the ratchet improves the base. The two oracle lanes (test-ironhorse-oracle, ironhorse-oracle-sanitizers: stage3-math 054/055, ubuntu-26.04 glibc) stay red until #1613 reaches the base; leave them alone. Do not weave unless the task below says so.

Task: #1298 and #1534 carry old bwrap dash/ulimit and parent-death reds already fixed on llm. Refresh each onto current llm (a plain rebase of the head; keep the PR base as it is unless the PR cannot go green otherwise, and say so), resolve conflicts, then re-check. Also diagnose the undiagnosed build red on #1534 and fix it.

