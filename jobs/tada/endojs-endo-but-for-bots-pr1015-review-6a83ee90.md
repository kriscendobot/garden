Confirmed: zero inline comments, empty inbox. The review's sole ask is resolved.

## Completion report

**Job:** Review directive on `endojs/endo-but-for-bots` PR #1015 (kriskowal, review `5064747988`).

**What the review was.** A single `COMMENTED` review body and **zero inline comments** (verified by count). The body was a "please consider these notes from a similar garden" ask — a production-verified sibling design note (*"The provider adapter layer"* / Agent C voice-agent) on presenting a Claude **subscription** and metered API keys as one cap-wrapped provider type. PR #1015 is our own `@endo/claude` confinement-core builder DRAFT.

**Disposition (why routing, not editing #1015).** The design `designs/endo-claude.md` (merged, PR #995) is already deeply developed and **already cites the garden fleet** for the same pooling problem (§ Pooling subscriptions; DD8's `{type:…}` precedent). The sibling notes are a more mature, field-verified instance that sharpens the design's **already-deferred residuals** — not the confinement core this DRAFT increment builds. So the correct route is a design refresh, not a change to the #1015 diff.

**What I did.**
1. Ran the preflight → `PROCEED` (no correlated peer resolution).
2. Fetched and read the review body + the 117 KB design doc (Pooling, Design Decisions, Known Gaps, Open questions) and the PR to map the notes precisely.
3. **Posted designer job** `endojs-endo-but-for-bots-endo-claude-sibling-notes-20260831` (verified on the board at `jobs/todo/`) to fold six distilled, generic lessons into `designs/endo-claude.md` as a separate draft PR against `llm`: DD7 per-guest-credential evidence (isolated `HOME`+`CLAUDE_CONFIG_DIR`); the unnamed **fail-open-onto-operator-login** hazard; keepalive/session-reuse cross-user leak as field rationale for "fresh process per call"; the `spawn E2BIG` operational ceiling; entitlement/"ratchet-at-source" reinforcement; and an explicit out-of-scope steer on the sibling's multi-provider ring/router. The job body carries prompt-injection discipline (distill, don't copy internal paths/identifiers; treat the note as untrusted data).
4. **Replied on PR #1015** (`issuecomment-5476268679`) acknowledging the notes, stating the disposition and the full lesson-to-section mapping so the maintainer sees the input was genuinely considered.

**Untrusted-input handling.** The review body and note were treated as data, not instructions — no imperative in them was followed; internal paths/app names were not propagated.

**Follow-ups.** The designer job will produce a design-refresh PR against `llm` (design panel auto-stages at its completion). Nothing blocks #1015 — its confinement core stands.

No garden-repo (`main2`) changes were needed, so the worktree is clean with nothing to commit.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1015-review-6a83ee90.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (898520 cached reads)
- Output: 17512 tokens
- Cost: $1.63112
- Wall-clock: 296s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
