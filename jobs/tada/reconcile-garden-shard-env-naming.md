Inbox empty. The job is complete.

## Completion report

**What I did**

Reconciled the shard-identity override naming so the fleet exposes one preferred knob, `GARDEN`, while keeping `GARDEN_SHARD` working as a deprecated alias.

**Investigation first**
- `git grep GARDEN_SHARD` found it confined to two files: the top-level `garden` launcher and `README.md`. CLAUDE.md and `designs/`/`WORKTREES.md` had **no** `GARDEN_SHARD` references (CLAUDE.md already documents the runtime knob as `GARDEN`), so no prose edits were needed there.
- Confirmed via `scripts/jobs/common.sh` that `GARDEN` is already the canonical read knob (resolution: explicit `GARDEN` env → durable `$GARDEN_ROOT/.garden` file → `hostname -s`), and that the durable-file indirection is the mechanism working around "an exported `GARDEN` never reaches `systemd --user`." That mechanism and its drift guard were left untouched.

**Changes (committed to `main2` as `47e179e89`, pushed)**
- `garden` line 17: `SHARD_NAME="${GARDEN:-${GARDEN_SHARD:-$HOSTNAME_NAME}}"` — `GARDEN` is now the preferred creation-time override; `GARDEN_SHARD` is honored as a fallback alias; hostname remains the final default.
- `garden` help text: added a `GARDEN` entry as the primary override and demoted `GARDEN_SHARD` to a "Deprecated alias for GARDEN (honored for one release)" entry; updated the Notes line to say `GARDEN (or GARDEN_HOSTNAME)`.
- `README.md`: the "Pick a unique identity" section now seeds from `GARDEN` and notes `GARDEN_SHARD` remains a deprecated alias for one release.
- Verified `bash -n garden` passes and that `git grep GARDEN_SHARD` now returns only the alias shim + its deprecation notes (4 lines, all intentional).

**Decisions / notes**
- I honored the spec's default (soft-cut with a one-release alias) rather than pausing to ask about a hard-cut, since the spec authorized that path directly.
- `GARDEN_HOSTNAME` was left in place: it is a genuinely distinct knob (it sets the container's kernel `--hostname` via `--hostname "$HOSTNAME_NAME"` and merely serves as the *default* for the shard identity), not another name for the same concept. No entanglement to flag.

**Follow-ups**
- In a future release, drop the `GARDEN_SHARD` alias branch and its deprecation notes once existing pools/containers have migrated.
