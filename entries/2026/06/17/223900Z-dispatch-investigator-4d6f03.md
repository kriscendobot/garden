---
ts: 2026-06-17T22:39:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: investigator
dispatch_root: /home/kris/dispatches/investigator--4d6f03
model: sonnet
prs:
  - repo: endojs/endo-but-for-bots
    pr: 452
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/452
  - https://github.com/endojs/endo-but-for-bots/pull/452#issuecomment-4735987527
  - https://github.com/endojs/endo-but-for-bots/pull/452#issuecomment-4736018123
  - https://github.com/endojs/endo-but-for-bots/pull/452#issuecomment-4735846280
  - entries/2026/06/17/221400Z-message-queued-investigator-452.md
  - entries/2026/06/17/221800Z-message-queued-rebase-and-investigator-update.md
---

# dispatch: investigator — #452 reconnection semantics + tcp-network comparison

Kumavis at 22:11:25Z (id 4735987527) asked:

> we want to make sure that if the connection goes down and a then
> a remote object is attempted to be used again, it will retrigger
> a connection attempt. if im not mistaken, the correct way to do
> that is to trigger the teardown of all remote formulas and those
> that depend on them by destroying the peer formula. investigate
> and report here

Kumavis at 22:16:31Z (id 4736018123) added:

> when researching this answer
> https://github.com/endojs/endo-but-for-bots/pull/452#issuecomment-4735987527
> please look at how other networks do this, like the tcp network

Prior bot teardown response at 22:08Z (id 4735846280) said the PR
deliberately keeps the peer formula alive across connection loss
so `ResilientPeerGateway` re-dials, and that only the CapTP
session + QUIC connection are torn down. Kumavis is pushing back:
the *peer formula itself* should be destroyed on connection loss
so subsequent remote-object use retriggers a connection.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#452`, DRAFT, base `llm`, head
  `kriskowal-iroh-heartbeat` at `c08a2262c` (post-rebase).
- **Mergeable**: yes.
- **Iroh heartbeat additions**: `packages/daemon/src/iroh-heartbeat.js`
  (new), `packages/daemon/src/iroh.js` (modified).

## Task

In your `project/` worktree at `c08a2262c`:

1. Read `garden/roles/investigator/AGENT.md`.
2. Read kumavis's three comments cited above in full.
3. Read the relevant peer/host formula code paths to characterize
   current connection-loss behavior:
   - `packages/daemon/src/iroh.js` (the iroh network)
   - `packages/daemon/src/iroh-heartbeat.js` (the new heartbeat)
   - `packages/daemon/src/captp.js` or similar CapTP wiring
   - `packages/daemon/src/peer.js` or similar peer-formula code
   - `packages/daemon/src/host.js` for `provideRemoteValue` etc.
4. **Read the tcp network's implementation** for comparison:
   - `packages/daemon/src/tcp.js` or similar
   - How does the tcp network handle a dropped connection?
   - Does it teardown the peer formula on disconnect?
   - What happens when a remote object is used after disconnect?
     Does the next request trigger a new dial?
5. Compare the two networks. Address:
   - **Current iroh behavior**: when an iroh connection drops,
     what happens to the peer formula, its remote presences, and
     a subsequent attempt to use one of them?
   - **Current tcp behavior**: same questions.
   - **Kumavis's hypothesis**: is destroying the peer formula the
     correct trigger for retriggering connection on next use? Is
     that what tcp already does, or is the tcp network silent on
     this?
   - **Recommendation**: should iroh adopt tcp's pattern, OR does
     iroh's keep-alive-timeout semantics call for something
     different? Be specific about the code change shape (or lack
     thereof) and the consequences.
6. Post a **top-level findings comment** on PR #452
   at-mentioning `@kumavis`. Structure: short summary; current
   iroh behavior with file:line cites; current tcp behavior with
   file:line cites; comparison and recommendation. End with a
   one-line statement of whether code change is needed and, if so,
   what shape.

## Authorizations

- Top-level summary comment on PR #452 at-mentioning @kumavis.
- Read-only access to all daemon source files (no commits).

## Out of scope

- Do NOT push commits — this is an investigation, not a fix.
- Do NOT mark PR ready.
- Do NOT touch #449 or #442.

## Deliverable

A `result` entry under `journal/entries/2026/06/17/` naming:

- The peer/host formula code paths read.
- The tcp-network code paths read.
- The comparison findings.
- The PR comment URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: depending on findings, either
  `next: builder` (if code change is recommended and kumavis
  confirms) or `next: liaison` (if no code change, just an
  answer to kumavis's question).

End your turn with a concise summary back to the orchestrator.
