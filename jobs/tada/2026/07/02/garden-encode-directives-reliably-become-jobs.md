Pushed to `origin/main2` on the first attempt (no contention). Work is complete.

## Completion report

**Job:** Widen the comment-watcher so every clear actionable maintainer directive reliably becomes a JOB (the "action floor"), not just a reply.

**What I found:** The sibling reply-floor work had already landed, and a prior widening routed *any* trusted no-verb comment to a deterministic `attention` job. The remaining gaps in the verb-gate (`scripts/jobs/comment-watcher.sh`) were:
- A **bare imperative verb** ("Shepherd.", "Conduct #57") never fired the verb table — the scan was gated on an explicit "please"/@-mention, so a bare directive fell back to a generic attention job (or dropped on a review surface).
- **conduct/merge** weren't recognized at all.
- A **multi-part direction** (#442 "refactor accordingly. But first, rebase.") was reduced to its first matched verb (rebase), silently dropping the refactor.

**What I changed (`comment-watcher.sh`):**
1. Added an `imperative_verb_present` detector + a shared action-verb vocabulary. `reads_as_directive` now recognizes a **clause-initial** imperative verb with no "please" needed — while preserving the #513/#526 verb-as-subject-matter guard (a verb used as a noun/future intention, e.g. "a subsequent rebase … will", stays inert because it isn't in imperative position).
2. Added **conduct/merge → the finalization (conductor) path**, but **trust-gated** — an autonomous merge is high-consequence, unlike the low-risk mechanical branch ops which stay trust-independent. An untrusted "please merge" is dropped, not merged.
3. Added a **multi-part counter**: 2+ distinct action verbs in imperative position from a trusted sender / @-mention route the **whole** comment to one `attention` (triage) job, so nothing is lost to single-verb reduction.

**Tests added (`scripts/jobs/test/comment-watcher-test.sh`):** MP1 (#442 multi-part → one attention job, not rebase-only, + re-poll idempotency), MP2 (bare "Shepherd." → shepherd job), MP3 (#513 noun/future-tense false-positive guard holds), CN1 (trusted "conduct" → conductor job), CN2 (untrusted merge → trust-gated drop, security), SQ1 (#58 status question → attention job, not a bare 👀), SELF1 (bot self-comment mints nothing).

**Verification:** Baseline was 157/157. Final suite is **182 passed, 0 failed**; both files pass `bash -n`. All jobs remain deterministic and idempotent by comment-id.

**Landed:** commit `13a61bc80` on `origin/main2`.

**Follow-ups:** None required. Note that an `[APPROVED]` review that also names "merge"/"conduct" now routes to the asks-first `review` path (finalize deferred to that handler) rather than clean finalize — correct behavior, no test regression, just recorded here for awareness.
