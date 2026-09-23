Verified. The `roadmap_index` now deterministically maps all three at relevance **100** (the maximum). The job is complete. Let me write the completion report.

---

## Completion report — `groom-carve-mcp-bridge-milestone`

**Re-derived state first (clean re-run):** no prior PR existed for this job (marker search empty). Confirmed nothing changed since the brief: minion.town **#41 merged** (2026-08-18), endo-but-for-bots **#1015** and **#1102** both **open drafts**. The endo ledger (`designs/README.md` @ `llm`, tip `1d91f0d9d`) has **M1 and M2 Complete**, so **M3 (Remote Access and Coding Capabilities) is the first unfinished milestone** — and it already housed the git-remote capability's endo companions (the git trio, `daemon-agent-tools` push tier, `endo-agent-tools`), while `endo-claude` sat in **M6**.

**Which milestone I carved, and why (existing-reworded, not newly-inserted).** I **re-worded M3** rather than splicing a new milestone ahead of it. M3 already owns the git-remote follow-on substrate *and* `endo-agent-tools` — the very MCP-adapter-projection prerequisite that `endo-claude` depends on. A new milestone ahead of M3 would either **break the ledger's dependency invariant** (each milestone's deps live in earlier milestones, per maintainer PR #400) or force a disruptive M3–M11 renumber for no structural gain. Re-wording keeps the invariant intact and puts both halves of the bottleneck class at the head of the first unfinished milestone. `endo-claude` is **moved M6 → M3** (pointer left in M6; priority raised in M3, lowered in M6 — never removed). No milestone is renumbered, so nothing is *demoted in number*; the "bump down" is relative — the carved items rise to the top, everything else defers behind them.

**PR opened against `endo-but-for-bots`:** **https://github.com/endojs/endo-but-for-bots/pull/1127** (draft, spec-only), carrying the durable `<!-- garden-job: groom-carve-mcp-bridge-milestone -->` marker via `ensure-pr.sh` (needed `GARDEN_ENSURE_PR_LIST_LIMIT=600` — the fork has 200+ open bot PRs). It edits `designs/README.md` (M3 goal + a new **Client-side bridge (top priority)** block naming both capabilities and their companions; 4 new M3 rows; exit-criterion clause; M6 constituent-note → "moved to M3" pointer + estimate adjust) and appends the groom note to `designs/ARCHIVE.md` per the ledger's own convention. Left as a draft to avoid triggering the fork's build/gauntlet automation on a pure-prose PR; it's substantively ready for maintainer inline review.

**Journal-side (all landed on `origin/journal2` via the sanctioned `land-journal-edit.sh`, CAS-safe):**
- Created `plan/designs/endo-but-for-bots/endo-claude.md` (`pr: #1015`, `milestone: M3`, `roadmap_relevance: 100`).
- Created `plan/designs/endo-but-for-bots/endo-claude-agents-capability.md` (`pr: #1102`, M3, relevance 100).
- Created `plan/designs/minion-town/git-remote-capability.md` (`repository: minion-town`, `pr: #41`, M3, relevance 100).
- Added `minion-town` to `plan/repositories.md`.
- Added a `## Roadmap` pointer section to `projects/minion-town/README.md`.
- Plan validator: **0 errors**, 2 non-fatal warnings (`endo-agent-tools`/`endor-git-bindings` are real fork designs never imported as journal records — an accurate pre-existing import gap, not introduced breakage). I deliberately did **not** churn the four ~900-line git-trio records: they carry no `pr:` field, so `roadmap_index` skips them regardless of relevance — editing them would add nothing to the bulletin.

**Bulletin verified.** `journal/README.md` **re-rendered at 21:19**, after my 21:18 pushes. I proved `roadmap_index` now maps `endo-but-for-bots#1015 → 100`, `#1102 → 100`, `minion-town#41 → 100` (the maximum). The two endo PRs are currently **drafts**, so they are correctly *not yet* in the review-ready "Parked for maintainer feedback" list; the ranking signal is in place so they surface **first** the moment they're undrafted, and #41 (merged) never appears as parked. This is the honest verified state, not an unverified success.

**Follow-ups for the maintainer/liaison:** (1) mark PR #1127 ready-for-review when you want it to draw a panel; (2) the two `depends_on` warnings would clear if `endo-agent-tools` and `endor-git-bindings` were imported as journal records (a general staleness in the one-time endo import, out of this job's scope).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/groom-carve-mcp-bridge-milestone.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 112 tokens (7226673 cached reads)
- Output: 52029 tokens
- Cost: $6.646455500000002
- Wall-clock: 925s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
