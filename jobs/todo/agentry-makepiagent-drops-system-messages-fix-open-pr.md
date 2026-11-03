---
posted_at: 2026-11-03T04:13:47Z
role: fixer
tier: mentor
requires: host=endolin-garden-ece02cb4
arc: moonshots
dispatch: automatic
fallback-tier: minion
---
**Open the draft PR for an already-pushed fix.** Repo endojs/endo-but-for-bots. The host that built this cannot create PRs on endojs (403), so this job is pinned to endolin. Only open the PR; do not change the code.

Head `fix/agentry-pi-agent-system-messages` (d080647e4bc3), frozen base `llm-48d6f3e`, both already pushed. Verify the head and base with `git ls-remote` first.

The fix is high priority: without it, `makePiAgent` sends providers no system prompt and no tools, so Lal workers cannot call tools.

Get a project worktree, cd into it, and run ensure-pr with the prior job's base so its marker is the durable one:

    scripts/jobs/gardening/ensure-pr.sh agentry-makepiagent-drops-system-messages-fix endojs/endo-but-for-bots fix/agentry-pi-agent-system-messages llm-48d6f3e --title "fix(agentry): keep system messages in makePiAgent requests" --body-file <file>

Write the body file with exactly the text between the markers. Report the PR URL.

----- PR BODY -----
## Description

`makePiAgent` has sent no system prompt and no tool declarations to the provider since Pi 0.86. Lal workers and `defineAgent` agents build on it, so a provider saw only the user's words: no instructions, and no tools it could call.

Pi 0.86.0 stopped passing `systemPrompt` and `tools` on the request context. They now travel only as a leading `role: 'system'` message of the transcript, built by `createInitialSystemMessage`. The harness's `defaultConvertToLlm` kept `user`, `assistant`, and `toolResult`, so it removed that message. The break arrived with the `^0.85.1` to `^0.86.1` bump in 5c8309652 (2026-09-27); pi-agent-core's `dist/agent-loop.js` at 0.85.1 still passes both fields, and its own default filter gained `system` in the same release.

The fix removes the harness's copy of the filter and lets pi-agent-core apply its default, so the two cannot drift again. A caller-supplied `convertToLlm` still wins, and the `makePiAgent` documentation now says it must keep `system` messages.

Callers checked:

- `defineAgent` forwards `options.convertToLlm`, which is undefined unless a caller sets one, so it picks up the fix.
- `spawnWorkerLoop` in `packages/lal/agent.js` and the code-mode agents use the default.
- No production code passes a custom `convertToLlm`. The Lal tests that build a `PiAgent` directly carried copies of the old filter, described as matching production, so those copies now keep `system` too.

The most critical file to review is `packages/agentry/src/harness/pi-agent.js`.

### Security Considerations

The system prompt reaches the model again, including the instructions that describe each worker's boundaries. The model is also told about the tools the agent already holds. No new authority is granted: tool execution always followed `state.tools`, and the declarations match that set.

### Scaling Considerations

Each request grows by the system prompt and tool schemas, which is the size it had before Pi 0.86.

### Documentation Considerations

The changeset records the behavior and the requirement on custom `convertToLlm` functions.

### Testing Considerations

`packages/agentry/test/harness-pi-agent.test.js` is new, and four of its five tests fail without the fix. The fifth pins that a caller-supplied `convertToLlm` is honored.

- Scripted stream function: the context's roles are `['system', 'user']`, and the system message carries the prompt and the tool in `toolsAdded`. This is also checked with seeded messages and through `defineAgent`.
- Real `openai-completions` adapter, the one Lal's Ollama path uses, against a local fake endpoint: both request bodies carry the system prompt and a `tools` entry across a full tool call round trip.

Without the fix, the real adapter's first message was the user's. The tool still ran in that test only because the fake endpoint scripts the call regardless of what was declared.

Verification on this branch:

- `packages/lal`: 197 passed, 1 skipped, run before the final test-only type-import cleanup in agentry.
- `packages/agentry`: `eval/conflict-rebase` › `outcome assertion fails when conflicted worktree is left mid-rebase` fails (`git rebase integration`). It fails the same way with `pi-agent.js` restored to the base. That full-suite run also timed out with one test pending in the same file; the file finished when run alone with a longer timeout. Every other test that ran passed.
- `tsc` passes in both packages.
- ESLint and Prettier ran on changed files only, and the pre-push probes ran with `--probes-only`, so CI is the first full repository lint.
- No live provider was called.

### Compatibility Considerations

Agents regain their system prompts and tools, so model behavior changes for anything running on `llm` since 2026-09-27. A custom `convertToLlm` that drops `system` messages still loses both.

### Upgrade Considerations

None. Stored transcripts need no migration.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
----- END PR BODY -----
