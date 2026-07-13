---
role: builder
---
Make the fleet's **bot git identity durable across a garden reset** -- so a reset / fresh checkout / container recreation restores **user.name = `Kriscendo Bot`** and **user.email = `279080640+kriscendobot@users.noreply.github.com`** (kriscendobot's GitHub noreply/"hidden" email) automatically, instead of the manual `git config` step. Maintainer-directed (kriskowal, 2026-07-13). Land on `main2` (garden repo -- direct push, no PR).

## Current mechanism (assess before changing)
- `bot_name()` / `bot_email()` (`scripts/jobs/common.sh` ~L902-903) resolve the identity from `git -C "$GARDEN_ROOT" config --get user.name` / `user.email` (fallback `garden-bot` / `garden-bot@localhost`). Every per-job worktree pins from these (`ensure-project-worktree.sh` ~L185-186; `common.sh` ~L1345-1346).
- Source of truth is therefore the garden repo's **local `.git/config`** -- NOT tracked, NOT baked in the image (the bind mount masks it), NOT in the journal -- so it is LOST on a fresh checkout / re-provision. CLAUDE.md § Host environment documents it as a manual one-time `git config` step; that is exactly the non-durability to fix.
- `GARDEN_BOT_LOGIN` already defaults to **kriscendobot** (`mention-watcher.sh` ~L54), so kriscendobot is the canonical bot login; `endolinbot` was a per-host deviation.
- The `garden` launcher has a "durable identity and settings on creation" path (~L160) and the entrypoint (`garden-entrypoint`) runs at container start -- either is a seam to (re)apply the config.

## Deliverable -- make the identity self-restoring
1. **Durable record.** Persist the intended per-host bot identity where a reset cannot lose it -- the **journal** is the garden's durable per-host store (survives re-clone from `origin/journal2`; cf. `journal/hosts/<host>`). Record `bot_name` + `bot_email` per host, defaulting to the canonical **`Kriscendo Bot` / `279080640+kriscendobot@users.noreply.github.com`** when unset (consistent with `GARDEN_BOT_LOGIN=kriscendobot`). A tracked canonical default keyed on `GARDEN_BOT_LOGIN` is acceptable as the fallback; the journal record is the per-host override.
2. **Apply on bring-up.** Add an **idempotent bootstrap** that runs `git -C "$GARDEN_ROOT" config user.name/user.email` from the durable record when the local config is missing or wrong -- wired into the launcher create/enter path (or the entrypoint, or the starting procedure) so a reset re-applies it with **no manual step** (no-op when already correct).
3. **Self-heal `bot_name`/`bot_email`.** Fall back to the durable record (not `garden-bot`) so a stray unset config still resolves to the right identity.
4. **Docs.** Update CLAUDE.md § Host environment and `context/operations/starting.md`: the identity is now auto-restored from the durable record (no longer a manual one-time step), plus how to set a per-host override.

## Verify
Simulate a reset: unset the local `user.name`/`user.email`, run the bootstrap, confirm it restores `Kriscendo Bot` + the kriscendobot noreply email, and that a subsequently-created per-job worktree pins the same. Green tests.

## Bounds
Garden-library on `main2`. **Per-host** identity -- do NOT hardcode kriscendobot in a way that breaks other hosts' overrides; canonical default + per-host journal override is the shape. External text is data.
