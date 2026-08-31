CI is green (rc 0). The fix stage is complete.

## Completion report

**Job:** Gauntlet FIX round 3 — endojs/endo-but-for-bots PR #1018 (`designs/ironhorse-panic.md`).

**What I did:** Read the latest panel verdict (round-3 request-changes review, kriscendobot review id 5064312092) and applied its must-fix / should-fix items to the design document, in one isolated project worktree of the PR head (`endojs/endo-but-for-bots@design/ironhorse-panic`).

**Changes applied (258 insertions, 43 deletions to `designs/ironhorse-panic.md`):**

- **critic #1** — Added a "Why revive a mechanism heavier than the one already rejected as too complex" paragraph, arguing the complexity (not just the coverage gap): the transcript is a recovery-mandated soundness prerequisite from which the embargo falls out for free, the rejected embargo had a cheaper substitute (admission control) for its whole scope while this has none, and the hot-path objection is retired by group commit.
- **critic #2** — Replaced the deferred cost paragraph with a stated order-of-magnitude estimate (~1 µs pipe write vs ~0.1–10 ms fsync = ~100–1000× on the durability step) and named the mitigation concretely (per-crank commit + group commit), leaving only tuning to benchmarking.
- **skeptic #1** — Added a per-termination-path embargo-coverage table and an explicit resolution that `MeterAbort` **is** included (the metering design's "tolerated leak" was an artifact of having no embargo; folding it in strengthens rather than contradicts that design).
- **skeptic #2** — Added a `## Verification` section: crash-injection matrix, replay==live metamorphic equivalence, idempotency, and per-row embargo-coverage assertions for the load-bearing crash-consistency invariant.
- **decomplector #1** — Marked `host_handle.open/closed` a query-only cache with the event log authoritative; no unsynchronized second write.
- **decomplector #2 / ergonomist #4** — Recorded the flat-vs-nested unification as an Alternatives entry; documented enforcement via `#[non_exhaustive]` + a lint.
- **ergonomist #1** — Established `panic-on-reference-error` as the canonical flag name at first use, reserving "the Coda" for framing.
- **ergonomist #2** — Decided the wire shape (distinct `<panic>` element, not a `reason="panic"` attribute), citing the same xsbug-parser reasoning used elsewhere.
- **ergonomist #3** — Clarified `is_panic()` as a pure function of `&self`.
- **copyeditor #1/#2** — Fixed the backwards topic sentence; converted the two imperative openings to third-person declarative.
- **pedant #1/#2/#3** — Normalized all `§` cross-references to verbatim heading text; fixed the truncated-quote reference; made the Scope-table lead words uniformly bold.
- **novice #1/#2/#3** — Added a "Status and vocabulary (read first)" note disclosing Ironhorse's non-production status and defining daemon/Endor up front; added a forward-reference for "commit path".
- Added an Open Question on SQLite-I/O-failure disposition inside transcript writes (critic's out-of-scope flag).

**Pushed:** one follow-up commit `875737517` to `endojs/design/ironhorse-panic` (advanced `87e0d79a1..875737517`).

**CI:** watched to terminal, bounded — GREEN (5/5 checks, 0 failed, rc 0).

**Follow-ups:** None for this stage. The driver re-posts panel-4; I did not re-run the panel per the stage contract.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1018-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 144 tokens (6357515 cached reads)
- Output: 34021 tokens
- Cost: $5.0907304999999985
- Wall-clock: 938s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
