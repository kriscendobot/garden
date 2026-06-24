All five follow-up jobs are durably on the board (one already completed to `tada`), and the audit is on `main2`. Worktree torn down. Here is my completion report.

---

# Completion report — `audit-self-healing-wrappers`

**Role worn:** mentor (self-improvement). **Deliverable:** `designs/self-healing-audit.md` committed to `origin/main2`.

## Report artifact
- **Commit:** `91dd6763` on `main2` — `designs: audit self-healing wrappers + git-content-store failure capture` (bot identity `endolinbot`). Built in an isolated worktree off `origin/main2` and pushed clean; worktree torn down.

## Part A coverage summary
**~22 `claude -p`-bearing or supervisory scripts: 2 has-wrapper · 1 central responder (mentor) · 8 partial · 3 missing · ~8 deterministic-adequate.** The posture is **not universal.**

Key findings, each grounded in the script:
- **Best pattern is on the retired path.** `scripts/driver/driver.sh` is the only full self-healing wrapper (EXIT-trap transcript capture `:131-151` + `capture_and_self_improve` hashing each tick and feeding only the SHA to a `claude -p` agent `:481-582`). The driver posture is superseded by the gardener pool, and its pattern was **never ported into the v2 fleet.**
- **Highest-value gap: `scripts/jobs/gardener.sh`** — the live v2 supervisor of the gardening state machines. On handler failure it discards the handler's stdout/stderr and **completes the failed job as `tada` (done)** (`:70-74`). No capture, no responder, no diverted-trace wiring.
- **Diverted tracing is half-done.** `garden-pr.sh`/`panel.sh` route `set -x` to a trace file (good), but never hash it or invoke a debugger — the trace dies in `/tmp`.
- **The fleet's only net is the central mentor's 30-min `journalctl` scan** — coarse, no per-task role, inlines logs wholesale.
- **`foreman.sh` swallows handler failure** (`|| true`, `:110`); **`bulletin.sh`** swallows the journalist failure (`2>/dev/null`, `:177`); **no systemd unit defines `OnFailure=`**.

**Supporting role/skill gaps:** the canonical **`self-healing-wrapper` skill does not exist**; **`prompt-on-failure-capture`** and **`gardener-inbox-error-reporting` (+`report-error.sh`)** are still **v1-only** and target the wrong branch (`journal`, not `journal2`); the mentor role's `self-improvement` skill is "to be migrated" and hasn't landed.

## Part B (capture-via-hash) opportunities — prioritized
1. `gardener.sh` — capture the discarded handler output by hash on failure.
2. `mentor.sh`/`mentor-claude.sh` — the whole `journalctl -p warning` tail is inlined (`mentor-claude.sh:36`); largest wholesale blob in the fleet.
3. `garden-pr.sh`/`panel.sh` — hash the `/tmp` trace into the journal on `fail()`.
4. `triager-claude.sh` / `watchman-claude.sh` — replace the arbitrary `head -400` caps with hash-capture.
5. `bulletin.sh` swallowed journalist stderr. Plus a `common.sh` `capture_blob`/`inspect_note` helper as the shared foundation (with the local-clone-vs-cross-host nuance documented).

## Follow-up jobs posted (all on `journal2`, idempotent basenames)
1. `self-healing-wrapper-skill` — author the canonical skill *(in progress)*
2. `self-heal-common-capture-helper` — `common.sh` capture helper *(already completed → `tada`)*
3. `self-heal-port-capture-skills` — port both v1 capture skills to v2, retarget `journal2` *(in progress)*
4. `self-heal-gardener` — capture+escalate gardener.sh failures instead of marking done *(in progress)*
5. `self-heal-mentor-capture` — hash the mentor digest, pass the SHA *(in progress)*

Design-level/judgment calls were **left as recommendations in the report** (systemd `OnFailure=` handler unit; gardener.sh failed-job lifecycle semantics; retire-or-fold `driver.sh`; deterministic-script escalation gaps).

## Incidental finding worth flagging
While posting, jobs **silently disappeared from the board after `post-job.sh` reported "posted"** — twice. Root cause appears to be the **single shared producer clone (`$GARDEN_STATE/producer/journal`) racing under the ~100-gardener fleet**: concurrent `post-job` processes share one working tree/`.git`, and one process's `sync_clone` (`git reset --hard`) can discard another's just-committed-not-yet-pushed work. I recovered by a retry-until-present loop (all five now confirmed on the board), but this is a live reliability bug squarely in the audit's domain — recommend a follow-up to give producers per-process clones (or serialize posts), consistent with the per-lane-worktree discipline the driver already uses.
