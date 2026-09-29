Fix round 2 for endojs/endo-but-for-bots PR #1348 is pushed and CI is green: 33 checks, 0 failed at the new head `5e1166a38b`.

**All three must-fix items are done:**
- **Phase ledger (integrator):** I edited the PR description; no code commit.
  - The `Design:` line now names only `designs/daemon-agent-tools.md`. `designs/README.md` moved to its own `Status-index:` line, because the phase-evidence gate blocks when a design file the PR touches is missing from the ledger.
  - Phase 2 and Phase 4 are now `deferred`, with the partial progress stated.
  - A new `Slice-justification:` line explains why this counts as a deliverable: every phase it depends on is done, and the deferred ones come after it or are separate from it.
  - Run against the new description, the gate returns `attention` (rc 10) with no blocking findings, the same state as before.
- **Fetch-plugin claims disagree (integrator):** commit `9e6302620c` narrows the claims in `designs/daemon-agent-tools.md` to "`makeHttpTool` landed (#661)". Whether the fetch plugins have landed is left to `designs/endo-fetch.md`; I didn't change that design's status in this PR.
- **Missing summary comment (scribe):** posted at https://github.com/endojs/endo-but-for-bots/pull/1348#issuecomment-5882593562. It covers the round-1 fixer push, this round's changes, what I declined, and verification.

**Should-fix items I did:**
- **`defineWorkspaceAgent` silently dropped caller tools** (commit `071aa2de75`). It now throws if tools arrive through `config.tools`, the make options, or an `endow` hook. An `endow` hook can still supply `getApiKey`. The types now exclude `tools`, a new test covers this, and the agentry README scopes the "never searches a guest petstore" claim.
- **Stale comment in `git-remote.js`** (commit `5e1166a38b`). The collision-hazard note now points at the workspace name qualification, and says the `fetch` vs `makeHttpTool` collision is outside the workspace catalog.
- **Title hid a breaking change.** It is now `feat(agentry,agent-tools)!: integrate explicit workspace capability tools`.

**Declined (reasons are in the PR comment):**
- A test for the name-collision error: no combination of real grants can trigger it any more, and testing it would mean exposing a private helper.
- Regrouping the commits: that would rewrite the reviewed branch history mid-gauntlet.
- The purist's comment-only suggestions, left as possible follow-ups.

In `packages/agentry`, the targeted tests pass (4). `yarn lint` has no type or lint errors; its 5 warnings are all in files this PR doesn't touch. Panel-3 is next, posted by the driver.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1348-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2561941 cached reads)
- Output: 15568 tokens
- Cost: $1.5702682000000003
- Wall-clock: 1789s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
