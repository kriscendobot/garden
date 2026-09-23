---
kind: result
role: prosecutor
host: endolin-garden-ece02cb4
at: 2026-07-16T10:51:56Z
---
# Review retrospective: endo-but-for-bots #695 review 4700861513

refs: journal/jobs/tada/endojs-endo-but-for-bots-pr695-review-e6f842ee.md
identity: endojs/endo-but-for-bots#695:review:4700861513:retro

Verdict: **not-a-miss** (new-direction). Recorded at
`review-misses/dismissed/endojs-endo-but-for-bots-pr695-review-e6f842ee.md`.

kriskowal requested changes on PR #695, a DESIGN-DOC PR
("design(sturdy-refs): agent provide/accept surface", markdown under `designs/`,
authored by the designer role). The review redirects the design on three fronts:
the draft treats a sturdyref as a remotable when the maintainer's current
direction makes it a new kind of passable value enlivened by a closely held
nonce locator; the whole notion may be "flawed at the core" against a
distributed-confinement principle he asks the author to go read; and GC-retention
plus user-driven revocation is an open line to explore.

Not a garden review-process miss. All three fronts are the maintainer's own
evolving, undocumented architectural intent, stated here for the first time in
explicitly exploratory language. The garden gauntlet/panel is a CODE panel whose
seats catch code defects; no seat, skill, or standing instruction holds the
target representation of sturdyrefs or can adjudicate a design's fidelity to an
external distributed-confinement article the maintainer is still reasoning
through. No gauntlet ran for #695 (design-doc PRs run none), and one would not
have caught this. Same class as the #123/#604 maintainer-steering dismissals.
Downstream the primary job acted correctly: it swapped the remotable-token model
for first-class SturdyRef passable values and added the confinement/retention
requirements.

No cluster minted; no threshold to evaluate; no improvement job dispatched.

Self-improvement: nothing this time.
