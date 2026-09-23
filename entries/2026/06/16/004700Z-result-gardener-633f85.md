---
ts: 2026-06-16T00:47:00Z
kind: result
role: gardener
host: endolinbot
project: garden
from: gardener
to: steward
dispatch_root: /home/kris/dispatches/gardener--633f85
refs:
  - entries/2026/06/16/004000Z-dispatch-gardener-633f85.md
  - https://github.com/kriscendobot/agoric-sdk/pull/5
  - https://github.com/kriskowal/garden/commit/d106a613
---

# result: gardener — ci-failure-classification-loop landed (closes PR #5 re-prompt seam)

Per the dispatch `633f85` (forwarding kriskowal's 2026-06-16T00:39Z
directive on `kriscendobot/agoric-sdk#5`: *"there is a pattern that I
have had to manually request continued progress after CI settled …
please dispatch a gardener to fix the loop and keep it going until CI
is passing all tests"*), I landed a new skill plus the steward-side
and shepherd-side wiring needed for the loop to run autonomously.

## Shape chosen

**Hybrid A + D**: new canonical skill (Option A) + steward extension
(Option D). The skill is the rubric and the procedure; the steward
extension is what turns it on in the per-cycle scan.

Rationale:

- Option A alone leaves the rubric homeless on the steward side; the
  steward would read the skill only on explicit cite, and the
  per-cycle scan would not enter the loop without a cite.
- Option D alone (extend steward without a skill) would cram the
  classification rubric and the worked examples into the steward role
  file, which is already long and is not the natural home for
  per-cycle procedural content.
- The hybrid keeps the role file pointing at the canonical procedure
  and keeps the procedure itself in a re-usable skill body that other
  orchestrators (liaison gamut, future driver lanes) can cite without
  reading the steward role.

## Files landed (commit d106a613, main)

- `skills/ci-failure-classification-loop/SKILL.md` (new). The
  canonical procedure: four-class rubric (A expected, B structural
  impasse, C tractable, D regression), four-phase cycle (Observe,
  Orient, Decide, Act), termination conditions (green / A+B only /
  no-progress / authorization gap), regression-detection rules, and
  composition with the shepherd, the auto-pickup chain, the per-cycle
  procedure, and the gamut. Worked examples cite the
  `ba72cd` → `cb7a05` → `cc9bb5` chain on PR #5.
- `roles/steward/AGENT.md`: Auto-pickup chains gains a *Fixer →
  fixer (CI failure classification loop)* sub-section naming the
  skill as the standing form of the Shepherd → fixer chain. A
  2026-06-16 notes-from-the-field row cites the PR #5 precipitating
  chain and the maintainer's framing.
- `roles/shepherd/AGENT.md`: Skills gains a cross-reference to the
  new skill so the shepherd's escalation-class vocabulary aligns with
  the loop's rubric (the shepherd does not run the loop itself; its
  dispatch is one *Act* step inside the loop).
- `CLAUDE.md`: inventory gains `ci-failure-classification-loop`.

A pre-compaction parallel attempt at `/home/kris/skills/ci-ooda-loop/`
(no wiring) was discarded as an orphan during reconciliation; the
landed version retained the more thorough body and the staged
steward / shepherd wiring.

## How a future steward / shepherd uses this

- **Steward, per-cycle scan**: for each open PR the steward owns,
  read the most recent `result` entry. If it carries a classification
  table and a non-terminal disposition, the PR is mid-loop. Enter the
  skill: read the latest CI rollup, classify into A / B / C / D,
  apply the decision rule (D first, then C, terminate on A+B-only or
  green or no-progress or authorization-gap), and dispatch the next
  fixer with the classification table inlined into the brief. Write
  the cycle's `result` entry with the next classification table; that
  becomes the next cycle's `prior_classification`.
- **Shepherd, in-dispatch**: continues to drive *one CI cycle* to
  green inside its own dispatch per its own *Operating norms*. On
  escalation, its `result` enumerates failure classes using the same
  rubric (A / B / C / D); when more than one class is in play, cite
  the loop skill so the steward picks it up across cycles.
- **Liaison, in-session gamut**: when running the gamut on a PR and
  CI goes red between stages, the loop is the gamut's CI-side
  subroutine. The liaison cites the skill in the engagement notes
  and runs the loop in-session until termination, then resumes the
  gamut.

## Self-improvement

The pre-compaction reconciliation revealed two parallel gardener
attempts (one in the dispatch root under
`skills/ci-failure-classification-loop`, one in the main worktree at
`/home/kris/skills/ci-ooda-loop`) that did not detect each other. The
naming divergence (`ci-failure-classification-loop` vs `ci-ooda-loop`)
made the duplication visible during reconciliation; if both had used
the same name, one would have overwritten the other silently. The
post-compaction recovery path should grep for unstaged work and any
untracked skill directories before authoring a new SKILL.md.

## Recommended next step for PR #5

The steward's next per-cycle wake on `kriscendobot/agoric-sdk#5`
should:

1. Read the head SHA's current statusCheckRollup.
2. Enter the new loop skill.
3. Classify against the `cc9bb5` result's prior table.
4. Dispatch the next fixer (if Class C remains) or surface the
   remaining A + B failures to the bulletin (if only those remain).

This will demonstrate the loop in action without further re-prompt
from the maintainer.

The dispatch root (`/home/kris/dispatches/gardener--633f85`) is ready
for teardown.
