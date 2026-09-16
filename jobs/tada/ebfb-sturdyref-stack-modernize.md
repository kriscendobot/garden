---
handed-off: ebfb-sturdyref-stack-rebase-20260916
deliverable-complete: false
---
Everything is in place and verified. The full inventory is done, the target decision is made and recorded, all pre-rebase SHAs are captured into the child bodies, and a serial halt-on-failure orchestration owns the entire remaining execution. Here is my report.

---

## Completion report — `ebfb-sturdyref-stack-modernize`

**What I did:** Inventoried, diagnosed, and decided the sturdyref stack modernization, then decomposed the execution into a serial orchestration (per the "split into claim-sized stages" instruction), since I durably own the plan/decision and the pipeline owns the conflict-heavy rebases.

### Inventory (work item 1 — done)
The stack is a **single linear chain of 10 PRs**, verified by git ancestry (not just base fields):

| order | PR | branch | own commits | true base |
|---|---|---|---|---|
| 1 | #774 | build/sturdyref-shim-first-wins | 3 | `llm-da209e5-endo-ascii` (snapshot) |
| 2 | #737 | build/sturdyref-pass-style-ocapn-single | 7 | #774 |
| 3 | #541 | build/sturdyrefs-endor-syscall-retention | 5 | #737 |
| 4 | #698 | build/sturdyref-bridge-1-bytes-wire-read | 2 | #541 |
| 5 | #700 | build/sturdyref-bridge-2-ocapn-promotions | 8 | #698 |
| 6 | #701 | build/sturdyref-bridge-3-daemon-mint-export | 4 | #700 |
| 7 | #702 | build/sturdyref-bridge-4-ocapn-singleton | 4 | #701 |
| 8 | #703 | build/sturdyref-bridge-5-foreign-internalization | 4 | #702 |
| 9 | #704 | build/sturdyref-bridge-6-three-party-roundtrip | 4 | #703 |
| 10 | #871 | build/sturdyref-agent-surface | 5 | **#704** |

Key findings:
- **#871 is the TOP of the stack, not an independent PR.** Its head descends from #704, but its **PR base field lies** — it says `llm` (so GitHub was computing its diff as all 48 stack commits). Also, GitHub's cached PR head (`2e90885`) is **stale**; the real branch tip is `fbd0da9`. Both captured for the rebase.
- **Snapshots:** `llm-da209e5` is a clean ancestor of live `llm`; `llm-da209e5-endo-ascii` = it + the `@endo/ascii` package (2 commits). Live `llm` is ~2385 commits / 2 months ahead.
- **Snapshot users:** `llm-da209e5` → **only #752** (independent; must be kept). `llm-da209e5-endo-ascii` → **only #774** (retirable once the stack moves off).
- **Conflict surface:** 49 of the 96 stack-touched files also drifted on `llm` (heaviest in `packages/daemon/{daemon,host,guest,directory,interfaces,types.d.ts}`, `packages/ocapn/*`, `packages/pass-style/*`, `marshal`). Real, non-mechanical conflicts.

### Decision (work item 2 — done)
**Rebase the whole stack onto live `llm`; do NOT re-cut a snapshot.** Rationale: `@endo/ascii` — the sole reason `llm-da209e5-endo-ascii` existed — **has landed on live `llm`** (`packages/ascii` present, tree identical bar a version bump), so that snapshot is fully obsolete; `llm-da209e5` is a clean ancestor of `llm`; re-cutting merely moves the frozen-base entanglement forward. Keep `llm-da209e5` for #752; retire `llm-da209e5-endo-ascii` after the stack is off it.

### Sequencing & handoff (work items 3–5 — owned by the orchestration)
Posted orchestration **`ebfb-sturdyref-stack-rebase-20260916`** (serial, `on-child-failure=halt`) with 11 parked weaver children, bottom-up: one rebase per PR (#774→#871) plus a final retire/audit child. Each child body carries its exact `git rebase --onto` command with captured pre-rebase SHAs, a `--force-with-lease` bound to the old head (restore-safe), per-PR diff verification, local-verify, and the two base-field fixes (#774 `→llm`, #871 `→build/sturdyref-bridge-6-three-party-roundtrip`). The final child retires `llm-da209e5-endo-ascii` only after confirming nothing else bases on it, and leaves `llm-da209e5` intact for #752. Nothing is merged or undrafted.

**Pre-rebase head SHAs** (captured, also embedded in each child): 774 `1fb7a203`, 737 `1854bdc2`, 541 `5e385385`, 698 `9082faf7`, 700 `e4ebfc58`, 701 `664563c4`, 702 `44bdb01e`, 703 `c11c2e06`, 704 `01a58012`, 871 `fbd0da9d`.

**Coordination:** no in-flight jobs touch these PRs (checked board todo/doin and live agents).

**Follow-ups:** The `garden-orchestrate` watcher (leader-only) drives the pipeline from `state: pending`; a mid-stack conflict a child can't resolve halts the chain and surfaces to the maintainer inbox rather than corrupting downstream branches. #871 still carries `fixup!` commits (cosmetic; out of scope for rebasing — a squash is normal-review work).

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-stack-modernize.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (2665057 cached reads)
- Output: 40966 tokens
- Cost: $3.2882545
- Wall-clock: 838s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
