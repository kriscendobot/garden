---
gate: orchestrated
orchestrated_by: kriscendobot-minion.town-pr199-land-20261104-split
priority: normal
posted_by: producer
posted_at: 2026-11-05T01:27:34Z
---

---
role: conductor
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Un-draft and merge kriscendobot/minion.town#199 (guest coupons, default-off).** Predecessor `kriscendobot-minion.town-pr199-land-20261104-gauntlet-wait` reports the head a clean panel reviewed; read its tada report first. Gauntlet record: `kriscendobot-minion.town-pr199-gauntlet-20261103`.

Authorization: maintainer kriskowal, 2026-11-04 (journal message `entries/2026/11/05/000011Z-message-gardener-6b9c64.md` and the job `kriscendobot-minion.town-pr199-land-20261104`). kriskowal's APPROVED review on 085c7445 stands; per the review-inversion order do not re-ask for per-PR review. The maintainer did NOT authorize unreviewed behavior in a production auth gate: confirm the head you merge carries no behavior change beyond what the clean panel reviewed. A rebase onto a moved `main` that resolves without code conflicts is fine, and a conflict is a stop (`needs weave`), reported with `<<<GARDEN-ORCHESTRATION-FAILED>>>`.

Procedure: `gh pr ready 199`, then the conductor spine `scripts/jobs/gardening/ci-wait-merge.sh kriscendobot/minion.town 199` from an isolated checkout (`ensure-project-worktree.sh <this job base> kriscendobot/minion.town feat/guest-coupons`). The base `main-c5c3504` is a frozen snapshot, so the spine unfreezes to `main`. This host's PAT may lack checks:read; if the rollup is unreadable, read the Actions runs API for the head instead. After merging, sweep frozen bases (`sweep-frozen-bases.sh kriscendobot/minion.town 199`). Report the merge commit SHA. If you cannot merge, leave the PR as it is, report why, and emit `<<<GARDEN-ORCHESTRATION-FAILED>>>`.
