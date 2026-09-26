CI is GREEN (rc 0) at the new head. The clean stage is complete.

## Completion report

**Stage:** CLEAN — kriscendobot/minion.town PR #81 (`build/invitation-only-guest-onboarding`), gauntlet `build-minion-town-invitation-only-guest-onboarding-gauntlet`.

**What I did**
- Ran a coverage pass (vitest + `@vitest/coverage-v8`, provider installed `--no-save`) on the two touched sources, `src/web/invitation-envelope.ts` and `src/web/invitation-session.ts`. Baseline was ~94% with four uncovered spots.
- **Dead-code removal (commit `9684d66`):** deleted `isValidFormulaNumber` and its `NUMBER_PATTERN` — a bare-64-hex validator with no caller anywhere (grep across `src/`, `test/`, `designs/`, whole repo found only its own definition; not in the design's intended surface). The browser core only ever validates full `<number>:<node>` identifiers via `isValidFormulaIdentifier`. Deleted rather than kept on test life-support, per the four-criterion dead-code threshold.
- **Regression tests (commit `0092d49`):** covered the two remaining *reachable* branches — `parseFragment` dropping a duplicated (ambiguous) `label` rather than picking one, and `rememberUnconnectedGuest` throwing on an invalid identifier without mutating stored state. `invitation-session.ts` → 100%; the pair → ~97.6% stmts / 100% funcs.
- Left the two genuinely unreachable branches uncovered by design (not life-supported): the defensive `new URLSearchParams(string)` `catch` (a string arg never throws) and the TypeScript `never` exhaustiveness guard. Noted in the test commit message.

**What changed on the PR**
- Two follow-up commits pushed to the PR head via `safe-push-pr-head.sh` (`7ad4376..0092d49`). `package-lock.json` was left untouched (the coverage provider install was reverted).
- Typecheck green; 36 tests pass (was 34).

**CI:** `ci-wait-merge.sh --no-merge` → rc 0, **GREEN** at head `0092d49` (`test (typecheck + vitest)` SUCCESS).

**Follow-ups:** none for this stage. PR remains draft (correct — the panel un-drafts after its fixer loop, not the cleaner).

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-invitation-only-guest-onboarding-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (1864049 cached reads)
- Output: 14543 tokens
- Cost: $1.9619784999999996
- Wall-clock: 292s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
