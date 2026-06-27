# Rename the killswitch to a mundane "draining" marker (existence-meaningful + self-describing prose)

Map: **build** (garden infra) on the garden's own repo, branch main2. Build in an
ISOLATED worktree off origin/main2; commit explicit pathspecs (`git commit -m … --
<paths>`), push HEAD:main2 with a git-rebase CAS loop. Coordinate with the
deploy-sync reconciler so running services pick up the rename.

Maintainer directive 2026-06-27: rename the "killswitch" to something more mundane
like **"draining"**. It stays a FILE whose **existence is programmatically
meaningful** (present = this host's gardener fleet drains: workers finish in-flight
claims but take no new ones), but the file should now **contain a short prose
description of its meaning** so anyone who finds it understands what it does and
how to clear it.

## Current state
- `scripts/jobs/common.sh`: `: "${GARDEN_KILLSWITCH:=$GARDEN_STATE/NOPE}"` and
  `killswitch_engaged() { [ -e "$GARDEN_KILLSWITCH" ]; }`.
- Call sites: every long-running/loop service checks `killswitch_engaged` (bulletin,
  foreman, watchman, comment-watcher, deploy-sync, gardener loop, etc.). Enumerate
  them all (`grep -rn killswitch_engaged scripts/`).

## Scope
- Rename the marker to a mundane name (e.g. `$GARDEN_STATE/draining`) and the env
  var + predicate accordingly (e.g. `GARDEN_DRAINING_MARKER`, `fleet_draining()` or
  `draining_engaged()`). Keep one clear vocabulary; spell names out (no
  abbreviations) per the naming norm.
- **Self-describing content:** whenever the marker is CREATED (provide a small
  helper, e.g. `drain-fleet.sh on|off` / `start-draining.sh` + `stop-draining.sh`,
  or document the one-liner), write a short prose body into it explaining: what its
  presence means (fleet drains — finishing in-flight claims, taking no new ones),
  who set it and when, and that removing the file resumes the fleet. The predicate
  still keys on EXISTENCE only (content is for humans), so an empty file must still
  count as draining.
- **Backward compatibility / safe rollout:** during the transition honor BOTH the
  old `NOPE`/`GARDEN_KILLSWITCH` path and the new `draining` path in the predicate
  (presence of EITHER = draining), so a rename landing mid-flight cannot strand a
  host that already has the old marker set, and an operator using the old name still
  works. Note the old path as deprecated. Update any docs/skills/role files that
  mention the killswitch.
- Tests: extend run-test.sh — predicate true when the new marker exists (empty or
  with prose), true for the legacy marker (compat), false when neither; the
  create-helper writes prose and the predicate still keys on existence.

Deliverable: a mundane, self-describing "draining" marker replacing "killswitch"/
"NOPE", with all call sites + docs updated and legacy compatibility retained.
