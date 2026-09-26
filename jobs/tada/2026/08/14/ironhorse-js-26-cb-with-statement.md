---
handed-off: ironhorse-js-26-cb-with-closure
deliverable-complete: false
---
I've completed a thorough feasibility assessment and posted a durable, verified decomposition. Here is my report.

## Completion report: `ironhorse-js-26-cb-with-statement`

**Outcome: honest handoff via nested orchestration** (mirroring how the sibling `ca-regexp-unicode` cluster handled its own over-budget scope in this same arc).

### What I did
- Set up an isolated project checkout at the pinned head `b3c3ae93`, initialized the `c/moddable` XS oracle submodule (`23b4d6b0`), and **verified the full build + oracle harness work end to end** — built `ironhorse-xst`/`ironhorse-262-report` (release) and ran a live differential slice.
- **Located a valid pinned test262 checkout** (`be13516f`) and ran `full-run.sh --subtree language/statements/with`: **covered=20, unsupported=161** (140 of them `unsupported-opcode:with`, the rest belonging to other clusters — `eval:string-source`, `to_instance:primitive-box`, `native-call:Function`).
- **Traced the exact mechanism.** The parser already parses `with` (and rejects strict `with`); the coder already emits `XS_CODE_WITH`/`WITHOUT` (`code_with`, `scope_coding_body_eval`, params-eval prelude). The gap is purely in `ironhorse-vm/src/interp.rs`: no handler for `XS_CODE_WITH`/`WITHOUT`, so both fall to the default `Halt::Unsupported(op.name())` → the whole 949-case cluster. I read the XS ground truth (`xsRun.c` WITH/WITHOUT/EVAL_REFERENCE, `fxNewEnvironmentInstance`, `fxIsScopableSlot`, GET/SET_VARIABLE) and the ironhorse resolution/metering model.

### Why handoff
The cluster is one VM feature — the XS `mxEnvironment` register/chain model — but closing it requires a rewrite of ironhorse's name resolution (env-chain walk with `@@unscopables`, object-`with` and eval-prelude closure-cell publishing) **plus exact-computron calibration across many case shapes**, without regressing the large covered baseline or the exact-metering corpus. That exceeds a single handler's safe budget, and a half-calibrated push would risk new `ironhorse-failure`s (a forbidden regression). Per the job's explicit instruction for an over-budget cluster, I sub-decomposed rather than partially relabel. **No project code was changed.**

### Durable continuation (verified on `origin/journal2`)
Posted orchestration **`ironhorse-js-26-cb-with-closure`** (serial, halt-on-failure, state: pending) with 5 parked `orchestrated` children, each carrying the shared mechanism analysis, pins, acceptance bar, and oracle-execution/exact-metering gates:
1. `ironhorse-js-26-cb-with-env-core` — foundational: `mxEnvironment` chain + `WITH`/`WITHOUT` + `EVAL_REFERENCE` walk + `@@unscopables` + GET/SET_VARIABLE; deliver `language/statements/with`.
2. `ironhorse-js-26-cb-with-eval-closure` — sloppy direct-eval closure publishing (`STORE` into env instances); `language/eval-code` (~250).
3. `ironhorse-js-26-cb-with-annexb` — Annex B block-function hoisting through eval; `annexB/language` (~145).
4. `ironhorse-js-26-cb-with-statements-exprs` — residual `language/statements`+`expressions`+`function-code`/`identifier-resolution`/`types`.
5. `ironhorse-js-26-cb-with-builtins-strict` — `Proxy`/`Array`/`Function` residuals, the 6 `strict:unsupported-opcode:with`, and a final full-cluster closure sweep.

### Head SHA / PR
Starting head `b3c3ae93b81c0f266458cd25f2f27d94ef80cc5b`; PR https://github.com/endojs/endo-but-for-bots/pull/970 (kept open/draft, not merged). Cluster totals unchanged (949 actionable) pending the orchestration.

### Follow-ups
- The `garden-orchestrate` watcher (leader-only) will promote `env-core` first, then the rest serially.
- Note: the deployed garden-root `journal/` worktree lagged origin during the run; authoritative state was confirmed by cloning `origin/journal2` from GitHub.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-26-cb-with-statement.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 142 tokens (7571631 cached reads)
- Output: 53289 tokens
- Cost: $6.610309500000001
- Wall-clock: 918s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
