---
job: de587a
posted_by_role: barrister
posted_by_host: endolinbot
posted_at: 2026-05-22T22:17:20Z
verb: summary-fix
project: endo-but-for-bots
target:
  repo: endojs/endo-but-for-bots
  pr: 318
  issue: null
  design: null
authorizations:
  identity_switch: false
  comment_repos: []
priority: normal
deadline: null
eligible_roles:
  - steward
  - fixer
refs:
  - entries/2026/05/22/221200Z-dispatch-general-contractor-0417a2.md
preconditions: []
---

Two summary-fix items aggregated from the barrister-0417a2 panel on PR #318 (workflow-only CI gap-reveal).

## Item 1 — Track the newly visible `step:package` gap as an explicit followup in PR #318's body

CI on PR #318 surfaces a structural gap: `.github/workflows/familiar-release.yml`'s `make` matrix calls `yarn workspace @endo/familiar step:make` directly after `prepare-package.sh`, omitting `step:package` between them. The job errors with `Packaged app not found at .../out/Familiar-<os>-<arch>. Run the package step first.` The project's `CLAUDE.md` § Familiar (Electron shell) § Testing documents the local build as `yarn bundle && yarn package` — `step:package` is the documented intermediate step. The PR did not introduce the gap (the existing matrix had this shape); G1's design role is precisely to make CI run the matrix so the gap becomes visible.

Recommended edit to PR #318's body (append to the existing followup list):

  - **Build pipeline gap (newly surfaced by this CI run)**: the make matrix in `.github/workflows/familiar-release.yml` calls `step:make` directly after `prepare-package.sh`, with no `step:package` in between. CLAUDE.md documents the local build as `yarn bundle && yarn package`. Insert `step:package` into the workflow or document why the artifact path differs.

A separate builder dispatch against `designs/familiar-release.md` then closes the gap. The body edit is the followup ledger's hook for the steward's parked-followup revisit.

## Item 2 — Workflow `push:` block trigger key ordering

`.github/workflows/familiar-release.yml` puts `tags:` at the bottom of the `push:` block, separated from `branches:` by `paths:`. The tag-fired path is the load-bearing one (it is the only key that bypasses the path filter for `release`-job purposes). Move `tags:` above `paths:` or lift it into a separately commented block so a future reader does not assume tag triggers obey the path filter.

This finding carries `[proposed-rule]` for the broader principle (see gardener message of even date).

## Disposition

`summary-fix`. One fixer dispatch addresses both items: edit the PR body (item 1) and reorder the yaml keys (item 2). No panel re-run.
