Inbox empty. Work complete.

---

**Completion report — `improve-worktree-sweeper-time-budget`**

**Problem.** `scripts/jobs/worktree-sweeper.sh` runs as `garden-worktree-sweeper.service` (oneshot, `TimeoutStartSec=1800`, timer every 30 min). Each PR-bound terminal checkout is verified with `gh pr view` (`timeout 30` per PR reference) inside `pr_disposition_allows_sweep`. A long queue of completion/doom bases could let the cumulative GitHub-check sequence exceed the 30-minute start timeout, so systemd SIGKILLs the tick, marks it `Failed`, and the sweep never finishes — the exact failure the job describes.

**Change made** (one file, `scripts/jobs/worktree-sweeper.sh`):
- Added a configurable soft tick deadline `GARDEN_WORKTREE_SWEEP_DEADLINE_SECS` (default **1500s** — 300s of headroom under the 1800s unit timeout, comfortably absorbing a single in-flight base's remaining `gh` calls plus the self-heal responder; `0` disables it), validated as a non-negative integer like the existing sweep cap.
- Captured `TICK_START` via `date +%s` and added two predicates: `past_deadline` (elapsed ≥ budget) and `budget_remains` (removal cap **AND** time budget still hold).
- Gated the terminal-worktree verification with `budget_remains`: it is checked at the top of `sweep_terminal_base` (**before** the `gh pr view` verification runs) and at every inter-loop checkpoint — the doom loop, the completion/GitHub-verify loop, and the legacy-orphan loop. Unswept candidates are simply left for the next tick, matching the existing cap-reached semantics.
- The end-of-tick log now distinguishes a deadline stop (`sweep deadline (Ns) reached … remaining candidates wait for the next tick`) from a cap stop.
- Inner project-checkout/legacy-directory removal loops keep the plain `under_limit` guard (pure local `rm`, no network), so cap accounting is unchanged; the deadline gates the network-bound outer iteration only.

**Verification (executed):**
- `bash -n scripts/jobs/worktree-sweeper.sh` → syntax OK.
- `shellcheck -x` → only pre-existing infos (SC1091 on the sourced `common.sh`; SC2295 on untouched lines 117/119); my additions introduced no new warnings.
- Isolated smoke test of the three predicates against fresh / overrun / disabled / cap-reached states — all seven expectations matched (fresh→continue, overrun→stop, disabled→continue, cap→stop).

**Committed & pushed:** `main2` at `9bc8c5682e` (rebase CAS push, first attempt). Job worktree torn down on exit.

**Follow-ups:** none required. The deadline is a soft per-base checkpoint, so worst-case overrun is bounded by one base's remaining `gh` calls (≤ its PR count × 30s), well inside the 300s headroom; operators can tune or disable it via `GARDEN_WORKTREE_SWEEP_DEADLINE_SECS` if the unit's `TimeoutStartSec` is ever changed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-worktree-sweeper-time-budget.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (842134 cached reads)
- Output: 11276 tokens
- Cost: $1.238902
- Wall-clock: 175s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
