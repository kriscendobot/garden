---
ts: 2026-05-14T17:56:38Z
kind: result
role: liaison
project: garden-library
refs:
  - entries/2026/05/14/051241Z-message-scholar-1f9a9e.md
---

# Library efficacy A/B test (round 1) — report

Single-trial A/B test of the journal library's value to a research subagent answering questions about Endo. The test was run earlier in the maintainer's 2026-05-14 session; the synthesis was given as a text reply at the time but never written to disk. This entry captures the methodology, raw measurements, per-question grading, and follow-up proposals so the result has a durable home.

## Methodology

- **12 questions** about Endo, chosen by the liaison to span the library's topics (exo, hardened-javascript, captp, capability-security, eventual-send, ocapn, marshal, pass-style, getting-started, tooling, zoe). Questions are listed below in the "Questions" subsection.
- **Two `general-purpose` subagents** dispatched in parallel.
  - **Treatment** (with library): permitted to read only `/home/kris/garden/journal/library/`. Forbidden from WebSearch, WebFetch, and reading the bare clones under `/home/kris/garden/worktrees/`.
  - **Control** (without library): permitted to use WebSearch, WebFetch, and read source from `worktrees/endojs-endo.git` + `worktrees/kriscendobot-agoric-sdk.git` + `worktrees/kriscendobot-ocapn.git`. Forbidden from `/home/kris/garden/journal/library/`.
- Both agents asked to answer the 12 questions in 2–4 sentences with citations, and to report effort (file reads, web fetches, characters read) + qualitative pace.
- The liaison authored ground-truth notes for each question while the subagents were running (preserved at `/tmp/abtest-ground-truth.md` as of this writing; also reproduced in the "Ground-truth notes" subsection below).

### Questions (the 12)

1. What is the difference between `Far()` and `makeExo()`, and when should you prefer each?
2. What does `lockdown()` do, and how does it differ from `harden()`?
3. How does CapTP's `wire-delta` mechanism prevent races in distributed garbage collection of exports?
4. What is the "closed function" discipline in `@agoric/async-flow` and why is it required?
5. What is the difference between `PublishKit`, `NotifierKit`, and `SubscriptionKit` in `@agoric/notifier`?
6. How does a three-party handoff work in the OCapN family — what are the gifter, receiver, and exporter roles, and what certificates does each create?
7. What is the smallcaps wire format and how does it differ from JSON in `@endo/marshal`?
8. What are the three persistence zones (heap, virtual, durable) in `@agoric/vat-data`?
9. What does `proof: 'optimistic'` mean as an option to `@agoric/casting`'s `makeFollower`, and what's the trade-off?
10. How does Zoe guarantee that users either get what they asked for or a full refund?
11. What is the "crossed hellos" problem in CapTP session establishment and how does the protocol resolve it?
12. Why must `prepare` functions in Zoe contracts settle within a single crank from the second incarnation onward?

## Raw measurements

| Dimension | Treatment (library) | Control (web + source) |
|---|---|---|
| Total tokens | **62,857** | 63,996 |
| Tool uses | **25** | 42 |
| Duration | **138.96 s** | 159.22 s |
| Files / fetches (self-reported) | ~16 file reads | ~12 git reads + 2 WebSearch |
| Pace (self-reported) | "fast" | "fast" |

Tokens are the harness-reported `total_tokens` per subagent. Tool-use counts are the harness-reported counts. Durations are the harness-reported wall-clock per subagent in milliseconds (rounded). The treatment was ~14% faster on wall clock and used ~40% fewer tool calls; token totals were within 2% of each other.

**Agent transcript locations** (as of 2026-05-14):
- Treatment: `/home/kris/.claude/projects/-home-kris-garden/4f411a27-5e1f-4d49-b503-737567e92658/subagents/agent-a167e378b810cd704.jsonl`
- Control: `/home/kris/.claude/projects/-home-kris-garden/4f411a27-5e1f-4d49-b503-737567e92658/subagents/agent-a84070dc980a9de69.jsonl`

## Quality grading

Both agents got **12/12 substantively correct** when checked against the liaison's ground-truth notes. Differences were in framing, citation density, and specificity. Notable per-question observations:

