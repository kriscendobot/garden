The panel round completed. Here is my report.

---

**Job: PANEL round 4 — endojs/endo-but-for-bots PR #1264** (design: daemon storage capability matrix)

**What I did:**
1. Resolved PR head (endojs/endo-but-for-bots @ `design/daemon-storage-capability-matrix`, base `llm`) and created an isolated project worktree keyed to this job's base.
2. Ran the panel in single-round mode (`GARDEN_PANEL_SINGLE_ROUND=1`) against the worktree at merge-base `ff3ca7d`. The design-panel fanned 8 seats (critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice, orthographer).
3. Panel disposition: **must-fix** (exit 0, decided cleanly).
4. Posted the aggregate as a `gh pr review`. GitHub blocks a request-changes review on a bot-authored PR ("Can not request changes on your own pull request"), so I posted it as a **comment review** whose body leads with `disposition: **must-fix**` — the panel-verdict shape the next-stage-owed heuristic recognizes.

**Blocking findings (request-changes seats):**
- **critic** — Target-naming vs. Migration Phase 3 self-contradiction: the design both advertises freeing `readable-blob`/`readable-tree` names for reuse *and* recommends keeping the compat alias indefinitely; the two are mutually exclusive and must be reconciled.
- **skeptic** — Migration overlooks a third `formula.type` dispatch site (`formula-record.js:215` `case 'readable-blob'`) that would silently drop `properties.content` once new records write `snapshot-blob`; plus a test-catalog gap covering the four external literal-string rekeys.
- **ergonomist** — Readable-view row spells the same cell three ways (`ReadableTree` / `ReadableTree` / `ReadableNameHub`); mount-backed live-read-only-view analog left unaddressed.
- **pedant** — Heading capitalization inconsistent and divergent from repo convention (`## Open questions` vs. the corpus's `## Open Questions`, etc.).
- copyeditor/novice raised should-fix prose issues; orthographer approved (no British spellings).

**Follow-ups:** none from me — this is one gauntlet stage; I did not fix, un-draft, or loop. The next stage (fix-loop) owns the must-fix findings.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1264-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (604922 cached reads)
- Output: 4765 tokens
- Cost: $0.897565
- Wall-clock: 346s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
