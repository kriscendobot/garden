---
title: The four-problem motivation that frames *giving a value to another agent* as a missing message type (a `package` with empty template strings is the current workaround; lacks clear reply semantics; requires `adopt` ceremony; doesn't fit the AI-agent-replies-with-result LLM-tool-loop) the unified design proposing a new `value` message type carrying exactly one `valueId` formula-identifier with **required** `replyTo` (every value message is a reply, unlike the optional-replyTo `package` type); the §sendValue method on Mail/Host/Guest with `(messageNumber, petNameOrPath, resultName?)` signature; the §implementation that infers the recipient from the parent message's other-party (same logic as `reply`), looks up the value's formula identifier via the directory, constructs the hardened ValueMessage, and posts it; the §auto-retain idiom — recipient's `deliver()` writes the value to the recipient's pet store under the `resultName` hint when present; the open question about envelope-vs-out-of-band carriage of `resultName`; the §message hub directory that exposes seven edges (FROM/TO/DATE/TYPE/MESSAGE/REPLY/VALUE) where VALUE is the primary payload; the §five-decision *reply-only / single-value / auto-retain-optional / no-promise-resolver-infrastructure / recipient-inferred-from-parent* rationale block; the §14-row Files Modified table that names the implementation surface spanning daemon (`types.d.ts` + `mail.js` + `host.js` + `guest.js` + `interfaces.js` + `help-text.js` + `daemon.js`), cli (`endo.js` + new `commands/send-value.js` + `inbox.js`), test (`daemon/test/endo.test.js`), and chat (`inbox-component.js` + `command-registry.js` + `command-executor.js`)
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
---

## Abstract

The §opening Problem block (lines 10-38) frames *giving a value to another agent* as a missing message type. Endo's existing messages either carry text-with-references (`package`), promises (`request`/`form-request`), or code (`eval-request`/`definition`). The §four problems with the current `package`-as-empty-template workaround: (1) *a `package` requires template strings* — the sender must construct a non-empty `strings` array; (2) *no clear reply semantics* — promise-resolution returns a value, but `package` reply can only carry references as named edges within text; (3) *adopt ceremony* — the recipient must explicitly `adopt` each edge name; (4) *LLM agent tool results* — an AI agent producing a task result (file, capability, computed object) should be able to reply with the result as a first-class retained value. The §Design (lines 40-277) proposes a new `value` message type carrying exactly one `valueId` formula-identifier with *required* `replyTo` (every value message is a reply). The §implementation traces through 14 subsections covering: (a) the `ValueMessage` typedef with required `replyTo: FormulaNumber` and `valueId: FormulaIdentifier`; (b) `MessageFormula.messageType` union extension adding `'value'`; (c) the `Mail.sendValue(messageNumber, petNameOrPath, resultName?)` interface; (d) the `mail.js` implementation that infers the recipient from the parent message's other-party, looks up the value's formula identifier via the directory, constructs the hardened ValueMessage with `replyTo: parent.messageId`, and posts to the recipient handle; (e) the auto-retain mechanism — recipient's `deliver()` writes the value to the pet store under the `resultName` hint when present; (f) the open question of envelope-vs-out-of-band `resultName` carriage; (g) the message hub directory's seven edges (FROM/TO/DATE/TYPE/MESSAGE/REPLY/VALUE); (h) Guest+Host interface exposures with M.call interface guards; (i) help text and CLI command (`endo send-value <message-number> <pet-name> --as <agent> --name <result>`); (j) CLI inbox display formatting (with optional *(as "task-result")* annotation when `resultName` is present); (k) Chat UI rendering (sender chip + *sent a value* text + reply-chain indicator + inline value preview + Adopt button or pet-name chip). The §Design Decisions (lines 279-301) name five rationale points: *reply-only* (unsolicited values stay as `package`); *single value* (multiple values use multiple messages or `package`); *auto-retain is optional* (resultName is a hint, not a guarantee); *no promise/resolver infrastructure* (value messages are fire-and-forget from sender perspective; no promise to resolve); *recipient inferred from parent* (prevents sending values to unrelated parties). The §Files Modified (lines 303-321) names 14 implementation surfaces spanning daemon (7 files), cli (3 files), test (1 file), and chat (3 files). The §Related Designs (lines 322-331) cross-references three sister designs: `daemon-form-request` (forms use value messages as reply mechanism), `chat-reply-chain-visualization` (value messages participate in reply chains), `daemon-capability-bank` (value messages could deliver capability grants).

## Body

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

## Connection to the wider library

This section is the **canonical *single-feature-fully-traced-across-packages* worked example**. Three threads:

1. **The reply-only single-value invariant** — the `value` message type's structural constraint (required `replyTo`, single `valueId`) keeps it focused on the reply-with-result pattern. Each message type has a single use case; conflation across types is rejected.

2. **The auto-retain-optional `resultName` hint** — the *offer-ergonomics-preserve-flexibility* dual-mode pattern. Recipients can accept the hint for zero-ceremony delivery or ignore it for explicit control.

3. **The recipient-inferred-from-parent discipline** — the security-by-topology pattern. The message-graph topology determines the recipient; `sendValue` cannot send to unrelated parties because it doesn't take a recipient argument.

The §value-as-reply pattern is *foundational* — cycle 101's daemon-commands-as-messages design reuses it (every command's result reply is a value-typed message with `replyTo` to the command). Together they form the *daemon's reply-primitive layer*.