- **Q1 (Far vs makeExo)**: equivalent precision. Treatment cited `endo--pkg-exo-readme--why-exo`; control cited `packages/exo/README.md` + `packages/far/README.md`.
- **Q3 (wire-delta)**: both correct. Treatment cited the library's stage-3 implementation-guide section; control cited the OCapN spec. Equivalent content.
- **Q7 (smallcaps)**: **control wins on specificity** — it listed the actual sigil characters (`#`, `+`/`-`, `%`, `$`, `&`, `!`) and concrete examples; treatment was correct but more abstract. The library's `endo--pkg-marshal-docs-smallcaps-cheatsheet--overview` exists but the abstract doesn't surface the sigil table; the body does. The treatment agent didn't dig into the body for this one.
- **Q11 (crossed hellos)**: both correct. Control added a detail the treatment didn't: "double-SHA256 of the syrup-serialized session pubkey" for the Public Identifier. The library's `ocapn--implementation-guide--stage-0-foundation` says "sort + hash"; the spec is more specific. Library gap.
- **Q12 (single-crank rule)**: treatment combined two sections via `notes:` cross-references; control read two separate package READMEs and synthesized. Both correct.

## Synthesis

The library's value in this test was **fewer round-trips** (40% reduction in tool uses) at **comparable token spend and quality**, with a **~14% wall-clock advantage**. For agents under sandbox constraints or with limited tool budgets, the library is clearly a win. For an agent that already has fast source access and a clear search target, the library is roughly tied on quality and tokens.

