Inbox empty. Work complete.

## Completion report

**Job:** Dead-lettered message intended for `issue-kriskowal-garden-43` — a maintainer (kriskowal) comment on kriskowal/garden issue #43 asking: *"Are we able to rewind context if an execute fails due to a mismatched pattern shape and retry?"*

**What I did:** Answered the question grounded in the actual code, then posted a reply on the issue thread (never closed it — the submitter does that).

**Investigation (read-only, no shared-tree mutation):**
- Traced the two surfaces where a "mismatched pattern shape" can throw in `endojs/endo-but-for-bots@origin/llm`: the `execute` tool's own arg guard (`@endo/agent-tools/tool.js`, `mustMatch` from `@endo/patterns`) and an interface-guard rejection *inside* the generated program (`execute/compartment.js`, `await compartment.evaluate(source)`).
- Followed the error path through `@earendil-works/pi-agent-core@0.79.9` (`dist/agent-loop.js`): both throws converge on `createErrorToolResult(error.message)` with `isError: true`, which is appended to the transcript, and the loop continues → the model sees the guard diagnostic and retries automatically.
- Confirmed the two rewind seams pi-agent-core exposes but agentry's `makePiAgent` does not wire: `transformContext` (per-turn transcript rewrite) and `prepareNextTurn` (per-turn context snapshot/restore).

**Conclusion delivered:** Retry-on-shape-mismatch is automatic (the ordinary tool-error → next-turn loop; the Endo pattern diagnostic is a strong retry signal, and the compartment is fresh per call). Context rewind is *not* wired today — failed `execute`+error pairs accumulate — but adding it is a config-level `transformContext` compaction hook, no Pi fork. Separately flagged that transcript rewind ≠ side-effect rewind: a half-mutated worktree needs a capability-level checkpoint (git index/stash), not a transcript op.

**Changed:** Nothing in the garden repo (research answer). One issue comment posted: https://github.com/kriskowal/garden/issues/43#issuecomment-4974203549

**Follow-ups:** None required. If kriskowal wants to act on it, the natural next step would be a `build` job adding a `transformContext` compaction hook to `@endo/agentry`'s `makePiAgent`.
