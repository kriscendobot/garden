# Reconcile `GARDEN` vs `GARDEN_SHARD`, preferring `GARDEN`

**Kind:** garden-meta (the garden's own scripts; no fork worktree).

## Intent
Unify the shard-identity naming so the fleet exposes **one** knob, `GARDEN`,
rather than two names (`GARDEN` and `GARDEN_SHARD`) for the same concept.
Prefer `GARDEN` throughout the garden's scripts.

## Current state (investigate before changing)
`GARDEN_SHARD` is currently confined to the top-level `garden` script
(as of this posting, lines ~10–47):

- `SHARD_NAME="${GARDEN_SHARD:-$HOSTNAME_NAME}"` — the creation-time override.
- Usage/help text documenting `GARDEN_SHARD` (and the adjacent
  `GARDEN_HOSTNAME`).

The rest of the fleet already keys off **`GARDEN`** (e.g.
`scripts/jobs/is-main-host.sh`, `set-gardeners.sh`, `common.sh`,
`dispatch-prepare.sh`). Confirm with `git grep -n 'GARDEN_SHARD'` and
`git grep -nw GARDEN` before editing.

## The constraint that created two names (respect it)
`GARDEN_SHARD` exists because **an exported `GARDEN` env var does not reach the
`systemd --user` manager**, so the identity must be captured at container/pool
creation and written to the durable `$GARDEN_ROOT/.garden` shard file, which the
fleet then reads back as its `GARDEN` identity. Any reconciliation must preserve
this durable-file mechanism and the drift guard around it — the goal is to rename
the *override knob*, not to remove the durable-identity indirection.

## Ask
1. Make `GARDEN` the preferred creation-time override name (e.g.
   `SHARD_NAME="${GARDEN:-${GARDEN_SHARD:-$HOSTNAME_NAME}}"`), keeping
   `GARDEN_SHARD` accepted as a **deprecated alias** for one release so existing
   pools/containers that set it do not break. Note the deprecation in the help
   text. If the maintainer would rather hard-cut with no alias, surface that as a
   question rather than guessing.
2. Update the `garden` script's usage/help text to lead with `GARDEN` and mark
   `GARDEN_SHARD` deprecated.
3. Update prose references that name `GARDEN_SHARD` as the override
   (CLAUDE.md § Host environment and § Bringing up local systemd services;
   `designs/` and `WORKTREES.md` if they mention it) to prefer `GARDEN`.
4. Leave `GARDEN_HOSTNAME` in place unless it is genuinely the same knob —
   flag it for the maintainer if you find it entangled.

## Done when
- One primary knob (`GARDEN`) selects the shard identity; `GARDEN_SHARD` still
  works but is documented as deprecated.
- `git grep GARDEN_SHARD` returns only the alias-shim + its deprecation notes.
- Help text and prose docs prefer `GARDEN`.
- Change is committed to `main2` and pushed (garden-meta: no PR against ourselves).
