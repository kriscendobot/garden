---
ts: 2026-06-03T05:57:12Z
kind: dispatch
role: liaison
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/03/054821Z-dispatch-liaison-f24468.md
---

Dispatched boatman (dispatch-root `dispatches/boatman--4d496e`) for stage 2: **Shape-2 re-ferry** of the rebased endo-but-for-bots#244 onto endojs/endo#3263, clearing #3263's CONFLICTING by recompute onto current master.

Source: bots#244 (rebased, MERGEABLE), head `dbe04c499`, 2 commits: `5dc0e2095 chore(eslint-plugin): require underscore-delimited groups in numeric literals` (migration) + `dbe04c499 chore: Update yarn.lock`, both endolinbot, base master-ba26f4c == endo master `ba26f4cdb`.

Upstream: #3263, branch `kriskowal-eslint-numeric-separators-style`, head `4d039c3c7`, CONFLICTING, REVIEW_REQUIRED (no approval -> force-push safe). Recompute onto endo master, force-with-lease.

Boatman brief: fetch origin (verify master via exact `refs/heads/master`); detach at origin/master; cherry-pick `5dc0e2095` then `dbe04c499` (bases match endo master, should apply clean; if yarn.lock conflicts because master moved past ba26f4cdb, regenerate via `corepack yarn install` and commit `chore: Update yarn.lock`); normalize author+committer of BOTH commits to `Kris Kowal <kriskowal@kriskowal.com>`; strip `(#244)` suffixes; **RUN the `git interpret-trailers --parse` gate on every commit and confirm EMPTY** (the #3295 leak this session is why this is mandatory); verify net diff matches bots#244 and `HEAD:packages/eslint-plugin` reflects the rule; force-with-lease against `4d039c3c7` to `kriskowal-eslint-numeric-separators-style`; confirm #3263 CONFLICTING -> MERGEABLE; edit the existing garden-side cross-link on bots#244 to the new head. `identity_switch_authorized: true`. (Do NOT write a message: boatman -> steward cross-link; retired 2026-05-29.)

Expected report: new #3263 head, force-with-lease confirmation, CONFLICTING->MERGEABLE, both-commits Kris Kowal + trailers-empty confirmation, net-diff-matches-source, CI, edited cross-link.
