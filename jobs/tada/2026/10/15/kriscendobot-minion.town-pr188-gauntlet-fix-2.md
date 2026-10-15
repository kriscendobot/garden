Fix round 2 for kriscendobot/minion.town PR #188 is pushed as `bb62cc5`, and CI is green: `ci-wait-merge.sh` returned rc 0, read through the Actions runs API.

**What changed** (`deploy/aws/www/shell.js`, `test/shell-clip.test.ts`, `designs/clip-shell-framework.md`):
- **Account isolation** (locksmith, breaker, purist, wire-watcher): if a refresh gets no clip list back, the gutter and pane are now cleared. That covers a network error, a 5xx, or a body that fails to arrive. The list carries no account identity, so the shell can't tell whether someone else signed in since the last read. A new test covers account A's list, then a switch to account B whose refresh returns 503: A's clips disappear. The design doc (§ 3) now says this.
- **Newest read wins** (engine-realist, corner-prober): each read now cancels the one before it, and an older result is never shown. A read that never finishes no longer blocks later refreshes. Tests cover both cases.
- **Selection race** (prover): when the user picks a clip, the new `invalidate()` throws away the in-flight read and schedules a fresh one. This replaces the old selection counter. A controlled in-flight test covers it, plus a source check that user actions call `invalidate()`.
- **Body handling** (spec-keeper, engine-realist): the body is now read as text. If that read fails, the result counts as a failure; only text that isn't valid JSON counts as "no clips". A test covers a body read that throws.
- **Narrower `try` blocks** (saboteur): each one wraps only the call it guards. An error in `onClips` is no longer reported as a listing failure, and a test checks this.
- **Docs and property tests** (archivist, fast-checker): `createClipRefresher` now documents what it returns. Two fast-check properties were added, one for HTTP status classification and one for `clipSelectionAfterRefresh`, each with 1,000 runs.

**Not applied, with reasons given in the PR comment:**
- **benchmarker:** the comments it flagged describe behavior (how many reads happen, whether the pane reloads), and tests cover both, so no benchmark is planned.
- **releaser:** the repo has no Changesets setup.
- **coverage-auditor:** its finding was comment-only.

**Verification:**
- `test/shell-clip.test.ts`: 46/46 pass.
- `npm run typecheck`: clean.
- Full local suite: one failure, `test/git-remote/capability.test.ts` "propagates a git failure", in a file this PR doesn't touch; it probably depends on the local git environment.

I posted the SHA-anchored summary comment the scribe seat asked for: https://github.com/kriscendobot/minion.town/pull/188#issuecomment-6193059541

**Follow-ups:**
- CI sat queued for about 30 minutes because jobs take turns on the single self-hosted `ci-minion-town` runner. My first CI wait ran in the background and was stopped at its time limit; I re-ran the waits in the foreground and the final one reported green.
- The panel-3 re-review is next, posted by the driver.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr188-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (1948246 cached reads)
- Output: 18762 tokens
- Cost: $1.4309052
- Wall-clock: 2164s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
