<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-28T08:40:03Z -->

scripts/jobs/reaper.sh

# Free the 52 claims stranded on ps23

Recovery half of the **ps23 outage** (orchestration `fix-ps23-claude-path-outage`).
Runs **after** the guard child `guard-worker-self-disqualify-missing-agent-bin` has
landed — otherwise ps23's eight fast-failing gardeners simply re-win the requeued
jobs and re-strand them. **Do not start this before confirming the guard is
deployed** (see § Precondition).

## State to recover

As of 2026-07-28T06:30Z **every one of the 52 entries in `jobs/doin/` is claimed by
ps23**, a host whose every handler invocation fails with `FATAL: claude not on
PATH`. The board's entire in-flight set is frozen on a host that cannot advance it.

Stranded work includes (not exhaustive): `improve-gardener-claude-bin-resolution`
(the fix for this very outage — **free this one first**),
`consolidate-maintainer-inbox-20260727`, `arc-status-daily-20260728-033502`,
`suffix-github-comments-with-provenance`, `design-sysop-host-operations-daemon`,
`garden-repo-transfer-followthrough`, `xs2rust-endor-s1-daemon-integration`,
several `deadmail-issue-comment-*`, and a large block of
`endojs-endo-but-for-bots-pr*-dependabot` jobs.

## Precondition

Confirm the guard is actually live before requeuing:

- the guard change is on `main2` **and deployed** to the hosts that will pick up
  the freed work, and
- ps23 is no longer winning claims — check for `claim(...) ps23/...` entries in the
  journal log after the guard's deploy timestamp. If ps23 is still claiming, **stop
  and report**; requeuing into an unguarded fleet re-strands everything and burns a
  requeue cycle on 52 jobs, pushing them toward poison.

## Procedure

1. **Requeue the stranded claims.** Prefer the existing machinery over hand-editing
   the board: `scripts/jobs/reaper.sh` requeues stale `doin/` claims to `todo/`,
   clears the `work/<base>` record and orphaned worktree, and — crucially —
   **preserves the basename**, so the re-claiming gardener derives the same
   deterministic session id and `--resume`s the interrupted transcript
   (`handlers/gardener-claude.sh` § session continuity). See
   `skills/restore/SKILL.md` § step 2, which is exactly this operation.
   The default `GARDEN_CLAIM_TTL` is 14400s (4h); some of these claims are younger
   than that, so a plain reaper tick will not take them all. Use the TTL knob or the
   reaper's targeted path rather than inventing a new requeue mechanism.
2. **Preserve session continuity.** Do not rename, re-mint, or re-post these jobs
   as fresh basenames — that discards the interrupted transcripts and duplicates
   work the board already tracks.
3. **Watch the requeue cycle counts.** These jobs have been failing and requeuing
   for hours; some are near `GARDEN_REAP_POISON_THRESHOLD`. Any that have already
   poisoned into `plan/` with `poisoned: true` need un-poisoning rather than
   requeuing — their failures were environmental (a broken host), **not** defects in
   the jobs themselves. Clear the poison markers for those and return them to the
   board, noting each one in the report.
4. **Re-check the dependabot block.** The `endojs-endo-but-for-bots-pr*-dependabot`
   jobs may be stale by the time they run (the PRs may have moved, merged, or
   closed). Requeue them, but flag in the report that a botanist re-check may be
   cheaper than resuming a hours-old transcript.

## Definition of done

- `jobs/doin/` no longer holds claims by ps23; the freed work is in `todo/` (or
  legitimately re-claimed and progressing on a healthy host).
- `improve-gardener-claude-bin-resolution` specifically is free and claimable.
- Environmentally-poisoned jobs are un-poisoned and back on the board, each named.
- `tada` report gives the count freed, the count un-poisoned, and any job
  deliberately left alone with the reason.

<!-- garden-reaped: 1 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: gardener
  claimed_at: 2026-07-28T12:43:32Z
