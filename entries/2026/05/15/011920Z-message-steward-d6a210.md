---
ts: 2026-05-15T01:19:20Z
kind: message
role: steward
project: endo-but-for-bots
to: "*"
subject_matter:
  - ci-resilience
  - investigation
refs:
  - entries/2026/05/14/225300Z-dispatch-steward-f0aba2.md
  - entries/2026/05/14/225829Z-result-builder-f0aba2.md
  - entries/2026/05/15/010640Z-message-steward-c4d8e9.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 82
    role: source
  - repo: endojs/endo-but-for-bots
    pr: 255
    role: source
---

# Investigation: why GitHub Actions cache is not compensating for substitute-server outages

User asked at ~2026-05-15T01:17Z: "It would be worth figuring out why the github cache is not compensating for the loss of access to the guix repositories."

## The answer

The workflow's `actions/cache` step caches **only the Guix installer tarball** (`guix-binary.x86_64-linux.tar.xz`, ~120 MB), not the **Guix runtime store** that contains the substituted packages the test actually depends on at runtime.

From `.github/workflows/ocapn-guile-interop.yml` on `llm` HEAD:

```yaml
- name: Restore Guix tarball cache
  id: guix-cache
  uses: actions/cache@0057852bfaa89a56745cba8c7296529d2fc39830 # v4.3.0
  with:
    path: guix-binary.x86_64-linux.tar.xz
    key: guix-binary-x86_64-linux-${{ env.GUIX_VERSION }}-${{ env.GUIX_TARBALL_SHA256 }}
```

That's the **only** cache step. The runtime substitutes — `guile`, `guile-fibers`, `guile-websocket`, `guile-gnutls`, `guile-gcrypt` and their transitive deps — live under `/gnu/store/` after each `guix build` invocation. They are **re-resolved by querying the substitute servers on every run**.

When both `ci.guix.gnu.org` and `bordeaux.guix.gnu.org` are degraded (the 2026-05-14 condition), the daemon has no fallback because:

- No `/gnu/store` cache from prior runs preserves the resolved packages.
- `--fallback` permits a *local build* (compiling from source) only if neither server has the requested item, but compiling Guile + its libraries from source on every CI run is operationally far worse than just failing.

The installer tarball cache hits ~100% (the SHA-pinned tarball never changes), so the installer cost is already amortized. The runtime cost is **not** amortized — every run pays the full substitute-fetch cost.

## What iteration II (PR #255, merged) did and did not address

#255's changes:

1. Reorder `--substitute-urls` (`ci.guix.gnu.org` primary, `bordeaux.guix.gnu.org` fallback) — addresses the case where the daemon listed-first server is *unreachable* (paying per-item connect-timeouts).
2. Widen polling/timeout windows — addresses slow-path startup.

Neither helps when both substitute servers are degraded. The reruns I triggered against #109, #253, #250, #243 (which used the pre-#255 workflow per GitHub's rerun-uses-original-workflow behavior) all failed again; the empty-commit nudges I just pushed will exercise the new workflow but the fundamental cache gap remains.

## What iteration III should land

A second `actions/cache` step caching the Guix store contents that the daemon resolves at runtime:

```yaml
- name: Restore Guix store cache
  id: guix-store-cache
  uses: actions/cache@v4
  with:
    path: |
      /gnu/store
      /var/guix/db
    key: guix-store-${{ env.GUIX_VERSION }}-guile-fibers-websocket-gnutls-gcrypt-${{ hashFiles('.github/workflows/ocapn-guile-interop.yml') }}
```

Considerations the iter-III builder must think through:

- Path permissions: `/gnu/store` is owned by `root:root` with strict permissions; `actions/cache` runs as `runner` and may need a wrapping step to `sudo tar`/`sudo cp` the store contents into a runner-accessible path before cache save, and reverse on restore. The Guix install path already uses `sudo tar` for the installer extract, so the same pattern fits.
- Cache key sensitivity: the cache key must change when any of the queried package set changes. Hashing the workflow file or the package list captures most of it; a `guix describe` SHA might be even tighter.
- Cache size limits: GitHub's per-repo cache budget is 10 GB. A full `/gnu/store` populated only with the packages this workflow needs is probably 200-500 MB; well within budget.
- Daemon database vs store-only: `/var/guix/db` records which paths are valid; if only `/gnu/store` is cached without `/var/guix/db`, the daemon may re-resolve anyway. Caching both together is the safe path.

## Recommended next step

Dispatch a builder for iter III with this brief. The companion empty-commit-nudge sweep on the 4 affected PRs (just performed) lets iter II's resilience be observed under real load while iter III is in flight.

User's "A rebase should suffice" note (from 01:17Z) — acknowledged for future discipline: instead of empty-commit nudges, future shepherd-style re-triggers should rebase the PR onto the post-fix base. The empty commits I pushed are landed; the maintainer's eventual squash-merge will collapse them away.

## Self-improvement

The iter II resilience PR (#255) and its companion broadcast under-scoped the problem class: "make substitute resolution more resilient against single-server outages" treats degradation as one-server-at-a-time. The cache-store gap means the workflow is *not* resilient against either-or-both-servers degraded, which is what 2026-05-14 actually showed. Future operational-flake remedies should ask "does the cache cover this?" as the first question, before considering retry / reorder / timeout changes.
