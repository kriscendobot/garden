**Job `endojs-endo-but-for-bots-pr124-feedback-triage` (fixer): triage, reply, and report on all feedback for https://github.com/endojs/endo-but-for-bots/pull/124 — DONE.**

## What I did

Fetched and read all 33 inline comments plus both `CHANGES_REQUESTED` review bodies, treating every fetched body as data. Of the 33: **16 are kriskowal asks, 17 are prior kriscendobot replies**. Every one of the 16 already carried a reply; I verified each reply's claims against the job board and the repo rather than taking them at face value.

### Comment accounting (all 16 maintainer asks, none skipped)

**(a) Already addressed — 8.** Typist-hostile code points (skill `typist-friendly-code-points` + three juror seats + a `--fix`-capable pre-push probe, garden commit `79ae6035bf`, in `tada/`); the four "post a plan/job" asks (`ebfb-124-sqlite-iterate-streaming`, `-nongeneralised-design` (already completed), `-pragma-simple`, `-shutdown-checkpoint` — all present on the board); connection pooling agreed closed; move-to-draft (done, still draft); netstring-to-cbor-frame design (draft PR #711); `@ts-ignore` reverted to `@ts-expect-error` in `81c5fe88fe`.

**(b) Open, actionable without advancing the PR — 1.** `garden-style-url-not-path` has sat in `plan/` behind `gate: go-ahead` since 2026-07-09, so the `new URL` convention is still not in the style guide and the reviewer pool still does not flag `import path`. Its sibling from the same review landed. Surfaced, not silently left.

**(c) Deferred under the pause — 7.** Six code fix-ups (workflow rename, `on:` triggers, single bundle-builder command, two base64 type-specificity restorations, the `EXCLUDED_PACKAGES` filter question) plus the rebase half of the draft-and-trigger ask. All still bundled in `ebfb-124-resume-rebase-review-fixups`.

### Pause condition: NOT cleared (evidence, no unilateral lift)

- **Raw XS SQLite host bindings already existed before the review.** `rust/endo/xsnap/src/powers/sqlite.rs` (582 lines, 9 host functions, no `todo!`/`unimplemented!`, registered in `powers/mod.rs` + `lib.rs`, Rust unit tests present) landed on `endor` in `f5f0b1031` on **2026-05-02**, and is byte-identical on `endor`, `llm`, and `slot-machine`. So they cannot be what the 2026-07-09 pause was waiting on.
- **The durable-store layer on top is entirely unmerged**: #811 (draft), #819 (draft), #690 (draft), #825 (non-draft but based on the frozen `daemon-store-phase3-weak-ertp-74931b9`, not `llm`). On that reading the condition has not cleared.
- Disambiguation posed to the maintainer on the PR and via `message-user.sh`; **not decided by me**.

### CBOR share-utils verdict: satisfied — no follow-up posted

Design PR #710 (`designs/cbor-codec.md`), phase 1 `@endo/cbor` **merged 2026-07-28** (#755), ocapn adoption in flight. The remaining gap (`packages/slots/src/cbor.js`) is already tracked by `plan/endo-cbor-adopt-slots.md`, gated `blocked_on` #124 itself. Re-posting would duplicate, so I did not. I did flag the mutual-wait: that job waits on #124 and #124 is paused; its own escape hatch (adopt in flight) is the way out.

### New finding: rebase hazard

`llm` is **1390 commits ahead of `endor`**; `endor` frozen since 2026-07-06. `llm` grew a new persistence seam (`manager-database.js`, `manager-persistence-powers.js`, `bus-manager-rust-xs-powers.js`) that **keeps** `better-sqlite3-xs.js`, while #124 **renames** it to `rust-xs-sqlite.js`. Recorded on the parked resume job (journal commit `4f51aa554`) so the future doer does not rediscover it.

## What changed

Posted (standing authorization on this repo), no code pushed:
- Disposition comment: https://github.com/endojs/endo-but-for-bots/pull/124#issuecomment-5111817506
- Thread replies: [`r3670370016`](https://github.com/endojs/endo-but-for-bots/pull/124#discussion_r3670370016) (typist codepoints closed), [`r3670370094`](https://github.com/endojs/endo-but-for-bots/pull/124#discussion_r3670370094) (url-not-path still parked), [`r3670370164`](https://github.com/endojs/endo-but-for-bots/pull/124#discussion_r3670370164) (pause assessment)
- Journal `result` entry `entries/2026/07/29/014840Z-result-gardener-85428f.md`; triage note appended to `plan/ebfb-124-resume-rebase-review-fixups.md`; maintainer message `20260729T014905Z-e6bc8a`.

**Verified by execution:** `gh pr view 124` after all posting returns `draft=true head=1c63350189aca751727606726b1e7a39ce678cf7 base=endor state=OPEN` — identical to the pre-work head. Not rebased, not un-drafted, no CI driven, no review re-requested. House-style check (em-dashes, Latin shorthand, hard code points) ran clean on all five bodies before posting.

## Follow-ups

1. **Maintainer decision needed:** which sense of "sqlite bindings ready" gates #124. Nothing else blocks the resume trigger.
2. **Promote `garden-style-url-not-path`** (go-ahead gate, maintainer-only).
3. Scratch cleaned: project worktree and the temporary journal clone both removed.

Self-improvement: posted a `message` to liaison (`entries/2026/07/29/014935Z-message-gardener-edb59d.md`) — there is no sanctioned way to annotate a parked `plan/` job (`post-plan.sh` is idempotent-only), so I hand-rolled the CAS append. Suggested `scripts/jobs/annotate-plan.sh`; did not land it myself since this job's scope was triage, not tooling.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr124-feedback-triage.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 71 tokens (3764831 cached reads)
- Output: 37061 tokens
- Cost: $3.9486654999999997
- Wall-clock: 636s

<!-- garden-usage-end -->
