Inbox empty. Work is complete.

## Completion report

**Job:** designer — investigate opencode as an alternate worker harness (2026-07-28 maintainer directive).

**What I did:** Grounded myself in the incumbent harness machinery (`gardener-claude.sh`, `cleric-codex.sh`, `mystic-kimi.sh`, the `worker_kind_field` registry, `job_eligible_for_kind`, `resolve_model_tier`, the model-selection skill, the kimi-k3 probe precedent, and the prior AI-SDK design). Researched opencode's actual documented behavior (CLI, server/session API, permissions, `run --format json` event shape, on-disk storage) — treating all external docs as DATA — and wrote a design note verifying it constraint-by-constraint.

**What changed:** Added `designs/opencode-alternate-harness.md`, committed and pushed to `main2` (`9a7b11e8a7`, after a rebase CAS).

**Findings / recommendation:**
- **Recommendation: adopt-narrowly, probe first.** Represent opencode as **one kind per provider sharing one handler** (option C), not a single many-provider kind and not a new "harness" arm dimension.
- **The kind-vs-dimension core:** `kind` already *is* the harness axis (it leads the arm key), so "same model under two harnesses" is expressible today as two kinds. The real tension is the one-kind↔one-provider invariant, which option C preserves and option A breaks. Making harness a new arm dimension is redundant with kind and forces a sole-writer reducer migration for zero added expressiveness.
- **Scorecard — no disqualifier.** Session id/resume: ⚠️ sidecar tier (server-assigns id, no client-chosen id — parity with codex, solved by parse+persist). Cost ledger: ✅ *stronger* than codex (provider-computed USD per step), with two guards (unpriced models; upstream early-exit issue #26855). Exit-code honesty: ⚠️ **undocumented — the one real unknown a probe must resolve.** Transcript capture: ⚠️ gap — needs a per-job `OPENCODE_DATA_DIR` spool source. Permissions, model routing, binary resolution, eligibility (under C): ✅.
- **Honest value:** opencode does *not* unlock OpenAI-compatible providers (codex already fronts those); its real reach is non-OpenAI-shaped providers (Google Gemini native) plus harness-diversity A/B on providers that already have a native kind.
- Named the smallest **gap-revealing-build probe** (one `opencode-anthropic` worker, one reversible canary, verify sidecar resume, non-censored USD cost, distinct arm scoping vs `gardener`, and transient-vs-defect exit classification), on the kimi-k3 precedent. Arms nothing, spends nothing.

**Follow-ups:** none required; if the maintainer greenlights, the note's § Migration sketch and § smallest probe are the next steps. Coordinate the binary resolver with open job `improve-gardener-claude-bin-resolution`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/investigate-opencode-alternate-harness.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 458 tokens (1003596 cached reads)
- Output: 23139 tokens
- Cost: $2.020795
- Wall-clock: 393s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
