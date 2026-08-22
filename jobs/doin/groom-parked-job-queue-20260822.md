---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Groom the job board's parked-job queue: prune confirmed-moot entries

Repository: this repo (garden). Garden-infra work -- edit and push directly
to `main2`/`journal2` as appropriate, no PR (CLAUDE.md § Conventions).

## Why

A 2026-08-22 classification pass across `journal/jobs/plan/` (290 files)
found roughly 85-95 entries whose target already resolved -- merged, closed,
or answered through a different job -- leaving stuck/doomed stub jobs
sitting inert for no purpose. This job prunes them so the plan queue
reflects reality. This is board hygiene, not roadmap work: do not resume,
re-scope, or otherwise act on the underlying PRs/issues here, only remove
the dead entries.

**Re-derive current state yourself -- do not trust the facts below as
current** (this classification is already ~an hour old and the board
moves). For every candidate, confirm the resolution before removing it.

## Read first

- Check whether a cancel/withdraw/prune script already exists for
  `jobs/plan/` entries (`ls scripts/jobs/ | grep -iE
  "cancel|withdraw|prune|remove-plan|drop-plan"` -- came back empty in the
  survey that found this, but re-check; naming may differ). If one exists,
  use it. If not, this job should add a small, properly-documented one
  (`scripts/jobs/withdraw-plan.sh <base> <reason>` or similar, following
  the shape of the existing `post-plan.sh`/`promote-plan.sh` CAS-push
  pattern) rather than hand-`git rm`-ing files with no durable record of
  why -- board state should stay auditable the same way every other
  job-board mutation is.
- `skills/job-board/SKILL.md` for the CAS-push conventions every other
  board mutation follows.

## Candidates to verify and prune

**PR endojs/endo-but-for-bots#475 (58 total parked, 54 confirmed moot as of
this survey)** -- the exact basenames, verbatim from the survey (re-verify
each against the live PR/thread before removing, per the instruction
above -- do not batch-trust this list):

pr475-2cf2d662-retro, pr475-495be080-retro, pr475-54294cd3,
pr475-54294cd3-retro, pr475-6bff44d0-retro, pr475-6c19a076-retro,
pr475-9885f3d8-retro, pr475-9fe4e7c7-retro, pr475-c4ef0155-retro,
pr475-d34b881a-retro, pr475-e3925eb5-retro, pr475-e8792d98,
pr475-e8792d98-retro, pr475-fa8acb7f-retro, pr475-review-07347c0d,
pr475-review-07347c0d-retro, pr475-review-1011c1c5-retro,
pr475-review-13c49ed1-retro, pr475-review-1c227402,
pr475-review-1c227402-retro, pr475-review-1c83e1bb,
pr475-review-1c83e1bb-retro, pr475-review-237b89d7-retro,
pr475-review-2c700561-retro, pr475-review-2ea278c9-retro,
pr475-review-2f4785d0-retro, pr475-review-41c12eb0-retro,
pr475-review-489e73fc-retro, pr475-review-538450f1-retro,
pr475-review-5453eefb-retro, pr475-review-54cdd039-retro,
pr475-review-5aae699b-retro, pr475-review-5b54f00b-retro,
pr475-review-605988a6-retro, pr475-review-60fc33cf-retro,
pr475-review-662af34e-retro, pr475-review-69a8dffc-retro,
pr475-review-6c57250a-retro, pr475-review-79645bf9-retro,
pr475-review-90ef14d6-retro, pr475-review-92a260ae,
pr475-review-92a260ae-retro, pr475-review-b3132dc6-retro,
pr475-review-b4dd5851-retro, pr475-review-b865f40a-retro,
pr475-review-c85b88c9, pr475-review-c85b88c9-retro,
pr475-review-cb751bbb-retro, pr475-review-e560d700-retro,
pr475-review-f1438d1b-retro, pr475-review-f1df1c4f,
pr475-review-f1df1c4f-retro, pr475-review-f55c1aef-retro,
pr475-review-f66ed689-retro

