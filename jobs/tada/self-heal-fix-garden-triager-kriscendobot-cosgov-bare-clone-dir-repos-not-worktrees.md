The peer message confirms the convergence: a sibling gardener working the same root cause already landed all three fixes (including `fork-watch-provisioner.sh` via `9ad9c72931`) and asked me to wrap up as a no-op. My commit added the failure-signature documentation on top. All three consumers now agree on `worktrees/` on origin/main2. The work is complete.

---

## Completion report

**Job:** Fix the triager's bare-clone lookup path and its handling of a genuinely-missing clone (cosgov FATAL-storm).

**What I found:** Both core defects were *already committed to origin/main2* by sibling gardeners working the same root cause before I claimed this job:
- **(A)** `triager.sh:38` and `comment-watcher.sh:191` already default `GARDEN_REPOS` to `$GARDEN_ROOT/worktrees` (commit `118f7384fc`).
- **(B)** `triager.sh:55` already degrades a missing bare clone to a clean `log` + `exit 0` skip instead of a `die`, ending the FATAL-storm (commit `e33d0b71ba`).

**What I fixed (the remaining gap):** Grepping the "other `GARDEN_REPOS` consumers" the job flagged surfaced a **third** consumer the two commits missed: `fork-watch-provisioner.sh` — the leader-only component whose MATERIALIZE step clones each armed own-fork into `$GARDEN_REPOS/<slug>.git`. It still defaulted to `repos/`, so it would clone a just-armed fork (cosgov) into `repos/` while the triager reads `worktrees/` — a materialize/read split leaving cosgov permanently uncloned. A sibling gardener (vattr97 job) landed the functional default-flip (`9ad9c72931`) concurrently; my commit `54156852da` adds the explanatory comment tying the default to this failure signature. All three consumers now agree on `worktrees/` on origin/main2.

**Design note on (B):** I deliberately did *not* implement the "preferred" clone-on-demand in triager.sh. The graceful-skip fallback was already landed and is the coherent design — clones are host-local, the leader materializes them via the (now-fixed) provisioner, and non-leader hosts skip. Clone-on-demand in the triager would contradict that just-established design and make every host clone every fork.

**Verification:**
- `fork-watch-provisioner-test.sh`: 16/16 PASS (incl. materialization case E).
- `triager-test.sh`: 41/41 PASS (incl. case H, missing-clone graceful skip).
- `comment-watcher-test.sh`: 80 assertions PASS, 0 fail (exit-code flake is the harness's shared fixed-path fixture `/home/kris/.garden-cw-test` colliding across concurrent gardeners; unrelated to this change, which doesn't touch `comment-watcher.sh`).
- Live read-only check: triager resolves `worktrees/kriscendobot-endo.git` and yields a single 40-hex SHA (no die, no skip, no ambiguous-argument poison). Confirmed `repos/` does not exist and cosgov's clone is absent (the leader provisioner will now materialize it into `worktrees/`).

**Follow-ups:** None required. Once the leader's `garden-fork-watch` tick runs, it will clone `worktrees/kriscendobot-cosgov.git` and `garden-triager@kriscendobot-cosgov` gains coverage.
