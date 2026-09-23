Design delivered. Completion report:

---

**Job: CapTP error identification follow-up design to (merged) #58**

**What I did**
- Isolated project worktree off `llm` for `endojs/endo-but-for-bots`; did all work there (never the shared root).
- Read the full driving context: kriskowal's review 4612637233 (the six invariants, verbatim), the merged #58 mechanism (`marshal.js` error encode/decode, `marshalSaveError`/`marshalLoadError`, `trace-aggregator.js`), and the flagged `packages/daemon/src/unredacted-stack.js:53` (the `globalThis.getStackString` / `MAKE_CAUSAL_CONSOLE_…` SES-internal tap).
- Authored `designs/captp-error-identification.md` (327 lines, design-only).
- Opened **DRAFT** design PR **#595** (base `llm`, verified `isDraft: true`).
- Posted a follow-up comment on #58 (issuecomment-4862114579) linking #595, closing the loop on the review request.

**What the design says**
Each of the six hard invariants is specified with *how it's met* + *the OCapN/CapTP change required*: (1) hoist the error id out of the pass-style error body into a per-message `errorIds` frame side channel (parallel to `slots`), sender-namespaced — a negotiated wire-format change; (2) `(workerFormulaId, workerErrorId)` aggregator key, well-formed because worker↔daemon is one pairwise hop; (3) id off the object entirely (wire and heap) with the required test proving an application `errorId` data property is independent of the sender id; (4) closely-held `identifyError` backed by a receive-side WeakMap, replacing #58's `traces.lookup`; (5) send-side `sourceError→id` WeakMap for stable ids + by-copy decode for distinct identities; (6) identifiers session/sender-scoped, not multi-hop invariant. Also proposes an alternative to the `unredacted-stack.js` SES tap — capture unredacted rendering at the worker throw site via a *sanctioned* SES API (upstream endo dependency), tagging @erights on that section per his flag. Build-phase cleanups (`daemon-go-powers.js:176` dangle, typedefs → `.d.ts`) are noted as explicitly out of scope.

**Diagnosis note:** the #58 merged source (branch `feat/error-tracing-implementation`) is not yet present on the `llm` HEAD I checked out (68246ad92) — the trace files live only on that head branch and PRs #187/#171-era diagnostics on `llm`. I grounded the design against the actual merged blobs via `git show`, so this doesn't affect the design; but the `llm` base for the eventual build may need those files merged/rebased in first.

**Follow-ups**
- Build PR (separate) to implement, with the enumerated proof-obligation tests.
- Upstream endo/ses issue for the sanctioned unredacted-diagnostic API (gating dependency for the unredacted-stack alternative).
- Confirm the #58 error-tracing code is on `llm` before the build branches off it.

No upstream (`endojs/endo`) contact; all artifacts on the bot fork. No unverified claims made — this is a design deliverable, no execution to verify.
