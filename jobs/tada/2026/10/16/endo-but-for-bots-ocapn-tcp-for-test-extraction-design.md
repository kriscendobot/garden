---
handed-off: endo-but-for-bots-ocapn-tcp-for-test-extraction-design-pr-open
deliverable-complete: false
---
## Completion report: `endo-but-for-bots-ocapn-tcp-for-test-extraction-design`

**This is a handoff, not a clean finish.** The design is written and pushed, but the draft PR is not open. This host's bot token is refused when it tries to create pull requests on endojs, so a successor job on a host that can will open it.

**The job's premise was out of date.** The February stub assumed OCapN-Noise (`np`) would run a redundant `op:start-session`. It doesn't: since #137, `np` goes through `provideSession` and never uses core's handshake. Its encrypted in-tunnel `op:start-session` (`exchangeIdentity`) is needed, because it carries the Ed25519 session key used for handoffs and binds to the Noise handshake hash. What remains is core's fallback. Any network that implements only `connect`, or whose `provideSession` resolves `undefined`, still gets core's unencrypted hello. Today that is `tcp-testing-only`, websocket, `ocapn-iroh`, and thixotrope's durable netlayer.

**What the rewritten `designs/ocapn-tcp-for-test-extraction.md` specifies:**
- **New adapter.** `@endo/ocapn/netlayer/start-session` (`makeStartSessionNetwork`) takes over the whole handshake and its connection bookkeeping from core. It hands the four netlayers the same `NetlayerHandlers` as today, so only their construction sites change.
- **One way into core.** Core's network factory gets a single synchronous `adoptSession` instead of `makeConnection`, `handleMessageData`, `handleConnectionClose` and `resumeSession`. It stays synchronous because thixotrope counts a frame as processed only after dispatch returns. Core matches each adopted session to its internal session, so the same one is never built twice. Noise's `provideSession`/`inboundSessions` path is unchanged.
- **Removed from core.** `client/handshake.js` is deleted, along with the `undefined` fallback and the `sendSessionHandshake`/`handleSessionHandshake` hooks. A network that implements only `connect` now fails at construction with a clear error.
- **No wire change.** The test plan requires byte-identical hello captures, the python OCapN suite, the Guile interop tests, and the thixotrope restart suites.
- **Also included:** a list of every caller to migrate, an ownership map, a validated mermaid diagram (`flowchart-v2 OK`), design decisions, and two open questions:
  - Should `np`'s in-tunnel record keep the `op:start-session` name?
  - Should routing networks that front both `np` and start-session be supported?

**Other changes:**
- `designs/README.md` has the new Updated date and a new notes row.
- I left the size estimate at S-M / 3 days. Migrating four netlayers' callers may make it M; the next grooming pass should decide.

**Branch:** `endojs/endo-but-for-bots` `design/ocapn-tcp-for-test-extraction`, one commit on the frozen base `llm-61cd656`.

**PR not opened:** `ensure-pr.sh` failed on `createPullRequest` with a 403 ("Resource not accessible by personal access token") on host oros-studio-garden-ce242c49.

**Successor:** `endo-but-for-bots-ocapn-tcp-for-test-extraction-design-pr-open` is in `jobs/todo` on `origin/journal2`, pinned to `requires: host=endolin-garden-ece02cb4`. Its only task is to run `ensure-pr.sh` under this job's base, so the garden-job marker points back here, with the PR body embedded. It opens the PR as a draft against `llm-61cd656`. Its report will cite that PR and name the build follow-up.

## Follow-ups
- Successor `endo-but-for-bots-ocapn-tcp-for-test-extraction-design-pr-open` opens the draft design PR; the design gauntlet follows automatically.
- Build `ocapn-tcp-for-test-extraction`: one builder job, with the implementation PR based on `master`. It runs after the design gauntlet, via the design-build handoff.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-but-for-bots-ocapn-tcp-for-test-extraction-design.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 80 tokens (3986905 cached reads)
- Output: 34275 tokens
- Cost: $2.5185530000000003
- Wall-clock: 840s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
