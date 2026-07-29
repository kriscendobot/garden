• Now let me locate the journal worktree and the prior review evidence.

• The journal worktree is at `/home/kris/garden/journal` (read-only for me). Let me explore its structure and find prior reviews.

• I have the executable inventory. Now let me check the journal override state and the shape of the evidence (tada reports, usage, reputation).

• Reputation arms give per-model acceptance/cost stats. Now I need job-level outcome evidence with model attribution. Let me check how tada files retain job metadata, and what per-instance clones exist.

• I'll check the reputation events format — they may carry per-job model+timestamp evidence without needing git history.

• Now I understand the reputation schema. Let me check outcome vocabulary in usage logs, then build the aggregation.

• A burst of poison notices on the press schedules. Let me quantify by family/date and check their model pins plus the poison reasons.

• Panel error rate is high (14/20 errored) and cost data is in. A few final checks: the qwen served-model watch, the ocapn gauntlet requeue cause, and the opus-5 orchestration child outcomes.

• Two final evidence checks: PR merge/approval proxy from recent tada reports, and the local-inference context doc for the qwen served tag.

• Inbox is empty. Sending the review summary and recommendations to the maintainer.

• # Weekly model-tier effectiveness review — 2026-07-29

  **Job:** `model-tier-effectiveness-review-20260729-172004` (role assayer, run on mystic/`kimi-k3`)
  **Prior review:** none — this is the inaugural run (schedule `last_dispatched` was blank; no prior tada). This report is the carry-forward baseline for next week.
  **Evidence window:** primary 2026-07-22 → 2026-07-29 (7d); 14d noted where it changes the picture.
  **Executable inventory read:** `scripts/jobs/common.sh` (`resolve_model_tier`, `role_default_model`, `role_default_effort`), `scripts/jobs/model-routing-defaults.tsv` (no per-instance journal override present; `config/kimi-takes-opus-work` flag absent = OFF).
  **Sources:** 1,620 reputation events, `reputation/arms/`, 391 usage engagements in-window, 688 tada completions (7d mtime), 20 panel-runs, poison notices (maintainer inbox), schedule frontmatter.

  ## Measurement caveats (bias controls)

  - **Reputation events are completion-censored**: they are written at `tada`, so every arm shows acceptance 1.00 (0 `accepted: false`, 0 demerits all-time). The true quality signal is usage outcomes, requeue counts, and poisons — used below.
  - **Usage metering is partial** (391 of ~688 completions logged; only claude handlers stamp model+cost; codex/hermit/mystic cost comes from reputation `estimated_dollars`).
  - **Role mix confounds cross-model comparison** (designer/builder pin opus/terra); comparisons are made within work class.
  - **Outage vs quality separation**: 90 of 94 in-window fails (96%) were instant zero-token provider-side failures (quota-era), concentrated on claude-opus-4-8 (21), unattributed (57), fable (9). Only 4 substantive fails exist fleet-wide. **No model-quality failure signal was found for any model this window.**

  ## Fleet window measures

  - 688 completions; logged engagements: 189 tada / 108 requeue / 94 fail.
  - Metered claude cost 7d: **≈$250** — opus-4-8 $129 (56 eng), fable-5 $100 (41 eng), opus-5 $13 (4), sonnet-4-6 $8 (10). Cleric terra mean est $2.08/job (medium).
  - Panels: 1 passed / 5 must-fix / 8 error / 6 seat-error — panel harness is quota-degraded (errors, not rejections).
  - Downstream PR proxy: 140 in-window tada reports mention merged vs 2 changes-requested.
  - Poisons: dominated by `xs2rust-endor-press` (51, see qwen below) and fable-pinned endo presses (~17); fix-loop cases: pr705-fixer (8 requeues + budget overrun), finbot panels (5–7 requeues; 28-seat jobs exceeding claim budget — packaging, not quality; `split-gauntlet-into-claim-sized-stages` tracks it).

  ## Proposed tier table (new vocabulary per the 07-29 maintainer directive; current executable binding in parentheses)

  | Model | Current binding → tier | Window / samples | Work mix | Performance & acceptance | Confidence | Disposition |
  |---|---|---|---|---|---|---|
  | claude-fable-5 | explicit-only pins (endo presses, 6h) → **mentat** | 7d: 125 compl. | other:l/m press | 100% eventual acceptance; $100; 9 quota fails; ~17 press poisons (quota/packaging era) | medium-high | **Retain at mentat, manual-only.** Automatic schedule pins already directed to phase out (parked todo job). No evidence move from me. |
  | claude-opus-4-8 | designer/builder default @high → **minion** | 7d: 34 @high + 4 @med | build:l/m, design:l/m, panels | 100% acceptance; $129 (top spend); 21 quota fails; panel requeue-loops are budget shape | high | **Retain.** Zero defect signal; no shallower model has build:l evidence; cost is the watch item. |
  | claude-sonnet-4-6 | mechanical set (weaver/conductor/pages-shepherd) → myrmidon-side | 7d: 8 compl. | ops:m/l, weave, other | 100% acceptance; $8; 1 quota fail | medium (n=8) | **Retain.** Clean but small sample. |
  | claude-haiku-4-5 | mechanical set (cleaner/retcon/yarn-lock/journalist) → myrmidon-side | 0 dispatches (7d, 14d, all-time) | — | no evidence | none | **Insufficient evidence; retain binding** (already cheapest; nothing shallower). |
  | claude-opus-5 | explicit orchestration pins (xs2rust finish-line) → unclassified passthrough | 7d: 1 compl. + s1 child tada | other:l | accepted, 1106s, $8.13; 2 quota fails | none (n=1) | **Insufficient evidence; keep explicit-pin-only.** Early signal positive. |
  | claude fleet default (headerless) | unpinned gardener work | 7d: 155 compl. | other:s/m/l, gardener, prosecutor, weave, scholar | 100% acceptance; 24 fails on later-completed bases (quota-era) | high | **Retain.** |
  | gpt-5.6-terra | cleric default + designer/builder @high → **minion** | 7d: 208 compl. (174 med / 34 high) | other, gardener, fix, weave, prosecutor, build/design | 100% acceptance; est $2.08/job med; ocapn gauntlet 8 requeues→tada (budget slicing) | high | **Retain.** Highest-volume arm; effective across classes. |
  | gpt-5.5 | frontier (mechanical set) → myrmidon-side | 7d: 5 compl. | ops:s/m, weave:s | 100% acceptance; est $1.66 | medium (n=5) | **Retain.** |
  | gpt-5.4-mini | mini (mechanical set) → myrmidon-side | 7d: 1 compl. | doc:m | accepted, 1116s | none (n=1) | **Insufficient evidence; retain** (cheapest cleric tier). |
  | qwen3.6 (hermit, local) | local fleet default → **myrmidon** | 7d: 5; 14d: 38 compl. | other:s/m/l (bounded xs2rust stages), gardener:s, weave, fix:s, prosecutor:m, build:m@high 5/5 | 100% acceptance on bounded classes; **51 requeue-exhausted poisons** as recurring unbounded press-driver (07-20→27) | medium | **Retain at myrmidon for bounded small/medium classes.** The over-dispatch was already remediated 07-27 (sonnet watchdog + opus-5 orchestration). Not effective as an unbounded press-driver. |
  | kimi-k3 (mystic, moonshot) | explicit-only trial lane → directive target **mentor** | all-time: 3 compl. (21s, $0.063) + THIS review in flight on K3 | gardener:s | 100% acceptance at canary class | low (n=3) | **Insufficient evidence for automatic mentor routing; retain explicit-only.** Mentor mapping is maintainer-directed and parked; keep the opus-fallback gate mandatory (`config/kimi-takes-opus-work` still OFF) and build the arm with bounded gardener:m/researcher:m trials. Mentat access not widened — untouched. |
  | fireworks/* (glm-5p2) | explicit-only lane | 1 canary compl. (8s) | gardener:m | accepted | none | **Insufficient evidence; retain explicit-only.** |

  ## Changes

  - **Routing: none.** No retier is evidence-supported beyond the already-directed, already-parked `garden-tier-vocabulary-kimi-routing` migration (in `jobs/todo/` with maintainer annotations). Per spec, weak-evidence routing was left untouched; no follow-up retier job posted.
  - **Surfaced to maintainer** (message delivered, inbox receipt `20260729T174012Z-e4a390`): (1) 96% of fails are quota-side, no quality demotion anywhere; (2) K3 mentor evidence still thin — keep fallback gate mandatory, feed bounded trials; (3) **qwen default-id drift** — every hermit completion records `qwen3.6` but the seed/journal default says `qwen3:0.6b`, and garden2's ollama units were in flux 07-28 (system unit serving empty list); recommend live probe then `set-model-routing.sh` realignment (data edit, no deploy); (4) panel error/seat-error 14/20 — quota/budget shape; (5) haiku/mini/fireworks lanes starved — route small mechanical work there if shallower-movement evidence is wanted.

  ## Follow-ups

  - Maintainer actions requested in the message above (qwen probe + data edit; K3 trial feeding; starved-lane evidence).
  - Next weekly run should diff against this report (jobs/tada/model-tier-effectiveness-review-20260729-172004.md) and against the tier-vocabulary job's landed mapping.
  - No main2 commit was needed (review-only; no executable mapping changed), so nothing was pushed from the worktree.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/model-tier-effectiveness-review-20260729-172004.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 82265 tokens (2444800 cached reads)
- Output: 34949 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1214s
- Model(s): kimi-k3 ×1

<!-- garden-usage-end -->
