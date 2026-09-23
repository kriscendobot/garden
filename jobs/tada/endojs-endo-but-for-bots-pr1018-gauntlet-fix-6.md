CI is green. The fix stage is complete.

## Completion report

**Job:** Gauntlet FIX round 6 for endojs/endo-but-for-bots PR #1018 (design PR editing `designs/ironhorse-panic.md`, head `endojs:design/ironhorse-panic`).

**Panel verdict applied** (round-6 must-fix, seats critic/skeptic/decomplector/ergonomist/copyeditor/pedant/novice):

- **pedant (must-fix):** Purged all 65 em-dashes from prose (rewritten to periods, parentheses, or colons per the em-dash-style skill, judgment-call not mechanical) and fixed the U+2192 arrow `snapshot→replay` → `snapshot->replay` (also flagged by copyeditor).
- **critic (request-changes):** (1) Corrected the `#[non_exhaustive]` "enforced two ways" framing — it only forces a wildcard arm and does not block explicit variant enumeration, so the clippy lint is named as the single load-bearing enforcement, with `#[non_exhaustive]` + doc comment recast as discovery-time friction. (2) Scoped the fsync "settled" claim.
- **skeptic (request-changes):** (1) Reframed the `GET_CLOSURE`→`raise_js` conversion as an unconditional default-build ECMA-262 conformance fix (captured-binding TDZ reads are uncatchable today), not a Coda prerequisite. (2) Scoped the group-commit "settled" claim to multi-worker concurrent load and added an Open Question for the single-busy-vat per-crank fsync cost.
- **decomplector:** Generalized the replay-determinism pin into a "replay-relevant `Machine`-config fingerprint" (of which `panic-on-reference-error` is the first member); lifted the flat/nested `Halt` asymmetry into Open Questions.
- **ergonomist:** Documented the rationale for the `CrankOutcome::classify` associated-function spelling (canonical constructor on the destination enum); framed `barrier` as the elimination/fallback case, not a peer behavior.
- **novice:** Added a load-bearing gloss for `longjmp` (why it makes termination uncatchable).

**Changed:** `designs/ironhorse-panic.md` (+180/−99). Committed as `efcf04a26` and pushed to the PR head via `safe-push-pr-head.sh` (fd4c5a494 → efcf04a26, advance mode).

**CI:** GREEN — 5/5 checks passed, 0 failed (`ci-wait-merge.sh` rc 0, `--no-merge`).

**Follow-ups:** None blocking. Remaining round-6 items were comment-only novice clarity nits (opening-paragraph term budget, "read first" forward pointers, embargo-reconciliation forward references); the driver re-posts panel-7 to re-adjudicate.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1018-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 192 tokens (8885386 cached reads)
- Output: 44696 tokens
- Cost: $7.268585999999999
- Wall-clock: 1086s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
