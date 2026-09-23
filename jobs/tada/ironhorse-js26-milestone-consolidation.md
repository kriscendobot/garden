All six milestones are parked with go-ahead gates and real budgets; all 37 over-fragmented children are removed; intl families and the pause marker are untouched. The board work is complete and verified on `journal2`. My cwd (main2) worktree has no garden-source changes — this job's deliverable lives entirely on the journal board.

Here is my completion report, including the requested decomposition of the out-of-scope multi-day clusters.

---

## Completion report — ironhorse-js26-milestone-consolidation

**What I did.** Read the 37 parked `ironhorse-js-26-*` causal sub-children and the re-scope proposal (`jobs/tada/ironhorse-test262-residual-rescope.md`), grouped them by their `orchestrated_by` family, then replaced the over-fragmented set with **6 per-family milestone jobs** (closeable families) and produced a decomposition report (below) for the **5 multi-day clusters** the maintainer put out of scope. All board writes went through the sanctioned producer-clone path (`post-plan.sh` for the mints; a CAS-loop `git rm` mirroring it for the removals) — no raw git in the root or journal worktree.

**Milestones minted** (all `gate: go-ahead`, `tier: mentor`, budgets under the ~3.98 h/14 328 s claim cap; each body carries the *commit-partial-gains* discipline, the kept quality bar — real XS-oracle execution, no relabel/suppress/skip-list, no baseline regression — the pins, and prerequisite-first ordering):

| Milestone | Consolidates | Budget | Prerequisite-first note |
|---|---|---|---|
| `ironhorse-js26-milestone-with-opcode` | `cb-with-{annexb,statements-exprs,builtins-strict}` (3) | 14000 | VM `XS_CODE_WITH/WITHOUT` handler first → ~949-case cascade clears. Carries the full mechanism context. |
| `ironhorse-js26-milestone-native-callables` | `ce-fn-native-receivers` (1) | 10800 | Route native/bound receivers through `call_native`. |
| `ironhorse-js26-milestone-async` | `ch-async-fromasync-{a,b,c,d}` (4) | 14000 | Shared async-iteration/await plumbing first, then fromAsync/Promise/await leaves. |
| `ironhorse-js26-milestone-iterator-collections` | `iterator-helpers`, `map-set-iterator-proto`, `set-map-metadata` (3) | 14000 | Native-fn metadata seam → Iterator Helpers (~635) → collection iterator protos. |
| `ironhorse-js26-milestone-core-builtins` | `cj-date`, `ck-string-number-math-bigint`, `cz-misc-residue` (3) | 14000 | Date (~586, most self-contained) first; each segment banks independently. |
| `ironhorse-js26-milestone-parser-annexb` | `cl-parser-annexb` (1) | 10800 | `parse-or-decode` front-end family, distinct from the runtime `with` opcode. |

**#1046 exclusion honored:** `with-opcode` is the deliberate *first* milestone and is pure `ironhorse-vm` work — it explicitly does not depend on / duplicate / build the `ironhorse`/`ironhorse+ses` hardened262 agent wiring that endojs/endo-but-for-bots#1046 owns. Later milestones note hardened262 (via #1040/#1046) as an optional coverage-ratchet once #1046 merges, never a blocker.

**Removed:** all 37 `ironhorse-js-26-*` parked children (single verified CAS commit). Git history on `journal2` retains their full bodies/mechanism context.

**Left untouched, by maintainer decision:** the 9 `ironhorse-intl-*` families (deferred indefinitely), `numberformat-*`, `ironhorse-branch-regression-fixer`, the pause marker `ironhorse-campaign-paused-20260816`, and the non-js-26 ironhorse plan jobs (`explore-*`, `ocap-workload-optimization`).

### Decomposition of the 5 multi-day clusters (report only — no handler jobs minted)

Common shape: each is **prerequisite-first with a cascading abort shadow**, so a single handler can't close it and it must run as a **standing milestone PR that commits partial coverage gains incrementally** (never orchestration-failing on residual). Recommended decompositions:

