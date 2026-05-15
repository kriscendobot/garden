---
ts: 2026-05-15T02:23:23Z
kind: result
role: judge
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 258
    role: target
refs:
  - entries/2026/05/15/022200Z-dispatch-steward-28da99.md
  - entries/2026/05/15/013945Z-result-builder-d613df.md
  - entries/2026/05/14/235614Z-result-judge-883a5d.md
---

# Result: judge un-drafted PR #258 (skip-panel; CI-config-only tiny-PR; iter III)

Dispatch root: `dispatches/judge--28da99/`. Project worktree on `endojs/endo-but-for-bots@ci/ocapn-guile-interop-resilience-iii`.

## Panel-kind decision: skip-with-audit (no panel ran)

PR #258's diff touches one file (`.github/workflows/ocapn-guile-interop.yml`, +106/-0). No source, no test, no design document. Mirrors the precedent of `883a5d` (iter II PR #255): the twelve-seat code panel and the five-seat design panel both target surfaces this PR does not have, so the documented skip-panel-with-diff-audit path applies. The dispatch brief at `022200Z-dispatch-steward-28da99.md` explicitly authorized this routing.

Panel execution: skip (no panel dispatched).
Panel kind: n/a (CI-config-only).

## CI state confirmation

All 24 checks SUCCESS at HEAD (`19959e999`). The load-bearing one for iter-III's claim:

- `test-ocapn-guile-interop`: SUCCESS in 3m20s at 01:49:21Z. First run on the branch, so the cache was populated from scratch (substitute servers cooperated this run). The cache pattern is validated on the populating path; the cache-hit path will be exercised by the next run after merge.
- All `test (Node x macos-15)` and ubuntu rows green; lint, build, browser-tests, sandbox-drivers, test262, xs, hermes, test-async-hooks, cover, viable-release, test-ocapn-python, build-wasm, check-action-pins, familiar-bundle, test-xs all SUCCESS.

## Four-step daemon-lifecycle audit

The cache pattern wraps four step boundaries; I read each in source order:

1. **`Restore Guix store cache`** (line 100, before `Download Guix stable tarball`). `actions/cache@0057852bfaa89a56745cba8c7296529d2fc39830 # v4.3.0` (SHA-locked, satisfies `check-action-pins`). `path: ~/guix-store-cache` (runner-owned staging dir, not the root-owned `/gnu/store` directly). Key: `guix-store-${GUIX_VERSION}-${hashFiles(workflow.yml)}` with `restore-keys: guix-store-${GUIX_VERSION}-` prefix. Sound: version bump invalidates the DB-schema axis; workflow-content edits force a fresh save while still seeding from the prior snapshot.
2. **`Install Guix`** (line 168). Unchanged from iter II. Writes the `guix-daemon.service` systemd unit and starts the daemon (`sudo systemctl enable --now ... guix-daemon.service`). Daemon is running at exit.
3. **`Restore Guix store from cache snapshot`** (line 218). `if: steps.guix-store-cache.outputs.cache-matched-key != ''`. Stops the daemon (`sudo systemctl stop`), `sudo tar --extract --no-overwrite-dir` (preserves installer-laid `/gnu` and `/var` dir entries; content-addressed store paths overlap byte-identically, `/var/guix/db` superset overwrites blank DB), starts the daemon (`sudo systemctl start`). Daemon is stopped only across the extract window. Sound: prevents on-disk-vs-in-memory divergence.
4. **`Authorize build farm`** (line 250) onward (key gen, version report, module resolution, env scratch). Daemon assumed running; cache restore returned it to that state. No regression of #82's authorization pattern or #255's substitute-URL ordering.
5. **`Snapshot Guix store for cache`** (line 325, after env scratch, before `Start Guile goblin-chat host`). `if: steps.guix-store-cache.outputs.cache-hit != 'true'` (skipped on exact-key match). `sudo tar --create --zstd /gnu/store /var/guix/db` (no daemon stop; tar reads filesystem layer, SQLite DB captured as point-in-time copy), then `sudo chown -R "$(id -u):$(id -g)" ~/guix-store-cache` (hands tarball to `runner` so `actions/cache` post-job save can read it). Sound.

The runner-permission gap is handled correctly throughout: `actions/cache` only ever touches `~/guix-store-cache` (runner-owned); the privileged `/gnu/store` and `/var/guix/db` reads/writes are wrapped in `sudo tar` shell steps that the cache action does not see.

## Un-draft action

```sh
gh pr ready 258 -R endojs/endo-but-for-bots
# → Pull request endojs/endo-but-for-bots#258 is marked as "ready for review"
```

Post-action GitHub state: `isDraft: false`, `state: OPEN`, `mergeable: MERGEABLE`. PR #258 is in the maintainer's review queue.

## Final state

- PR #258 is ready-for-review at HEAD `19959e999`.
- The shepherd-ignore standing instruction (`013250Z-message-steward-bf3c7e.md`) remains active until #258 merges and the verification reruns on #109/#253/#250 confirm cache resilience under live load. Clearing it is the steward's job, not the judge's.

Self-improvement: nothing this time. The skip-panel-with-diff-audit path is already documented (precedent `883a5d` for iter II), and the daemon-lifecycle audit shape the dispatch named in advance (`Install Guix` → `Restore Guix store from cache snapshot` → `Authorize build farm` → ... → `Snapshot Guix store for cache`) was the right checklist for this kind of CI-config PR. A future tiny-PR judge dispatch on the same workflow file would reuse the same audit shape.
