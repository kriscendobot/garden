I applied the round-5 must-fix items to PR #1343, pushed the fix, and CI is green on all 26 checks at the new head `a7590864f`.

**What I changed**
- **PR description:** fixed the stale *Compatibility Considerations* line. It said `@endo/cli` was a `patch` bump, but the changeset at head says `minor`, so the body now says `minor` to match. I also added a sentence explaining that Agentry keeps its own `introducedNames` spelling.
- **Agentry README** (`packages/agentry/README.md`, commit `a7590864f`, pushed with `safe-push-pr-head.sh`): explained that Agentry's `introducedNames` is its own spelling and keeps the host-to-guest direction on purpose. Agentry translates it into the daemon's `endowments` map, which runs the other way, so Agentry needs a daemon that accepts `endowments`. The integrator, curator and changeset-auditor jurors all asked for this note.
- **Curator's "must-fix":** it found no remaining `provideGuest` caller that passes `introducedNames`. Its only actionable point was the Agentry README note above.

**CI**
- The first run failed on one cell, `test (22.x, ubuntu-latest)`. All 1137 tests passed; the failure was a single unhandled `Termination requested` rejection in `@endo/daemon` `test/endo.test.js`. My change touched docs only, and this matches a known intermittent failure on that cell.
- I re-ran the failed job and it passed, which gave the green result.

**Not done (should-fix and comment-only items, left for later rounds or the maintainer)**
- The integrator's commit folding (`5f0311ed8` into `aa1aaa9cc`, and `12f5331c5` into `166b9f15b`) needs a history rewrite, which this round's follow-up-commit approach doesn't do.
- The reserved special names are still listed in more than one module; the jurors suggested one shared constant.
- The typist's branded-type notes.
- The test gaps: the CLI `mkguest` translation, and the `ENDO_SPECIAL_NAME_SOURCE_UNAVAILABLE` race branch.
- Pins on host-owned formulas can leak if guest formulation fails after validation.
- Error codes are inconsistent for an endowed `@main` that is not a worker.
- An existing guest found by `agentName` is not checked.
- `getTypeForId(...).catch` discards every error.
- The legacy retained-record translation can silently merge entries.
- The docs don't say that endowing `@main` gives up process isolation.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1343-gauntlet-20261007-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (1783644 cached reads)
- Output: 7602 tokens
- Cost: $1.0765608
- Wall-clock: 3581s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
