CI is green (24 checks, 0 failed). The fix stage is complete.

## Completion report

**Job:** FIX round 1 for endojs/endo-but-for-bots PR #1076 (`test(hardened262): pin %ThrowTypeError% intrinsic metadata`).

**Panel must-fix items applied** (from the panel-1 request-changes verdict), in one follow-up commit `8fd5b9410`:

1. **breaker (blocking) — no strict-mode flag.** Added `flags: [onlyStrict]` to the test front-matter. The test derives everything from the `callee` accessor, which is the poison-pill getter only for an *unmapped* (strict) arguments object; under a future sloppy agent `calleeDescriptor.get` would be `undefined` and `ThrowTypeError.name` would throw an uncaught `TypeError` before any assertion. The flag makes it degrade to a scenario-level skip.

2. **spec-keeper (blocking) — comment misattributed a base-spec invariant to hardening.** Rewrote the metadata comment: `%ThrowTypeError%` is frozen by base ECMA-262 §10.2.4.1 (non-extensible, non-configurable `length`/`name`), independent of SES `lockdown()`; the test now frames itself as pinning that hardening does *not perturb* that pre-existing invariant. Also corrected the loose "reparented onto %Function.prototype%" — its `[[Prototype]]` is `%Function.prototype%` from creation.

3. **purist (should-fix) — pinned two more distinguishing shape facts.** Extended the metadata tuple to assert `%ThrowTypeError%` has **no own `prototype`** (non-constructible built-in) and that the `callee` accessor property is **non-configurable and non-enumerable**. Verified empirically (Node strict + all three harness engines) that the pinned string is now `'function||0|true|true|true|false|false|false'`.

**Baseline regeneration:** ran `yarn test262:update`; the `onlyStrict` flag drops the case from all 12 `*sloppy*` scenarios (entry removed from their `skipped.txt`). The 6 `module`/`lockdownModule` `passed.txt` entries are retained — confirming the three new assertions pass on sesNode, sesXs, and xs under both lockdown and non-lockdown. Reverted an unrelated flaky flap on `xs/module` (`Compartment/prototype/globalThis/defaults.js`) so the diff stays surgical: 13 files (test + 12 sloppy baselines).

**Push & CI:** pushed to `origin/test/hardened262-throwtypeerror-intrinsic-metadata` (`45b9c8439..8fd5b9410`). CI watched to terminal: **GREEN** — 24 checks, 0 failed.

**Not addressed (non-blocking comment-only, out of this fix's scope):** `features: [caller]` ad-hoc feature name; the caller/arguments asymmetric-host guard nit; composite-string per-field diagnostics; coverage report absence. The driver re-posts panel-2 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1076-gauntlet-20260828-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (2644395 cached reads)
- Output: 16706 tokens
- Cost: $2.5942335
- Wall-clock: 913s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
