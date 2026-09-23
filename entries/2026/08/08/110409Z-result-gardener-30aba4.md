---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-08T11:04:11Z
---
---
ts: 2026-08-08T00:00:00Z
kind: result
role: warden
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
---

# Panel — juror `warden` — endojs/endo-but-for-bots#970

Diff base `llm`; reviewed increment `cccc3f4ab..258c76078` (the ironhorse errors/coercions/strict work), read at `rust/engine/ironhorse-vm/src/interp.rs`.

**Verdict: request-changes**

## Findings

**1. must-fix — `Reflect.defineProperty` lost its exotic/global guard (regression from this PR).**
`interp.rs:14419` adds a new arm that calls `ordinary_define_own_property(object, …)` for *any* reference target. The previously-guarded arm (`is_ordinary_object` at `interp.rs:14447`, from `cccc3f4ab:interp.rs:13206`) is now dead for every reference, and there is no global-object guard — while `Object.defineProperty` still deliberately self-names on the same seam (`interp.rs:12134`, "the ordinary-object path does not model that aliasing yet"). So `Reflect.defineProperty(globalThis, 'x', {get(){…}})` performs exactly the mutation `Object.defineProperty` refuses, and `Reflect.defineProperty(arr, '0', …)` writes an ordinary chain property behind the array-exotic path. Restore both guards on the new arm. [rule: roles/jurors/warden/AGENT.md § Operating norms — intrinsic/boundary bypass] [proposed-rule: when a behavior seam is introduced, a new fast arm placed ahead of a guarded arm must carry that arm's preconditions forward, or the guard is deleted, not refactored.]

**2. must-fix — no prototype-cycle check in `Reflect.setPrototypeOf`; the walk it feeds is unmetered.**
`interp.rs:14324-14357` checks extensibility but omits OrdinarySetPrototypeOf step 8's cycle walk. `const a={},b={}; Reflect.setPrototypeOf(a,b); Reflect.setPrototypeOf(b,a)` returns `true` and installs a cycle; `a.missing` then spins forever in `ordinary_get`'s `while !owner.is_null()` loop (`interp.rs:18298`) — and that loop ticks no meter and calls no `check_meter`, so the computron bound cannot abort it. A guest-reachable hang *outside* the metering boundary is a resource-integrity escape, not just a spec gap. `reflect_intrinsic.rs` (touched here) has no cycle case. [rule: skills/adversarial-tests/SKILL.md § SES-specific — prototype-graph attacks]

**3. should-fix — unqualified identifier writes bypass the new `[[Set]]` seam entirely.**
`XS_CODE_SET_VARIABLE` (`interp.rs:5493`) routes to `resolve_set` (`interp.rs:18777`), which writes the global property slot's `kind`/`value` with no `XS_DONT_SET_FLAG` check, no accessor dispatch, and no strict TypeError. `globalThis` is an ordinary object (`is_ordinary_object`, `interp.rs:17903`), so `Object.freeze(globalThis)` / `harden(globalThis)` stamps `DONT_SET` — and then a bare `x = 2` silently *mutates* the frozen binding, in both sloppy and strict code. This is the exact invariant `lockdown()` establishes, and it is asymmetric with the strict TypeError this PR just added one opcode away at `interp.rs:5825`. The read side has the same shape: `resolve_get` (`interp.rs:18758`) returns the raw slot, so an accessor global reads `undefined` through `x` but invokes the getter through `globalThis.x`. Either route `SET_VARIABLE` through `ordinary_set`, or self-name as `Object.defineProperty` does. No test covers a frozen `globalThis`. [rule: roles/jurors/warden/AGENT.md § Operating norms — unguarded globals]

**4. comment-only — `harden`'s visited mark is set before the freeze can fail.**
`harden_enqueue` stamps `XS_DONT_MARSHALL_FLAG` at enqueue (`interp.rs:17986`), but `harden_freeze_and_traverse` can return `Halt::Unsupported("harden:exotic-object")` mid-walk (`interp.rs:18004`), leaving already-enqueued objects marked-but-unfrozen. If an `Unsupported` halt is ever recoverable (the machine supports suspend/resume), a later `harden(x)` short-circuits at `interp.rs:17956` and hands back an unhardened object as hardened. Marking on dequeue, or unwinding the marks on error, removes the question.

**Credit:** the accessor traversal added to `harden_freeze_and_traverse` (`interp.rs:18026-18037`) closes a documented gap — getter/setter functions in a hardened graph are now walked. The strict-mode TypeError on a rejected `[[Set]]` (`interp.rs:5825`) and the ValidateAndApplyPropertyDescriptor port (`interp.rs:18178`) are both faithful reads of the spec, including SameValue's signed-zero/NaN handling over a correctly narrow `numeric_of`.

Self-improvement: the recurring shape in this diff — a new unguarded fast arm silently retiring an older guarded one — is worth a standing warden check ("did a refactor make a precondition unreachable?"), distinct from the "missing guard" check the seat already runs. Proposed as a rule in finding 1; routing to liaison if the panel agrees.
