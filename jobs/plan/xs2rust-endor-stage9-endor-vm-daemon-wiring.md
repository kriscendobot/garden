---
gate: orchestrated
orchestrated_by: xs2rust-endor-build-stage9
priority: normal
posted_by: producer
posted_at: 2026-07-18T04:59:13Z
---

---
model: opus
---
# Stage-9 child 4/6 — endor-vm path-dep + daemon spawn wiring (probe step 5)

**Repo:** `endojs/endo-but-for-bots`, PR **#600**, branch `xs2rust-endor` (base `llm`). **Keep the PR DRAFT; never comment on it.** Report via your tada completion report ONLY — never message the parked supervisor or the maintainer.

**Worktree:** `/home/kris/garden2/scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`, then sync to the REAL remote tip (`git fetch origin xs2rust-endor`, checkout FETCH_HEAD). The press may have rebased — find equivalents by subject, verify `git diff -- rust/ c/` byte-identity. Verify pushes by git EXIT CODE.

**Environment (binding):** `cargo` at `$HOME/.cargo/bin`. TWO workspaces are in play: the engine workspace `rust/engine` AND the ROOT workspace (which builds the `endor` daemon bin under `rust/endo`). `TMPDIR=$HOME/tmp`; capture output to files, check `$?`. Seed `rust/engine/target/` by `cp -al` from a same-commit sibling; `c/moddable`: `rmdir` empty dir, `cp -al` from sibling, `git -C c/moddable checkout --detach 23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`, verify clean status. **Never `git add c/moddable`.** **Push-per-item**; size to one 2400s invocation; report the honest remainder rather than overrun.

## The work (the stage-7 daemon-boot probe's step 5)

1. **Path dependency:** add `endor-vm = { path = "../engine/endor-vm" }` (and whatever engine crates the boot surface needs) to `rust/endo`'s Cargo manifest; build the ROOT workspace; push the wiring commit once it builds clean.
2. **Spawn wiring:** wire the daemon's worker spawn path to the engine boot surface **behind the existing injection seam** (it mirrors the sqlite seam — read the stage-7 `daemon-boot-probe` and stage-8 injection-seam commits and `rust/endo` README §§ on the seam before writing code). The C-XS xsnap path must remain the default; the Rust engine is selected explicitly (env/flag per the seam's existing selection mechanism). Push when the selection round-trips.
3. **Smoke measurement (report-only, no mass fixing):** run a SMALL targeted subset of the `test:rust` daemon tests on the RUST engine, serially. Report per-test results honestly, including failures — this stage's finish-line child does the full run; your job is to prove the spawn path boots and to name the first real gaps.

**Environment-artifact discipline for any `test:rust` run (binding):**
- **AF_UNIX `sun_path`:** `test/channel.test.js` caps the per-test socket path at 90 chars; a long scratch path fails en masse as `endo.sock not ready`. Run from a REAL short path (symlinks do NOT work), e.g. `~/tmp/s9w`. Recipe (the `~/tmp/s8cxs` pattern): `git clone --shared` from the bare `worktrees/endojs-endo-but-for-bots.git` into the short dir, `git checkout --detach <tip-sha>` (sha fetch can fail on a `--shared` clone while detach-checkout succeeds), provision node_modules, run ava as `node ../../node_modules/ava/entrypoints/cli.js`.
- **Provisioning-race:** a clone killed mid-install yields uniform `AssertionError null == true` — treat mass-identical failures as artifacts until excluded; re-provision before believing them.
- **Serial only** for believable numbers (ava file-level parallelism amplifies to hundreds of `endo.sock not ready` artifacts).
- Expected C-XS baseline divergences (do NOT chase these): git-backend (`Could not parse git version from ""`), error-trace worker-assertions, content-store-gc marshal decode, endo.test.js (sandbox-unrunnable), shell `/tmp`-noexec EACCES.

**Verification bar:** root workspace builds clean (EXIT=0, no new warnings); engine workspace untouched or still green (`cargo test --workspace` in `rust/engine` if you touched engine code — with the fresh-clean rule `cargo clean -p endor-compile -p endor-vm -p endor-oracle`); the smoke subset's per-test table with exit codes; `forbid(unsafe_code)` intact at all 7 engine crate roots.
