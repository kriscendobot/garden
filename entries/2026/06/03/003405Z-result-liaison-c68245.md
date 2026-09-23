---
ts: 2026-06-03T00:34:05Z
kind: result
role: liaison
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/03/002904Z-dispatch-liaison-2447fd.md
---

Fixer retconned endo-but-for-bots#387 (dispatch `2447fd`); stage 1 of retcon-and-referry complete.

New bots#387 head `57b9e8f8b`, 3 clean commits on frozen base master-814dfa1:
1. `82f7aae17` fix(benchmark): install xs/v8 via direct download instead of esvu — packages/benchmark/{README.md, install-engines.sh, package.json, run-tests.sh}
2. `ebdcdff7b` chore(hex): point run-benches.sh at the ~/.engines binary cache — packages/hex/test/run-benches.sh
3. `57b9e8f8b` chore: Update yarn.lock — yarn.lock

Net diff invariant held (`git diff pre-retcon..HEAD` empty; same 6 files). Force-with-lease push clean. Bot identity throughout.

Stage 2 next: boatman referry to endojs/endo#3294 (Shape-2 recompute onto endo master 3c5753b67). Upstream attribution mapping (applying the maintainer's standing rule "substantive direct-download commit -> 0xPatrick, chores -> Kris Kowal"): `fix(benchmark)` -> 0xPatrick author / Kris Kowal committer; `chore(hex)` and `chore: Update yarn.lock` -> Kris Kowal author+committer. yarn.lock regenerated on endo master (the bot's frozen-base lockfile is not carried). gibson042's APPROVED on #3294 expected to persist (endo master unprotected).
