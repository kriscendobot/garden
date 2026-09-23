---
ts: 2026-06-17T20:35:00Z
kind: result
role: researcher
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
refs:
  - dispatches/researcher--4151cb
---

Refinement for a proposed `designer` dispatch that will draft
`designs/presence-severance-observation.md` on the `llm` branch of
`endojs/endo-but-for-bots`. The design proposes a way to use
HandledPromise and eventual-send to observe when a presence is severed
from its remote target (typically an OCapN / CapTP remote-object
presence whose connection breaks). The refinement below grounds the
prompt in the library's existing material on `@endo/eventual-send` (the
HandledPromise handler protocol, the forwarding forest, the `E` /
`E.sendOnly` proxy surface), `@endo/captp` (the `{dispatch,
getBootstrap, abort}` triple plus the disconnect surface documented in
the unhandled-rejection-display design), the OCapN spec (`op:abort`
operation, the netlayer's reliability contract), and three sibling
designs (`daemon-cross-peer-gc.md`, `ocapn-network-transport-separation.md`,
`daemon-message-streaming.md`) that already gesture at severance under
the names "partition", "abort", and "disconnect". Most relevant: the
`captp-bounded-transient-pin` concept already names a partition-handler
mechanism with disconnection-triggered intrinsic release, and the
`release-exo-lifetime-and-captp-partition` section explicitly flags
that the per-Exo cancellation-promise surface "may not yet be exposed"
and that adding "the minimum surface required" is part of any design
that depends on it — exactly the gap the proposed design fills.

```markdown
## Library and project references

### Library concepts and sections

**HandledPromise and the local presence object**

- [concepts/captp-bounded-transient-pin](../../../journal/library/concepts/captp-bounded-transient-pin.md) — the existing pattern for "partition-triggered release"; the *captp partition handler*, *captp partition signal*, and *disconnection-triggered intrinsic release* aliases here are the closest existing vocabulary for what the proposed design generalizes.
- [sections/endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find](../../../journal/library/sections/endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find.md) — the union-find forest backing presences and the four WeakMaps the handler protocol consults: `promiseToPresence`, `presenceToPromise`, `promiseToPendingHandler`, `presenceToHandler`. The presence-to-handler map is where a severance hook would attach.
- [sections/endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly](../../../journal/library/sections/endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly.md) — the six-operation surface (`get`, `applyFunction`, `applyMethod`, plus three `*SendOnly` variants) and its two-method reduction. The hook composes with this surface rather than extending it.
- [sections/endo--packages-eventual-send-src-E-js--E-proxy-handler-trio-with-this-receiver-check-and-freezable-not-hardened-proxy-targets](../../../journal/library/sections/endo--packages-eventual-send-src-E-js--E-proxy-handler-trio-with-this-receiver-check-and-freezable-not-hardened-proxy-targets.md) — the user-facing `E()` proxy that bottoms out into the handler protocol; the `E.sendOnly` shape and its synchronous-throw discipline are precedents for an `E.whenSevered(p)` or sibling shape.
- [sections/endo--pkg-eventual-send-readme--handled-promise](../../../journal/library/sections/endo--pkg-eventual-send-readme--handled-promise.md) — the documented HandledPromise primitive surface; the canonical place to name a new method if the design chooses that shape.

**CapTP connection lifecycle**

- [sections/endo--pkg-captp-readme--usage](../../../journal/library/sections/endo--pkg-captp-readme--usage.md) — `makeCapTP` returns `{dispatch, getBootstrap, abort}`; `abort(Error)` is the canonical local entry point for tearing down a connection. The proposed design needs to either extend this triple or wire a new method off the handler the abort fires.
- [sections/endo--pkg-captp-readme--overview](../../../journal/library/sections/endo--pkg-captp-readme--overview.md) — frame for `@endo/captp` (the JavaScript implementation of CapTP).
- [sections/endo--pkg-captp-readme--loopback](../../../journal/library/sections/endo--pkg-captp-readme--loopback.md) — in-process loopback fixture; the natural test substrate for severance semantics without requiring a real network.
- [sections/endo--packages-captp-src-finalize-js--weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability](../../../journal/library/sections/endo--packages-captp-src-finalize-js--weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability.md) — the export-table slot-management primitive; the table the design must walk to reject pending sends on severance.
- [sections/endo-but-for-bots--llm-designs-unhandled-rejection-display--two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback](../../../journal/library/sections/endo-but-for-bots--llm-designs-unhandled-rejection-display--two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback.md) — `CTP_DISCONNECT.reason` is CapTP's existing disconnect-signaling wire shape; the "error-path-cannot-depend-on-error-path" discipline (marshal tables may be partially torn down at disconnect) constrains what the severance hook can rely on.
- [sections/endo-but-for-bots--llm-designs-chat-slot-slash-commands--daemon-changes-makeretainedvalue-and-captp-bounded-pin--release-exo-lifetime-and-captp-partition](../../../journal/library/sections/endo-but-for-bots--llm-designs-chat-slot-slash-commands--daemon-changes-makeretainedvalue-and-captp-bounded-pin--release-exo-lifetime-and-captp-partition.md) — **the closest precedent.** Names a "per-Exo cancellation promise" obtained via "the standard CapTP partition-handler mechanism", explicitly notes the surface "may not yet be exposed in the form this design needs", and prescribes adding "the minimum surface required" — exactly the gap the proposed design fills. The proposed design should cite this as prior work that already anticipates the API it generalizes.

**OCapN spec (wire-layer view of the severance event)**

- [sections/ocapn--draft-specifications-captp--operations](../../../journal/library/sections/ocapn--draft-specifications-captp--operations.md) — names `op:abort` as one of the nine wire operations; the peer-to-peer signal that closes a session.
- [sections/ocapn--draft-specifications-captp--captp-overview](../../../journal/library/sections/ocapn--draft-specifications-captp--captp-overview.md) — connection lifecycle: handshake, start-session, deliver, end-session. The wire-level frame for severance.
- [sections/ocapn--draft-specifications-netlayers--introduction](../../../journal/library/sections/ocapn--draft-specifications-netlayers--introduction.md) — netlayer contract: reliable in-order message streams, integrity, optional confidentiality, plus per-connection metadata surfaced to the protocol layer. The connection-closed event the proposed design hooks comes from the netlayer.
- [sections/ocapn--draft-specifications-netlayers--overview](../../../journal/library/sections/ocapn--draft-specifications-netlayers--overview.md) — abstraction-over-transport framing.
- [sections/ocapn--implementation-guide--stage-0-foundation](../../../journal/library/sections/ocapn--implementation-guide--stage-0-foundation.md) — first milestone: "get a session up and down" — the implementation-guide's own framing of session lifecycle.

**Cancellation-promise pattern (Observer API shape candidate)**

- `keywords.md` entry: `cancellation-promise-as-platform-neutral-interface (Promise<never>)` points at the cli-http-client design where a `Promise<never>` is used as a platform-neutral cancellation token. Directly informs the "Observer API" trade-off in the proposed design: `whenSevered(presence): Promise<never>` (rejects on severance, never resolves) is a precedent-with-name in the corpus.

**Sibling designs (cited verbatim in the proposed prompt's Cross-design coordination section)**

- `designs/daemon-cross-peer-gc.md` on `llm` — the retention-accumulator + cross-peer-gc design; reconnect-on-the-peer-side already treats a network partition as a full snapshot rebuild. Severance observation is the *single-presence* form of what cross-peer-gc handles in bulk. Cite:
  - [sections/endo-but-for-bots--llm-designs-dcpg--crash-reconnect-and-revocation--reconnect-on-the-peer-side](../../../journal/library/sections/endo-but-for-bots--llm-designs-dcpg--crash-reconnect-and-revocation--reconnect-on-the-peer-side.md)
  - [sections/endo-but-for-bots--llm-designs-dcpg--wire-and-batching](../../../journal/library/sections/endo-but-for-bots--llm-designs-dcpg--wire-and-batching.md)
- `designs/ocapn-network-transport-separation.md` on `llm` — the four-layer hierarchy (OCapN Core → Network → Transport → Netlayer); names *where* a connection-closed event surfaces (the netlayer) and *which layer* delivers it to the captp session machinery. Cite:
  - [sections/endo-but-for-bots--llm-designs-ntsep--design-conceptual-model](../../../journal/library/sections/endo-but-for-bots--llm-designs-ntsep--design-conceptual-model.md)
  - [sections/endo-but-for-bots--llm-designs-ntsep--problem-statement](../../../journal/library/sections/endo-but-for-bots--llm-designs-ntsep--problem-statement.md)
- `designs/daemon-message-streaming.md` on `llm` — streaming sessions whose *abort* phase is the observable form of severance for a long-running call; the persistence-model section's "durable on end, partial on abort" rule is the precedent for distinguishing graceful end from severance. Cite:
  - [sections/endo-but-for-bots--llm-designs-daemon-message-streaming--streamReply-and-streamSend-with-stream-formula-and-CapTP-rides-method-calls--the-persistence-model-durable-on-end-partial-on-abort](../../../journal/library/sections/endo-but-for-bots--llm-designs-daemon-message-streaming--streamReply-and-streamSend-with-stream-formula-and-CapTP-rides-method-calls--the-persistence-model-durable-on-end-partial-on-abort.md)

**Sibling implementation (vocabulary reference)**

- [sections/metamask-ocap-kernel--docs-glossary-md--canonical-vocabulary-for-kernel-vat-baggage-exo-and-kref-vref-rref-eref-name-space](../../../journal/library/sections/metamask-ocap-kernel--docs-glossary-md--canonical-vocabulary-for-kernel-vat-baggage-exo-and-kref-vref-rref-eref-name-space.md) — MetaMask/ocap-kernel's `rref` (remote reference, *does not survive the channel*) is the same concept as a severed presence under different vocabulary. The "ephemeral namespace" framing names the lifetime relationship explicitly. Worth a one-line nod in the proposed design's Related Work or Open Questions.

### Project context

- [`journal/projects/endo-but-for-bots/README.md`](../../../journal/projects/endo-but-for-bots/README.md) § Rules of engagement — base-branch inference: a design touching only `designs/` lands on `llm` as a DRAFT per `roles/designer/AGENT.md` § Operating norms; the standing relaxation in § Standing authorizations covers the PR open.
- [`journal/projects/endo-but-for-bots/README.md`](../../../journal/projects/endo-but-for-bots/README.md) § Authority structure — erights' (Mark S. Miller's) topic-scoped authority on the wider `endojs/endo` repo covers `eventual-send`, `captp`, OCapN; on this `endo-but-for-bots` repo, every commenter is maintainer-equivalent, so any review on the resulting PR routes through the standard chain. The design author should expect potentially substantive review from erights, kumavis, or jcorbin.
- `designs/CLAUDE.md` (on `llm`) — design metadata table conventions (Created / Author / Status); the proposed prompt already names "Status Not Started" which matches.

### Why each reference is relevant

- The `captp-bounded-transient-pin` concept page is the single most relevant existing artifact: it already names the partition-handler mechanism, the disconnection-triggered intrinsic-release semantics, and the per-Exo cancellation-promise surface. The proposed design generalizes from "release a transient pin on severance" to "observe severance for any presence".
- The `forwarding-forest-union-find` body shows that the local presence is *already* a discrete object in a known data structure (`presenceToHandler` WeakMap). A severance hook attaches to the handler at that map's value.
- The `release-exo-lifetime-and-captp-partition` section is the prior-work citation that justifies the proposed design existing at all: it flags the API gap, prescribes the fix, and was not generalized. The proposed design picks that thread up.
- `op:abort` and the netlayer introduction together fix *what* the severance event is on the wire and *which layer* delivers it.
- The cancellation-promise / `Promise<never>` pattern is the platform-neutral observer shape the proposed design's "Observer API" section can name directly rather than reinvent.
- The three sibling designs (`dcpg`, `ntsep`, `daemon-message-streaming`) are the cross-design-coordination citations the proposed prompt already requires; each has at least one library-indexed section that gives the design author the specific paragraph to read.
- The MetaMask/ocap-kernel `rref` glossary entry is a vocabulary alternative (`rref does not survive the channel`) the design could cite under Related Work to situate the contribution against a sibling implementation.

### Open questions for the design author

- **No existing concept page for "severance" as a first-class event.** The library's current vocabulary is "partition" (`captp-bounded-transient-pin`) and "abort" (the captp tear-down primitive). The proposed design will need to either (a) introduce a "severance" concept page after landing or (b) treat its terminology as an alias of the partition vocabulary. The researcher recommends (a) so the broader semantics (sub-cases: transport-level, object-level, permission-revoked) get a single home rather than scattering across partition + abort + disconnect.
- **The "per-Exo cancellation promise" API is not visible in any source section yet.** The `release-exo-lifetime-and-captp-partition` section claims the captp partition-handler mechanism exposes such a promise, but no `@endo/captp` source-file section in the library names a `whenAborted` / `whenDisconnected` / `whenSevered` export. The design author should grep `packages/captp/src/` directly to verify the current state; the library currently lists only `trap.js`, `finalize.js`, `loopback.js`, and `atomics.js` among the captp source files.
- **Re-binding / reconnection semantics are open.** The `daemon-cross-peer-gc` reconnect-on-the-peer-side section treats reconnect as a fresh snapshot, which implies new presences rather than re-bound old ones. The proposed design's "severance vs reconnection" open question should cite this as the existing posture and either inherit it or argue for a different rule.
- **`handler.HAS` and `handler.DELETE` are mentioned in the proposed prompt's primitive list but appear in no library section.** The `operation-reduction-and-sendonly` section enumerates `get` + `applyFunction` + `applyMethod` + `*SendOnly` variants only. The design author should verify whether `HAS` / `DELETE` are real members of the current handler protocol or whether the prompt is imagining them; if real, the library has a gap worth filing.
```

### Library writeback

Keyword shortcuts added (all pointing at `captp-bounded-transient-pin`
since the existing partition-handler mechanism is the closest extant
concept for the proposed severance vocabulary):

- `presence severance` → `captp-bounded-transient-pin`
- `connection severance` → `captp-bounded-transient-pin`
- `captp severance` → `captp-bounded-transient-pin`
- `captp connection sever` → `captp-bounded-transient-pin`
- `remote disconnected` → `captp-bounded-transient-pin`
- `disconnection-triggered release` → `captp-bounded-transient-pin`
- `whenSevered` → annotated as "no concept; load-bearing term for
  proposed presence-severance-observation design" (placeholder so the
  next reader's flat-grep on the design's vocabulary hits the keyword
  file rather than wandering)
- `onSever` → same annotation

No concept page drafted: the proposed design will land the primary
material on severance; drafting a concept page before the design exists
would invert the dependency. Recommend a librarian / scholar pass after
the design merges to lift `presence-severance` into its own concept
page with the partition vocabulary as aliases.

No distractions pruned: the partition vocabulary on
`captp-bounded-transient-pin` is correctly indexed; the gap was simply
that severance-vocabulary callers did not know to look there.

### Open questions

The four open questions above (severance as a first-class concept,
the cancellation-promise API surface in `@endo/captp`, reconnection
semantics, `handler.HAS` / `handler.DELETE` reality check) are signals
for the librarian / scholar to grow the corpus. The first one is the
highest-leverage: a `concepts/presence-severance.md` page after the
design lands would consolidate vocabulary that currently scatters
across "partition", "abort", "disconnect", and the soon-to-be-coined
"severance".

Self-improvement: nothing this time.
