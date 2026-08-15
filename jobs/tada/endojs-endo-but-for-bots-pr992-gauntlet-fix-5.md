CI is GREEN (rc 0, all 5 checks pass). The fix stage is complete.

## Completion report

**Job:** FIX round 5 of the endojs/endo-but-for-bots PR #992 gauntlet — a design-only PR (`designs/http-adapter-pipeline.md` + `designs/README.md`).

**What I did:** Read the panel-5 request-changes verdict (6 of 7 seats requested changes) and applied every must-fix / should-fix item as follow-up commit `33d202fdf` on the fork PR head `design-http-adapter-pipeline` (checked out from its owner, `kriscendobot`, per the fork-PR-head rule):

- **critic + decomplector (numeric domain):** Split a discrete `IntegerNonNegative` guard from the continuous `FiniteNonNegative`; the cost formulas now widen each integer count with `BigInt(...)` (bare `bigint*number` throws) and state the `ceil` rounding rule for the one continuous term (deadline), so `costActual <= costMax` holds by construction. `@endo/patterns` has no integer-number matcher, so integrality is documented as a boundary assertion (verified against the actual matcher set).
- **skeptic:** Named the retry idempotency mechanism (a retry-stage `idempotentMethods` set, default `['GET','HEAD']`, distinct from `CONFINED_ALLOWED_METHODS`; PUT/DELETE opt-in); added a structural-unreachability test for `attachChargeAccount`; fixed the stale `FeePurse` name to `ChargeAccount`.
- **decomplector:** Named the price-snapshot-at-`reserve()` mechanism for reservation price immunity.
- **ergonomist:** Spelled `CircuitOpenError`/`RateLimitError` shapes + a shared `name` discriminant alongside `InsufficientFundsError`; surfaced the reject-vs-truncate asymmetry of `setMaxRequestBytes` at the verb table and CLI help.
- **critic/skeptic:** Reworded the retry-billing "incentive" framing to cost-attribution.
- **novice:** Reordered the stage-order rationale into a numbered list, added a worked-numbers metering example, glossed "pass-style" at first use.
- **copyeditor:** Fixed the README attachment ambiguity, the ambiguous "stops" comment, the inverted composer pronoun, and the second-person voice slip.
- **pedant:** Sentence-cased two headings, removed the Latin `e.g.`
- Kept the doc free of em-dashes and arrow glyphs (converted the ones I'd introduced to the doc's ASCII idiom), preserving the typist-friendly-code-point cleanliness the panel praised.

**Result:** Pushed via `safe-push-pr-head.sh` (advanced `750ed9d2` → `33d202fdf`). CI watched to terminal: **GREEN** — all 5 checks pass (`build`, `lint`, `test`, `browser-tests`, `zizmor`). Per the gauntlet contract I did not re-run the panel; the driver re-posts panel-6.

**Follow-ups:** Two comment-only items were left as-is by design (the panel marked them non-blocking and the doc already covers them at length): the `estimateCost` → `estimateAttemptCost` rename suggestion, and separating rationale from the illustrative code blocks.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr992-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 2 host(s) (2 unmetered)
- Input: 173 tokens (11745825 cached reads)
- Output: 58865 tokens
- Cost: $8.944523499999999 (2 engagement(s) unpriced)
- Wall-clock: 1207s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
