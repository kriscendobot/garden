---
role: fixer
---
# Fix: gauntlet force-push can rewind a peer's newer commits (branch-rewind hazard)

Target: the garden repo itself (`main2`), `scripts/jobs/gardening/` (the gauntlet/panel/fix-loop
push path) and any other fleet code that force-pushes a PR head branch.

Evidence (endojs/endo-but-for-bots PR #792, 2026-07-18): the shepherd pushed CI fixes at 08:25Z
(head `6e9937cd66d`, green in run 29636715959). The gauntlet claimed at ~12:20Z, worked from a
worktree that predated those commits, and at 13:08Z finished with a plain forced update that rewound
the branch to `a510ee6` — a strict ANCESTOR of the shepherd's head — silently discarding the two fix
commits. CI went red (run 29645592685), the merge conductor declined, and the arc stalled until a
manual fast-forward restore.

Task:
1. Find every `git push --force`/`+refspec` in the fleet's job scripts that targets a project PR head.
2. Replace with `--force-with-lease` keyed to a FRESHLY-fetched remote head (fetch immediately before
   push; a lease against a stale ref is what makes the guard work — a plain --force-with-lease using a
   worktree's stale remote-tracking ref would still have rejected this push, but make the fetch+lease
   explicit so it cannot rot).
3. Where the push is not intended to rewrite history at all (the gauntlet's final push after a fix
   loop), add a cheaper invariant first: refuse to push if the outgoing head is BEHIND (ancestor of)
   the remote head, and instead rebase/restart onto the live head.
4. Add a hermetic regression test in the style of `auto-gauntlet-handoff-test.sh`.

Related, already landed: `fix-garden-auto-gauntlet-handoff-stall` (03833819f7) fixed the handoff
stall; this job fixes the rewind the handed-off gauntlet then inflicted.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: gardener
  claimed_at: 2026-07-18T18:39:38Z
