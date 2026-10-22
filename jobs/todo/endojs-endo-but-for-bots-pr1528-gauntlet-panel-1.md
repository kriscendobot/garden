---
role: gardener
arc: moonshots
handler-budget-role: panel
handler-timeout: 10800
gauntlet: endojs-endo-but-for-bots-pr1528-gauntlet
gauntlet_stage: panel
gauntlet_iteration: 1
pr: https://github.com/endojs/endo-but-for-bots/pull/1528
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #1528

You are ONE stage of a staged gauntlet (endojs-endo-but-for-bots-pr1528-gauntlet). Run the deterministic read-only
style pre-pass against the pinned base/head. Only if it passes, run EXACTLY ONE
panel round and post the verdict. Then STOP — do NOT fix, do NOT un-draft, do not
loop.

Garden script names below are repo-relative. Resolve them against THIS claiming
worker's `$GARDEN_ROOT` (known by `scripts/jobs/common.sh`), never against the
posting host's garden root.

1. Before dispatching any juror, retain the PR's immutable baseRefOid and
   headRefOid (both full 40-hex commit IDs), along with its head owner and branch.
   Get an ISOLATED project checkout of that head:
   `scripts/jobs/ensure-project-worktree.sh endojs-endo-but-for-bots-pr1528-gauntlet-panel-1 <pr-head-owner>/<repo-name> <pr-head-branch>`.
   Resolve all four retained fields with `gh pr view https://github.com/endojs/endo-but-for-bots/pull/1528 --json baseRefOid,headRefOid,headRepositoryOwner,headRefName`;
   do not pass the base repo when the PR head belongs to a fork.
   Fetch the retained objects if necessary, check out the retained head object ID
   detached, and verify git rev-parse HEAD equals it. A missing/malformed object ID
   or head mismatch is a sensor failure: do not run probes or panel; emit
   panel=panel-error.
2. Run the deterministic probes read-only against that exact pinned pair with
   `scripts/jobs/gardening/pre-push-gates.sh --no-auto-fix --probes-only \
     --base-ref <base-object-id> <worktree>`.
   Capture combined stdout/stderr byte-for-byte. On non-zero, do NOT
   run panel.sh and do NOT post a PR review. Put the exact captured output between
   these lines in the completion report, then emit panel=prepass-failed:

   <!-- gauntlet-style-prepass-output-begin -->
   <exact combined stdout/stderr, unchanged>
   <!-- gauntlet-style-prepass-output-end -->

   This is a deterministic finding, not a panel verdict. The driver routes that
   exact block to fix-1 and only spends juror seats after the probes pass.
3. Only after the probes exit 0, run the panel in SINGLE-ROUND mode against that
   same worktree and retained base object ID:
   `GARDEN_PANEL_SINGLE_ROUND=1 \
     scripts/jobs/gardening/panel.sh <worktree> 1528 <base-object-id>`
   It fans the seats, aggregates, preflights the PR author against the authenticated
   login, and posts its own formal review. A must-fix result normally requests
   changes; on a self-authored PR it posts the same aggregate as a comment review,
   retaining the `Must-fix before merge` heading. It does NOT fix or un-draft.
   Only after the review post succeeds does it print the existing stage-result
   marker followed by a terminal line whose last token is `pass` or `must-fix`.
   Copy that marker into your completion report; do not post the aggregate yourself.
4. If panel.sh exits NON-ZERO it did NOT return a posted review verdict. A seat error, a
   decider error, or a supervisor interruption is an INFRASTRUCTURE (sensor)
   failure, not a pass/must-fix decision. Do NOT report `orchestration-failed:
   true` (that halts the whole gauntlet on one transient blip). Complete NORMALLY
   and emit the `panel=panel-error` marker: the driver then re-posts this panel
   round under its bounded stage-retry budget, exactly as it retries a doomed
   transient stage. A genuine pass/must-fix verdict (panel.sh exit 0) always uses
   its own marker below — never panel-error.

Put EXACTLY ONE of these marker lines on its own line immediately BEFORE the
completion signal; the completion signal itself stays the very last line:
  <!-- gauntlet-stage-result: panel=pass -->         (panel.sh exit 0, disposition pass)
  <!-- gauntlet-stage-result: panel=must-fix -->     (panel.sh exit 0, disposition must-fix)
  <!-- gauntlet-stage-result: panel=prepass-failed --> (read-only deterministic probes failed; no juror dispatched)
  <!-- gauntlet-stage-result: panel=panel-error -->  (panel.sh non-zero: seat/decider error or interruption — a sensor failure, retried)
