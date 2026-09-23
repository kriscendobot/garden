---
title: Body
source: designs/daemon-value-message.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: HEAD (origin/llm, fetched 2026-06-02)
source_date: 2026-03-02
source_authors: [Kris Kowal (prompted)]
source_lines: "1-331 (full file)"
topics: [daemon]
status: current
notes: |
  Twenty-third endo-but-for-bots design ingest. Status: **Complete**
  — value message type, persistence, delivery via submit(), Chat UI
  rendering, VALUE edge, standalone sendValue method on Mail/Host/
  Guest, and send-value CLI command all implemented. The 331-line
  design defines a new `value` message type carrying exactly one
  `valueId` formula-identifier with required `replyTo`. Three
  structurally interesting moves: (1) the *reply-only* invariant
  (required replyTo, unlike package's optional replyTo) constrains
  value messages to the reply-with-result pattern that motivates
  them; (2) the *auto-retain* mechanism via optional `resultName`
  hint — recipient's `deliver()` writes the value to the pet store
  under the hint name, enabling zero-ceremony value delivery for
  the common case; (3) the *recipient-inferred-from-parent* rule —
  sendValue doesn't take a recipient argument because the parent
  message's other-party *is* the recipient, mirroring `reply` and
  preventing sending values to unrelated parties.
  
  Single-section cohesion-honest ingest (like cycles 95, 100, 101).
  The 331-line file is *one tight unified proposal* (introduce a new
  message type for value-replies); the apparent four-part decomposition
  (problem / design / decisions / files-modified) is one cohesive
  argument with implementation appendices. Pairs structurally with
  cycle 101's daemon-commands-as-messages which *reuses the reply
  pattern this design establishes* (every command's result reply
  is a value-typed reply with replyTo to the command).
parent: endo-but-for-bots--llm-designs-daemon-value-message--value-message-type-and-reply-only-design
---

### §The four-problem motivation

The §opening Problem block frames the missing-message-type gap. The §existing message taxonomy:

- **`package`** — text with embedded references.
- **`request`** / **`form-request`** — request-with-promise.
- **`eval-request`** / **`definition`** — code negotiation.

The §gap: *there is no message type for the simple act of giving a value to another agent*. The §current workaround — sending a `package` with empty template strings and embedded reference — has four documented problems:

**§(1) Template-string noise**:

> A `package` requires template strings. The sender must construct a `strings` array with at least one element. For a pure value transfer the text is noise.

**§(2) No reply semantics**:

> No clear reply semantics. An agent that receives a `request` or `form-request` can resolve the promise with a value, but there is no way to reply with a value to an arbitrary message — a `package` reply can only carry references as named edges within text, not a first-class retained value.

The §structural significance: `package` reply *can* carry references via named edges within text, but the *first-class retained value* surface is missing. The reply discipline is asymmetric — synchronous promise-replies work, asynchronous value-replies don't.

**§(3) Adopt ceremony**:

> The recipient of a `package` must `adopt` each edge name to create a pet name. A value message should retain the value directly in the recipient's pet store under a specified name, like `request` resolution does.

The §ergonomic gap: receiving a `package` is two-step (receive + adopt); receiving a request-resolution is one-step (the resolved value lives in the pet store automatically). Value messages should match the one-step ergonomics.

**§(4) LLM agent tool results**:

> An AI agent that performs a task and produces a result (a file, a capability, a computed object) should be able to reply to the originating message with the result as a retained value. This is the core loop of agentic interaction: human sends task, agent replies with result.

The §LLM-motivated framing names the *core loop of agentic interaction*. The agent receives a task message, performs work, produces a result that needs to be a *first-class retained value* in the human's pet store so the human can refer to it by name in subsequent messages.

### §The `value` message type — required-replyTo + single-valueId

The §ValueMessage typedef (lines 48-54):

```ts
export type ValueMessage = MessageBase & {
  type: 'value';
  replyTo: FormulaNumber; // required, not optional
  valueId: FormulaIdentifier;
};
```

The §two structural invariants:

- **`replyTo` is required**, unlike `package` where it is optional. *Every value message is a response to something* — a human's text message, a request, a form result, or another value message.
- **`valueId` carries exactly one formula identifier**, naming the retained value (any passable value or capability).

The §design discipline: the type itself enforces the *reply-only* and *single-value* invariants. The TypeScript type-checker prevents constructing a ValueMessage without `replyTo`; the field-shape prevents carrying multiple values without inventing a multi-value container.

The §MessageFormula union extension (lines 62-79) adds `'value'` to the existing eight-variant `messageType` enum and adds a `valueId?: FormulaIdentifier` field to the formula.

### §The `sendValue(messageNumber, petNameOrPath, resultName?)` interface

The §Mail interface method (lines 86-95):

```ts
interface Mail {
  sendValue(
    messageNumber: bigint | number | string,
    petNameOrPath: string | string[],
    resultName?: string | string[],
  ): Promise<void>;
}
```

The §three parameters:

- **`messageNumber`** — the message being replied to. The recipient is *inferred* as the other party (same logic as `reply`).
- **`petNameOrPath`** — the value to send, resolved from the sender's pet store to a formula identifier. Single-element path or multi-element drilling.
- **`resultName`** *(optional)* — if provided, the recipient automatically retains the value under this pet name in their store (no `adopt` needed).

The §implementation (lines 110-136):

```js
const sendValue = async (messageNumber, petNameOrPath, resultName) => {
  const normalizedMessageNumber = mustParseBigint(messageNumber, 'message');
  const parent = messages.get(normalizedMessageNumber);
  if (parent === undefined) {
    throw new Error(`No such message with number ${q(messageNumber)}`);
  }
  const otherId = parent.from === selfId ? parent.to : parent.from;
  const messageId = await randomHex256();
  const to = await provideHandle(otherId);

  const petPath = namePathFrom(petNameOrPath);
  const valueId = await E(directory).identify(...petPath);
  if (valueId === undefined) {
    throw new Error(`Unknown pet name ${q(petNameOrPath)}`);
  }

  const message = harden({
    type: 'value',
    valueId,
    messageId,
    replyTo: parent.messageId,
    from: selfId,
    to: otherId,
  });

  await post(to, message);
};
```

The §five-step structure:

1. **Parse and look up the parent message** by number; throw if no such message.
2. **Infer the recipient** as the *other party* of the parent (sender if self is recipient, recipient if self is sender).
3. **Mint a fresh `messageId`** via `randomHex256()` — the value message's own identity.
4. **Look up the value's formula identifier** via the directory; throw if no such pet name.
5. **Construct and post** the hardened ValueMessage with `replyTo: parent.messageId`.

The §recipient-inferred-from-parent discipline avoids the *can-I-send-this-value-to-an-unrelated-party* attack surface. The sender doesn't get to choose the recipient; the message-graph topology determines it.

### §The auto-retain mechanism

The §reception logic (lines 152-156):

```js
if (message.type === 'value' && resultName) {
  await E(directory).write(namePathFrom(resultName), message.valueId);
}
```

The §discipline:

> When a `value` message is delivered, the recipient's mailbox checks for a `resultName` hint. If present, the value is automatically written to the recipient's pet store — the recipient does not need to explicitly `adopt`.

The §two-mode delivery:

- **`resultName` present** → the value is auto-written under that pet name. The recipient sees the value in their pet store immediately, named as the sender suggested.
- **`resultName` absent** → the value is *not* auto-retained. The recipient must explicitly `adopt` the `VALUE` edge from the message hub directory.

The §explicit caveat:

> the `resultName` is a hint from the sender, not a guarantee. The recipient (or their agent) may choose to ignore it.

The §discipline: the sender doesn't *force* the recipient to retain; they *offer* a name. The recipient's mailbox honors the offer (per the implementation above) but the recipient can subsequently rename or release the value.

The §open question:

> Should `resultName` be carried inside the message envelope or passed out-of-band? Carrying it in the envelope makes it visible to both sender and recipient but means the sender chooses the pet name in the recipient's namespace. An alternative is for the recipient to adopt manually using the `VALUE` edge name on the message hub directory.

The §envelope-vs-out-of-band design question is *honestly unresolved*. The current implementation carries `resultName` *in the envelope* — visible to the recipient, who can read it and decide. The §alternative (recipient manually adopts via `VALUE` edge) would preserve more recipient autonomy at the cost of the auto-retain ergonomics. The §design accepts the envelope-carriage trade-off as the *common-case-ergonomics* choice.

### §The message hub directory's seven edges

The §directory exposes (lines 167-176):

| Edge name | Value |
|---|---|
| `FROM` | Sender handle formula ID |
| `TO` | Recipient handle formula ID |
| `DATE` | ISO 8601 timestamp |
| `TYPE` | `'value'` |
| `MESSAGE` | `messageId` |
| `REPLY` | `replyTo` messageId |
| `VALUE` | The retained value (resolved from `valueId`) |

The §`VALUE` is the *primary payload* edge. Recipients can `adopt` it:

```bash
endo adopt 5 VALUE my-result
```

The §discipline: the message hub is a *capability directory* — the recipient can name any of the seven edges as their own pet name, getting independent access to each. The §`VALUE` edge in particular gives access to the value itself (which is itself a capability that the directory delegates).

The §seven-edge shape is *uniform across message types* (other types like `request`, `form`, `package` have similar directory structures; `value` adds the `VALUE` edge specific to its semantics).

### §The five-decision rationale

The §Design Decisions (lines 279-301) name five rationale points:

**§(1) Reply-only**:

> A value message must always be a reply (`replyTo` is required). Sending an unsolicited value is a `package` with an edge name. This keeps `value` focused on the reply-with-result pattern.

The §discipline: *each message type has a single use case*. `package` carries unsolicited references; `value` carries solicited (reply) values. Conflating them would dilute both.

**§(2) Single value**:

> Each `value` message carries exactly one formula identifier. To send multiple values, send multiple value messages or use a `package`. This simplicity aligns with the *one result per task* pattern and avoids inventing a new multi-value container.

The §discipline: *don't invent multi-value containers when single-value-plus-multiple-messages works*. The §`one result per task` framing is structurally significant — most agentic tasks produce one result.

**§(3) Auto-retain is optional**:

> The `resultName` hint enables zero-ceremony value delivery for the common case. Recipients who want explicit control can omit `resultName` and `adopt` manually.

The §discipline: *offer ergonomics for the common case, preserve flexibility for the niche*. The optional-parameter shape lets both modes coexist.

**§(4) No promise/resolver infrastructure**:

> Unlike `request` and `form-request`, a value message is fire-and-forget from the sender's perspective. There is no promise to resolve. The value already exists; it is being shared, not requested.

The §key structural distinction: *requesting* values uses promises (sender waits for resolution); *sharing* values doesn't (the value already exists). The §sender-fire-and-forget discipline matches the *I-already-have-this-here-take-it* semantic.

**§(5) Recipient inferred from parent**:

> Like `reply`, the recipient of a `sendValue` is always the other party in the parent message's conversation. This avoids requiring the sender to re-specify the recipient and prevents sending values to unrelated parties.

The §security framing: *the message-graph topology determines the recipient*. A value message can only flow along an existing conversation edge; sending values to unrelated parties is structurally prevented (since `sendValue` doesn't take a recipient argument).

### §The 14-row Files Modified implementation surface

The §implementation surface (lines 303-321) spans four packages:

**Daemon (7 files)**:

- `packages/daemon/src/types.d.ts` — Add `ValueMessage` type, update `Message` union, update `MessageFormula`, add `sendValue` to `Mail`/`EndoGuest`/`EndoHost`.
- `packages/daemon/src/mail.js` — Implement `sendValue`, update `makeStampedMessage` and `deliver` for value type, update message hub directory.
- `packages/daemon/src/host.js` — Expose `sendValue` on host exo.
- `packages/daemon/src/guest.js` — Expose `sendValue` on guest exo, delegate to mailbox.
- `packages/daemon/src/interfaces.js` — Add `sendValue` guard to Guest and Host interfaces.
- `packages/daemon/src/help-text.js` — Add help text for `sendValue`.
- `packages/daemon/src/daemon.js` — Update `makeMessageHub` to expose `VALUE` edge.

**CLI (3 files)**:

- `packages/cli/src/endo.js` — Add `send-value` command definition.
- `packages/cli/src/commands/send-value.js` — New CLI command implementation.
- `packages/cli/src/commands/inbox.js` — Add value message display formatting.

**Test (1 file)**:

- `packages/daemon/test/endo.test.js` — Add value message integration tests.

**Chat (3 files)**:

- `packages/chat/inbox-component.js` — Render value messages with preview and adopt.
- `packages/chat/command-registry.js` — Register `/send-value` command.
- `packages/chat/command-executor.js` — Execute send-value via `E(host).sendValue()`.

The §discipline: *one feature, fourteen files, four packages*. The implementation surface is large because the message-type adds a new variant to every type-aware layer (typedef + mail + interfaces + Guest/Host wrappers + CLI command + chat rendering). The §design-doc-as-implementation-tracker discipline captures this surface explicitly so a future maintainer can trace the feature.

### §The Related Designs cross-references

The §three cross-references (lines 322-331):

- **`daemon-form-request`** — form messages use value messages as their reply mechanism; each form submission produces a value message with `replyTo` pointing to the form. The §value-as-reply-pattern is the bridge.
- **`chat-reply-chain-visualization`** (deprecated as of cycle 99) — value messages participate in reply chains; rendering with connector lines would have been part of that design.
- **`daemon-capability-bank`** — value messages could be the delivery mechanism for capability grants. The §future-extension is named but deferred.

The §design-dependency-graph reading: the value-message type *establishes the value-as-reply pattern* that subsequent designs (form-request, capability-bank, commands-as-messages from cycle 101) *reuse*. The §value message is the *foundational reply primitive* on top of which higher-level patterns build.
