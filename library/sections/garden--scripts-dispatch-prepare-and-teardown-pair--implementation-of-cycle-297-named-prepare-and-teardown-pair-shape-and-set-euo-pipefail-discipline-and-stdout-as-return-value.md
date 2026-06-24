---
title: "garden/scripts/{dispatch-prepare,dispatch-teardown}.sh — implementation of cycle 297's named-prepare-and-teardown-pair-shape; `set -euo pipefail` named-strict-bash-discipline; stdout-as-named-return-value with stderr-for-errors; named-roll-back-on-failure; named-search-bare-clones-for-the-project-worktree; named-`rmdir || rm -rf` best-effort-cleanup-fallback"
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
kind: index
section_count: 8
---

Sections:

- [`garden/scripts/{dispatch-prepare,dispatch-teardown}.sh` (pair ingest)](garden--scripts-dispatch-prepare-and-teardown-pair--implementation-of-cycle-297-named-prepare-and-teardown-pair-shape-and-set-euo-pipefail-discipline-and-stdout-as-return-value--garden-scripts-dispatch-prepar.md)
- [Key moves](garden--scripts-dispatch-prepare-and-teardown-pair--implementation-of-cycle-297-named-prepare-and-teardown-pair-shape-and-set-euo-pipefail-discipline-and-stdout-as-return-value--key-moves.md)
- [§the-named-no-shellcheck-suppressions reaffirmed (first-explicit-observation in this script)](garden--scripts-dispatch-prepare-and-teardown-pair--implementation-of-cycle-297-named-prepare-and-teardown-pair-shape-and-set-euo-pipefail-discipline-and-stdout-as-return-value--the-named-no-shellcheck-suppre.md)
- [§the-named-line-count-asymmetry-explained (first-explicit-observation)](garden--scripts-dispatch-prepare-and-teardown-pair--implementation-of-cycle-297-named-prepare-and-teardown-pair-shape-and-set-euo-pipefail-discipline-and-stdout-as-return-value--the-named-line-count-asymmetry.md)
- [Patterns from prior cycles, reaffirmed](garden--scripts-dispatch-prepare-and-teardown-pair--implementation-of-cycle-297-named-prepare-and-teardown-pair-shape-and-set-euo-pipefail-discipline-and-stdout-as-return-value--patterns-from-prior-cycles-reaffirmed.md)
- [Borrowing tiers](garden--scripts-dispatch-prepare-and-teardown-pair--implementation-of-cycle-297-named-prepare-and-teardown-pair-shape-and-set-euo-pipefail-discipline-and-stdout-as-return-value--borrowing-tiers.md)
- [Synthesis target](garden--scripts-dispatch-prepare-and-teardown-pair--implementation-of-cycle-297-named-prepare-and-teardown-pair-shape-and-set-euo-pipefail-discipline-and-stdout-as-return-value--synthesis-target.md)
- [Single most structurally interesting move](garden--scripts-dispatch-prepare-and-teardown-pair--implementation-of-cycle-297-named-prepare-and-teardown-pair-shape-and-set-euo-pipefail-discipline-and-stdout-as-return-value--single-most-structurally-interesting-move.md)
