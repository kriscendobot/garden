---
title: Body
source: designs/daemon-commands-as-messages.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: HEAD (origin/llm, fetched 2026-06-02)
source_date: 2026-03-11
source_authors: [Kris Kowal (prompted)]
source_lines: "1-253 (full file: problem + design + enables + costs + dependencies + affected packages + prompt)"
topics: [daemon]
status: current
notes: |
  First non-chat endo-but-for-bots design ingest in the library
  (chat-cluster fully ingested as of cycle 99). The 253-line *Not
  Started* design proposes that every user/agent command be logged
  as a *self-addressed message* in the issuer's own inbox, with
  results delivered as replies. Single cohesive argument with
  unified Problem → Design → Enables/Costs → Dependencies structure.
  Three structurally interesting moves: (1) the *asymmetric
  transcript* problem-framing — `followMessages()` shows what
  others said but not what you did, which makes agents' inbox-
  follow context incomplete; (2) the *self-addressed message* trick
  — lift the `mail.js` self-delivery suppression *for commands only*
  to enable command-as-message without inbox noise from internal
  delegation; (3) the *agent tool audit trail* bonus — capability-
  confined agents' tool invocations become commands too, giving
  the daemon-capability-bank a built-in observability surface
  without a separate logging system. The §Which-operations-become-
  commands table is the canonical mapping from current behavior to
  the proposed command-message form (8 operations enumerated). The
  *evaluate subsumes eval-proposal pair* line is a structural
  simplification — the existing two-message eval-proposal-proposer /
  eval-proposal-reviewer pattern collapses into one command + one
  value-reply, mirroring daemon-form-request / daemon-value-message.
parent: endo-but-for-bots--llm-designs-daemon-commands-as-messages--commands-as-self-addressed-messages-design
---

### §The four-problem motivation — asymmetric transcript and beyond

The §opening lines (11-15) frame the gap:

> The daemon's mail system records only inbound messages — things sent *to* a user or agent. When a user issues a command (`dismiss`, `adopt`, `resolve`, `evaluate`, `send`), the operation executes as a promise that settles and vanishes. There is no durable record in `followMessages()` that the command was issued, what its arguments were, or whether it succeeded.

The §four enumerated problems each name a downstream consequence:

**§(1) Asymmetric transcript**:

> The inbox shows what others said to you but not what you did. Reconstructing a session requires correlating inbox changes (a message disappeared, a name appeared) with unrecorded commands.

The §honest debugging-friction observation: a user trying to remember *what happened in this session* sees half the conversation. The inbox shows arrivals (messages from others, pet-names appearing, requests received) but not the user's own actions (dismissals, adoptions, resolutions). Reconstruction is *forensic* — correlating disappearances and name-changes with implicit-user-action.

**§(2) No agent visibility**:

> Lal and Fae follow the user's inbox to build context. They cannot see the user's commands, so they lack half the conversation. An agent cannot distinguish *the user dismissed that request* from *the request was never delivered*.

The §structural significance: an agent's context-from-inbox-follow is *fundamentally incomplete*. The two scenarios (*dismissed* vs *never-delivered*) are observationally identical to the agent. This is a *failure of agent-substrate fidelity*: the agent's view of the user's state doesn't include the user's actions.

**§(3) No audit trail**:

> There is no persistent record of who did what and when. For capability-confined agents (see [daemon-agent-tools](daemon-agent-tools.md)), tool invocations are equally invisible — an agent reads a file, writes a file, runs a command, and none of it appears in the message log.

The §security-relevant gap: capability-confined agents are *supposed* to be observable by the host (otherwise the confinement is purely structural with no monitoring affordance). Without an audit trail, the host has *granted* the capability but cannot *see* how it's being used.

**§(4) Chat UI workarounds**:

> The Chat pending commands region ([chat-pending-commands](chat-pending-commands.md)) is a UI-only workaround: it tracks in-flight commands in ephemeral DOM state. This solves the immediate UX problem but does not persist across page reloads, is invisible to agents, and duplicates bookkeeping that the daemon should own.

