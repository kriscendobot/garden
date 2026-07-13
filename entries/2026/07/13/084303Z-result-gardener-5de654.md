---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-13T08:43:05Z
---
# result: retro on endojs/endo-but-for-bots PR #169 review (prosecutor)

**Job:** `endojs-endo-but-for-bots-pr169-review-1aae27be-retro` — the second
(review-retrospective) loop over kriskowal's CHANGES_REQUESTED review
`#pullrequestreview-4682392602` on PR #169 (`design: pass-style promise`).

**Verdict: not-a-miss** (category `new-direction`). Recorded as a durable
dismissal:
`review-misses/dismissed/endojs-endo-but-for-bots-pr169-review-1aae27be.md`.

**Grounds (grounded in the PR's review history, not the comment alone):**
1. #169 is a **pure design-proposal document** (adds `designs/pass-style-promise.md`,
   touches `designs/README.md`; no code/tests/packaging). It ran **no code panel**
   and none was due — no `*-gauntlet*`/`*-panel*` job for #169 in `jobs/tada/`.
2. This review is the maintainer **closing the same open design questions** an
   earlier review (`4680376639`, already dismissed as the `-ce5f9073` retro) had
   floated. The body is a scope directive ("all questions are closed, integrate
   them and drain the open-questions section"); the six inline comments each
   **settle an open question the doc itself framed as open** — static-method
   settlement primitive, single shared `'promise'` tag, `PassablePromise` carrier
   name, the uneven default-flip policy, and a naming *leaning* toward `listen` over
   `subscribe`.
3. Every comment is the maintainer authoring an open design question — a
   taste/architecture call only the maintainer can settle (no prior-art convention
   named subscribe/listen/PassablePromise to be consistent with; these primitives
   are being *proposed* here). None is a bug, spec violation, style/convention
   breach, missed edge case, or violated standing instruction any seat, gate, or
   skill demonstrably knows. A design doc is the **input** to review; the primary
   tada applied the decisions as design content and replaced Open Questions with a
   Resolved Decisions ledger — it fixed no defect a review missed.

This is the second, terminal beat of the same design iteration whose first beat
(`-ce5f9073`) was already a textbook new-direction dismissal; nothing changed to
reclassify it.

**No cluster minted, no threshold evaluated, no improvement job dispatched** — a
dismissal is a single short pass by design (cost discipline). Severity-bypass
precondition absent (no standing rule bound and failed).

**Idempotency:** pre-checked; no `misses/` or `dismissed/` record existed. The
record was placed and CAS-pushed to `journal2` by `review-miss-record.sh`. Inbox
drained empty.

Self-improvement: nothing to change — the "design-doc-vs-code-PR" discriminator
and the "open-question-answered = the design-review loop working as intended"
heuristic fit this case cleanly and are already captured in the grounds for future
calibration.
