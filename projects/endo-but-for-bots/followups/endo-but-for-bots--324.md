---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 324
upstream_mirror_repo: null
upstream_mirror_pr: null
created_at: 2026-05-22T23:17:00Z
last_appended_at: 2026-05-22T23:17:00Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#324

Created from the code-panel verdict (14 seats, in-band fallback) on `test(lal): Primer-into-CAS packaged-build smoke (G16 from #231)` (branch `test/familiar-primer-cas-smoke`). The PR adds four serial AVA tests covering the bundled primer's path from `lal/primer/` through `bundle.mjs` to a sub-guest's `lookup('primer')` shape. Two deferrals warrant revisit when the PR (or its upstream mirror, if later ferried) merges.

## Items

- [ ] **Changeset policy verification for tests-only PR.**
  **Source juror(s)**: packager.
  **Round**: 1.
  **Recommended action**: confirm the upstream maintainer's changeset convention treats tests-only changes as no-changeset (the project's `skills/changeset-discipline/SKILL.md` and the `releaser` seat's read of this PR support that view). If the upstream convention requires a `tests:` changeset for visible test additions, file as a follow-up `chore` PR adding one.
  No action on this PR until the upstream convention is confirmed; do not block un-draft.

- [ ] **Stale-bundle freshness check in `ensureBundledPrimer`.**
  **Source juror(s)**: saboteur.
  **Round**: 1.
  **Recommended action**: open a follow-up implementation PR adding a content-hash freshness check to `ensureBundledPrimer()` so that a stale `bundles/primer/` (left over from a prior `lal/primer/` revision whose filenames match the current set) is detected and re-bundled rather than silently passing the directory-listing assertion.
  Test #1's per-file sha256 loop catches the case once the test runs; the freshness check would surface it earlier (at module load) with a clearer error.
