Pushed to main2 as `2f1bd76db2`.

## Completion report

**Investigation.** `roles/designer/AGENT.md:18` (and `roles/web-designer/AGENT.md:53`) cite `[prompt-section-discovery]`, but the skill was absent from both `skills/` and the CLAUDE.md inventory. Git history showed it was **never** an active skill file: it existed only on the read-only reference shelf (`references/endo-but-for-bots/skills/prompt-section-discovery.md`). The citation was ported into the designer role in commit `412bb5a9ca` ("roles: designer + scout — port from references/endo-but-for-bots/"), but the skill file itself was never created — a dangling citation since day one. The reference shelf's `skills/README.md` claimed it had been "fully adopted into the active library and the snapshots removed," which was inaccurate.

**Resolution.** Restored the skill rather than dropping the citation, since the capability is genuinely useful (find the maintainer's actual `## Prompt` input before drafting) and two active roles depend on it:
- Created `skills/prompt-section-discovery/SKILL.md`, adapted from the reference snapshot to the active library's SKILL.md conventions (purpose / inputs / procedure / output / notes), with relative links back to the designer and web-designer roles.
- Added `prompt-section-discovery` to the CLAUDE.md skill inventory in alphabetical position.

**Not changed.** Left the designer/web-designer citation text as-is — the bare `[prompt-section-discovery]` now resolves conceptually and matches its sibling bare citations (`library-lookup`, `cherry-pick-followup`). The reference README's "fully adopted" claim is now finally accurate, so no edit there.

**Follow-ups.** None required. (Minor pre-existing inconsistency, out of scope: designer's `## Skills` list mixes bare `[name]` citations with one full relative link for `worktree-per-pr`; not introduced or worsened here.)
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-fix-designer-dangling-skill-citation.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 17 tokens (393696 cached reads)
- Output: 5758 tokens
- Cost: $0.713202
- Wall-clock: 100s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
