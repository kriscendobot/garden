# Fix: v1 `dispatch-prepare.sh` references the retired `journal` branch (broken under v2)

`skills/dispatch-worktree/dispatch-prepare.sh:85` hardcodes:

```sh
git -C "$GARDEN_ROOT" worktree add --detach "$ROOT/journal" journal
```

Under the v2 job system the journal branch is **`journal2`** (the garden
repo has `journal2` and `journal-v1`, but **no `journal` branch**). Every
dispatch through this v1 path now dies with:

```
fatal: invalid reference: journal
```

Observed 2026-06-28 by a gardener (host endolinbot) trying to dispatch a
designer via `dispatch-prepare.sh designer ... endojs/endo-but-for-bots
<branch>`: the `garden/` worktree is created, then the `journal/` step
aborts, leaving an orphaned `dispatches/<role>--<id>/` containing only
`garden/`. Two such orphans were already present
(`dispatches/designer--23837a`, `dispatches/designer--93154f`), suggesting
this is recurring. The teardown's cleanup (`dispatch-teardown.sh`) is never
reached because the orchestrator never gets a DISPATCH_ROOT back.

## Decide the right resolution (judgment call — do not blind-edit)

This is a doc/script divergence between v1 dispatch tooling and the v2 job
board. Pick one, with rationale, rather than mechanically swapping the
literal:

1. **Repoint to `journal2`** — change line 85 (and the line-15 doc comment)
   to the live branch. Simplest if the Agent-tool dispatch triple is still a
   sanctioned path in v2 (the `gardener`/`liaison` role files still list the
   `dispatch-worktree` skill).
2. **Make the journal branch configurable** — read it from a single source
   (env/config) so a future rename doesn't re-break this.
3. **Retire the v1 dispatch-prepare path** — if per-subagent worktrees off
   `origin/main2` + the gardener fleet fully supersede the liaison/steward
   Agent-tool triple, delete or quarantine the skill and update the role
   skill lists that still reference it.

Whichever is chosen: also sweep `dispatches/` for orphaned half-built
triples (dirs containing only `garden/`, no `journal/`/`project/`) and prune
their worktree registrations (`git -C worktrees/<...>.git worktree prune`
and the garden admin tree's registration for the stray `garden/` worktrees).

## Build discipline

Garden-infra change: develop in an isolated worktree off `origin/main2`
(`roles/COMMON.md` § Per-subagent worktrees), commit explicit pathspecs,
push `HEAD:main2`. Do not edit the deployed root checkout.

---
claim:
  host: endolinbot
  gardener: 44
  claimed_at: 2026-06-28T06:41:03Z
