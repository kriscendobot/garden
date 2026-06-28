# revise the garden's standing scope instructions: agoric-sdk fork is now in scope

Map: **garden-infra** → revise the encoded "agoric-sdk off-limits" rule across the
garden repo to match the maintainer's 2026-06-28 revision. Build in an **isolated
worktree off `origin/main2`** (never edit the deployed root tree); commit explicit
pathspecs; push `HEAD:main2`.

## Authorization
kriskowal, on kriskowal/garden#9 (2026-06-28, comments 4825117452 + 4825122191):
> "Please revise your standing instructions to reflect this. You are free to experiment
> with agoric/agoric-sdk using the kriscendobot/agoric-sdk fork and simply must avoid
> linking issues or pull requests to agoric/agoric-sdk or otherwise commenting upstream."
> "Agoric SDK is equally germane to the garden as Endo."

## The revision
The OLD rule ("agoric-sdk is entirely off-limits / we must not and cannot do anything
for agoric-sdk") is **superseded**. New rule:
- **Authorized:** experimentation on the **`kriscendobot/agoric-sdk` fork** — builds,
  XS toolchain work, source reads, DRAFT PRs with base+head both on the fork.
- **Hard line (unchanged in spirit, now the only line):** never open or **link** an
  issue/PR against **upstream `agoric/agoric-sdk`**, and never comment upstream. Keep
  every artifact fork-internal. (This is consistent with the existing
  roles/COMMON.md:70 "must not initiate on issues/PRs in any repository" rule — that
  stays.)
- Treat agoric-sdk (via the fork) as **germane to the garden, equal to Endo**.

## Sites to revise (grep found these; sweep for more)
- `CLAUDE.md:141` — "...does **not** authorize any work on agoric-sdk, which stays
  off-limits." → reword: read-only sender-trust check still does not by itself
  authorize work, but fork experimentation on `kriscendobot/agoric-sdk` IS now
  generally authorized; only upstream agoric/agoric-sdk stays off (no links/comments).
- `roles/COMMON.md`, `roles/boatman/AGENT.md`, `roles/triager/AGENT.md`,
  `roles/proxy/AGENT.md`, `roles/designer/AGENT.md`, `roles/botanist/AGENT.md` — revise
  any "agoric-sdk off-limits / cannot act on agoric-sdk" wording to the fork-authorized /
  upstream-only-off form. Preserve every "no upstream issue/PR/comment" constraint.
- Re-grep `-rniE 'agoric-sdk.*(off.limit|exclud|cannot|must not)'` after editing to
  confirm no stale "entirely off-limits" assertion remains.

## Out of scope for this job
Do not change the monitoring-safety constraint's repo-gating logic itself (the set of
repos whose untrusted *text* may enter context is a separate decision) — only correct
the claim that agoric-sdk *work* is categorically forbidden.

## Report
Open a DRAFT PR or push to main2 per garden convention (garden's own repo pushes main2
directly; no PR gauntlet against itself). Report the commit/PR on this job; a follow-up
comment on garden#9 is optional.
