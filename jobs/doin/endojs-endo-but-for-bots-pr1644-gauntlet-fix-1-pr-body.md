---
posted_at: 2026-11-03T07:29:31Z
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Update the PR body of endojs/endo-but-for-bots PR #1644

The fleet PAT on oros-studio cannot call updatePullRequest on endojs (403), so this job is pinned to endolin. It is the only remaining action from gauntlet fix round 1 (endojs-endo-but-for-bots-pr1644-gauntlet-fix-1), and it answers the integrator and pruner panel findings on the body.

Replace the body of https://github.com/endojs/endo-but-for-bots/pull/1644 with the text between the markers, verbatim, using `gh pr edit https://github.com/endojs/endo-but-for-bots/pull/1644 --body-file <file>`. Do not change anything else. Then read the body back and confirm it matches.

----- BODY -----
Refs: designs/endopi-iterative-compaction.md (M9)

## Description

A Lal worker's transcript used to grow until the provider refused it. Now the worker compacts the conversation as it nears the model's context window: older messages become one structured summary, and recent messages stay verbatim. The host can also compact on demand by sending the worker `/compact [instructions]`.

`packages/lal/compaction.js` is the file to review most closely, with the `/compact` branch of `packages/lal/inbox-loop.js`. `packages/lal/README.md` describes the behavior and settings, and the Status section of `designs/endopi-iterative-compaction.md` records what remains.

The job asked to extend `packages/genie`, which `42bc7d516` retired, so this builds on the Lal transcript as the design's own Design section says.

The main cost of landing now: until the design's step 4 lands, elided messages are not saved anywhere the worker can read them.

<!-- garden-phase-evidence-ledger:v1 -->
## Phase and evidence ledger

Design: `designs/endopi-iterative-compaction.md`
Index: `designs/README.md` (status and date)
Disposition: deliverable
Acceptance: satisfied | the design names no acceptance observations and no numbered phases; `spawnWorkerLoop` was exercised end to end against a local fake endpoint, and no live vendor run was made. Step 4 (the JSONL `compaction` entry) is not in this PR: it belongs to phase 4 of `designs/endopi-jsonl-transcript-format.md`, which that design sequences after this work lands, so this design's status is In Progress
<!-- /garden-phase-evidence-ledger -->

### Security Considerations

- **Only the host can run `/compact`.** It spends the worker's credentials and steers what the summary keeps, so from any other sender it is ordinary mail for the LLM.
- **Summaries are data.** A summary is written from mail and tool output that peers can influence, and it enters the transcript with the `user` role because providers need the message list to start with a user turn. Its text says it is a record that grants no authority, but that framing is advice to the model, not an enforced boundary.
- **The summary prompt encodes history as JSON,** so mail cannot forge the end of the history section.

### Scaling Considerations

Each compaction costs one extra LLM request with caching disabled, at most once per turn. Tool results are cut to 2,000 characters in that request, and shorter still if it would not fit the window. If it still cannot fit, automatic compaction logs the failure and the round continues.

### Documentation Considerations

The Lal README and the design are updated in this PR.

### Testing Considerations

`packages/lal/test/compaction.test.js` drives a real `PiAgent` with a scripted stream, and `spawnWorkerLoop` against a local fake of the OpenAI-compatible endpoint. The tests were mutation-checked, and the Lal suite passes locally. No live provider was used.

### Compatibility Considerations

- Compaction is on by default.
- A host message consisting only of a `/compact` line used to reach the LLM and now does not.
- `feat/lal-model-command` adds the same `isFromHost` check to `inbox-loop.js`, so whichever lands second has a small conflict to resolve.

### Upgrade Considerations

None. The transcript and its summary last as long as the worker's memory, as before.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

<!-- garden-job: endopi-iterative-compaction-build -->
----- END BODY -----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-03T08:46:44Z
