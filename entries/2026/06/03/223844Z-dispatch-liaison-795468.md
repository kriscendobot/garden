---
ts: 2026-06-03T22:38:44Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--795468
prs:
  - repo: endojs/endo-but-for-bots
    pr: 411
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/411
  - https://github.com/endojs/endo/pull/3296
  - https://github.com/endojs/endo/actions/runs/26912459352/job/79393784371?pr=3296
---

# dispatch: fixer — #411 pin Playwright to known-good version (upstream still hitting install timeout)

Maintainer comment on #411 (2026-06-03T22:36:34Z):

> When ferried upstream, still seeing failures on install
> https://github.com/endojs/endo/actions/runs/26912459352/job/79393784371?pr=3296.
>
> Should we consider pinning to a version that can install
> reliably?

Despite the cache + retry + timeout bumps already landed, the
upstream re-ferry of #411 → endo#3296 is still failing on the
Playwright install. The maintainer is asking if pinning to a
known-good version would help.

## Target

- PR: endojs/endo-but-for-bots#411
- Branch: `ci/cache-playwright-browsers`
- Head: `cad00a777` (post latest fixer)
- Base: `master-ba26f4c`

## Investigation procedure

1. Pull the failing upstream job log:
   `gh run view 26912459352 --repo endojs/endo --log-failed`
   (or via job URL).
   Identify what version Playwright tried to install + what
   exactly failed.
2. Look at `https://github.com/microsoft/playwright/releases`
   (or the npm registry) to find a known-good recent version
   that historically installs reliably. Some signals:
   - Recent (post-2024) versions to ensure browser support
     matches current sites.
   - Versions referenced in `microsoft/playwright`'s CI as
     stable releases (not pre-releases).
3. Check `browser-test/package-lock.json` for the current
   resolved Playwright version (currently pinned to `1.49.1`
   per the earlier builder dispatch).
4. Decide: stick with `1.49.1` (already exact-pinned) or move
   to a different version.
5. The exact-pin is already there (no `^`). So the question is:
   is `1.49.1` itself a bad version, or is there a transient
   CDN issue?
   - If `1.49.1` is bad: pin to a different version.
   - If transient: the cache + retry should help on next
     attempt; maintainer's frustration suggests they've seen
     repeated failures. Switch to a different version
     defensively.

## Suggested change

Without seeing the log, defensive guidance: pin to a version
that has been around for at least 4-6 weeks (CDN well-seeded).
`1.49.1` is itself recent — if released within the last 2-3
weeks, the CDN seed time hypothesis suggests stepping back to
`1.48.x` or earlier.

**Use judgment** based on the failing-job log + Playwright
release dates.

## Procedure

1. Check the failing log to understand what specifically
   failed.
2. If a different version is warranted: edit
   `browser-test/package.json` to pin the new version. Run
   `npm install` in `browser-test/` to update the lock file.
3. Commit (regular append):
   ```
   ci(browser-test): pin Playwright to <version> for reliable install
   ```
4. Push.
5. Reply on issue-comment thread acknowledging + naming the
   new version + new SHA.

If the conclusion is "no version change needed, the cache
will hit on the next attempt", post a reply explaining + ask
the maintainer to re-trigger or wait.

## Per-action authorizations

- Read upstream CI logs. Authorized.
- Edit `browser-test/package.json` + lock file. Authorized.
- Commit + push to `ci/cache-playwright-browsers`. Authorized.
- Issue-comment reply on #411. Authorized.

## Not authorized

- Modifying any file outside `browser-test/`.
- Force-pushing.
- Touching upstream endojs/endo (boatman's job).
- Un-drafting / merging.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/fixer--795468/garden/roles/COMMON.md`
2. `/home/kris/dispatches/fixer--795468/garden/roles/fixer/AGENT.md`
3. Other skills referenced just-in-time.

Project worktree at `project/` on `ci/cache-playwright-browsers`
(refetch — head may have advanced beyond `b82249e1c` to
`cad00a777`).

## Report

A `result` journal entry. Include:

- Failing-log diagnosis (what specifically failed).
- Decision: pin to new version OR no-version-change.
- If pinned: old → new version, new head SHA.
- Issue-comment reply ID.
- Judgment calls.
