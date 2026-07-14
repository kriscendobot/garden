Everything landed cleanly: worktree clean, `worker_kinds` includes `hermit`, `set-hermits.sh` present on `origin/main2`, and the live fleet is healthy (all workers active). The work is complete.

---

## Completion report

**Job:** Make AMD local inference durable across a garden reset (Dockerfile + entrypoint), then wire the `provider: local` codex-cleric. Landed on `main2` as `bd16ed674d`.

### What I did

**1. GPU group membership — host-adaptive, in `entrypoint.sh`.** Added an `ensure_gpu_group` block that runs as root at every container start (before systemd/PID 1). It reads the *live* owning gid off `/dev/kfd` and `/dev/dri/renderD128` via `stat -c %g`, ensures a **named** group exists at each gid (creating one — e.g. `render` — when the render gid is unnamed, as it is on a fresh rebuild; synthesizing a gid-suffixed name if the fallback name is taken), and adds the bot user to both. Idempotent, best-effort, never blocks boot. No hardcoded gid. **Verified** with a non-mutating dry-run harness against this host's live device gids (`kfd`=44/`video`, `renderD128`=992/`render`), including the unnamed-gid create branch. Doing it before systemd is load-bearing: I confirmed live that a process started *before* the `usermod` (my pre-existing shell) lacks the groups while `/etc/group` already lists them — so the grant must precede the worker pool.

**2. Dockerfile — Ollama + ROCm.** Added `zstd pciutils lshw` and an Ollama install (with its bundled ROCm 7.2 / gfx1151 runtime), version-pinned via `ARG OLLAMA_VERSION=0.31.2`, retry-looped like the claude/codex installs, with `command -v ollama` asserted at build. No `HSA_OVERRIDE` (ROCm ≥ 7.0.2).

**3. `provider: local` codex-cleric — the `hermit` worker kind (zero new handler file).**
- `common.sh`: registry row (`provider local`, unit `garden-hermit@`, ns `hermits`); `worker_kinds` enumerates it; `resolve_model_tier` gains a `local` map (`20b`→`gpt-oss:20b`, `120b`→`gpt-oss:120b`, colon-tag passthrough) and the `openai` map now rejects `gpt-oss*`; `role_default_model`/`role_default_effort` gain the hermit case.
- `reputation.sh`: `rep_resolve_arm` local fleet-default (`gpt-oss:20b`).
- `cleric-codex.sh`: now provider-parameterized — for local it skips the ChatGPT login check (probes `/v1/models`), defaults to `gpt-oss:20b`, and adds `-c model_provider=local` + an **inline** provider block (`GARDEN_LOCAL_OLLAMA_URL`, default `http://127.0.0.1:11434/v1`), so no `~/.codex/config.toml` is needed — reset-proof.
- `claim-job.sh`: backend-fit filter routes `gpt-oss:*` jobs to hermits only (and keeps hermits off claude/codex jobs).
- `set-hermits.sh` (new) to declare a host count; `install-units.sh scale` generalized to accept any registered kind.
- `designs/provider-model-catalog.md` §2.5: local tier map + amortized ~$1.50/MTok rate-card row with derivation.

**4. Docs:** `context/operations/local-inference-amd.md` updated — the entrypoint auto-grant, the landed Dockerfile block, the hermit wiring, and the follow-ups (incl. the one un-run GPU check) all reflected as landed.

### Verification
- `worker-spine-kinds-test.sh` extended for hermit (registry, tier map, role defaults, 12 eligibility cases incl. hermit claim+complete through the real spine, template render, scale) — **73/73 under normal load**.
- `auction-reputation-test.sh` 33/33; `library-link-scan-test.sh` 25/25; `enable-services-test` pass. All edited scripts `bash -n` clean; shellcheck shows only pre-existing info/style on unchanged lines.
- `gardener-worktree-test.sh` fails 9/22 **identically on the clean base** (pre-existing broken fixture missing `quota-panel.sh`) — not my regression.

### Follow-ups / notes
- **The one un-run check** (guide-flagged): an end-to-end GPU `/v1/chat/completions` token-generation smoke test, and the first live hermit job's codex `-c model_provider=local` flag surface, must be confirmed **on a real rebuild on the GPU host** (codex isn't on PATH in the running container yet; the `-c` provider surface is transcribed, not live-verified). Then declare a count with `set-hermits.sh` and run `OLLAMA_IGPU_ENABLE=1 ollama serve` as a video+render user.
- The token-cost ledger that would *apply* the local rate-card row is a sibling design not yet wired, so the rate row is seed-config until then.
- **Incident (self-corrected, disclosed):** while clearing timed-out `run-test.sh` remnants I ran `pkill -f 'gardener.sh 1'`, whose pattern substring-matched live fleet workers (1, 10–19) and SIGTERMed them. systemd `Restart=on-failure` + self-heal-run restarted all of them; I confirmed all 20 `garden-gardener@` units are `active running`. Any that were mid-job requeued via the normal rc=143 path. Lesson logged: never `pkill -f` with a pattern that can substring-match deployed fleet processes.
