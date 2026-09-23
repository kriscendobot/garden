---
kind: review-miss-dismissed
primary_job: kriscendobot-minion.town-pr69-review-6989f40d
verdict: not-a-miss
category: new-direction
review_at: 2026-09-05T04:35:08Z
repo: kriscendobot/minion.town
comment_url: https://github.com/kriscendobot/minion.town/pull/69#pullrequestreview-5119120338
identity: kriscendobot/minion.town#69:review:5119120338
producing_role: builder
producing_job: kriscendobot-minion.town-pr69-build
severity: minor
---

Maintainer Socratic naming-vocabulary probe on the gateway daemon site registry.
The reviewer asked, as an explicit "preliminary question," why the identifier the
diff called a "reference name" (`powerReferenceName`) is not simply a pet name.
The underlying value genuinely *is* an Endo `Name` — the pinned daemon defines
`Name = PetName | SpecialName` (an ordinary value is a `PetName`, an `@`-prefixed
value like `@agent` is a `SpecialName`) — so the producer's answer was
substantively correct (it is a Name), and the refinement was to stop inventing a
third term and adopt the canonical vocabulary: e9478b4 renamed
`powerReferenceName` → `powerName` and switched to "pet name or special name" at
the validation and MCP surfaces.

Dismissed as new-direction, not a review miss, on three grounds. (1) No standing
rule bound: no juror seat brief, skill, or COMMON norm encodes Endo's
`Name = PetName | SpecialName` naming taxonomy as a check the panel demonstrably
knows, so the convention was effectively first stated in the review itself. The
adjacent naming rules (stylist's "a name that lies about its value type";
`name-contradicts-value-type`, `semantic-name-matches-value-kind`) address names
that misrepresent a *type*; `powerReferenceName` did not lie about the type, it
used non-canonical *wording* for a value that is a Name — a weaker, taste-level
divergence those rules do not reach. (2) It was framed as an open preliminary
question, preference-shaped, made with full information (the term was visible in
the diff, not concealed to satisfy a metric — no evaluator gaming). (3) No panel
ran on #69 and none was due: under the manual-gauntlet-trigger regime a build
stops at a draft PR and is not gauntleted until the maintainer says "run the
gauntlet," so the absence of a panel is by-design, not a `process` miss; and even
had a panel run, no seat carries the Endo Name vocabulary, so it would not have
caught this specific choice. The primary loop's deliverable exists and is verified
in the world (commit e9478b40 on PR #69, typecheck/build/test green, CI run
33945266616 passed) — this is a genuine addressed refinement, not a false no-op.

Adjacency note for future calibration: this belongs to the Endo-idiom family the
maintainer repeatedly pushes (`prefer-endo-primitives`,
`endo-errors-over-raw-throw`, `named-imports-over-namespace`), but is the first
instance of an Endo *naming-vocabulary* divergence and the first on the
minion.town repo (the whole naming corpus is endo-but-for-bots). If a second
Endo-canonical-vocabulary naming ask recurs, revisit whether a naming cluster
("use Endo's canonical Name/PetName/SpecialName vocabulary, do not invent domain
terms") has begun to form and whether the purist/stylist brief should carry it.
