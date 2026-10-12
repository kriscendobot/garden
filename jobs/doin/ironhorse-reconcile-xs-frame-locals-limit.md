---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Reconcile Iron Horse's frame-locals ceiling (PR #1278) with the landed upstream XS fix

Repo: endojs/endo-but-for-bots, PR https://github.com/endojs/endo-but-for-bots/pull/1278
(draft, head `ironhorse-frame-locals-limit`, base `llm`), crate `rust/engine/ironhorse-compile`.

The upstream fix has now landed: Moddable-OpenSource/moddable commit
`cfe72a8cfcd23b188fbb75ea2786e5fb56432812` ("oss-fuzz: fix crash on scope overflow",
2026-09-10), released in Moddable SDK 10.0.0 (2026-10-07/09). Semantics: in
`xs/sources/xsScope.c`, `fxFunctionNodeBind` / `fxModuleNodeBind` / `fxProgramNodeBind`
each do `if (binder->scopeMaximum > 65535) fxReportParserError(parser, self->line,
"too many variables")` after `fxScopeBound`. So: limit 65535 scope slots (variables
AND compiler temporaries), enforced at bind time per function/module/program, reported as
a SyntaxError "too many variables" at the function/module/program node's line. Upstream
regression test: `tests/xs/issues/scope-count-limit.js` (65535 `let`s with base-36 names
compile; 65536 throw SyntaxError).

The #1278 port MATCHES on limit, enforcement point, and error shape. Divergences found
by running the upstream vectors through #1278's `compile_atoms` + `run_program_with_symbols`
(probe by job xs-locals-limit-check-20261012-213527):

1. **Named-slot boundary is unreachable / XS-valid programs rejected.** XS compiles and runs
   `(function(){ let a0,…,a1ekf; })` (65535 names). Iron Horse: 65534 and 65535 names fail with
   `too many symbols (maximum 65534)`; even 65533 names compiles but the run halts
   `Refused("property-key:id-space-exhausted")`. XS's own regression test's first assertion
   therefore fails on Iron Horse. Decide (and document in the PR) whether to raise the symbol /
   property-key id-space caps to XS parity or record this as a deliberate, documented divergence.
2. **Temporaries path not covered.** The OSS-Fuzz vector is a chain of 32767 tagged templates
   (`` t`` `` `` repeated) inside a function — slots from compiler temporaries, no names.
   XS parses it and (post-fix) rejects with "too many variables"; pre-fix it corrupts byte code
   (`TypeError this: not an iterator (in next)`). Iron Horse's parser fails first with
   `stack overflow`. Add a temporaries-only over-limit vector that the scoper can actually see
   (scoper-level test), or document why none is reachable; consider whether the parser's
   recursion limit for left-recursive tagged-template chains should match XS.
3. **Housekeeping:** update the PR body ("not upstream yet as of 2026-09-14") to cite
   `cfe72a8cfc` / 10.0.0, and port `scope-count-limit.js` as a test (with the divergence noted
   if item 1 is kept as a divergence).

Minor: field-init frames report at the first member's line; XS reports at the synthesized
initializer function's node line. Align if cheap.

<!-- garden-transient-elapsed: kind=signature through=0 values=55 -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-12T22:35:41Z
