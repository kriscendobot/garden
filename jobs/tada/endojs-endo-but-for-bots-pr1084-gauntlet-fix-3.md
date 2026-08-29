CI is **GREEN** (rc 0): all 5 checks passed, 0 failed. The fix stage is complete.

## Completion report

Applied the design-panel round-3 (request-changes) must-fix items to PR #1084 (`docs: Design adaptive exo-stream pacing and buffer control`) in one follow-up commit, pushed to the PR head, and CI went green.

**What changed** (`9c6a1b978`, files `designs/exo-stream-adaptive-pacing.md` and `designs/README.md`):

- **pedant (must-fix):** swept all 27 em-dashes from the new design prose (100% new file, not grandfathered) into periods/parens/colons per `skills/em-dash-style`; also fixed the `re-converges` vs `reconvergence` hyphenation inconsistency. Verified the design file is now clean ASCII (0 em-dashes, no typist-hostile code points); the README's other 83 em-dashes are pre-existing grandfathered entries left untouched, and my new README entry is clean.
- **ergonomist:** corrected the false premise that the new constructors land on the `@endo/exo-stream` barrel `index.js` — verified that barrel is type-only (`export {}`) and every sibling is deep-import-only, so the design now places `makeCodelCreditController`/`makeOccupancyCreditController` on their own `credit-controller.js` subpath matching the convention; also stated the descriptor's unknown-key policy (reject typo'd knobs with a `TypeError`).
- **decomplector:** exposed `policy: 'codel' | 'occupancy'` on the `CreditController` interface so the no-clock delegation to the occupancy fallback is observable on the returned value rather than only inferable from degraded behavior; documented which knobs the fallback honors vs. ignores.
- **skeptic:** specified (not merely asserted) how `tArrive` is captured — an eager arrival callback attached to each node promise as credit is issued, distinct from the numeric path's consumption-instant sampling that would silently disable the shrink half; added a real-timing shrink integration test and an `iterateBytesReader` sibling test to the verification plan.
- **critic:** paced additive increase per window epoch (once per `floor(W)` items) so aggregate growth is `alpha` per RTT-equivalent rather than window-proportional `alpha * W`; updated the mermaid label, worked example, and added a within-`interval` BDP-overshoot assertion; scoped the "occupancy AIMD" naming to the fallback only in Degenerate links.
- **copyeditor / novice:** "the garden" → "this design"; parallelized the integration-test list; split the ~130-word headline-path sentence; added a CoDel forward-pointer, `target0` definition, and BDP expansion at first use; fixed comma splices and the README bracket-within-parenthetical.

**Verification:** docs-only CI (`ci-docs.yml`) ran prettier (scoped to `.github`/`packages`, so `designs/*.md` is unaffected) and TypeDoc; all 5 checks terminal green, 0 failed. Confirmed the two claims I built fixes on (empty `index.js` barrel; the `iterate-reader.js:110-156` node-promise mechanism) against the live tree before editing.

Per stage instructions I applied the must-fix items once, pushed, watched CI to green, and stopped — the driver re-posts panel-4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1084-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 141 tokens (7353922 cached reads)
- Output: 37796 tokens
- Cost: $5.736933000000001
- Wall-clock: 960s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
