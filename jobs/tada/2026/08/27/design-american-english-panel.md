The PR diff is exactly the one design file; inbox is empty. The work is complete.

## Completion report

**Job:** `design-american-english-panel` — design the garden automation for an American-English spelling jury seat + a fixing role (kriskowal directive off `endojs/endo-but-for-bots` PR 282, `serialise` → `serialize`).

**What I did**

Wrote `designs/american-english-spelling-panel.md` specifying three coordinated artifacts with a single home for the word data:

1. **Skill `skills/american-english-normalization/SKILL.md`** — the one auditable home for a data-driven `divergences.tsv` (British→American word/pattern list) plus the exclusion discipline (always-`-ise` words like *surprise/exercise*; `-re`/`-our` false friends like *genre/glamour*; identifiers, upstream names, quoted text, fixtures). Both the seat-gate and the fixer read it.
2. **Jury seat `roles/jurors/orthographer/AGENT.md`** — a **mandatory, cost-gated** panel seat modeled exactly on `coverage-auditor`: a deterministic `seat-gate-orthographer.sh` greps the diff's added lines against the list with no LLM, and the panel spends a `claude -p` only on a hit. The seat then adjudicates each candidate (real prose divergence vs. identifier/quote/fixture) into a panel finding.
3. **Role `roles/americanizer/AGENT.md`** — a fixer variant that applies vetted spelling fixes without touching semantics, upstream identifiers, or quoted text. Dispatched by the in-gauntlet fixer for spelling findings, or standalone via a proposed `americanize #N` verb.

I included a validated mermaid flow diagram, a build plan (skill+tsv → seat-gate+test → seat wiring into `panel.sh` seat lists → role + vocabulary), alternatives considered (fold into pedant/copyeditor; auto-fixing pre-push probe; standing watcher — each rejected/deferred with reasons), and a `## Open questions` section with five genuine maintainer forks.

**What changed**

- `designs/american-english-spelling-panel.md` landed **bare on `main2`** (commit `520d6b3115`, pushed).
- Because the design carries a non-empty `## Open questions` section, per the designer's garden-own-repo carve-out it also gets a **frozen-base review PR**: **[kriscendobot/garden#75](https://github.com/kriscendobot/garden/pull/75)** (draft, base `main2-276a3ea`, diff = exactly the one design file), body marked `<!-- garden-design-open-questions -->` so the completion machinery stages **no** design panel and cites the originating PR-282 review.

**Follow-ups**

- The five open questions (external-author scope; design-panel membership; rule-set conservativeness + curation ownership; default disposition; name confirmation) await maintainer answers on PR #75.
- The follow-on builder job to carve the seat + role + skill + seat-gate + tests is **gated on those answers** and deliberately not posted yet (the shape is not fully settled). Once resolved, it's a single builder job or small orchestration per the design's build plan.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-american-english-panel.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 31 tokens (1551990 cached reads)
- Output: 26592 tokens
- Cost: $2.4725509999999997
- Wall-clock: 426s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
