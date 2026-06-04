---
ts: 2026-06-04T03:22:15Z
kind: result
role: shepherd
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
dispatch_root: /home/kris/dispatches/shepherd--ed2960
prs:
  - repo: endojs/endo-but-for-bots
    pr: 411
    role: target
  - repo: endojs/endo
    pr: 3296
    role: upstream-mirror
refs:
  - entries/2026/06/04/031814Z-dispatch-liaison-ed2960.md
  - https://github.com/endojs/endo/pull/3296
  - https://github.com/endojs/endo/actions/runs/26922336482/job/79425214012
  - https://github.com/endojs/endo-but-for-bots/pull/411#issuecomment-4618654468
next: fixer
---

# result: shepherd — endo#3296 browser-test diagnosis

## Upstream PR + failing run

- Upstream: endojs/endo#3296 at head `8516443994cec272f783cd83a00b75e1b4a2fc7d` on
  branch `kriskowal-browser-test-cache`, base `master` (mergeStateStatus: BEHIND,
  mergeable: MERGEABLE).
- Failing run: https://github.com/endojs/endo/actions/runs/26922336482
- Failing job: `browser-tests` (id 79425214012), step `Install Playwright Browsers`.
- All other checks in the upstream rollup are SUCCESS (lint, build, zizmor,
  test 22/24 ubuntu/macos, cover, test262, test-hermes, check-action-pins,
  viable-release, test-xs, test-ocapn-python).

## Classification

**Real failure, deterministic, in-scope for fixer.** Not a flake; not a CDN
problem; not a workflow-dispatch issue. The 1.58.2 pin landed in the PR did
not solve the failure mode the PR was trying to address.

### Log evidence

All three retry attempts exhibit the same pattern. Excerpt from attempt 1
(line 1485+ of the job log):

```
00:39:00.7548035  Downloading Chrome for Testing 145.0.7632.6 (playwright chromium v1208)
                  from https://cdn.playwright.dev/builds/cft/145.0.7632.6/linux64/chrome-linux64.zip
00:39:00.9326359  | 0% of 167.3 MiB
... (10% increments at sub-second intervals) ...
00:39:01.6445635  | 100% of 167.3 MiB
00:53:42.5843796  ##[warning]Attempt 1 failed. Reason: Timeout of 900000ms hit
```

The download completes in ~1.5 seconds (Azure runner network). Then nothing
is logged for **~14 minutes 41 seconds** until the `nick-fields/retry`
framework kills the attempt at the 15-minute per-attempt ceiling. Attempts 2
and 3 are identical, except they preface with
`Removing unused browser at /home/runner/.cache/ms-playwright/chromium-1208`
(prior attempt's partial extract). No "downloaded to ..." confirmation line
ever appears in any of the three attempts.

### Contrast with last successful upstream browser-test run

Last green: run 26531669032, job 78149649462, master on 2026-05-27, when
`browser-test/package.json` had `@playwright/test: ^1.49.1`. Same install
step, same `--with-deps`:

```
18:50:22.0059553  Downloading Chromium 131.0.6778.33 (playwright build v1148)
                  from https://playwright.azureedge.net/builds/chromium/1148/chromium-linux.zip
18:50:23.4423637  | 100% of 161.3 MiB
18:50:25.6684074  Chromium 131.0.6778.33 (playwright build v1148) downloaded to
                  /home/runner/.cache/ms-playwright/chromium-1148
18:50:25.6686421  Downloading Chromium Headless Shell 131.0.6778.33 (playwright build v1148) ...
```

The pre-CFT install printed a "downloaded to ..." confirmation within ~2
seconds of 100% and moved on to the next browser download. The new CFT path
hangs in the gap between 100% and the missing confirmation.

### Diagnostic interpretation

1. **The download itself is not the bottleneck.** 167 MiB lands in 1.5
   seconds. There is no CDN failover involved (single host
   `cdn.playwright.dev`), and the PR description's premise that 1.58.2
   "routes browser downloads through mirrored CDNs with failover" is not
   borne out by the log.
2. **The hang is in the post-download phase** (extract + sanity-check +
   probably a `chrome --version` invocation against the extracted binary).
   Playwright migrated to Chrome-for-Testing infrastructure between v1148
   (chromium-131, last green) and v1208 (chromium-145, current); the new
   install code path is where the silence lives.
3. **`mv /opt/google/chrome /opt/google/chrome-unstable`** at the start of
   the workflow is a vestige of a Selenium-image setup that is commented
   out. On `ubuntu-latest` runners (today's actual runner), this rename
   moves the pre-installed Google Chrome. The new CFT install path likely
   probes the system for an existing Chrome to skip download; the moved
   binary may put it in a state where it hangs rather than either using
   the system Chrome or proceeding to use the just-downloaded one.

### Why the PR's framing was wrong

The PR landed three commits:
- `d46c43b1c` (cache + retry): defensive against flakes, sound shape.
- `dd65c157f` (bump per-attempt to 15min + job to 60min): bigger window,
  but the hang fills the window deterministically.
- `37440d0e2` (pin to 1.58.2): the load-bearing assumption was that
  1.58.2 routes through mirrored CDNs. The log shows it does not — same
  single CDN host as before. The pin moves the build version forward
  (1148 → 1208) without solving the post-download hang.

## Action taken

1. Read upstream rollup and failing job log (authorized read-only).
2. Compared with last green run on master (2026-05-27) to isolate the
   regression to the CFT migration window.
3. Inspected the workflow file and `browser-test/package.json` in the
   bot-side project worktree (`ci/cache-playwright-browsers`) to confirm
   PR contents.
4. Posted a classification comment on bot-side #411 documenting the
   evidence and recommending fixer options:
   https://github.com/endojs/endo-but-for-bots/pull/411#issuecomment-4618654468

## Escalation

**`next: fixer`** — root cause is within the PR's own diff (the
`@playwright/test: 1.58.2` pin combined with the unchanged `mv` step). The
repair fits surgical-fix scope (one workflow file + the package.json/lock
pin, at most three files). Failure inventory:

- File: `browser-test/package.json`
- File: `browser-test/package-lock.json`
- File: `.github/workflows/browser-test.yml` (possibly: drop the
  `mv /opt/google/chrome` step that predates CFT, or insert
  `DEBUG=pw:install` to surface what hangs)

Fixer hypotheses to test, in order of cheapest probe:

1. **Add `DEBUG=pw:install` to the install command** to capture what step
   hangs in 1.58.2. One-line workflow edit; CI exposes the answer in the
   next run. (Lowest-cost diagnosis without code-level guess.)
2. **Drop the `mv /opt/google/chrome /opt/google/chrome-unstable` step.**
   If the post-download hang is the new CFT path probing the system
   Chrome, restoring `/opt/google/chrome` should let install complete.
3. **Downgrade the pin** to the last-known-good Playwright version
   (1.49.x). Proves a fast path to green, at the cost of staying behind
   on upstream Playwright.

Recommend the fixer try (1) and (2) first; reserve (3) as the fallback.

## Authorization audit

All actions taken were authorized by the dispatch:

- Read upstream CI logs: authorized.
- Post bot-side classification comment on #411: authorized.
- No upstream comments (bot has no upstream credentials, and dispatch
  forbids touching endojs/endo).
- No re-enqueue (deterministic failure, three attempts proved it; a
  re-run would burn another ~45 minutes for the same outcome).
- No source modifications.
- No force-push, un-draft, or merge.

Self-improvement: nothing this time.
