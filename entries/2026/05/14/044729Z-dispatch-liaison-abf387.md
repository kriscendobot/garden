---
ts: 2026-05-14T04:47:29Z
kind: dispatch
role: liaison
project: garden
to: "*"
refs:
  - entries/2026/05/14/044729Z-dispatch-liaison-d0c5ed.md
prs:
  - repo: endojs/endo
    pr: 3232
    role: source-of-feedback
---

# Dispatch: gardener encodes recurring patterns from #3232 feedback into skills/roles

Dispatch root: `dispatches/gardener--encode-patterns-from-3232-feedback--20260514-044729--abf387/`.

Maintainer directive (this session): "Please also dispatch a gardener to adjust skills and roles based on the feedback" (on endo#3232).

The feedback from kriskowal on #3232 surfaces recurring patterns the bot's builders/fixers/boatmen keep generating. The gardener's job: distill them into role/skill updates so future engagements don't keep producing the same shape of comment.

## Patterns visible in #3232 (read the full feedback before deciding which to encode)

Sample patterns from comments at dispatch time:

1. **Gratuitous renames.** Multiple inline comments tag a rename as gratuitous and ask for the prior identifier ("This was better when named `random`, unless there was a shadowing issue I don't see"; "Ditto. Gratuitous rename."). The bot is renaming identifiers without a forcing reason. The right discipline: **never rename in a refactor unless required by a documented constraint (shadowing, name collision, the maintainer asked, a published API change)**. This is likely a builder / fixer / weaver discipline; possibly an addition to `pr-formation` or a new `rename-discipline` skill.

2. **Changeset hygiene.** Several comments target changeset bodies:
   - Stale interface descriptions ("The interface documented here is stale").
   - Outdated claims ("No longer true").
   - Implementation-detail commentary not relevant to package-update consumers ("Omit as not interesting to package authors updating dependencies").
   - Multiple changesets for a single release-cycle change ("We have only made one change in this release cycle, when this PR merges. Please consolidate these changeset").
   - Process commentary in changeset bodies ("Please omit gratuitous process comment").
   
   The active library carries `skills/changeset-discipline/SKILL.md` (per the inventory). Either update it with these field-tested rules, or create `skills/changeset-hygiene/SKILL.md` if the existing skill is procedural-only and the new content is content-discipline.

3. **Test additions for equivalence claims.** "Let's add an assertion to the test suite to make sure this equivalence sticks." When a PR claims an equivalence (e.g., "the new interface is equivalent to pure-rand-v8 structurally"), there should be an assertion test backing it. This is a `pre-pr-checklist` or `regression-evidence` discipline.

## Task

1. **Read the full feedback** on #3232: `gh pr view 3232 -R endojs/endo --json reviews,latestReviews,reviewRequests`; `gh api repos/endojs/endo/pulls/3232/comments`. Extract the full set of patterns (not just the three above; the dispatch survey was incomplete).

2. **Map each pattern to the right surface**:
   - Existing skill → update its body + notes-from-the-field row dated 2026-05-14.
   - Missing skill → author a new skill if the pattern is dense enough to warrant its own file.
   - Role file → add an operating-norm bullet citing the new/updated skill.
   - `pr-formation` skill is the natural carrier for "produce a PR the maintainer doesn't have to clean up" disciplines.

3. **Don't bloat.** Each updated skill should remain 1-2 screens. If the new content is a single line, fold into an existing skill rather than creating one. If multiple comments share a root cause (e.g., "gratuitous renames" appears 3+ times), the new rule's prose should call out the recurrence as the lesson.

4. **Cite the source.** Each new rule's notes-from-the-field row names #3232 and the specific comment ID(s).

## Out of scope

- No PR edits.
- No retroactive sweeps of other open PRs to enforce the new rules; future engagements pick them up.
- No modifications to fixer/builder per-role behavior beyond the operating-norm citation of the new skill text.

## Commits

Suggested split on `main`:
- A commit per skill touched (one if you only update `changeset-discipline`; multiple if you create new skills + edit pr-formation).
- A final commit for any role-file citations.

Push at end. Journal result entry.

## Report

Files edited, patterns encoded (one line per pattern with the destination skill/role), one-line confirmation that the next builder/fixer dispatch reading those skills will avoid the #3232-shaped feedback.
