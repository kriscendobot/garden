Done. All work complete. Here is my completion report.

---

## Completion report — `comment-watcher-capture-full-review`

**SHA:** `a6ff8afb6f27084ccfa911e8f55ba69a1dd14ac3` on `origin/main2` (rebased onto the `$GARDEN_SCRATCH` commit `d6eb03aa` that landed mid-job).

**Built on:** `c81e3641` (the `reinforce-cw-maintainer-reviews` "inline-review is always actionable" base).

### What changed (2 files)

`scripts/jobs/comment-watcher.sh`
- **Restructured `classify()` so a review surface is handled as one unit.** Previously the `*"run the gauntlet"*` case (and the gated single-word verb table) returned a verb on *any* surface, so a review whose body said "Run the gauntlet once more" short-circuited to a `gauntlet` job and dropped everything else. Now, for `surface == pr-review-body`, if the review is from a **trusted sender** and actionable in *any* way — a named verb, an `@`-mention, `CHANGES_REQUESTED`, an `[INLINE-REVIEW]` marker, or an imperative body — it mints exactly **one** `review` job. A detected verb is recorded in a new `PRIMARY_VERB` and noted as the *primary action*, but it is one item in the bundle, never the whole job. Untrusted or non-actionable reviews are dropped (sender-trust gate preserved; no untrusted text feeds work). Non-review surfaces keep the original verb-table behavior unchanged.
- **`write_job_body()` review branch** now frames the WHOLE review as the unit: lists the review body, labels the primary verb, and instructs the gardener to enumerate **every** inline comment (`pull_request_review_id == REVIEW_ID`, each with file:line + text) *and* re-fetch the review body — all treated as untrusted DATA re-fetched at the source.
- Keyed per **review id** (`$slug-pr$pr-review-<shorthash cid>`), so a re-poll is idempotent — one job per review, not per comment.
- Header doc block updated to describe the whole-review bundling and cite the #528 regression.

`scripts/jobs/test/comment-watcher-test.sh`
- **Test R** (modeled on endo-but-for-bots #528): trusted review with a verb in the body → exactly one per-review `review` job, **no** verb-only `gauntlet` job; asserts the body frames the WHOLE review, notes the verb as PRIMARY, and instructs enumerating all inline comments; idempotent on re-poll.
- **Test S**: trusted `CHANGES_REQUESTED` review (no verb) → one bundle job that enumerates inline comments (not a verb-only/reader fallback).

### Verification
- `bash -n` clean; `shellcheck -x` clean (only a pre-existing SC2015 *info* on line 121, untouched).
- Full suite: **57 passed, 0 failed** (all prior A–Q tests still green; R/S new).

### Redeploy
- Pushed to `origin/main2`; fast-forwarded the shared `/home/kris` tree (clean, no conflicting WIP) so the deployed `scripts/jobs/comment-watcher.sh` now equals the fix. The `garden-comment-watcher@endojs-endo-but-for-bots.timer` is **active**; unit files unchanged, so the next tick runs the new code (no daemon-reload needed). Isolated worktree torn down; inbox empty.

### Bundling behavior, in one line
An actionable trusted-sender review now produces **one job per review id** enumerating the review body **plus every inline comment** as the asks; a mapped verb is the primary item among them, not the entire job — so multi-part reviews like #528 are fully handled, not half-handled.

**Follow-up (none blocking):** Test L's PASS message still reads "routed to the reader (triager fallback)" though that path now produces a deterministic review bundle instead — the assertion it guards (no bogus rebase job, exactly one job) remains correct; the message is cosmetically stale and could be reworded in a future touch.
