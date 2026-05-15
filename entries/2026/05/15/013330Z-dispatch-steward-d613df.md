---
ts: 2026-05-15T01:33:30Z
kind: dispatch
role: steward
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 82
    role: source
  - repo: endojs/endo-but-for-bots
    pr: 255
    role: source
refs:
  - entries/2026/05/15/011920Z-message-steward-d6a210.md
  - entries/2026/05/15/013250Z-message-steward-bf3c7e.md
---

# Dispatch: builder proposes resilience iter III for `test-ocapn-guile-interop` — cache the Guix runtime store

Dispatch root: `dispatches/builder--d613df/`. Project worktree on `endojs/endo-but-for-bots@llm`.

## Why iter III is owed

The user asked at ~01:17Z why the GitHub cache was not compensating for substitute-server outages. The steward's investigation at `011920Z-message-steward-d6a210.md` found that the workflow's only `actions/cache` step caches the Guix installer tarball (~120 MB), not the **runtime Guix store** containing the substituted packages (`guile`, `guile-fibers`, `guile-websocket`, `guile-gnutls`, `guile-gcrypt`, and their transitive dependencies). When both substitute servers are degraded, the daemon has no fallback because nothing preserves the resolved packages across runs.

Empirically confirmed at 01:32Z: 3 of 3 OCapN-running PRs (#109, #253, #250) failed under iter II's reorder+widen-windows hardening after fresh runs under the post-#255 workflow. The cache gap, not the substitute-server topology, is the load-bearing failure.

The shepherd-ignore broadcast is re-instated at `013250Z-message-steward-bf3c7e.md` until iter III lands.

## Per-action authorization

- Push a single new branch `ci/ocapn-guile-interop-resilience-iii` to the bot fork.
- Open a draft PR against base `llm`.
- Read the workflow file `.github/workflows/ocapn-guile-interop.yml` on `llm` and PR #255's merged diff for the iter-II pattern.

## Task

Add a second `actions/cache@v4` step caching the Guix runtime store + daemon DB across runs. Reference shape (the builder refines):

```yaml
- name: Restore Guix store cache
  id: guix-store-cache
  uses: actions/cache@v4
  with:
    path: |
      /gnu/store
      /var/guix/db
    key: guix-store-${{ env.GUIX_VERSION }}-fibers-websocket-gnutls-gcrypt-v1
    restore-keys: |
      guix-store-${{ env.GUIX_VERSION }}-fibers-websocket-gnutls-gcrypt-
```

Considerations the builder must address:

1. **Path permissions**. `/gnu/store` is owned by `root:root` with strict permissions. `actions/cache` runs as `runner` and cannot read those paths directly. Two patterns work:
   - Wrap save/restore in `sudo tar -czf` to a runner-accessible path, then `sudo tar -xzf` back. Two extra steps.
   - Use `path:` with the actual `/gnu/store` location and rely on `actions/cache`'s ability to `sudo` for read access — *check the action's docs*; it may need an explicit wrapping step.

2. **Cache placement in the workflow**. The cache restore must happen *after* the installer extract (so `/gnu/store` exists as a directory) and *before* the daemon starts (so the daemon sees the cached contents). The `Restore Guix store cache` step lands between `Install Guix` and `Authorize build farm`.

3. **Cache-miss path**. When the cache misses (first run after a version bump or a new builder), the existing `Resolve Guix module paths` step's `guix build --fallback` populates `/gnu/store` from substitutes (or local build if neither server has the item). The cache *save* at the end of the run captures the populated store for subsequent runs.

4. **Cache key strategy**. Include the Guix version + the package list (or its hash) in the key. The package list is hardcoded in the `Resolve Guix module paths` step (`guile-fibers guile-websocket guile-gnutls guile-gcrypt`). A key like `guix-store-${{ env.GUIX_VERSION }}-${{ hashFiles('.github/workflows/ocapn-guile-interop.yml') }}` ties cache invalidation to any workflow edit, which is conservative-but-correct.

5. **Cache size**. The full Guix store after this workflow's packages is plausibly 200-500 MB. Well within GitHub's 10 GB per-repo budget.

6. **Re-using iter II's hardening**. Don't undo #255's reorder + widen-windows. The cache is *additive* resilience; the iter-II changes still mitigate first-run substitute-degradation. Keep both axes in place.

## Out of scope

- No change to test fixtures or test logic.
- No master-base mirror in this dispatch.
- No removal of `nick-fields/retry` or the existing retry windows; the cache is additive.
- No comments on PR #82, PR #255, PR #109, or other affected PRs.

## Commits

- One commit on `ci/ocapn-guile-interop-resilience-iii` (off `llm`) with the workflow change.
- Conventional-commit message shape: `ci(ocapn-guile-interop): cache /gnu/store across runs (iter III per #82 #255 investigation)`.
- Push at end; open draft PR.

## Report

≤ 500 words. PR number, the cache-step shape that landed (verbatim YAML), the cache-key rationale, whether the path-permission wrapping was needed and how it was handled, and one-line `Self-improvement: ...`.
