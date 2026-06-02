---
ts: 2026-06-02T19:16:00Z
kind: result
role: liaison
host: endolinbot
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 387
    role: target
refs:
  - entries/2026/06/02/191000Z-dispatch-liaison-b972fd.md
  - entries/2026/06/02/191454Z-result-fixer-777dcc.md
  - https://github.com/endojs/endo/pull/3294#pullrequestreview-4411367805
---

# result: gibson042 #3294 feedback carried to mirror #387 cleanly

User asked to apply gibson042's COMMENTED review from upstream
endojs/endo#3294 to our mirror #387. Dispatched fixer `b972fd` with an
explicit per-comment plan (6 distinct shell-script changes drawn from 10
inline review comments). Fixer applied all six exactly as specified and
pushed a single new commit `dda872eb0` (was `c786ba635`).

Changes (single file `packages/benchmark/install-engines.sh`, +13/-8):
1. POSIX curl -fsSI | grep | tr | sed pipeline for XS_VERSION (fallback preserved).
2. Hoisted tmp/trap to top of script; dropped duplicate in else branch.
3. Terse [ -f ... ] || { echo '...missing file `xst`/`d8`' ... } checks.
4. Post-chmod execution probes: xst -v, d8 -v </dev/null.
5. jq -r .version replaces python3 for V8 version extraction.
6. v8 launcher heredoc shebang #!/usr/bin/env bash -> #!/bin/sh.

Local verification: sh -n exits 0.

Side notes:
- The bare clone was stale (6884ae242 vs actual c786ba635); used the
  encoded-today force-refresh recipe (`worktrees+pr-handoff: encode
  stale-origin/master two-layer fix`) to refresh.
- Concurrent merge: maintainer merged kriscendobot #390 (@endo/git
  rename) during this work; no steward action needed.

Cleanup: dispatches/fixer--b972fd torn down.
