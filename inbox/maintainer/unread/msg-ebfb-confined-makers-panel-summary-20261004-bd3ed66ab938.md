from_host: endolin-garden-ece02cb4
from: gardener:ebfb-confined-makers-panel-summary-20261004
reply_to: ebfb-confined-makers-panel-summary-20261004
msg_key: msg-ebfb-confined-makers-panel-summary-20261004-bd3ed66ab938
notice_count: 1
first_seen: 2026-10-04T04:49:58Z
last_seen: 2026-10-04T04:50:00Z
sent_at: 2026-10-04T04:50:00Z
---
Confined application makers, phases 1–2 (endojs/endo-but-for-bots endojs/endo-but-for-bots#1417 → endojs/endo-but-for-bots#1419): merge-decision summary

Both PRs are draft and stopped at the 6-round review budget. Each panel round turned up fewer and smaller findings. Every round-6 must-fix has a fix pushed, but **neither latest head has been reviewed by a panel**. CI is green on both. No design-level objection is open on either PR.

## 1. endojs/endo-but-for-bots#1417: makeTreeReadPowers (merge first)
https://github.com/endojs/endo-but-for-bots/pull/1417 · head 85457233dd · CI green (33 checks) · last panel ran on 7e0be5e1a2, so the round-6 fix (one commit) is unreviewed.

Round-6 must-fixes, all addressed in 85457233dd according to the fix summary:
- percent-encoded control characters now refused after decoding
- PR body refreshed
- `canonicalSegments` rename carried into the design
- missing fix summaries posted

Still open:
- **Must-fix (small, mechanical): regroup the commits.** There are 14 commits: six `fix(platform)`, two one-line `chore: Update yarn.lock`, plus docs. The fixer deferred this because it needs a force-push. The repo merges by rebase, so the fix-up noise would land on llm as-is. Regroup into feat / test / docs / one `chore: Update yarn.lock`.
- **Follow-up:** a malformed escape, `?` or a raw `#` makes the code throw where Node returns. Refusing is defensible, but the module docs should say so.
- **Follow-up:** the module needs a host `URL`, so it fails at construction on XS. This matters for Phase 2's XS parity.
- **Follow-up:** use `makeExo` + `M.interface` if these powers ever cross a vat boundary.
- **Taste/noise:** NFC/NFD spellings untested, `pathToFileURL('/app')` refused, WHATWG citation, fast-checker property-test suggestions. None of these changes behavior.

**Bottom line: merge after the commit regroup.** Optionally do one quick check that 85457233dd delivers what its summary claims. It is a single commit, and CI plus 424 local tests pass.

## 2. endojs/endo-but-for-bots#1419: makeFromTree node_modules layouts, partial Phase 2 (merge second)
https://github.com/endojs/endo-but-for-bots/pull/1419 · head 4c833373a0 · CI green, but against the frozen base `llm-confined-application-makers-p1-0bdf895`, which is endojs/endo-but-for-bots#1417's round-1 head · last panel ran on 8d7eda22b3, so the round-6 fix (two commits) is unreviewed.

Round-6 must-fixes, addressed according to the fix summary:
- `entry: ''` and an empty `compartments: {}` are now refused
- a mount rooted at `/` works
- the design names the Node-supervisor-only constraint (Decision 7, Phase 2b)
- PR body trimmed

Still open:
- **Must-fix, found in this research, not by the panel: restack on endojs/endo-but-for-bots#1417's final head and rename an option.** endojs/endo-but-for-bots#1417 renamed the `makeTreeReadPowers` option `canonical` to `canonicalSegments` after the snapshot endojs/endo-but-for-bots#1419 is based on. endojs/endo-but-for-bots#1419 still passes `{ root, canonical }` (capture-node-modules.js). Against the final endojs/endo-but-for-bots#1417, that key is silently dropped by destructuring. Mounts would then lose the host-private canonical hook, which removes both the dedupe of in-root links and the refusal of links that leave the root. endojs/endo-but-for-bots#1419's tests must also be re-run against endojs/endo-but-for-bots#1417's later semantics (directories treated as absent, control-character refusal, empty-segment collapse).
- **Must-fix (small):** same commit cleanup as endojs/endo-but-for-bots#1417. Fold the six `fix(daemon)` commits into the commits they amend, and drop the `(endojs/endo-but-for-bots#1339)` suffix from the subject of 68e9dac0b9; under rebase-merge it reads as "landed via endojs/endo-but-for-bots#1339".
- **Maintainer scope call, not a defect:** the PR calls itself a partial Phase 2 slice. It is Node-supervisor only: under the XS supervisor every node_modules layout refuses. The Node-vs-XS parity evidence is deferred to endojs/endo-but-for-bots#1339 / Phase 2b, and the integrator wanted it kept draft until then. Merging means accepting the slice. The design now documents the gap, so nothing contradicts it.
- **Follow-up-worthy, cheaper before merge:**
  - Drop the `'package'` layout. It is always refused, so every consumer has to `Exclude` it.
  - Settle the `runningAs` / `treeLayoutRunningAs` naming, and narrow the bare `string` return types, before the published inspector property ships.
- **Follow-up:** lookup-failure messages are joined into a plain error string that can contain mount host paths, bypassing `X` redaction. This is a minor information leak; keep the errors structured.
- **Taste/noise:** `refuse` uses plain templates instead of `X` + `bare()`; duplicated compartment-shape check; `any` casts in `runTreeAs`; the typist's JSDoc enumeration nit.

**Bottom line: merge after a named small fix** (restack onto final endojs/endo-but-for-bots#1417, rename `canonical` → `canonicalSegments`, regroup commits), and only if you accept a Node-only partial slice. If you want parity first, keep it draft. Either way it does not need a redesign.

Phases 3–5 can be unparked once endojs/endo-but-for-bots#1417 lands. I pushed nothing and staged no gauntlet.
