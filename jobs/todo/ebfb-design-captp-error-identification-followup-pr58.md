# Design: CapTP error identification follow-up to (merged) #58 — maintainer invariants
Repo: endojs/endo-but-for-bots (bot; DRAFT DESIGN PR, base `llm`). #58 (error tracing across CapTP workers)
is MERGED; kriskowal (review 4612637233, 2026-07-02) asks: **"post a design for a follow-up… we need the
same functionality and may need to improve OCapN and CapTP to support certain invariants."** This is a
DESIGN-phase deliverable (separate design/build PRs).
Author `designs/captp-error-identification.md` (or similar) capturing these **hard invariants** (verbatim
intent; the design must specify how each is met + name the OCapN/CapTP changes required):
1. The **error ID is communicated IN-BAND on the wire**, assigned in a **namespace dictated by the SENDER**.
2. For the aggregator, an error is identified by the **(worker formula identifier, worker-assigned error
   identifier)** pair.
3. The error ID **must NOT be on the pass-style error object** — not on the heap, not on the wire. It **must
   be possible (and proven with tests)** that an error carries an `errorId` **data property that is unrelated
   and different** from the sender-assigned error identifier.
4. A CapTP client's holder of a closely-held server object identifies an error via a **closely-held method
   (e.g. `identifyError`)**, with the identifier in a **side table (WeakMap)**, not a property of the error.
5. An error **sent twice through the same CapTP arrives with the SAME identifier but DIFFERENT JS object
   identities** (neither `===` nor `Object.is`).
6. **Error identification is pairwise-pass-invariant; error IDENTITY is not.** Identification is **not**
   pass-invariant across multiple CapTP hops; identity is **scoped to the sender**.
Also fold in the inline concern `packages/daemon/src/unredacted-stack.js:53` — kriskowal flagged @erights
"this should not be, we need an alternative": the design must **propose an alternative to the current
unredacted-stack approach**. Note (for the eventual BUILD phase, not this design) the trivial cleanups:
the unnecessary dangle at `daemon-go-powers.js:176`, and typedefs → `.d.ts`. erights is a maintainer +
tagged — address his concern. Open the DRAFT design PR; design-only, no impl. Bot fork; no upstream contact.
