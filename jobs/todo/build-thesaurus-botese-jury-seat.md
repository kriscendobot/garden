---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Add a "thesaurus" jury seat for Botese (AI-slop cliché phrases)

Maintainer directive (kriskowal, GitHub review comment
https://github.com/endojs/endo-but-for-bots/pull/1281#discussion_r4028527867,
2026-09-16): "The gauntlet should have caught this automatically, in the same
manner as deterministically detecting British English spellings and
agentically fixing them in a loop. Please dispatch a job to add a thesaurus
role to the jury panel for all the known words of Botese like seam,
load-bearing, and so on." The panel itself had already flagged the trigger
example in round 6 of that same PR (the `pruner` seat: repetitive
"known"/`false`-permit rationale restated 4 times; "load-bearing" appeared in
one of the affected comments).

## Mirror the existing British-English mechanism exactly

This is a direct structural port of
[american-english-normalization](../../skills/american-english-normalization/SKILL.md)
(design: `designs/american-english-spelling-panel.md`) — same shape, different
word/phrase domain. Read that skill and design in full before starting; do not
reinvent the pattern.

1. **New skill** `skills/botese-normalization/SKILL.md` (or a name you judge
   clearer — "thesaurus" was the maintainer's word for the jury seat, not
   necessarily the skill name): documents the curated, auditable phrase list,
   the exclusion discipline, and how it's consumed. Co-located data file
   (`cliches.tsv` or similar) — **enumerated literal phrases, not heuristics**,
   mirroring `divergences.tsv`'s "no suffix or pattern rows" decision (PR #75).
   Seed the list with exactly the two examples the maintainer gave — **`seam`**
   and **`load-bearing`** — used in the AI-cliché sense (e.g. "this is the seam
   where X happens", "the load-bearing invariant is..."), NOT flagging every
   literal use of those words in genuinely appropriate contexts (a real
   architectural seam, a real load-bearing wall in unrelated prose) — this
   needs the SAME false-friend/precision-over-recall discipline the British-
   English list uses, likely harder here since these are common words used
   both literally and as clichés, not distinctive misspellings. Think hard
   about how to keep this a low-false-positive, auditable check rather than a
   vibes-based "sounds botty" heuristic — consider requiring the cliché
   phrase's specific pattern (e.g. "the load-bearing X" as a construction)
   rather than bare word matching, if that's what precision requires. Curation
   stays maintainer-reviewed going forward, same as the orthographer list —
   don't have this job invent a large word list unilaterally; two seed entries
   plus the mechanism is the deliverable, not an exhaustive thesaurus.
2. **New jury seat** `roles/jurors/thesaurus/AGENT.md` (mirroring
   `roles/jurors/orthographer/AGENT.md`), wired into the panel the same way.
3. **Deterministic seat-gate grep**, mirroring
   `scripts/jobs/gardening/orthographer-divergence-grep.sh` (no LLM,
   search-gated — only dispatches when there's an actual hit on the diff's
   added lines).
4. **Fixing role/loop**: mirror how `americanizer`
   (`roles/americanizer/AGENT.md`) runs the deterministic apply-then-re-grep
   loop to a zero-candidate fixpoint. Same scope note as the orthographer:
   this is a garden/house convention for maintainer-authored (bot +
   maintainer) prose, not imposed on external contributors (external-author
   findings downgrade to `drop`, per panel-review's external-author
   calibration — mirror that too).
5. Wire into `skills/panel/SKILL.md` / `skills/panel-review/SKILL.md` and the
   panel seat roster the same way the orthographer seat is wired.

Regression-test the deterministic grep the same way
`orthographer-divergence-grep.sh` presumably has coverage — false positives on
legitimate literal uses of "seam"/"load-bearing" are exactly the failure mode
to guard against; write a test that pins BOTH a true-positive cliché usage and
a false-positive-avoided literal usage.

Reply on the PR thread (already RSVP'd from the liaison; you don't need to
post that ack again) once landed, or if you hit a design fork worth surfacing
to the maintainer before committing to a phrase-matching strategy.
