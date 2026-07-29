---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-29T02:03:20Z
---
Rebased endojs/endo-but-for-bots#761 onto current upstream endojs/endo master and updated for ferry readiness.

- Old base: master-3f601bc (upstream master snapshot from PR open)
- New base: master-eda7b57 (upstream master at eda7b576e, 44 commits ahead)
- Rebase strategy: `--onto upstream/master origin/master-3f601bc` -- the branch carried endo-but-for-bots fork-specific commits between the common ancestor and old frozen base; --onto applied only the single PR commit cleanly
- No conflicts; diff byte-identical to the original
- Title cleaned: removed "(reconstruct #720 on master)" suffix
- Description: Provenance section removed; upstream-facing description leads; compact provenance note appended
- Verification: 610 patterns tests pass, type build clean
- Completion comment posted: https://github.com/endojs/endo-but-for-bots/pull/761#issuecomment-5111935513

Self-improvement: nothing this time.