1. **RegExp u/v/unicode** (u/v flag reason ≈ 2,870, cross-cutting; also gates Temporal/String/language aborts). This is a whole Unicode-aware regexp engine, not a handler task. Decompose into a **standing milestone PR** landing, in order: (a) the u/v flag parse + `RegExpStringIterator`/`v`-flag set-notation grammar; (b) Unicode property escapes `\p{…}` with the pinned UCD tables; (c) case-folding + `unicodeSets` string-literal matching; (d) `matchAll`/`replace`/`split` observable integration. Each stage lands covered cases and reports residual. Expect the largest downstream cascade — many non-RegExp aborts clear once u/v parses.

2. **TypedArray/ArrayBuffer** (cf-* — 13 removed children; ~3,109 actionable, 1,194 aborts in TypedArray alone). The shared prerequisite is **TypedArray core** (integer-indexed exotic `[[Get]]/[[Set]]/[[DefineOwnProperty]]`, `%TypedArray%` prototype dispatch, detach/OOB checks). Decompose: **(TA-core milestone PR first)**, then bounded follow-on milestones that each become individually claim-sized once core lands — `Atomics` single-agent (~156), resizable/growable buffers + length-tracking views (~290), `ArrayBuffer.prototype.slice`/`transfer`/detach, DataView, and the `%TypedArray%.prototype` method groups (copying/sorting/reducers/search/callbacks/from-of, ~429 in the non-dense Array subset). The cf-* split was right *shape* but wrong *vehicle/order* — it fanned the leaves before core existed.

3. **language expr/stmt/eval** (`cn` — ~5,474 actionable, ~2,056 generic aborts). Broad language semantics; the aborts are entangled with the `with`/eval-environment work (now the `with-opcode` milestone) and the exotic-object MOP (cluster 4). Recommend: **land those two prerequisites first**, then re-measure — a large fraction of `cn`'s aborts will have cleared as a cascade. Whatever remains becomes a residual-semantics milestone PR decomposed by subtree (expressions / statements / arguments-object / eval-code), each committing partial gains.

4. **Object/Array/Reflect/Proxy MOP** (cc-mop 5 + `cm` — ~3,589 actionable). Prerequisite is the **exotic-object metaobject protocol**: generic `[[DefineOwnProperty]]`/`[[GetOwnProperty]]` for Array/Function/arguments/string-wrapper exotics + Proxy trap forwarding with the ECMA-262 invariants. Decompose as a milestone PR ordered: (a) generic ordinary + descriptor-conversion core (`Object.defineProperty`/`getOwnPropertyDescriptor` shared path); (b) Array/Function/arguments exotics; (c) Proxy `[[DefineOwnProperty]]`/`[[GetOwnProperty]]` + revoked/invariant checks; (d) a closure audit. A clean generic seam lets the TypedArray integer-indexed residue (cluster 2) reuse it.

5. **eval/Function/dynamic-import** (`eval-06`, `eval-07` — ~1,945 actionable). Architectural: needs a real runtime-compile path + a module loader. Not a handler. Decompose as a milestone PR: (a) indirect/direct `eval` compile-and-run with correct scope (leans on the `with`/eval-environment machinery); (b) `Function`/`AsyncFunction` constructor dynamic compile; (c) `import()` dynamic-import + module linking. Land (a) first; (b)/(c) cascade partially off it.

**Follow-ups for the maintainer:** promote milestones when the ironhorse pause lifts (the pause marker names this job as the resume gate). Suggested promote order mirrors budget-efficiency and prerequisite value: `with-opcode` → `core-builtins` (Date banks a clean early win) → `native-callables` → `iterator-collections` → `async` → `parser-annexb`. The 5 multi-day clusters remain future work needing a milestone-PR vehicle (and, for RegExp/eval, likely a design pass) rather than handler jobs.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js26-milestone-consolidation.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (3073278 cached reads)
- Output: 37058 tokens
- Cost: $3.502258
- Wall-clock: 617s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