The §architectural-fault-line observation: the UI is doing daemon-layer work. The `chat-pending-commands` design solved the UX problem (*show me what I'm waiting on*) by tracking pending commands in JavaScript-only DOM state. The §discipline: the daemon should own the pending-state because the daemon owns the command-resolution; the chat UI should consume daemon state, not manage its own.

### §The self-addressed message trick

The §central design move (lines 44-68) is the *self-addressed message*:

```
#42  You → You  dismiss #5
```

When the command completes, the result is delivered as a reply:

```
#43  (reply to #42)  ✓ dismissed
```

The §three structural moves:

1. **`from === to`** — the message's sender and recipient are the same identity. The command-issuer logs the command *to themselves*.
2. **`replyTo` chains the result** — the reply uses the same `replyTo` mechanism the daemon already uses for `daemon-form-request` (form messages get value-reply messages with `replyTo` linking them).
3. **`followMessages()` yields both** — inbound messages from others AND self-addressed command records. Pending commands are messages without replies yet; settled commands carry a reply.

The §benefit: *no new mechanism needed*. The existing message infrastructure (`followMessages`, `replyTo`, durable formulas) carries everything; only the *type* and the *self-delivery suppression* change.

### §The self-delivery suppression lift

The §`mail.js` mechanism (lines 117-125):

> Today, `mail.js` suppresses self-sends:
>
> ```js
> if (message.from !== message.to) await deliver(message);
> ```
>
> This suppression must be lifted for `command` type messages specifically. Other self-sends can remain suppressed to avoid inbox noise from internal delegation patterns.

The §design-discipline distinction:

- **General self-sends suppressed**: internal delegation patterns (an agent talking to its own subordinate, the daemon routing through itself) shouldn't appear in the inbox. The default-suppress prevents inbox noise from these.
- **Commands self-deliver**: command-as-message is the intentional surface. Lift the suppression *only* for `type: 'command'` messages.

The §minimal change: one conditional becomes type-aware. The §discipline preserves the existing default-suppress for everything else.

### §The new `command` message type

The §type definition (lines 70-98):

```js
/** @type {CommandMessage} */
const message = {
  type: 'command',
  number: nextMessageNumber,
  date: new Date().toISOString(),
  from: selfId,
  to: selfId,
  commandName: 'adopt',
  args: harden({
    messageNumber: 3n,
    edgeName: 'VALUE',
    petName: ['myval'],
  }),
  promiseId,
  resolverId,
};
```

The §five-field-plus-metadata shape:

- **`type: 'command'`** — discriminator for the message-routing and rendering layers.
- **`commandName`** — the operation (`dismiss`, `adopt`, `resolve`, `evaluate`, `send`, `request`, etc.).
- **`args`** — a structured *frozen* record of the command's arguments. Frozen because the message is a durable record; mutability would let later code rewrite history.
- **`promiseId` / `resolverId`** — formula identifiers for the result. Same shape as today's `request` messages — the resolution capability has a formula identity that survives across daemon restart.

The §`from === to === selfId` is the self-addressing. The §`number`, `date`, `from`, `to` are the standard message metadata the existing mail system already carries.

### §The result-as-reply story

The §reply-message shape (lines 100-113):

- **`replyTo`** references the command message number (`replyTo: 42`).
- **Success carries `valueId`** if the command produced a value (evaluate, request), or a simple confirmation otherwise.
- **Failure carries the error message**.

The §mirror discipline:

> This mirrors the existing form → value-reply pattern from [daemon-form-request](daemon-form-request.md) and [daemon-value-message](daemon-value-message.md), where a `form` message receives a `value` reply with `replyTo` linking them.

The §pattern-reuse benefit: the chat UI already renders form → value-reply pairs; command → command-result reuses the *same* rendering logic. No new chat-UI primitive needed; just a new message-type discriminator.

### §The persistence story

The §durability claim (lines 127-136):

> Command messages and their reply messages are durable formulas, surviving daemon restart. The `command` formula stores the command name and arguments. The reply formula stores the outcome. Both are linked by `replyTo` and discoverable via `followMessages()`.
>
> On restart, the inbox replays all historical messages including commands. An agent or Chat UI can reconstruct the full session history: what was received, what was done, and what happened.

The §formula discipline: each command becomes a *formula* (the endo-daemon's durable-object primitive). The formula's identity survives restart; its contents are immutable. The §reply formula is a separate formula linked by `replyTo`.

The §reconstruction property: an agent or UI starting fresh after a daemon restart can replay the full inbox and see *what the user did, what was sent to them, and how it all resolved*. The session is *reproducible from the message log*.

### §The Which-operations-become-commands table

The §eight-operation table (lines 140-149):

| Operation | Currently | As command message |
|-----------|-----------|-------------------|
| `dismiss` | Promise, no trace | `command` + confirmation reply |
| `adopt` | Promise, no trace | `command` + confirmation reply |
| `resolve` | Promise, settles remote | `command` + confirmation reply |
| `reject` | Promise, settles remote | `command` + confirmation reply |
| `evaluate` | `eval-proposal` pair | `command` + value reply (subsumes eval-proposal) |
| `request` | Outbound message to recipient | `command` + value reply when settled |
| `send` | Outbound message to recipient | `command` + confirmation reply |
| `grant` | Promise, no trace | `command` + confirmation reply |

The §three operation-shape categories:

1. **Promise, no trace** (dismiss/adopt/grant) — currently the promise settles and vanishes; the proposed form records the command and confirms.
2. **Promise, settles remote** (resolve/reject) — currently delivers a settlement to a remote promise's resolver; the proposed form additionally records the local action.
3. **Already produces messages** (request/send/evaluate) — currently produces an outbound message to the recipient; the proposed form ALSO produces a command message in the sender's own inbox. The §note: *for `request` and `send`, the outbound message to the recipient continues to work as today. The `command` message is an additional record in the sender's own inbox.*

The §`evaluate` simplification: today's `evaluate` uses a paired `eval-proposal-proposer` / `eval-proposal-reviewer` message pattern. With this design, that pair collapses into one `command` + one `value` reply, *subsuming* the eval-proposal special case into the general command-message pattern.

### §Chat UI compact-rendering

The §UI specification (lines 159-180):

> Command messages must be visually distinct from conversational messages. They should render compactly — a single line showing the command and its arguments, not a full message bubble.

The §example ASCII rendering:

```
┌─ transcript ──────────────────────────────────────┐
│                                                    │
│  #38  Fae: Here's what I found...                  │
│  #39  You: @Fae Can you also check the tests?      │
│  #40  ◐ dismiss #36                        pending  │
│  #41  ✓ adopt #38:VALUE → analysis         done     │
│  #42  ◐ eval (source…)                    pending  │
│                                                    │
│  [command bar]                                     │
└────────────────────────────────────────────────────┘
```

The §three visual states:

- **`◐ pending`** — spinner indicator; command issued but reply not yet arrived.
- **`✓ done`** — checkmark; success reply received.
- **`✗ error`** — cross; failure reply received with error text.

The §reply-fold discipline: *the reply message is not rendered separately — it is folded into the command card's settled state*. From the user's perspective, the command-and-its-result are one row. From the daemon's perspective, they remain two distinct messages (command + reply) with `replyTo` linkage.

### §The agent-tool audit-trail bonus

The §extension to capability-confined agents (lines 182-191):

> This design applies equally to agent tool invocations from [daemon-agent-tools](daemon-agent-tools.md). When Fae calls `readFile` or `exec` via a capability, the tool wrapper posts a `command` message to Fae's own inbox. The host can observe the agent's command history by following the agent's messages.

The §bonus result:

> This gives the capability bank ([daemon-capability-bank](daemon-capability-bank.md)) a built-in audit mechanism without a separate logging system.

The §structural payoff: *one design solves two problems*. The original motivation was the user's command-as-message gap; the same design *also* makes agent tool invocations observable. The capability bank doesn't need its own logging system because the command-message infrastructure already provides one.

The §observability discipline: the host who *granted* the agent a capability can *see* how the agent uses it by following the agent's inbox. No separate `auditLog` capability needed; no separate logging system needed; the existing message infrastructure carries the audit trail.

### §The What This Enables / Costs / Dependencies

The §benefits (lines 193-204) — *four enables*:

- **Unified transcript** — chat renders `followMessages()` directly. No separate pending region needed.
- **Agent-visible history** — agents see the user's command history as messages.
- **Undo/replay** — a durable command log enables future undo support or session replay.
- **Tool audit trail** — agent tool invocations are logged in the same system.

The §costs (lines 206-216) — *three costs*:

- **Mail system changes** — `mail.js` and `types.d.ts` need a new message type, new formula definitions, and changes to delivery routing. Touches the core persistence layer.
- **Message volume** — every command produces at least two messages (command + result). Dismiss, adopt, and other fast operations become heavier. The §mitigation: *command messages are smaller than conversational messages (no markdown body, no embedded references)*.
- **UI rendering** — the chat transcript must distinguish command messages from conversational messages and render them compactly.

The §dependencies (lines 218-227) — *six related designs*:

- **chat-pending-commands** — UI-only predecessor; this design *subsumes* its pending region.
- **chat-command-bar** — the command bar that dispatches commands.
- **daemon-form-request** — existing form → value-reply pattern this extends.
- **daemon-value-message** — value reply mechanism reused for command results.
- **daemon-agent-tools** — agent tool invocations use the same command logging.
- **daemon-capability-bank** — audit trail for capability-confined operations.

The §design-dependency-graph reading: this design *fits between* an existing UX surface (chat-pending-commands, chat-command-bar) and an existing messaging primitive (daemon-form-request, daemon-value-message), *enabling* two consumer designs (daemon-agent-tools, daemon-capability-bank).

### §Affected packages

The §affected-packages list (lines 229-238) names the implementation surface:

- **`packages/daemon/src/mail.js`** — `command` message type, self-delivery for commands, result reply posting.
- **`packages/daemon/src/types.d.ts`** — `CommandMessage` and `CommandResultMessage` type definitions, `CommandFormula`.
- **`packages/daemon/src/host.js`** — command methods post a command message before executing and a result reply after settling.
- **`packages/chat/inbox-component.js`** — render command messages compactly in the transcript, fold reply into settled state.

The §discipline: *implementation lives in four files*. The §file-count is a structural cost — small enough to land cleanly, but spanning two packages (daemon + chat), so the work must be coordinated.
