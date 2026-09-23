The work is complete. Inbox is empty. Here is my completion report.

---

## Completion report: `improve-project-worktree-dep-cache`

**What I did.** Moved dependency provisioning off the agent and into `scripts/jobs/ensure-project-worktree.sh`, so native modules (better-sqlite3) are built **once per lockfile per host** in a controlled place and reused across every fresh per-job worktree, instead of being re-run and re-failed ad-hoc by each gardener.

**What changed** (committed `2cf29eae82`, pushed to `origin/main2`):

- **`scripts/jobs/ensure-project-worktree.sh`** — after a *fresh* worktree checkout (never on resume-reuse), a new `provision_deps` populates `node_modules` from a warm shared cache:
  - Cache keyed by `<owner>-<repo>/<lockfile-hash>` under `$GARDEN_STATE/dep-cache` (per-host, persistent, same filesystem as the worktrees so the hardlink is a genuine same-fs `cp -al`). Content-addressing means a lockfile change is a new key → automatic rebuild ("refresh when the lockfile changes").
  - **Cold miss:** runs the project's real installer once (yarn/pnpm/npm auto-detected; native builds included; `TMPDIR` pointed off noexec `/tmp`), then snapshots every `node_modules` tree (root + each workspace package) into the cache and marks it `.complete`.
  - **Warm hit:** hardlink-copies (`cp -al`, the pnpm-linker pattern; EXDEV→plain copy) each cached tree in, sharing the compiled `.node` inodes rather than recompiling.
  - **Concurrency:** a per-repo `flock` serializes concurrent first-jobs (one builds, the rest hit warm).
  - **Deterministic signal** to stderr: `WARM-CACHE hit` / `built` / `MISS+FAIL` / `dep-cache skip`, so a broken toolchain surfaces as a script line, not a buried agent note. A failing install caches **nothing** and names the container-image fallback (build-essential + python) that a warm cache cannot substitute for.
  - **Best-effort & failure-tolerant:** provisioning never blocks the worktree handoff; stdout stays the single worktree-path line. Resume-reuse skips provisioning entirely (resume stability preserved).
- **`scripts/jobs/test/project-worktree-isolation-test.sh`** — fixed a pre-existing baseline breakage (harness copied `common.sh`+`usage-meter.sh` but not `quota-panel.sh`, which `common.sh` now sources, so every helper call died) and added warm-cache coverage: cold build, warm hit, **shared-inode hardlink** assertion, resume-skip, install-failure `MISS+FAIL` signal, and lockfile-less no-op. **27/27 pass**; `bash -n` + `shellcheck` clean.
- **`roles/gardener/AGENT.md`** — documented that the helper now auto-provisions deps (don't reflexively re-install; read the `WARM-CACHE` signal; a native build failing on every host is a container-image gap to flag).

**Verification.** Ran the isolation test hermetically (throwaway forks, stubbed installer): the hardlink-shared-inode assertion passes, and the failure path emits `WARM-CACHE MISS+FAIL` and leaves no `.complete` marker. The native compile itself was not exercised end-to-end here (no real toolchain in this run) — by design, the script attempts the real install where the toolchain is present and flags the toolchain gap otherwise.

**Course-correction note.** I initially edited files in the deployed garden root by mistake; I transplanted the changes into this job's worktree and restored the root to its committed baseline (verified clean) before committing.

**Follow-ups.**
- The cache is per-host; each host pays one cold build per lockfile. If `WARM-CACHE MISS+FAIL` recurs on *every* host for a repo, the implicated fix is the **container image/entrypoint** gaining build-essential + python — a separate change this script deliberately does not paper over (it flags it).
- Env knobs added for tuning if needed: `GARDEN_SKIP_DEP_PROVISION`, `GARDEN_DEP_INSTALL_CMD`, `GARDEN_DEP_INSTALL_TIMEOUT` (900s), `GARDEN_DEP_LOCK_WAIT` (600s), `GARDEN_DEP_CACHE_TTL_DAYS` (14), `GARDEN_DEP_CACHE_ROOT`.