(all under the `endojs-endo-but-for-bots-` prefix as they appear on the
board). Note: many of these are `*-retro` review-retrospective jobs -- if
this session's earlier "ready-now bucket" promotion already ran them to
completion (check `jobs/tada/` first), they are simply gone from `plan/`
already and there's nothing to prune; don't error on a missing file, treat
it as already-resolved.

Also **one unrelated stale stub caught by the same grep**:
`registry-immutable-byte-array-followup-gauntlet-panel-1` -- targets PR
endojs/endo-but-for-bots#888, doomed since 2026-08-01, not part of the
#475 cluster. Verify #888's current state before pruning.

**Resolved by PR-level facts (re-derive exact current basenames yourself --
these are the facts, not a filename list):**
- endojs/endo-but-for-bots#403 MERGED 08-17, #286 CLOSED, #719 CLOSED,
  #856 MERGED 08-16, #882 MERGED 08-01, #980 MERGED 08-19, #987 MERGED
  08-20, #993 CLOSED, #995 MERGED 08-17, #998 MERGED 08-18 (the review
  directive is moot; its 8 `-retro` siblings are NOT moot, they audit
  process independent of PR state -- do not prune those), #1006 MERGED
  08-20, #1026 MERGED 08-18 (3 attention-directive jobs, all re: the same
  known `@endo/cli` teardown flake).
- endojs/endo-but-for-bots#910 MERGED 08-20: the `pr910-review-4941452327-*`
  orchestration's shepherd/fuzz-build/conductor children are moot IF they
  are still sitting in `plan/` at all (this session already manually
  promoted and completed several of them earlier on 2026-08-19/20 -- check
  `jobs/tada/` before assuming anything remains). Exception: **do not
  touch** `pr910-review-4941452327-base64-cleanup` -- it is a durable
  follow-up genuinely blocked on PR #475, not moot.
- kriscendobot/minion.town: #20 MERGED, #21 CLOSED, #36 CLOSED, #39
  MERGED, #47 MERGED, #48 CLOSED -- any parked job whose sole purpose was
  advancing one of these to that exact resolution is moot. Do not touch
  anything referencing #37 (still open, live) or #17/#29/#32/#33/#45
  (still open, unresolved).
- kriscendobot/agoric-sdk#15: CI already fully green; `kriscendobot-agoric-sdk-pr15-shepherd`
  is moot (nothing to shepherd).
- kriscendobot/list#1: CLOSED per direct maintainer order;
  `kriscendobot-list-pr1-1238bca7` was already promoted and should be gone
  from `plan/`; if a duplicate/sibling stub remains, it's moot too.
- `proposal-compartments-xs-source-phase-design`: explicitly annotated by
  its own sibling job as superseded -- prune per its own in-file note.
- `finbot-pr5-panel-20260727`: explicitly annotated "do NOT revive" by its
  own successor job -- prune per its own in-file note.
- `genie-docs-02-delete-from-llm`: annotated SUPERSEDED by
  `genie-docs-r2-02-delete-from-llm`; verify whether the r2 chain's actual
  precondition (the r2-01 migration landing) is now met before deciding
  prune-vs-repost -- this one may need a fresh delete-stage job posted
  rather than a bare prune, per the earlier survey's finding that the
  precondition looks satisfied now. Use judgment; note your call in the
  report either way.

## What NOT to touch

Anything gated `orchestrated` under a still-meaningful halted campaign
(gateway-phase-restack-chain, endor-fixture-parity-ratchet-campaign,
garden-tada-shard-orchestration, the Ironhorse js-26/intl children, the
`pr910-review-4941452327-base64-cleanup` exception above) -- these are
paused work awaiting an explicit resume decision, not dead weight. Anything
`gate: deferred` whose target is still open and unresolved. Anything you
cannot positively confirm is moot -- when in doubt, leave it parked and
name the uncertainty in your report rather than guessing.

## Deliverable

A completion report naming exactly what was pruned (and via what mechanism
-- the new/found script, or a justified `git rm` with a clear commit
message either way), what was left alone and why (uncertain cases), and
the plan-queue file count before/after.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-22T07:15:14Z
