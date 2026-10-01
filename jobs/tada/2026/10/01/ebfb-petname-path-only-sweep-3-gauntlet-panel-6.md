Panel round 6 on endojs/endo-but-for-bots#1390 returned **must-fix**. `panel.sh` exited 0, and the verdict is posted to the PR as review 5384015511 against head `93cbfe15fe`. That review is a plain comment rather than a request-changes review: the bot opened this PR, and GitHub won't let it request changes on its own PR. Rounds 1–5 were posted the same way.

**The run:** single-round mode against a separate checkout of `build/pet-name-path-only`, with the base given as its commit `8e53cc0f89` (`llm-8e53cc0`). All 33 seats finished and none errored. 8 seats asked for changes (assessor, corner-prober, engine-realist, locksmith, prover, pruner, spec-keeper, wire-watcher) and 9 left comments only; the rest approved. The automatic checks on design evidence, the PR description template and related designs all passed this time. The comment-banner check flagged the PR, which brought in the archivist seat, and it approved. The run is recorded as `panel-runs/endojs-endo-but-for-bots-1390/acf9979bf6a0`.

**What has to change** (I checked items 1 and 2 against the head myself):
1. **Pet names are still split on `/` in three places**, against this PR's own rule that a pet name is never split:
   - `send-form.js:800` is new in this diff.
   - `send-form.js:727` is older code the PR left in place.
   - `space-chat/src/inbox.js:613` is new, and it is a security issue: a value containing `/` used to be rejected as an invalid name, but now passes as a multi-segment path that resolves across the directory tree.
2. **Duplicate names in `mention-send.js:39-43`:** the clash check renames a duplicate only once. With three or more recap entries sharing a name, two end up identical, the daemon rejects the send as a duplicate, and nothing catches the error, so the mention is silently dropped.
3. **`namePathLabel` crashes on some valid pet names:** a name containing a lone UTF-16 surrogate passes validation, but `encodeURIComponent` then throws `URIError`. The new property test can generate that input, so it will fail CI now and then.
4. **Missing tests** for the six files the "never split" commit changed, and for the rename in `value-component.js`.
5. **One sentence to cut** from `daemon/AGENTS.md:98-99`, which explains implementation rationale rather than the API.

The review also lists the should-fix and comment-only items: a missing length guard on the derived scratch-mount name, naming inconsistencies, a stale README and design table, a dropped changeset note, and a missing summary comment for the round-5 fix push.

Next comes the fix stage, run by the gauntlet driver. I made no changes to the garden repo.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-sweep-3-gauntlet-panel-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1152387 cached reads)
- Output: 7815 tokens
- Cost: $1.0421614000000001
- Wall-clock: 1053s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
