---
ts: 2026-06-03T00:41:36Z
kind: result
role: liaison
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/03/003456Z-dispatch-liaison-847db6.md
---

Retcon-and-referry of endo-but-for-bots#387 -> endojs/endo#3294 complete (boatman dispatch `847db6`). The merge-ready finalization the maintainer signed off ("it's good to go").

**#3294** new head `8ff08496837cb9d659e5e218890e4e6f468eb246`, clean 3-commit structure:
1. `04083b87` fix(benchmark): install xs/v8 via direct download instead of esvu — author **0xPatrick <patrick@0xpatrick.dev>**, committer Kris Kowal
2. `84a3f2a1` chore(hex): point run-benches.sh at the ~/.engines binary cache — Kris Kowal
3. `8ff08496` chore: Update yarn.lock — Kris Kowal

Shape-2 recompute onto endo master `3c5753b67`, force-with-lease `983551383...8ff084968`. Net-diff fidelity confirmed: all 5 non-lockfile files match source #387 by per-file patch-id; yarn.lock regenerated on current master (esvu + transitive deps removed). benchmark subtree `98060f1e` == live mirror. Trailers empty; no fork-side suffixes.

**gibson042 APPROVED persisted** (endo master unprotected); MERGEABLE; title/body unchanged; CI re-triggered. Cross-link 4599031642 -> `...head 8ff084968`.

Two-stage chain: fixer retcon (result `c68245`) -> boatman referry. 0xPatrick's credit preserved on the substantive benchmark commit through both stages. The hex per-package commit was attributed to Kris Kowal (judgment call, flagged to maintainer as flippable).

Pipeline note: across this PR's life #3294 went first-time ferry -> Shape-2 (conflict) -> additive Feedback append -> two surgical amends (mirror churn) -> retcon+referry to clean final form. The repeated mirror-amend churn (a66f3c344/e22369065/a179d5aa8) preceding the retcon suggests, for future PRs, letting the bot side settle (or retconning) before the first ferry would reduce re-ferry count.
