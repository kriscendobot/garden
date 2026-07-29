Landed on `main2` as `df33583e94`.

## What I did

Wired `annotate-plan.sh --key <directive-identity>` into the PR-comment-driven triage path, closing a silent-drop-plus-cursor-wedge on both producers.

**The defect.** A watcher-derived base is not comment-unique — the mechanical verbs key on `(PR,verb)`, a review on its review id — so several distinct comments legitimately fold onto one base. When that base sits **parked in `plan/`**, `post-job.sh`/`post-plan.sh` no-op on the basename (correctly: re-minting into `todo/` would run a job the proxy parked as blocked and let `promote-plan.sh` later clobber it). The follow-up comment then had nowhere to rest:
- **primary path** — `verify_posted` scans only `todo/doin/tada`, and `journal_identity_owner_live` misses because a *new* comment has no index entry, so the watcher read the deliberate no-op as a lost push and froze its cursor below that comment **permanently**, re-polling a directive that could never post;
- **retro path** — `mint_retro`'s re-post no-op'd and the new comment simply vanished from the prosecutor's brief.

**The fix.** Both paths now detect the parked base (`base_parked`) and append via `annotate-plan.sh`, `--key`ed on the **directive identity** the watcher already computes for cross-producer dedup (`<repo>#<pr>:comment:<id>`, or `…:review:<id>[:retro]`) — so a re-poll of the same comment is a deduped no-op success while a genuinely new comment appends once. An annotation counts as a recorded job for the ack-implies-a-posted-job invariant: 👀 plus a reply naming the parked base, cursor slides. Exit 3 (promoted out of `plan/` mid-write) is deliberately *not* swallowed with `--if-parked` on the primary — the cursor freezes so the next tick takes the ordinary live-job dedup path rather than dropping the annotation. The note carries only deterministic metadata (verb, surface, author, URL, identity), never an excerpt of the untrusted body.

**Scope note:** I also applied the identical branch to `mention-watcher.sh`. Its mechanical-verb base is keyed on `(repo,number,verb)`, it computes the *same* comment identity (that is how the two watchers already collapse onto one job), and it had the same phantom-lost-push freeze — the two are the whole of the comment-driven triage path, so leaving one would let the wedge reappear from the other producer.

## Files

`scripts/jobs/comment-watcher.sh`, `scripts/jobs/mention-watcher.sh`, their two test suites, `skills/job-board/SKILL.md`, `designs/job-board.md`, `designs/review-retrospective-loop.md`.

## Verification

- `comment-watcher-test.sh`: **275 passed, 3 failed** — new `PK`/`PK2`/`PK3`/`PKR` cases all pass (annotation lands keyed on the identity, `model:`/`role:` pins survive, no untrusted text in the plan file, no `POST LOST`, cursor advances, re-poll appends nothing, retro annotated rather than re-posted).
- `mention-watcher-test.sh`: **33 passed, 0 failed** (new `PK`/`PK2`).
- `annotate-plan-test.sh` 45/45; `tests/checks/run.sh` 7/7; shellcheck clean apart from the pre-existing `GARDEN_TAG` SC2034.

## Follow-up (pre-existing, not mine)

The 3 failures are case **H** ("missing jq → comment-source-gh.sh fails LOUD"). I reproduced them standalone against the **unmodified** handler at HEAD: the PATH mask no longer bites in this environment, so the handler returns rc 0 and emits 44 lines (it also makes a real GitHub call from a supposedly hermetic suite). Worth a separate job — either the shim escape gets closed or the case is retired.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-fu-endojs-endo-but-for-bots-pr124-feedback-triage-4-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 152 tokens (8752206 cached reads)
- Output: 49502 tokens
- Cost: $7.110335999999999
- Wall-clock: 1017s

<!-- garden-usage-end -->
