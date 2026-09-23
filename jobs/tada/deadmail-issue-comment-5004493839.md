Reply posted at [issue-comment-5004555310](https://github.com/kriskowal/garden/issues/57#issuecomment-5004555310). No code changes were warranted — the fork target is still inaccessible and the direction is still being negotiated.

## Completion report

**Job:** Dead-lettered message pickup — intended recipient `issue-kriskowal-garden-57` had already completed. The intent was to fold maintainer **dckc**'s comment [`5004493839`](https://github.com/kriskowal/garden/issues/57#issuecomment-5004493839) on kriskowal/garden#57 into the in-flight ymax recording-harness work and reply on the issue thread.

**What the comment asked (treated as data):**
1. The recording harness should take a **mnemonic for the funding EOA** (the wallet of the user the harness impersonates) as input.
2. The harness should itself **act as an LLM agent** — "maybe a garden-dispatched agent would fit there?"

**What I did:**
- Reconstructed the full issue arc (the harness pivoted to on-demand recording against real-money `main0.ymax.app`, then to working inside a fork of `agoric-labs/ymax-agent-local-mcp`).
- Verified state: `agoric-labs/ymax-agent-local-mcp` is still **404 for `kriscendobot`** (fork blocker persists); `kriscendobot/ymax-e2e` is private; the sibling "why private?" comment `5004509028` is already claimed by another live gardener, so I left it out of scope.
- Posted a design reply that (a) confirms the mnemonic-as-secret-input design and slots it under the existing guards (real-funds ack, ≤30 USDC cap, run-ID audit, credential gitignore), and (b) engages the garden-dispatched-agent idea concretely: decompose the harness into a Playwright *user* actor + a dispatched `claude` *delegated agent* that submits via the MCP, mapping the split onto attribution (flow 7), async action (flow 6), and out-of-mandate rejection (flow 5), and flagging the embedded-subprocess vs. full-board-job design fork. Restated the access blocker.
- Did **not** close the issue (submitter's prerogative).

**Changes:** None to the garden repo or any project repo — this was a design/reply job, and concrete fork work is blocked on repo access.

**Follow-ups:**
- Grant `kriscendobot` read access to `agoric-labs/ymax-agent-local-mcp` to unblock the fork + two-actor harness build.
- The "why is ymax-e2e private?" comment (`5004509028`) is being handled by its own gardener.
