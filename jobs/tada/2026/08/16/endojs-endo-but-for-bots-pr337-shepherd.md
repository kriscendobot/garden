Empty inbox. Job complete.

---

## Shepherd report — endojs/endo-but-for-bots PR #337

**Outcome: CI is GREEN.** Head `698fe57204126053bd11f411404b0116132e715e` now shows zero failing and zero pending checks.

### What was failing
One matrix leg — `test (24.x, ubuntu-latest)` — while its three siblings (22.x-ubuntu, 24.x-macos, 22.x-macos) passed on the same commit. The failure was an **open-handle exit leak**, not an assertion failure: `@endo/cli#test` printed `Failed to exit when running test/component/<file>.test.js`, then `Exiting due to SIGINT` with N tests left pending. **Zero `✘` assertion failures** — every test that ran passed.

### Diagnosis
- The leaking/interrupted file **varied every run** (attempt 1: microblog / inventory-component; attempt 2: inline-define / inline-command-form) — a timing-and-load-sensitive probabilistic leak in the `packages/chat`+`packages/cli` DOM component suite, isolated to the node-24-ubuntu leg.
- **Categorically unrelated to #337's diff.** The PR changes only `packages/where` (path-function scaffolding — index.js, types.d.ts, 4 tests, a changeset). `@endo/where` is a near-universal dependency, so turbo's affected-set drags the whole component suite into the run; the leak lives in that suite, not in the diff.
- **Pre-existing and cross-PR.** The unrelated `feat/cbors-package` PR hit the identical symptom (`@endo/cli#test`, SIGINT, pending `forum.test.js`/`heat-bar.test.js`). Most other PRs' 24-ubuntu legs pass, confirming it's a probabilistic flake, not a deterministic break.

### Action taken
Treated as a flake and re-ran the failed leg (`gh run rerun --failed`). It failed a second time (different files), then **passed on the third attempt** — run `31927636756` is now `success` and the PR rollup is clean. No commit was pushed (correctly — a nudge commit would be the wrong move for a component-harness leak on a `where` PR), and no PR comment was posted (job body carried no commenting authorization).

### Classification
`next: none` — operational flake, cleared on re-run.

### Follow-up (not blocking this PR)
The real fix is an open-handle teardown in the `@endo/cli`/`@endo/chat` component test harness, and belongs on the `llm` base branch — not smuggled into a feature PR. It recurs across unrelated PRs and wastes reruns; worth a targeted fixer/designer job against `llm` if the maintainer wants the flake retired at source. Recorded a fleet memory (`endo-cli-component-exit-leak-flake`) so future shepherds recognize the signature and retry rather than hunting the PR diff.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr337-shepherd.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 46 tokens (1635036 cached reads)
- Output: 19723 tokens
- Cost: $1.9970339999999995 (1 engagement(s) unpriced)
- Wall-clock: 799s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
