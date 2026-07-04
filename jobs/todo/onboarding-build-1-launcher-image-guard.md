<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-04T16:45:46Z -->

---
role: builder
model: opus
---

# Build (phase 1/4): launcher + image + guard hook

**GARDEN self-development.** Work in your per-job worktree off `origin/main2`; push **directly to `origin/main2`** (no PR, garden convention). Implement from the design **`designs/streamlined-onboarding.md`** — read § 1.1, § 1.2, § 1.3, § 1.4, and § 6 phase 1 in full; they are the spec. This phase is independent of the `context/` tree and is testable host-side without touching a live fleet.

> **Worktree caution (host endolinbot2):** the keeper's prune path has swept per-job `gardener-wt-*` git admin entries mid-job (fix `fix-journal-worktree-keeper-stale-registration` landed on main2 but may not be deployed to the running keeper yet). If your worktree's git admin entry vanishes, commit and push from a standalone scratch clone.

## Files (exactly two + one sentence)

- **`garden` script** (`cmd_enter` and a new subcommand), per § 1.1:
  - **`.garden`-first identity, zero required env vars:** bare `./garden` works with defaults; when `.garden` is present the shard identity, container name, and `--hostname` come from it (preferred: `echo petunias > .garden`). `GARDEN=petunias ./garden` stays supported as the belt-and-suspenders form (sets hostname **and** writes `.garden`). `GARDEN_CONTAINER`/`GARDEN_HOSTNAME` remain expert overrides.
  - **Auto-build:** if the image is missing, run `cmd_build` instead of erroring; `./garden build` stays for explicit rebuilds.
  - **Seed `.claude/settings.json` at container creation, only when absent**, host-side into the bind-mount root (the same move that already seeds `.garden`), containing a **SessionStart hook running `scripts/check-in-container.sh`** and nothing else (NOT a permission `defaultMode` — see § 1.3).
  - **Exec claude on bare enter:** `exec docker exec -it -u kris "$CONTAINER_NAME" /bin/bash -lc 'exec claude --dangerously-skip-permissions'` (auto mode via the launch flag, per § 1.3 — not via settings). CMD stays systemd PID 1 (§ 1.2).
  - **New `./garden sh` subcommand:** today's enter behavior verbatim (`/bin/bash -l`, no claude) — the debug escape hatch.
- **`Dockerfile`:** the image-side half of the direct-exec contract — the claude CLI install and the PATH wiring the exec relies on (today `/etc/profile.d/garden.sh`), adjusted so `exec claude` works on a bare `bash -lc`.
- **`CLAUDE.md § Container guard`:** add one sentence recording that the launcher now seeds the SessionStart hook, so CLAUDE.md is no longer the sole propagating vehicle for the guard (§ 1.1). Do not otherwise touch CLAUDE.md (later phases do).

## Definition of done

Bare `./garden` auto-builds if needed, enters, and execs `claude --dangerously-skip-permissions` as the foreground process; `./garden sh` opens a debug shell; identity resolves from `.garden` (and `GARDEN=… ./garden` writes it); `.claude/settings.json` is seeded with the guard hook when absent; the Container-guard sentence is added. Verify the launcher paths host-side (dry-run/read the code paths; do not disrupt the live fleet). Push to main2; report the commit sha and what you verified.
