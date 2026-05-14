---
ts: 2026-05-14T17:58:22Z
kind: result
role: liaison
project: garden-library
refs:
  - entries/2026/05/14/175638Z-result-liaison-b796b7.md
---

# Library efficacy A/B test (round 2) — methodology + 12 design-derived questions

**Status: PROPOSED, NOT YET RUN.** This entry captures the round-2 methodology and the 12 questions in their durable form. The 24-subagent dispatch (12 questions × 2 conditions, each as a fresh-context engagement) is awaiting maintainer confirmation before firing.

## Why round 2

Round 1 (companion entry `175638Z-result-liaison-b796b7.md`) had two acknowledged weaknesses in its result interpretation:

1. **Question-selection bias**. The 12 questions were chosen by the liaison who knew what the library covered. The library scored 12/12 in part because the test was implicitly designed to play to its strengths.
2. **Single-trial measurement**. One agent per condition answering all 12 questions confounds per-question variance with per-agent variance.

The round-2 redesign addresses both by:

1. **Deriving questions from design docs**, not from a curated list. The questions are the natural sub-questions an implementing agent would face when prompted to implement a feature from `endo-but-for-bots/llm/designs/`. The questions are *not* picked to flatter the library; some push on areas the library doesn't cover well.
2. **Treating each question as a fresh-context engagement** — 24 separate subagents, one per (question × condition) pair, each starting cold.

## Methodology

### Question derivation

The liaison read four substantive design docs from `endo-but-for-bots/llm/designs/` (each of which is now in the library as of cycles 39-43, but the questions were drafted before that ingest):

- `syrups.md` — codec design (50 lines)
- `ocapn-network-transport-separation.md` — OCapN refactor (170 lines)
- `trust-on-first-bind.md` — capability-policy pattern (417 lines)
- `retention-path-notation.md` — daemon GC + CLI rendering (678 lines)

For each design, the liaison imagined the prompt "design [this feature], here's the design doc" and extracted the natural sub-questions an agent would ask when trying to fill in gaps the design itself doesn't address — questions about existing primitives, conventions, constraints, interactions with other components, and failure modes.

The 12 questions span pure-Endo concerns (where the library is strong), endo-but-for-bots-specific concepts (where the library is weaker), and daemon internals (a known library gap as of round 1).

### Dispatch design

- **24 subagents** total, dispatched as `subagent_type: general-purpose`.
- Each subagent receives **one** question and answers it from scratch, with no shared context across questions.
- Subagents are dispatched in two batches:
  - **12 treatment**: each can read `/home/kris/garden/journal/library/` only.
  - **12 control**: each can use WebSearch + WebFetch, plus read source from `worktrees/endojs-endo.git`, `worktrees/kriscendobot-agoric-sdk.git`, `worktrees/kriscendobot-ocapn.git`, and `worktrees/endojs-endo-but-for-bots.git` (with branch checkouts as needed). Forbidden from `/home/kris/garden/journal/library/`.
- Each subagent returns a 2–4-sentence answer with citations, plus self-reported effort (file reads / fetches / characters read).
- The harness reports `total_tokens`, `tool_uses`, and `duration_ms` per subagent.

### Grading

For each question, the liaison authors ground-truth notes before dispatch (same convention as round 1). Quality is graded against ground truth on a per-question basis. Aggregate metrics: per-question token / tool-use / wall-clock differences; per-question quality (full / partial / wrong); win/lose/tie ratio across the 12 questions.

The round-1 ground-truth-bias caveat still applies: the liaison authored much of the library content. The round-2 mitigation is the question-selection method (design-derived, not library-derived) — but the bias isn't eliminated.

## The 12 questions

Each question is paired with the design it was derived from and the liaison's pre-dispatch prediction of library coverage strength.

**From `syrups.md` (codec; deprecated/consolidating with `@endo/syrups`)**:

1. What's the existing netstring framing implementation in Endo (`@endo/netstring`), and what shape does its API expose — `Uint8Array` or strings at its boundaries, and what async-iterator interface does it use? **Predicted library coverage: strong** — `endo--pkg-netstring-readme--overview` exists.
2. How does `@endo/stream` interact with byte-stream framers? Is there a standard adapter pattern between a chunk-of-bytes stream and a message-delimited stream? **Predicted: partial** — streams topic exists, thin coverage.

**From `ocapn-network-transport-separation.md` (OCapN refactor)**:

3. What fields does the current `op:start-session` handshake negotiate (in `packages/ocapn/src/client/handshake.js`), and what is each field for? **Predicted: strong** — `ocapn--implementation-guide--stage-0-foundation`.
4. How does CapTP handle crossed-hellos today, and where is that logic implemented? If handshake moves out of OCapN core into per-network code, where does crossed-hellos move with it? **Predicted: strong on what, weak on where the code actually lives**.
5. How is `OcapnLocation` serialized by Endo's Syrup codec today, and what are the wire-compat constraints when renaming a field (`transport` → `network`) across implementations? **Predicted: thin** — locators spec ingested but codec details aren't.
6. What is the current contract between a netlayer and the CapTP session machinery — what does a netlayer return at the connection boundary, and what does CapTP do with it next? **Predicted: partial** — covered abstractly, not at code level.

