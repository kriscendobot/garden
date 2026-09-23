---
ts: 2026-06-03T04:40:48Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: builder
dispatch_root: /home/kris/dispatches/builder--626602
prs: []
refs:
  - https://github.com/endojs/endo-but-for-bots/actions/workflows/browser-test.yml
---

# dispatch: builder — Playwright cache + version pin + install retry for browser-tests CI

User asked for advice on recurring browser-test failures (timeouts
downloading Chromium after Playwright/Chromium version bumps).
Liaison's recommendation, approved by the user:

1. **Add `actions/cache` for `~/.cache/ms-playwright`** keyed on
   resolved Playwright version.
2. **Pin `@playwright/test` exactly** (drop the `^`).
3. **Add a retry around `npx playwright install`**.

Item 4 (out-of-band cache priming workflow) deferred.

This dispatch lands items 1-3 as a new DRAFT PR on
`endojs/endo-but-for-bots`.

## Diagnosis context

`.github/workflows/browser-test.yml` currently runs `npx
playwright install --with-deps` cold on every CI run — no
caching. `browser-test/package.json` pins `@playwright/test:
"^1.49.1"` (caret range; resolved version drifts).

Failure mode the user reported: timeout downloading Chromium,
typically right after a new Playwright/Chromium pin lands and
the CDN hasn't seeded it widely.

## Procedure

### 1. Branch

- Branch off `origin/master` (currently `ba26f4cdb`, mirrors
  upstream after the recent weaver sync).
- Suggested branch name: `chore/browser-tests-cache-playwright`
  or `ci/cache-playwright-browsers`. Use judgment.
- Open DRAFT PR against the appropriate base — either `master`
  directly, or a fresh frozen-base snapshot
  `master-ba26f4c` if the per-PR frozen-base discipline is
  preferred. Check `roles/builder/AGENT.md` and
  `garden/skills/frozen-base-branch/SKILL.md` for the
  convention.

### 2. Workflow edits — `.github/workflows/browser-test.yml`

**Add the cache step** (between `Install browser test
dependencies` and `Install Playwright Browsers`):

```yaml
- name: Cache Playwright browsers
  uses: actions/cache@<pinned-sha>  # use a recent pinned SHA per the repo's pin convention
  id: playwright-cache
  with:
    path: ~/.cache/ms-playwright
    key: playwright-${{ runner.os }}-${{ hashFiles('browser-test/package-lock.json') }}
    restore-keys: |
      playwright-${{ runner.os }}-
```

**Wrap the install step in a retry**:

Either use `nick-fields/retry` (preferred — purpose-built):

```yaml
- name: Install Playwright Browsers (with retry)
  uses: nick-fields/retry@<pinned-sha>
  with:
    timeout_minutes: 10
    max_attempts: 3
    working-directory: browser-test
    command: npx playwright install --with-deps
```

OR use a bash retry loop if `nick-fields/retry` isn't already
in the repo's action-pin policy. Use judgment based on what
other workflows use.

**Optional**: skip the install step entirely on cache hit via
`if: steps.playwright-cache.outputs.cache-hit != 'true'`. This
saves a few seconds on hit and avoids the network call. But
the `--with-deps` flag also installs apt system packages, so a
pure cache-only skip means those won't be installed — you'd
need a separate `apt-get install` step on the always-run path,
OR run `playwright install --with-deps` unconditionally (still
cheap on cache hit because the browser binaries don't
re-download). **Recommended: run unconditionally**; the
download is the expensive part, and the cache hit makes it a
no-op.

### 3. Package-pin edit — `browser-test/package.json`

Change:
```json
"@playwright/test": "^1.49.1",
```
to the exact resolved version currently in
`browser-test/package-lock.json` (resolve via reading the lock
file).

Run `npm install` in `browser-test/` to refresh the lock file
if necessary; commit the lock file changes separately if they
move.

### 4. Verify locally (best-effort)

The browser-test workflow runs on GHA — local verification of
the full flow isn't practical from the worktree, but you CAN:

- `yamllint` or eyeballed YAML validity on the workflow.
- Confirm `browser-test/package.json` and `package-lock.json`
  are consistent (no `npm install` warnings).

### 5. Commit shape

Two commits is fine:
- `ci(browser-test): cache Playwright browsers + retry install + pin version`
- `chore: Update yarn.lock` (if yarn.lock at the repo root
  shifted because the workspace dep is the browser-test
  package).

Or one commit if no yarn.lock churn. Use judgment.

### 6. Open DRAFT PR

PR title:
```
ci(browser-test): cache Playwright browsers + retry install + pin version
```

PR body should include:
- Summary of the three changes.
- Reference to the user's diagnosis: "Browser tests frequently
  failing on timeout while downloading Chromium; likely the
  CDN being slow to seed after a Chromium version bump."
- Note that item 4 (out-of-band cache priming workflow) is
  deferred; will be added if the cache + pin + retry doesn't
  drop failure rate to near-zero.

DRAFT mode — the steward/contractor's PR-creation-flow picks
up from there.

## Per-action authorizations

- Branch off `origin/master` and edit
  `.github/workflows/browser-test.yml` and
  `browser-test/package.json` (plus `browser-test/package-
  lock.json` if `npm install` shifts it). Authorized.
- Commit(s) + regular push to a new branch. Authorized.
- Open DRAFT PR. Authorized.

## Not authorized

- Editing any other workflow file or any package outside
  `browser-test/`.
- Force-pushing.
- Un-drafting the PR (the gauntlet does that, after CI green).
- Merging.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/builder--626602/garden/roles/COMMON.md`
2. `/home/kris/dispatches/builder--626602/garden/roles/builder/AGENT.md`
3. `garden/skills/frozen-base-branch/SKILL.md` (decide whether
   to use a frozen-base branch vs bare `master`).
4. `garden/skills/check-action-pins/...` if any such skill
   exists, for the `actions/cache@` and `nick-fields/retry@`
   pin choices.
5. Other skills referenced just-in-time.

Project worktree at `project/` on `master` (refetch to current
`ba26f4cdb`).

## Report

A `result` journal entry. Include:

- New branch name + head SHA.
- PR URL + number.
- Resolved Playwright version pinned.
- Whether you used `nick-fields/retry` or a bash retry loop,
  and the pinned SHAs of all actions used.
- Whether the cache-hit short-circuit was added (optional path).
- Any judgment calls.
