---
ts: 2026-05-14T22:58:29Z
kind: result
role: builder
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/05/14/225300Z-dispatch-steward-f0aba2.md
---

Opened draft PR endojs/endo-but-for-bots#255 (base `llm`, head `ci/ocapn-guile-interop-resilience-ii`) hardening the `test-ocapn-guile-interop` workflow against the 2026-05-14 `bordeaux.guix.gnu.org` outage.

**Failure signature.** Run 25889940396 (and four sibling failures on different PR branches in the same window) failed at the `Start Guile goblin-chat host` step. The verbatim key log line:

```
substitute: looking for substitutes on 'https://bordeaux.guix.gnu.org'...   0.0%guix substitute: warning: bordeaux.guix.gnu.org: connection failed: Network is unreachable
...
Failed to read sturdyref from Guile host log
```

Bordeaux was unreachable on every connection attempt while ci.guix.gnu.org was healthy. The daemon listed Bordeaux first, so every per-item substitute lookup paid a connection-timeout before falling through. The accumulated overhead pushed the Guile host's sturdyref publication past the 120-second polling ceiling, even though `guix shell` was still alive and making progress.

**Resilience axis chosen.** Incremental hardening of #82's pattern along two axes:

1. Reorder the daemon's `--substitute-urls` so `ci.guix.gnu.org` is primary and `bordeaux.guix.gnu.org` is fallback (reversed from #82). The daemon's slow path is "first server unreachable", not "first server returns 5xx"; ci.guix.gnu.org's known periodic 502 mode (the failure mode #82 originally addressed) still falls through to Bordeaux.
2. Widen the sturdyref-polling window from 120 to 240 seconds and the outer `timeout` on the background `guix shell` from 300 to 600 seconds. The 600-second upper bound covers a degraded-substitute-network startup plus the Guile host's steady-state lifetime; the 240-second polling cap leaves a generous margin, and the existing `kill -0` guard still exits the loop the instant the background process dies.

**Justification.** The change leans into iteration I's two-server pattern rather than introducing a new mechanism (mirror snapshot pinning, `continue-on-error`, etc.). Iteration I established that the daemon can list both servers and authorize both keys; the original ordering was opinionated about which server to prefer, and the 2026-05-14 outage revealed that the opinion has a slow-path cost when the preferred server is unreachable rather than returning errors quickly. The reorder costs nothing in the nominal case (substitutes resolve in seconds when either server is healthy) and removes the connection-timeout-per-item penalty when Bordeaux is the degraded one. The polling-window and outer-timeout widening is defense-in-depth so that the bound that fires first on a slow-startup day is the process tree's own, not an arbitrarily-short polling ceiling. Together they keep the diff small, the behavior change concentrated, and the failure-mode coverage symmetric.

Affected paths: `.github/workflows/ocapn-guile-interop.yml` only. No package observable behavior; no changeset (consistent with #82).

Self-improvement: nothing this time.
