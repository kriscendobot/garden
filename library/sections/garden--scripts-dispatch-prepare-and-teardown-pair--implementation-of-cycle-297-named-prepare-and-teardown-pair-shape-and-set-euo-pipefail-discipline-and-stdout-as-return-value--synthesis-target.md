---
title: Synthesis target
section-slug: garden--scripts-dispatch-prepare-and-teardown-pair--implementation-of-cycle-297-named-prepare-and-teardown-pair-shape-and-set-euo-pipefail-discipline-and-stdout-as-return-value
source-slug: garden--scripts-dispatch-prepare-and-teardown-pair
url: https://github.com/kriskowal/garden/blob/main/scripts/dispatch-prepare.sh
authors: [Endo project (collective; the garden's named-role-as-author convention)]
repo: kriskowal/garden
path: scripts/{dispatch-prepare.sh, dispatch-teardown.sh}
total-lines: 111 (65 + 46)
ingest-cycle: 298
ingest-date: 2026-06-11
lane: chat
scope: full
parent: garden--scripts-dispatch-prepare-and-teardown-pair--implementation-of-cycle-297-named-prepare-and-teardown-pair-shape-and-set-euo-pipefail-discipline-and-stdout-as-return-value
---

Slot machine library `@game/scripts/{tournament-prepare,tournament-teardown}.sh`: `set -euo pipefail` strict-mode; stdout-as-return-value with stderr-for-errors; `exit 64` for usage errors per sysexits.h; `openssl rand -hex 3` for 6-hex-char tournament-id; `$(cd "$(dirname "$0")/.." && pwd)` for canonical-script-location-discovery; named-roll-back-on-failure if the game-fork bare clone IS missing; actionable-error-message naming the fix ("clone first via:..."); `rmdir || rm -rf` best-effort-cleanup; named-search-bare-clones for the game-table worktree (search-rather-than-store); defensive-glob-handling via `[ -d "$bare" ] || continue`; shell-parameter-expansion (`${REPO%/*}` + `${REPO#*/}`) for owner-and-name-split; Layout-comment at the top; idempotent-cleanup discipline; fast-path-for-already-gone; rationale-comment naming the anti-pattern (`rm -rf` would leak git's worktree admin); `-C` vs `--git-dir` targeting based on whether the repo IS checked-out or bare.
