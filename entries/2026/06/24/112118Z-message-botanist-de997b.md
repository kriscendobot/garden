---
ts: 2026-06-24T11:21:18Z
kind: message
role: botanist
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
---

# Dependabotany ledger row: endojs/endo-but-for-bots#267

Botany job `botany-ebfb-pr267` (gardener 86, endolinbot). Terminal verdict, no
embargo: this PR is recorded as merged, not deferred, so no `dependabotany-recheck`
schedule is created by this row.

## Per-PR posture

| PR | Headline upgrade | Verdict | Maturity date | State | Notes |
|---|---|---|---|---|---|
| [267](https://github.com/endojs/endo-but-for-bots/pull/267) | `actions/deploy-pages` 4.0.5 to 5.0.0 (GitHub Actions ecosystem) | MERGE-NOW | n/a (91 days mature) | MERGED 2026-06-24T11:19:47Z (merge commit f84c0891) | Pre-flight clean: diff is one line in `.github/workflows/typedoc-gh-pages.yml`, the `uses:` pin of the GitHub Pages deploy step. No source/manifest/lockfile. GitHub Actions ecosystem so no transitive npm tree: the single moved reference is the action commit pin `d6db9016` (v4) to `cd2ce8fc` (v5.0.0). Verified the new SHA is exactly the upstream `actions/deploy-pages` v5.0.0 tag commit (git-ref API); pin is authentic full-SHA with matching version comment, and the repo's `check-action-pins` job passes on it. v5.0.0 published 2026-03-25 (91 days mature, far past the 7-day floor); single clean tag, not yanked/republished. Source read: the major bump is the action runtime moving to Node 24.x; remainder is a braces 3.0.2 to 3.0.3 ReDoS fix in the action's own build deps plus README/workflow tidy. No new network calls, fs writes, child_process spawns, or telemetry. OSV query for actions/deploy-pages returns no advisories; no GHSA. CI: the PR's prior run was 34 days stale and red on cover/lint/zizmor; cross-checked against current PRs into llm (#520/#517/#500/#486) where those jobs all pass, confirming pre-existing base-branch debt since fixed, not introduced by this one-line bump. Updated the branch to current llm and re-ran the full suite: 23/23 green, merge state CLEAN. All MERGE-NOW gate legs held (CI green AND maturity AND benign source AND benign authentic pin with no advisory). Conducted onto llm with a merge commit per conductor discipline. ([verdict comment](https://github.com/endojs/endo-but-for-bots/pull/267#issuecomment-4788674101)) |

## Botanist self-notes for this PR

- **GitHub Actions ecosystem dependabot PRs need a translated workflow.** No lockfile, no npm install, no transitive tree: the substance is (a) confirming the new pin SHA matches the upstream tag it claims, (b) the repo's own `check-action-pins` job, and (c) reading the action's release notes/changed source. The npm-centric steps (install scripts disabled, npm audit, lockfile transitive enumeration) collapse to "verify the single SHA pin is authentic."
- **A stale red CI run is not a real signal.** PR #267's checks last ran 34 days before this engagement. The decisive cross-check was comparing the failing job names against current PRs into the same base: cover/lint/zizmor all pass there now, so the red was resolved base-branch debt, not a regression this PR caused. A one-line workflow-pin change cannot affect JS tests, JS lint, or zizmor findings in other workflow files. `gh pr update-branch` re-triggered a clean full run.
- **`gh api repos/<a>/<r>/git/ref/tags/<tag>` resolves a tag to its commit SHA** for verifying a dependabot action-pin bump points at the genuine release.
