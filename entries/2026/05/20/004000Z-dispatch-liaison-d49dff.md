---
ts: 2026-05-20T00:40:00Z
kind: dispatch
role: liaison
project: endo
to: botanist
prs:
  - repo: endojs/endo
    pr: 3267
    role: source
---

# Dispatch: botanist evaluates Dependabot PR endojs/endo#3267 (actions/cache 4.3.0 → 5.0.5)

Dispatch root: `dispatches/botanist--d49dff/`. Project worktree on `endojs/endo@master` (head `052b0487e`).

Maintainer directive (2026-05-20): *"Please dispatch a botanist to make a recommendation on https://github.com/endojs/endo/pull/3267"*.

## PR snapshot

- **PR**: [endojs/endo#3267](https://github.com/endojs/endo/pull/3267) — `chore: bump actions/cache from 4.3.0 to 5.0.5`.
- **Author**: `dependabot[bot]`.
- **Base**: `master`. Head ref: `dependabot/github_actions/actions/cache-5.0.5`.
- **Diff**: 2 additions, 2 deletions across 2 files (GitHub Actions workflow files; lockfile-free since this is a GitHub-Actions bump rather than an npm bump).
- **Labels**: `dependencies`, `github_actions`.

## Load-bearing facts for the verdict

This is a **major version bump** (4 → 5), not a patch. Per actions/cache v5.0.0 release notes:

> **`actions/cache@v5` runs on the Node.js 24 runtime and requires a minimum Actions Runner version of `2.327.1`.** If you are using self-hosted runners, ensure they are updated before upgrading.

The botanist's first verification is whether `endojs/endo`'s workflows are compatible with the Node-24 + Actions-Runner-2.327.1 floor. GitHub-hosted runners (`ubuntu-latest`, `macos-15`, etc.) have already advanced past that floor as of mid-2025, so the runtime question is whether any *self-hosted* runners are in play. Read `.github/workflows/*` for `runs-on:` lines; if any name a self-hosted runner pool, surface that as a precondition before merge.

Also: v5.0.0 → 5.0.5 includes several `@actions/cache` library bumps for security fixes (5.0.3 references `actions/cache/security/dependabot/33`). Worth a quick read.

## Task

Read `garden/roles/COMMON.md` + `garden/roles/botanist/AGENT.md` first. Then the botanist workflow on PR #3267:

1. **Pre-flight diff inspection**. Confirm only `.github/workflows/*.yml` (or `.github/dependabot.yml`) are touched. Dependabot PR touching source code is a reject signal.

2. **Read the lockfile diff** — N/A for a GitHub-Actions bump (no npm lockfile churn). Instead read the **per-workflow diff**: which workflows pin `actions/cache@v4` today and which step will switch to `v5`. List them.

3. **Runtime-floor check**. Grep `.github/workflows/*.yml` for `runs-on:` and confirm all targets are GitHub-hosted (and thus already on the new Actions-Runner floor). If any self-hosted runners appear, flag as a precondition.

4. **Skim the actions/cache@v5 source/release-notes** between `v4.3.0` and `v5.0.5`. Note: behavioral changes, new permissions required, new network calls, breaking changes to cache-key semantics. The Node-24 runtime change is the main one; check whether `@actions/cache` library changes between these versions affect cache-hit determinism, save-on-failure, or save-always semantics.

5. **Vulnerability check**. `npm audit` doesn't apply (no npm lockfile change). Check GHSA for any open advisories against `actions/cache@4.3.0` that v5.0.5 closes. The v5.0.3 release notes mention `actions/cache/security/dependabot/33` — read what that was.

6. **CI status**. PR #3267's `statusCheckRollup`: surface pass/fail/pending. Green CI doesn't authorize merge on its own (per the botanist's standing anti-pattern), but red CI does authorize REJECT or further investigation.

7. **Render the verdict** per the botanist workflow:
   - **MERGE-NOW**: only if v5.0.5 closes a CVE the project is meaningfully exposed to, OR (≥7 days since v5.0.5 publish-date AND CI green AND no self-hosted-runner blocker AND source read clean).
   - **EMBARGO-YYYY-MM-DD**: benign-looking but <7 days from upstream publish, OR self-hosted-runner gap that the maintainer needs to close first.
   - **REJECT**: regression, malicious signal, license change, downstream incompatibility the project cannot absorb (e.g., a self-hosted runner pool on an old Actions-Runner version that the maintainer is not ready to upgrade).

8. **Cite the upstream-publish date of `v5.0.5`** (read from GitHub releases on `actions/cache`). The embargo math depends on it.

## Per-action authorization

- READ-ONLY on `endojs/endo`. **No comment posting** on PR #3267 — that's upstream, and standing comment-authorization is endo-but-for-bots only. Deliver the verdict as a `result` journal entry; the maintainer (or a future authorized liaison/boatman) posts the comment when ready.
- No push to anything. Botanist is read-only by role.
- The dependabotany ledger entry lands as a `journal` `message` entry tagged with `project: endo` per the role's ledger convention.

## Out of scope

- No comment on PR #3267 itself.
- No merging. The verdict is the recommendation; the maintainer (or a downstream dispatch) acts on it.
- No reaction emoji.
- No update to `.github/dependabot.yml` configuration even if you notice it should be tightened.

## Report

≤ 500-word `result` journal entry: verdict (MERGE-NOW / EMBARGO-… / REJECT), one-line headline (PR ref, version-bump shape), workflows-affected list (one-line each), runtime-floor verification (any self-hosted runners? GitHub-hosted only?), source-read paragraph (what's between v4.3.0 and v5.0.5 that matters), vulnerability check (CVE / GHSA), CI status, the upstream-publish date of v5.0.5 + the embargo math, one-line `Self-improvement: ...`. Plus the dependabotany ledger entry as a separate journal `message` entry tagged `project: endo`. The liaison adds a bulletin row on return.