**From `trust-on-first-bind.md` (capability-policy pattern)**:

7. How does the Endo daemon persist policy / allowlist state today? Is there a standard durable-store pattern, or does each confined capability roll its own? **Predicted: library gap** — daemon barely covered as of round 1.
8. What's the canonical pattern in Endo for coalescing concurrent requests so that N simultaneous calls produce only one prompt to a higher authority? Is there a primitive in `@endo/promise-kit` or elsewhere? **Predicted: unlikely** — promise-kit covered but not this pattern.
9. What is the existing revocation primitive for capabilities in Endo? How would you "pin an allow decision into durable storage and later revoke it"? **Predicted: library gap** — no dedicated coverage.

**From `retention-path-notation.md` (daemon graph + CLI rendering)**:

10. How does the daemon's formula graph in `packages/daemon/src/graph.js` represent retention edges? What is the current shape of a retention-path segment? **Predicted: library gap as of round 1** (now covered, since the design itself was ingested cycle 42 — see "Notable" below).
11. What's the existing `reverseLookup` API in the daemon — what does it accept, what does it return, and how does it interact with nested directories and pet stores? **Predicted: library gap** (now partially covered via cycle 42's retention-path-notation ingest).
12. What's the Endo convention for designing a typed return value where rendering belongs to the consumer? (The design wants the daemon to return a typed `RetentionPath`, not a pre-rendered string — what pattern does this fit into?) **Predicted: partial** — exo + patterns covered, but not this design pattern explicitly. **Now partially covered via cycle 42's notes:.**

### Distribution by predicted strength

| Predicted | Count | Questions |
|---|---|---|
| Strong | 2 | Q1, Q3 |
| Partial / strong-on-what-weak-on-where | 4 | Q2, Q4, Q6, Q12 |
| Thin | 1 | Q5 |
| Library gap | 4 | Q7, Q9, Q10, Q11 |
| Unlikely | 1 | Q8 |

Roughly 4-5 likely-strong, 3-4 partial, and 4 likely-weak — exactly the harder test the methodology was designed to produce.

## Notable: cycles 39-43 changed the library's predicted coverage

Between the round-2 question drafting (during the same 2026-05-14 session) and the round-2 dispatch (still pending), the scholar's loop ingested the four source designs themselves into the library (cycles 39, 40, 41, 42, 43). This means **the round-2 test, when run, will give the library more credit than the round-2 design originally intended** — the design docs the questions derive from are now *in* the library.

Two responses to this:

1. **Treat the additional coverage as confounded** in the round-2 interpretation. The questions are still design-implementation-emergent, but the library now has the designs themselves; the test no longer isolates the library's pre-existing Endo coverage. Note explicitly in the round-2 result entry which questions the library now has direct coverage for via the new design-ingest sections.
2. **Round-3 alternative**: do another round of question derivation from designs the library does *not* yet have (the ~106 designs in the cycle-38 meta-catalog that haven't been individually primed). This regenerates the design-derived methodology without the same-cycle ingest confound.

Recommendation: run round 2 as proposed, note the confound, and decide whether round 3 is needed based on round-2's signal-to-noise.

## Estimated cost

Per round-1 measurements (~63K tokens per subagent for 12 questions), a round-2 subagent answering one question should consume ~5-10K tokens. 24 subagents × 5-10K tokens ≈ 120-240K tokens total, plus measurement overhead. Wall clock should be ~30-60s per subagent in parallel batches.

Round 1 cost: ~127K tokens combined, 138-159s wall clock.
Round 2 cost estimate: ~120-240K tokens combined, ~60-120s wall clock (assuming 12-wide parallelism per batch).

Net additional cost vs round 1: ~0-2× tokens, comparable wall clock.

## Status

- 12 questions drafted (above).
- Dispatch prompts not yet authored (template will follow round-1's, adapted for single-question fresh-context format).
- Ground-truth notes per question not yet written.
- 24-subagent dispatch awaiting maintainer confirmation.

## Self-improvement

- The methodology shift (design-derived questions, fresh contexts) is itself a useful pattern beyond library evaluation — anywhere we want to test "does the library actually help an implementer". Worth keeping as a recognized A/B-test shape if more rounds are run.
- Documenting questions-and-methodology *before* the dispatch (this entry) is the durable-record habit that round 1 missed. Future evaluation rounds should produce a "round N proposal" entry at draft time and a "round N report" entry at dispatch-completion time, paired.
