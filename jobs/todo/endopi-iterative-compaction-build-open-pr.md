---
posted_at: 2026-11-03T03:26:52Z
arc: moonshots
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
requires: host=endolin-garden-ece02cb4
---
**Role: builder. Open one draft PR; write no code.** Job `endopi-iterative-compaction-build` built and pushed this work on oros-studio, whose PAT cannot create PRs on endojs (403 on createPullRequest).

Head `feat/lal-iterative-compaction` at `c4ede16c7d377526973f1a38ebf00e939bc0a558` is on `origin` of endojs/endo-but-for-bots. Frozen base `llm-48d6f3e` is also there.

1. Confirm with `git ls-remote` that the head is at that commit.
2. Write the PR body between the BODY markers below, verbatim, to a file.
3. Run, keeping the original job base so the durable marker matches:

   ```sh
   scripts/jobs/gardening/ensure-pr.sh endopi-iterative-compaction-build endojs/endo-but-for-bots feat/lal-iterative-compaction llm-48d6f3e --title 'feat(lal): compact the conversation with an iterative structured summary' --body-file <file>
   ```

4. Name the PR by its full URL in your completion report, so the completion machinery stages the gauntlet.

The phase/evidence gate returned `attention` with exit 0 on this body when run on oros-studio. The PR must be draft.

-----BEGIN BODY-----
Refs: designs/endopi-iterative-compaction.md (M9)

## Description

A Lal worker's transcript used to grow until the provider refused it. Now the worker compacts the conversation as it nears the model's context window: older messages become one structured summary, and recent messages stay verbatim. The host can also compact on demand by sending the worker `/compact [instructions]`.

The new `packages/lal/compaction.js` follows Pi's released algorithm:

- **Trigger:** context tokens exceed `contextWindow - reserveTokens`, where context tokens are the newest provider usage reading plus an estimate of the messages after it. The check runs before a round and between the tool calls of a long round. A provider context overflow gets one compact-and-retry.
- **Cut point:** walk back from the newest message until `keepRecentTokens` is covered. A tool call stays with its results.
- **Summary:** the same model produces Goals, Decisions, Open threads, and Code patterns. It receives the previous summary and only the newly elided messages, so a long session holds one summary.
- **Files touched:** code tracks `readText`, `writeText`, and `editText` paths cumulatively and renders the list, so it survives even when a summary omits it.

### Where this departs from the job and the design

- **The job says to extend `packages/genie`, which no longer exists.** `42bc7d516` retired it. The design's own Design section targets the Lal transcript, so this builds there and does not revive the package. This PR rewrites the design's stale Status section.
- **Writing the `compaction` JSONL entry (the design's step 4) is not in this PR.** Lal has no session file, and its messages have no ids for `firstKeptEntryId` to name. Phase 4 of `designs/endopi-jsonl-transcript-format.md` owns that integration. No hook is added for it, because nothing would call one yet.
- **Until that lands, elided messages are gone from the worker's memory.** The design's claim that originals remain on disk does not hold yet. Mail itself remains in the daemon. Please weigh this when reviewing, because it is the main cost of landing compaction before the writer.
- **Settings are `LAL_COMPACTION_*` environment variables.** The design names a per-host settings store, and none exists. The daemon's environment is the per-host configuration `/model` credentials already use.
- **Limits are clamped on small windows.** With the design's defaults on the harness's 32,768-token default window, `keepRecentTokens` would exceed the trigger and compaction would fire every turn without freeing anything. Windows of about 56k tokens and up get the design's values unchanged.

### Why not reuse existing code

- **Pi's `compact()`:** it works on session-manager entries and ships in `pi-coding-agent` with the terminal UI, which Lal does not depend on.
- **`providers/context-compaction.js` (Fae's):** it works on provider-shaped messages and a checkpointing conversation store, and sizes by bytes. Lal's transcript is pi-agent-core messages. The two share the rule that only a provider reading is an actual token count.

<!-- garden-phase-evidence-ledger:v1 -->
## Phase and evidence ledger

Design: `designs/endopi-iterative-compaction.md`
Index: `designs/README.md` (date only)
Disposition: deliverable
Acceptance: satisfied | the design names no acceptance observations and no numbered phases; `spawnWorkerLoop` was exercised end to end against a local fake endpoint, and no live vendor run was made. Step 4 of the design belongs to phase 4 of `designs/endopi-jsonl-transcript-format.md`, which that design sequences after this work lands
<!-- /garden-phase-evidence-ledger -->

### Security Considerations

- **Only the host can run `/compact`.** It spends the worker's credentials and steers what the summary keeps, so from any other sender it is ordinary mail for the LLM.
- **Summaries are data.** A summary is written from mail and tool output that peers can influence, and it enters the transcript with the `user` role because providers need the message list to start with a user turn. Its text says it is a record that grants no authority, but that framing is advice to the model, not an enforced boundary. Please review this closely.
- **The summary prompt encodes history as JSON,** so mail cannot forge the end of the history section.

### Scaling Considerations

Each compaction costs one extra LLM request with caching disabled, at most once per turn. Tool results are cut to 2,000 characters in that request, and shorter still if it would not fit the window. If it still cannot fit, automatic compaction logs the failure and the round continues.

### Documentation Considerations

The Lal README gains a *Context compaction* section. The design's Status section is rewritten and its date refreshed here and in `designs/README.md`. Its status stays Proposed until step 4 lands.

### Testing Considerations

`packages/lal/test/compaction.test.js` drives a real `PiAgent` with a scripted stream, and drives `spawnWorkerLoop` against a local fake of the OpenAI-compatible endpoint.

I broke the code 18 ways and each made the suite fail. They include allowing a cut on a tool result, eliding system messages, trusting a reading from a retained message, omitting the previous summary, resetting the file lists, counting failed tool calls as touched, accepting a partial summary, removing the mid-round hook, retrying non-overflow errors, and dropping the sender check.

The Lal suite passes (226 passed, 1 skipped), as do `tsc` for the package, eslint on the changed files, and the pre-push probes. Repo-wide lint outlasts the tool limit on the build host, so CI is the first full lint. No live provider was used.

### Compatibility Considerations

- Compaction is on by default. Set `LAL_COMPACTION_ENABLED=false` to turn off the automatic path.
- A host message consisting only of a `/compact` line used to reach the LLM and now does not.
- `feat/lal-model-command` adds the same `isFromHost` check to `inbox-loop.js`, so whichever lands second has a small conflict to resolve.

### Upgrade Considerations

None. The transcript and its summary last as long as the worker's memory, as before.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
-----END BODY-----
