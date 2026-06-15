---
ts: 2026-06-15T06:11:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--35f98a
prs:
  - repo: endojs/endo-but-for-bots
    pr: 411
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/411
  - https://github.com/endojs/endo-but-for-bots/pull/411#issuecomment-4705028722
---

# dispatch: fixer — reconstruct PR #411 to address root cause per kriskowal

Maintainer directive (kriskowal on PR #411, 2026-06-15T06:06:02Z):

> @kriscendobot Please reconstruct this branch to simply address the root cause. Update the description and title.

PR #411 currently attempts to fix browser-test CI failures via two workarounds:
1. Cache `~/.cache/ms-playwright` via `actions/cache@v4.3.0`.
2. Wrap `npx playwright install --with-deps` in `nick-fields/retry@v3.0.2`.

The maintainer's framing ("simply address the root cause") signals these workarounds are treating the symptom. The PR body's *Scope note* says:

> The Playwright version pin is intentionally left to the upstream security PR (endojs/endo#3254), which bumps `@playwright/test` to a current release.

The peer's prior intermediate commits (now in the branch's history per the earlier fetch) include `37440d0e2 ci(browser-test): pin Playwright to 1.58.2 for reliable install` — meaning the version-pin path was already explored. The maintainer's directive likely wants that pin to be the **only** intervention; drop the cache + retry workarounds entirely.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#411`, DRAFT, base `master-07aff33`, head `45810f0f1` (`ci(browser-test): restore chrome-unstable rename for chromium-next channel`).

## Task

In your `project/` worktree at `45810f0f1`:

1. Inspect the diff vs base (`git diff master-07aff33..HEAD` and `git log master-07aff33..HEAD --oneline`).
2. Read the failing browser-tests history (recent successful runs vs the failing ones; the bot's earlier comment on #379 noted "30 min on Install Playwright Browsers"; check `gh run list --repo endojs/endo-but-for-bots --workflow="Browser Tests" --limit 20`).
3. Identify the root cause:
   - If the failures correlate with a specific Playwright version (newest version's binary not on CDN yet), the root cause is unpinned version. Fix: pin to a known-stable version (1.58.2 if intermediate commit suggested it, or the latest version known to have CDN coverage).
   - If the failures correlate with a `--with-deps` flag introducing apt failures, the root cause is the flag. Fix: drop or adjust.
   - If something else, document and propose.
4. **Reconstruct the branch** to address ONLY the root cause:
   - Reset --mixed to base (`master-07aff33`).
   - Stage the minimal root-cause fix (likely: pin `@playwright/test` in `browser-test/package.json`).
   - Commit with a clean message describing the root cause.
   - If `browser-test/package-lock.json` updates, include it as `chore: Update browser-test/package-lock.json` (separate commit).
5. **Update PR title** via `gh pr edit 411 --title "..."` to reflect the new scope (e.g., `ci(browser-test): pin Playwright to <version> for reliable install`).
6. **Update PR body** via `gh pr edit 411 --body "..."` to describe the root-cause framing, drop the cache/retry diagnosis, name the version pin's rationale.
7. Force-push with lease: `git push --force-with-lease origin ci/cache-playwright-browsers`.
8. Post a brief top-level comment on PR #411 at-mentioning @kriskowal:
   - The root-cause identification.
   - New head SHA.
   - Updated title.
   - Drop summary (what cache/retry was removed).

## Authorizations

- Force-push with lease.
- `gh pr edit` for title and body.
- Top-level comment.
- Do NOT mark PR ready/un-ready.
- Do NOT re-request review (the maintainer is actively engaging).

## Out of scope

- Do NOT touch upstream endojs/endo (the security PR #3254 referenced in the body is its own concern).
- Do NOT pursue cache/retry workarounds.

## Deliverable

A `result` entry under `journal/entries/2026/06/15/` naming:

- Root-cause identification (cite evidence: CI run patterns, version bumps).
- Pre/post head SHAs.
- New diff summary.
- Old title / new title.
- Old body excerpt / new body summary.
- PR #411 comment URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: liaison` (maintainer reviews the reconstruction).

End your turn with a concise summary back to the orchestrator.