The library's strongest unique contribution was the **pre-built cross-references** (Q12 in particular benefited from `notes:` fields pointing at two sections that together answer the question). The library's question→section topical match was near-zero-search-cost per question: every question landed on a section whose title or `notes:` matched almost verbatim — section names were "indexed with these kinds of questions in mind" (the treatment's own report).

## Suggested library improvements

Three improvements surfaced from the treatment's friction notes:

1. **Add a `persistence` or `durability` topic page**. Sections on persistence zones, durable exos, and prepare lifecycle currently scatter across `exo`, `hardened-javascript`, `capability-security`. Treatment had to go directly to known section names rather than via the topic index.
2. **Add an `async-flow` topic page** (or a broader `replay` / `vow-flow` topic). `agoric-sdk--pkg-async-flow-readme--*` is filed only under `capability-security` and `agent-conventions`; treatment had to grep over `sections/` to locate.
3. **Surface specifics into section abstracts**. The smallcaps sigil table lives in the body of `endo--pkg-marshal-docs-smallcaps-cheatsheet--overview` but not in the abstract. Q7's specificity gap could be closed by lifting the table into the abstract.

## Caveats

- **Single trial, two agents** — variance is unmeasured. A 14% duration difference could be noise. A more rigorous test would use 24 fresh-context subagents (one per condition per question; see "Round 2 methodology" below).
- **Ground-truth bias** — the liaison authored much of the library content, so the grading favors the library's framings. The two agent reports are independently consistent enough that this bias matters less than it might, but it's not zero.
- **Token measurement** — harness-reported `total_tokens` is trusted as authoritative; tool-use count is similarly trusted. Wall-clock duration is harness-reported `duration_ms`.
- **Question selection bias** — the questions were chosen by the liaison who knew what the library covered. This is the primary reason for the round-2 redesign described next.

## Round 2 methodology (proposed; not yet run)

Per the maintainer's 2026-05-14 redirect, the round-2 test should treat each question as a fresh-context engagement and base questions on what would actually emerge from a "design X feature from `designs/<file>.md`" prompt rather than starting from what the library is known to answer. Twelve such questions were drafted, spanning four designs from `endo-but-for-bots/llm/designs/`:

**From `syrups.md`** (codec):
1. Existing netstring framing in Endo — API shape (`Uint8Array` vs string at boundaries; async-iterator interface)?
2. `@endo/stream` interaction with byte-stream framers — adapter pattern between chunk-of-bytes and message-delimited streams?

**From `ocapn-network-transport-separation.md`**:
3. `op:start-session` handshake fields today — what does each field do?
4. CapTP crossed-hellos today — where does the logic live; where does it move under the network-transport separation?
5. `OcapnLocation` Syrup codec today — wire-compat constraints when renaming a field across implementations?
6. Netlayer ↔ CapTP session-machinery contract today — what does a netlayer return, what does CapTP do with it next?

**From `trust-on-first-bind.md`**:
7. Endo daemon's persistent policy/allowlist storage today — standard durable-store pattern, or does each cap roll its own?
8. Endo's canonical concurrent-request-coalescing primitive — does `@endo/promise-kit` (or elsewhere) provide one?
9. Endo's existing revocation primitive — "pin an allow decision into durable storage and later revoke it"?

**From `retention-path-notation.md`**:
10. `packages/daemon/src/graph.js` retention-edge representation today — current shape of a retention-path segment?
11. `reverseLookup` API today — accepts what; returns what; nested directories?
12. Endo's convention for "typed return value where rendering belongs to the consumer"?

The maintainer's last word before this entry was that the 24-subagent dispatch (12 questions × 2 conditions, each as a fresh context) is awaiting confirmation before firing.

## Ground-truth notes

Reproduced from `/tmp/abtest-ground-truth.md` so the file's eventual disappearance doesn't lose the maintainer's reference answers. (Truncated to one-line summaries per question; full prose is in the /tmp file as of this writing.)

1. **Far vs makeExo** — both make remotables. Far minimal-overhead, no methodGuard. makeExo adds patterns-language argument typing + exo lifecycle. Use Far for simplest case; makeExo for arg validation or upgrade/durability.
2. **lockdown vs harden** — lockdown one-time, program-wide; freezes built-ins, installs causal console, idempotent. harden per-value, transitively freezes one object graph, called many times. lockdown composes repairIntrinsics + hardenIntrinsics.
3. **wire-delta GC** — op:gc-exports carries (export-pos-list, wire-delta-list). Wire-delta is the importer's count of received references since last GC for that position. Exporter subtracts; reclaims only when zero. Prevents the race where exporter sends N refs, importer GC counts K, exporter would dangle on N-K still in flight.
4. **closed function discipline** — async function passed to asyncFlow must not lexically capture mutable state (only powerless globals). Required because asyncFlow logs-and-replays across upgrades; captured mutable state would re-execute effects outside the replay mechanism.
5. **PublishKit / NotifierKit / SubscriptionKit** — NotifierKit lossy; SubscriptionKit fully lossless (deprecated; unbounded memory); PublishKit forward-lossless by default with opt-in lossy via subscribeAfter / getUpdateSince — flexibility is why it supersedes the others.
6. **Three-party handoffs** — Gifter deposits gift on Exporter (gift-id = 32 random bytes). Gifter creates desc:handoff-give signed with Gifter's key from *gifter↔exporter* session, sends to Receiver. Receiver wraps in desc:handoff-receive carrying handoff-count + signed give, signed with Receiver's key from *gifter↔receiver* session, sends to Exporter via withdraw-gift. Exporter checks four things (session open with gifter; gifter signed give; receiver signed receive; replay count); yields one-shot.
7. **smallcaps vs JSON** — extends JSON with capability refs by stealing leading-character namespace of strings — sigil prefix means tagged encoding. JSON values pass through; remotables/errors/bigints/symbols/etc. get sigils. Compact; JSON-compatible on the wire.
8. **Three zones** — heap (in JS memory, lost on vat termination); virtual (pageable to disk, lost on termination); durable (pageable AND revivable through vat upgrade+restart). @agoric/zone is the typical surface; @agoric/base-zone underneath.
9. **proof: 'optimistic'** — default mode for makeFollower. Releases data immediately; may crash the follower in the future if an already-released value couldn't be proven. Trade-off vs `strict` (proof-then-release, ~one-block wait) and `none` (no validation, no future crash).
10. **Zoe refund-or-fulfillment** — contract never has access to user assets; Zoe holds in escrow and only releases per the contract's rules. If contract is buggy/malicious, collateral remains escrowed and is refunded.
11. **Crossed hellos** — when two peers simultaneously open sessions to each other, both compute session ID (sort + hash of pubkeys; per the spec, double-SHA256 of syrup-serialized pubkey), sort serialized IDs, abort the lower-ID session via op:abort. Reason string implementation-defined.
12. **prepare single-crank rule** — first incarnation may take multiple cranks (may depend on remote calls); later incarnations must settle in one crank. Reason: at upgrade time the vat may have inbound messages queued; kernel can't distinguish "needed for upgrade" from "new work to delay until upgrade finishes", so prepare must be standalone within one crank.

## Self-improvement

The fact that this report sat as conversation-only text for hours before being written down is itself a finding. **Library-evaluation work should write its results directly to the journal at the time of the test**, not as a chat reply that may or may not get persisted. A future evaluation skill or convention should require a `journal/entries/.../result-` entry as the test's exit step.
