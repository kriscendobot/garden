Panel-3 fix stage complete. Applied the round-3 must-fix and substantive should-fix items to `designs/pass-style-symbol-condition.md` (and one em-dash fix in `designs/README.md`), pushed as a follow-up commit, and CI came back green.

## What I did

Read the latest panel verdict (round 3, request-changes across critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice, orthographer), verified each factual claim against the actual sources in a fresh checkout, then edited the design document.

**Must-fix items resolved:**
- **critic** (type resolution): Corrected the false claim that a consumer setting `customConditions: ["pass-style-symbol"]` in its own tsconfig gets variant types. Verified `#pass-style-symbol-impl` is package-private, public `exports["."]` is unconditional, and a consumer consumes the producer's pre-emitted `.d.ts`. Reframed the variant-gated **public** `.d.ts` via `exports` `types` conditions as the *required* fix (open question 5 updated to match), not an additive refinement.
- **skeptic** (call-site count): grep-verified the count is **seven**, not four; named `decodeToJustin` (`marshal-justin.js:176`/`:334`, a public `@endo/marshal` export) as a decode-reachable leaf whose `assert.typeof(sym, 'symbol')` guard breaks; added it to the test catalog.
- **decomplector** (option-(b) contradiction): Resolved it — under the recommended probe a hand-built tagged object is *rejected* under default (same end result as option (c)); the "recognized rather than rejected" benefit actually belonged to the rejected option (a). Rewrote the (b)-over-(c) rationale, the Summary claim, and open question 1.
- **ergonomist** (silent two-switch divergence): Added an enforceable-check fallback (dev-mode assertion / CI invariant) plus the public-types structural fix, replacing the "document it" remedy.
- **pedant** (em-dash): Fixed the `designs/README.md` em-dash.

**Should-fix / minor:** added the third silent breakage class (interning/identity loss), the second `@@`-narrowing casualty (`Symbol.for('@@foo')`), corrected the hardenIsNoop non-precedent, noted the world-query vocabulary seam, added default-rejection + variant-acceptance probe tests, and applied the copyeditor/pedant/orthographer/novice fixes (redundant clause, awkward parenthetical, forward-reference glosses, ESLint capitalization, `i.e.` comma, citation-form consistency, "labeled"). Kept the design document em-dash-clean throughout (removed the 16 I introduced).

**Verification:** design doc `grep -c "—"` = 0; commit `a4c83a896c` pushed to `origin/design-pass-style-symbol-condition` via `safe-push-pr-head.sh`; `ci-wait-merge.sh` returned rc 0 (5/5 checks, 0 failed).

Per the stage contract I did not re-run the panel; the driver re-posts panel-4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1156-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 122 tokens (6390105 cached reads)
- Output: 49859 tokens
- Cost: $5.689281499999999
- Wall-clock: 1049s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