## Translation block (design idiom → contemporary practice)

| Design idiom | Contemporary practice |
| ------------ | --------------------- |
| `replyTo is required, unlike package where it is optional` | The *type-level invariant* discipline; encode the constraint in the type, not just in the implementation. |
| `valueId: FormulaIdentifier` (single value) | The *single-value-per-message* invariant; multi-value cases use multiple messages. |
| `recipient inferred from parent` | The *security-by-topology* discipline; the message-graph determines the recipient. |
| `resultName is a hint from the sender, not a guarantee` | The *offer-not-force* discipline; the recipient retains the right to ignore. |
| `auto-retain mechanism` via `deliver()` writing to pet store | The *zero-ceremony-common-case* ergonomics. |
| `Open question: envelope vs out-of-band carriage` | The *honestly-unresolved* design question; document the trade-off without forcing closure. |
| 7-edge message hub (FROM/TO/DATE/TYPE/MESSAGE/REPLY/VALUE) | The *uniform-directory-shape-with-type-specific-edge* discipline. |
| `endo adopt 5 VALUE my-result` CLI pattern | The *capability-edge-adoption* idiom. |
| `fire-and-forget from sender's perspective` | The *no-promise-when-value-already-exists* distinction; requests use promises; values don't. |
| `one result per task` framing | The *agentic-loop-shape* — task in, result out, both as messages. |
| 14-row Files Modified table | The *design-doc-as-implementation-tracker* shape; surface every touched file. |
| `daemon-form-request uses value messages as their reply mechanism` | The *foundational-primitive-reused-by-higher-level-patterns* design layering. |

## See also

- [[daemon]] (topic) — the endo daemon architecture; this design extends the mail system.
- `endo-but-for-bots--llm-designs-daemon-commands-as-messages--*` (cycle 101) — the *commands-as-self-addressed-messages* design that **reuses this value-as-reply pattern** for every command's result reply.
- `endo-but-for-bots--llm-designs-chat-reply-chain-visualization--*` (cycle 99, deprecated) — value messages participate in the reply chain rendering that design described.
- `endo-but-for-bots--llm-designs-chat-focus-message--*` — the successor reply-visualization; consumes the reply-chain data this design produces.
- `endo-but-for-bots--llm-designs-daemon-capability-persona--*` — capability-persona-as-handle; value messages could be the delivery mechanism for capability grants per the §Related Designs cross-reference.

## Common confusions

- **"`replyTo` could be optional — let value messages be unsolicited too."** It could *not* in this design. The §Design Decision #1 explicitly states *unsolicited values stay as `package`*. The `value`-type's purpose is *the reply-with-result pattern*; allowing unsolicited values would dilute the type's semantic.
- **"`sendValue` should take a recipient argument."** It explicitly does *not*. The §Design Decision #5 names *recipient inferred from parent* as a security feature — `sendValue` cannot send values to unrelated parties. The message-graph topology determines the recipient.
- **"Auto-retain should be unconditional — always write to the pet store."** It is *intentionally optional*. The §Design Decision #3 names *the recipient may choose to ignore* the hint. Forcing auto-retain would override recipient autonomy.
- **"Why not let `value` carry multiple values?"** §Design Decision #2 names this — *to send multiple values, send multiple value messages or use a `package`*. The *one-result-per-task* framing matches the common case; multi-value containers would dilute the type and complicate handling.
- **"`fire-and-forget` means the sender doesn't know if the value was received."** The sender knows the *message was delivered* (the `Promise<void>` resolves on delivery). The sender doesn't get *confirmation that the recipient retained or did anything with* the value — but that's appropriate because the recipient autonomy is preserved.
- **"`resultName` being in the envelope is a privacy leak."** The envelope is visible to both sender and recipient, but only the recipient *acts* on it. The §open question section acknowledges the privacy trade-off and names the alternative (recipient manually adopts).
- **"`endo adopt 5 VALUE my-result`'s `VALUE` is just a magic string."** It is *the canonical edge name* in the message hub directory schema. Other types have their own edge sets (`MESSAGE`, `REPLY`, etc.); `VALUE` is the value-message-specific edge. The schema is documented.
- **"The 14-file Files Modified table is excessive — most of it is plumbing."** It is *plumbing* — and the §design-doc-as-implementation-tracker discipline surfaces all of it. A future maintainer who wants to *add* a new message type can use this table as a template for what they'll need to touch.
- **"Why is this design `Complete` but daemon-commands-as-messages is `Not Started`?"** They're independent. Value messages shipped 2026-03-02 as the foundational reply primitive; commands-as-messages was proposed 2026-03-11 as a *consumer* of the value-as-reply pattern. The consumer hasn't been built yet; the primitive has.
- **"Daemon-form-request uses value messages — that's a circular dependency."** It's a *layering*. Value messages are the foundational primitive; form-request layers on top by using value-replies as form-submission results. The §Related Designs cross-reference names form-request as the *consumer*, not the dependency. The value-message design stands alone; form-request depends on it.
