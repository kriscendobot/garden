The job is already fully complete. The prior attempt landed and pushed commit `6a50e9b2` to `origin/main2`, and my fresh worktree confirms it's the current tip. My validation confirms the section is correct, complete, and all links resolve — nothing remains to do.

## Completion report

**Status: already landed by a prior attempt; verified complete. No new commit needed.**

The requested `### The dispatch tier system` README section was committed and pushed to `origin/main2` as:

> **`6a50e9b2` docs(readme): explain the dispatch tier system**

It sits under `## 3. How it works` (line 345), right before the first bare tier-name mentions the reader would otherwise hit without context. Final heading + first paragraph:

> ### The dispatch tier system
>
> Every job carries a **tier**: how much model thought the job deserves. The four tiers, in descending thoughtfulness, are **mentat**, **mentor**, **minion**, and **myrmidon**. A tier is not a model. Several providers back most tiers, and the concrete model depends on which worker kind claims the job: a monk runs an Anthropic model, a cleric an OpenAI model, and the opt-in kinds (mystic, fireworker, and the like) run their own providers' models.

**Spec coverage confirmed against the fresh `skills/model-selection/SKILL.md`:**
- Four tiers in descending thoughtfulness, each with a "what it's for" + "how a job gets it" in one small table ✓
- `mentat` = manual-only via `post-manual-job.sh`, no automatic producer reaches it, claimable by whichever provider's worker is live ✓
- Automatic ceiling at `mentor`, `minion` as fallback (reaper one-step reroute, floored per-role — designers/builders stay at mentor), `myrmidon` explicitly *not* an escalation/fallback rung ✓
- Tiers are multi-provider; points to `skills/model-selection/SKILL.md` and the closed `scripts/jobs/model-tier-inventory.tsv` rather than duplicating the model table ✓
- Grounded examples reuse already-seen vocabulary: `design`/`build` at mentor (Opus on a monk), `americanize`/`deslop` as the myrmidon examples — and honestly notes the current reality that `post-job.sh` rewrites automatic jobs to mentor ✓
- The three §1 Key-vocabulary rows that name a tier (`americanize`, `deslop`, `mentat job`) now link to `#the-dispatch-tier-system` ✓

**Validation run:**
- All 4 relative links in the diff resolve (`skills/model-selection/SKILL.md`, `scripts/jobs/model-tier-inventory.tsv`, the two normalization skills); the `#the-dispatch-tier-system` anchor matches the heading slug.
- No trailing whitespace on added lines; README carries no frontmatter.
- Doc-gate link-check harnesses pass (`library-link-check-test` 42/42, `library-link-scan-test` 25/25). The library-link-checker itself is scoped to the context library (`sections/`), not the top-level README, so README relative links were verified by direct target-existence sweep.

**Follow-ups:** none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/doc-readme-dispatch-tier-section.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 56 tokens (1685061 cached reads)
- Output: 11621 tokens
- Cost: $1.8151812999999999
- Wall-clock: 177s
- Model(s): claude-opus-5-5 ×1, claude-opus-4-8 ×1

<!-- garden-usage-end -->
