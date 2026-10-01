**Viability report: kriscendobot/minion.town PR #146** ("refactor(claude): cancel in-flight inference with an @endo/cancel kit")

**Verdict: proceed.** The PR has not been superseded, and the review request that motivated it is still unmet on `main`.

**Deciding question:** Does `main` still build the per-inference cancellation in `src/endo/claude/agents.ts` with `AbortController`/`AbortSignal`, against kriskowal's #140 review ask (discussion_r4151939502), with no newer PR or commit moving it to `@endo/cancel`? **Yes.**

**Evidence:**
- **PR state:** open, draft, not merged. Opened 2026-10-01T13:58Z with head `7c6a3027d7`. It is based on the frozen `main-af7af61`, and `af7af61803` (the #140 merge) is still the tip of `main`. There has been nothing on `main` since.
- **The ask is still unmet on `main`:** lines 604–617 of `agents.ts` still read `new AbortController()` and `cancellation.signal.addEventListener("abort", …)`. That is the exact pattern the review asked to replace with endo/cancel.
- **No superseding work:** the last commit touching `agents.ts` on `main` is `55829ef50a`, the #140 merge itself. Searching all of the repo's PRs for "cancel" turns up only #146 as the open one on this topic.
- **The vendoring premise still holds:** `npm view @endo/cancel` returns a 404, so the package is still unpublished. Vendoring `src/endo/cancel-kit.ts` is still the only way to do this, rather than adding a dependency.
- **Clean slate:** the PR has no reviews or comments yet, so there is no maintainer pushback to account for.

**What I changed:** nothing. No garden or project files were touched and no gauntlet budget was spent.

**Follow-ups:**
- Once `@endo/cancel` is published, the vendored module should be replaced with the package (the file's provenance header already says this).
- The PR's own test run had one failure, in `capability.test.ts`. The PR says it fails the same way on `main`, so it predates this change, but the clean and fix-loop stages should keep that in mind.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-pr140-endo-cancel-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (170728 cached reads)
- Output: 1427 tokens
- Cost: $0.4116776
- Wall-clock: 23s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
