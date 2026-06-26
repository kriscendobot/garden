Done. Worktree torn down; the watchman is timer-driven (`garden-watchman.timer` enabled, ~2-min cadence; the `static` oneshot service shows `inactive` between ticks, which is normal — my manual `--once` just deployed immediately rather than waiting).

---

## Completion report — `fix-conductor-spine-unfreeze-to-llm`

**SHA:** `a59ed7740` on `origin/main2` (deployed to the live `/home/kris` tree; gardeners broadcast a reread).

**What was wrong:** `scripts/jobs/gardening/ci-wait-merge.sh` (the conductor spine) merged a PR onto whatever base it carried and stopped. When that base is a **frozen snapshot** (`<branch>-<sha>`, e.g. `llm-65b0abe`), the conductor's **step-2 unfreeze** never ran, so content stranded on the stale snapshot and never reached the live trunk (#510 merged onto `llm-65b0abe`, 186 commits behind live `llm`).

**Fix (the unfreeze/shared-stack behavior the DoD asks for):** before the CI-wait/merge, the spine now runs `unfreeze_base_if_frozen`:
- Reads `state,baseRefName`. If the base matches the frozen pattern `^(llm|main|master)-[0-9a-f]{4,40}$` on an OPEN PR, it computes the live trunk (`${base%-*}`) and **re-points the PR at it** (`gh pr edit --base <branch>`) so the merge lands on the trunk. A live (already-unfrozen) base is a no-op; idempotent on re-enqueue.
- **Shared-stack safety:** it counts OPEN PRs sitting on the same frozen base. If a sibling shares it (the #510/#521 case), re-pointing one alone would fork the stack off the shared base — so it does **not** touch it: it `alert_maintainer`s with the specific stack and stalls (**exit 1**), neither silently stranding nor force-forking. Solo PR → unfreeze and merge.
- Runs **before** the wait loop so any base-change-triggered CI is awaited; `--no-merge` probes skip it (they must not mutate the base).

**Coordination with the day's other two spine gaps:** both already landed on `origin/main2` ahead of me — `fix-ci-wait-merge-gh-path` (`d2811ba9e`, durable `gh` resolution) and `harden-conductor-ci-wait-complete-merge` (`422170623`, carry-merge-to-completion). My change builds on top, so the spine now reliably (a) finds its tools, (b) completes the merge, and (c) unfreezes to the live branch.

**Tests/verification:** added **T9** (frozen base, no sibling → base unfrozen + merge, exit 0) and **T10** (frozen base shared by a sibling → maintainer alerted, exit 1, no merge, no base edit) to `ci-wait-merge-test.sh`. Full suite **PASS=20 FAIL=0** (T1–T8 unchanged). `bash -n` clean on both files; `shellcheck -x` clean (only the pre-existing SC1091 source-resolution info and SC2034 on `GARDEN_TAG`, which `common.sh`'s `log()` uses).

**Follow-ups:** none required. (Doc note: `roles/conductor/AGENT.md` and `skills/frozen-base-branch` already prescribe unfreeze-before-merge; the spine now matches that doctrine, so no doc change was needed.)
