Done. Phase 1 of the streamlined-onboarding build is complete and pushed to `main2`.

## Completion report

**Commit:** `8fdbd11e0` — pushed to `origin/main2` (rebase-CAS, landed first attempt).

**What I did** — implemented `designs/streamlined-onboarding.md` § 1.1–1.4 and § 6 phase 1 across exactly the three named files.

**`garden` script:**
- **`.garden`-first identity, zero required env vars.** Resolution is now explicit `GARDEN`/`GARDEN_SHARD` env → gitignored `.garden` file → default `garden`. The container name and `--hostname` both derive from the resolved shard identity, so `echo petunias > .garden` is a self-consistent naming knob (a bare re-`./garden` re-attaches to the same container without needing `GARDEN_CONTAINER`). `GARDEN=petunias ./garden` still works and writes the file; `GARDEN_CONTAINER`/`GARDEN_HOSTNAME` remain expert overrides.
- **Auto-build.** `ensure_container` builds the image when absent instead of erroring; `./garden build` stays for explicit rebuilds.
- **Guard-hook seed.** New `seed_claude_settings` writes `.claude/settings.json` host-side at container creation, only when absent, containing solely a SessionStart hook running `scripts/check-in-container.sh` (via `$CLAUDE_PROJECT_DIR`) — **no** permission `defaultMode`, per § 1.3.
- **Direct exec.** Bare enter execs `claude --dangerously-skip-permissions` as the foreground process via `bash -lc 'exec claude …'`; CMD stays systemd PID 1.
- **`./garden sh`.** New subcommand = yesterday's enter behavior verbatim (`/bin/bash -l`, no claude), the debug escape hatch. Factored the create/start/seed logic into a shared `ensure_container`.

**`Dockerfile`:** documented the PATH-wiring half of the direct-exec contract and added a build-time `command -v claude` assertion so a broken CLI install fails the build loudly rather than at first `./garden`.

**`CLAUDE.md § Container guard`:** one sentence recording that the launcher now seeds the SessionStart guard hook, so CLAUDE.md is no longer the sole propagating vehicle.

**What I verified (host-side, no live-fleet disruption):** `bash -n garden` passes; the seeded `settings.json` heredoc validates as JSON via `jq`; confirmed `scripts/jobs/common.sh` reads `.garden` with `head -1 | tr -d '[:space:]'`, byte-compatible with the launcher's `printf '%s\n'` write, and that the launcher seeds `.garden` at creation so the container-side identity default never diverges. Did not run `docker build`/`docker run` (would touch the live host).

**Follow-up / note for the deployer:** container name now derives from the shard identity. A pre-existing instance whose container was created under the old default name (`garden`) while its `.garden`/`GARDEN` holds a different shard will, on the next bare `./garden`, target a container named after the identity and thus create a fresh one. Recovery is trivial (set `GARDEN_CONTAINER` to the old name, or `./garden reset`), and this behavior is what § 1.1 specifies (deriving the name from identity is what makes `echo name > .garden` sufficient for multi-instance) — flagging it only so the deliberate, drained deploy is done with eyes open. Phases 2–4 (`context/` tree, vocabulary/tutorial wiring, README/CLAUDE.md slimming) are separate jobs.
