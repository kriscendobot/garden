## Viability report: endojs/endo-but-for-bots PR #311

**Verdict: proceed.** The bug this PR fixes is still on both masters, and nothing newer has replaced the fix.

**PR facts:** #311 "fix(module-source): pass defineProperty through functor calling convention". It is OPEN and not merged. It is no longer a draft: the May 2026 contractor chain un-drafted it after a 15-seat panel, a fixer pass, and a clean 18-seat re-panel. Its base is the frozen `master-455ce47`, its head is `fix/module-source-define-property` @ `712918f28`, and GitHub reports it MERGEABLE.

**Deciding question:** Does the current master (bots fork and upstream `endojs/endo`) still emit `Object.defineProperty(fn,'name',…)` in the module-source preamble, with no other landed or open PR that replaces it with a host-supplied `defineProperty`?

**Answer: yes.**

**Evidence:**
- On `endojs/endo-but-for-bots` master, `packages/module-source/src/functor.js:61` still emits `` `Object.defineProperty(${cvname},'name',{value:…})` ``. The code moved out of `transform-analyze.js` into `functor.js` during the later module-source refactors (dfdfa085df, c8dcf34f14), but the vulnerable call is unchanged. Upstream `endojs/endo` master has the same line at `functor.js:62`.
- The PR's premise still holds: a module that does `import { Object } from …` shadows the global, so the hoisted-function `.name` call resolves to the import.
- PR searches on `endojs/endo` and the fork for defineProperty, hoisted-name and Object-shadow fixes found no merged or open competitor. #311 is the only PR for this change.
- Base `master-455ce47` is 194 commits behind current master, and the target code now lives in `functor.js`. A later weave or ferry will have to port the change to `functor.js` rather than rebase it mechanically. That is a rebase cost; the PR is still needed.

No clean, panel, fix, CI-wait or un-draft budget was spent, and nothing was changed.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr311-gauntlet-20261007-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (353393 cached reads)
- Output: 2302 tokens
- Cost: $0.5142386
- Wall-clock: 46s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
