---
ts: 2026-06-04T03:23:56Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--770ee3
prs:
  - repo: endojs/endo-but-for-bots
    pr: 411
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/411
  - entries/2026/06/04/032215Z-result-shepherd-ed2960.md
---

# dispatch: fixer — #411 fix CFT hang (shepherd auto-chain)

Shepherd `ed2960` diagnosed upstream #3296's browser-test
failure as: **silent post-download hang in Playwright 1.58.2's
Chrome-for-Testing install path**. The 1.58.2 pin doesn't fix
the actual failure mode (the PR's "multi-mirror CDN" framing
was wrong).

## Symptom

All 3 retry attempts (45 min total):
1. CFT 145 zip (167 MiB) downloads from `cdn.playwright.dev`
   to 100% in ~1.5s.
2. **~14m41s of silence** — no further log lines, no
   "downloaded to ..." confirmation.
3. `nick-fields/retry` kills each attempt at 15min ceiling.

Contrast: last green upstream run (2026-05-27, master,
Playwright `^1.49.1` build v1148) downloaded from
`playwright.azureedge.net` and printed
`downloaded to /home/runner/.cache/ms-playwright/chromium-1148`
within 2s.

The CFT migration (v1148 → v1208) is where the hang lives.

## Three hypotheses (cheapest-probe order)

1. **`DEBUG=pw:install`** — add to the install command to
   surface which step hangs. ONE-LINE workflow edit. Next CI
   run answers what's actually hanging.
2. **Drop vestigial `mv /opt/google/chrome` step** — vestige
   of a disabled Selenium container; on `ubuntu-latest` this
   rename may interact with CFT install probing for system
   Chrome.
3. **Downgrade pin to 1.49.x family** — last-known-good;
   trades currency for stability. Fast path to green.

## Recommended sequence

Land hypothesis 1 + 2 together (low risk, both improve
diagnostics or remove a real vestigial step). If the next
CI run still fails with informative DEBUG output, escalate
to hypothesis 3 (downgrade) or post a new shepherd dispatch.

Use judgment.

## Target

- PR: endojs/endo-but-for-bots#411
- Branch: `ci/cache-playwright-browsers`
- Head: `37440d0e2` (post weaver rebase).
- Base: `master-07aff33`.

## Procedure

1. Edit `.github/workflows/browser-test.yml`:
   - Add `env: { DEBUG: 'pw:install' }` (or
     `DEBUG: pw:install` in the install step) to the install
     step.
   - Drop the `mv /opt/google/chrome /opt/google/chrome-unstable`
     step (vestige).
2. Commit (regular append):
   ```
   ci(browser-test): add DEBUG=pw:install + drop vestigial Selenium chrome-rename
   ```
3. Push.
4. Reply on issue-comment thread (the kriskowal comment
   `4618214234`) summarizing the diagnosis + change.

## Per-action authorizations

- Edit `.github/workflows/browser-test.yml`. Authorized.
- One regular-append commit + push. Authorized.
- Issue-comment reply. Authorized.

## Not authorized

- Modifying any file outside the workflow.
- Force-pushing.
- Touching upstream endo#3296.
- Un-drafting / merging.
- Bumping Playwright to a different version (defer to a
  separate dispatch if hypothesis 1+2 don't resolve).

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/fixer--770ee3/garden/roles/COMMON.md`
2. `/home/kris/dispatches/fixer--770ee3/garden/roles/fixer/AGENT.md`
3. Other skills referenced just-in-time.

Project worktree at `project/` on `ci/cache-playwright-browsers`
(head `37440d0e2`).

## Report

A `result` journal entry. Include:

- Files touched + line summary.
- New head SHA.
- Reply comment ID.
- Judgment calls (especially: whether you landed h1+h2 only
  or also h3).
