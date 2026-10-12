PR #1412 fix round 1 is done: I pushed the panel's must-fix and should-fix items as follow-up commits, and CI is green (`ci-wait-merge.sh` rc 0, 33 checks, none failed). The PR is still a draft; the driver re-posts panel-2.

I read panel review 5486102634 and checked each finding against the code.

**Code fixes** (commit `d1fcd6e870`, `fix(claude): bound turn cleanup and close a late MCP server`):
- **Breaker 1:** cleanup at the end of a turn could hang forever. Both backends now run their cleanups through a new `runBoundedCleanups` in `src/turn-guard.js`. It waits at most 5 s on the injected timers for each cleanup, so a credential release, projection close or scratch removal that never answers can no longer keep `infer` from returning.
- **Breaker 2:** in the SDK backend, an MCP server the guest builds after the turn is terminated is now closed instead of leaked.
- **New tests:** a credential release that never answers no longer holds the turn open (CLI backend), and a server built after termination gets closed (SDK backend).

**Docs and types** (commit `2467b3a2de`, `docs(claude): list every backend subpath export and its types`):
- **Archivist:** the README's list of Decision 3 flags now includes the conditional `--permission-prompts none`. The `--disable-slash-commands` flag it questioned stays: the shared flag builder in `argv.js` really does emit it.
- **Surfacer 1:** I took its "document it" option rather than adding `types` entries to `package.json`. The README now says each subpath's types come from the JSDoc, emitted as declarations at pack time (I confirmed `tsconfig.build.json` does this), and that the named option types come from the root entry.
- **Surfacer 2–4:** the README section is now a bulleted list naming every export of each subpath. It also says the root entry does not re-export the backends and that `turn-guard.js` has no subpath. `ChildStream` and `ChildWritable` are now re-exported from the root types.

**PR body** (edited on GitHub, garden marker kept):
- **Integrator:** added the missing Documentation Considerations section. Corrected the Upgrade section: only `@endo/claude` is private and changed here, and the changeset exists because the repo versions private packages too. Compatibility now says the phase-1 `make()` provider and its result tags remain alongside the new backends.
- **Pruner:** cut the per-feature bullets and the module-list sentence from the Description. I kept the Upgrade section, because the integrator flagged its old wording as wrong rather than unneeded.

**Already fixed on the head, so no change:**
- Purist 1: the `true ||` dead assertion is gone, and the test for a grant with only a base URL exists.
- Prover: `turn-guard.test.js` already exists.

**Checks run locally:** all 177 `@endo/claude` tests pass, `yarn lint` has no errors (the remaining 36 are warnings), and Prettier is clean.

**Not addressed, still open for a later round or the maintainer:**
- Purist 2: two environment builders that may drift apart.
- Purist 3: the design doesn't say which of the two launch paths survives.
- Breaker 3: limits don't stop the SDK backend's in-process tools from running after termination.
- The integrator's suggestion to regroup the long commit history before un-drafting.

**Background wait killed:** the first `ci-wait-merge` run was killed at the 10-minute background limit. I polled the checks in the foreground until they finished, then re-ran `ci-wait-merge` for the final green result.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1412-post-weave-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 82 tokens (3702538 cached reads)
- Output: 18787 tokens
- Cost: $1.9463516
- Wall-clock: 2496s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
