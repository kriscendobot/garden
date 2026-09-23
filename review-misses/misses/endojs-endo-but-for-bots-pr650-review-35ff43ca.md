---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr650-review-35ff43ca
verdict: miss
category: naming
pr: 650
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/650#pullrequestreview-4673308688
identity: endojs/endo-but-for-bots#650:review:4673308688:retro
producing_role: gardener
producing_job: gauntlet-endo-but-for-bots-pr650-mount-revocation-caretaker-deny-patterns
missed_by: stylist
severity: minor
cluster: avoid-name-abbreviations
cluster_pattern: An abbreviated identifier in freshly-authored code (dir, Arg, subDir) that a panelled PR let through — the maintainer repeatedly asks names be spelled out in full; no code-panel naming seat or gate mechanically flags abbreviation.
---

# Miss: abbreviated identifier `dir` in panelled new test code on #650

kriskowal's CHANGES_REQUESTED review on #650 (PR A of the #127 mount-revocation
reconstruction) carried two inline comments on the freshly-authored
`packages/daemon/test/mount-revocation.test.js`, both paraphrased here (verbatim
untrusted text at `comment_url`):

1. **line 40 — a naming ask:** avoid the abbreviation in the name. The flagged
   name was the local `dir` in the `makeTempRoot` helper; the primary loop
   renamed it `directory`.
2. **line 439 — a test-strengthening ask:** make the deny-and-revocation
   composition test pass a *novel* denied segment (not just the default set) so
   the assertion distinguishes an applied custom `deniedSegments` option from the
   passive defaults. The primary added a `vault` segment.

## Grounds (miss — the naming ask, comment 1)

**The garden's own precedent names this exact moment a miss.** The prior retro on
`endojs/endo-but-for-bots#592` (dismissed record `…-pr592-review-79bd1b73`) set an
explicit trip-wire when it dismissed the same kind of ask (`Arg` → `pathComponent`/
`segment`): *"Were a SECOND garden-authored PR later to draw the same
identifier-abbreviation naming ask AFTER its panel had run (so the ergonomist/
stylist demonstrably had a turn and missed it), that would be the moment to record
a naming miss and consider a cluster."* #650 satisfies every clause: the code is
**garden-authored** (built by the mount-revocation build + gauntlet, not legacy),
the **code panel demonstrably ran** (the gauntlet report records 19 seats including
the always-on `stylist` naming seat, and the panel itself added tests to this very
file), and the maintainer nonetheless had to flag `dir`. The two escape hatches
that dismissed the earlier instances are both absent here — unlike #592 (still
DRAFT, no panel) and #127 (`subDir` lived in un-panelled #37/#127 legacy code and
was already renamed on the `llm` branch). This is the first identifier-abbreviation
ask to land on a work product the panel actually reviewed.

**Grounds it is genuinely a review miss, not new direction:** the abbreviation is
plain (`dir` for `directory`) with no domain-vocabulary ambiguity, it sits in code
the garden wrote and the panel passed, and the maintainer's preference is
consistent and long-standing (three PRs: `Arg` #592, `subDir` #127, `dir` #650,
plus his "I've provided feedback in the past" note on #592). The `stylist` code-
panel seat reads for "identifiers crisp and unambiguous," but its brief encodes no
mechanical *never-abbreviate* check, so an abbreviated-but-unambiguous local slips
its lens. That is the sense-gap this record opens the `avoid-name-abbreviations`
cluster to close.

## Why comment 2 (the test-strengthening ask) is NOT clustered as a miss

Comment 2 is a should-fix test refinement, not a review miss. The suite already
proves the override plumbing with distinguishing inputs elsewhere (`override: a
custom set replaces the default` uses `['secret']`; `override: callers extend the
default by spreading` uses `[...defaultDeniedSegments, 'extra']`), so there is no
coverage gap. The composition test's stated claim — deny AND revocation are both
active on a revocable mount — is genuinely satisfied by the default set; the
maintainer is asking it to *also* prove that a custom set composes with revocation,
a first-stated strengthening of one specific test's assertion power. Real and worth
doing, but taste about which test carries which proof, not a defect the panel let
through. Recorded here so it is not separately re-litigated; it mints no cluster.

## Threshold call recorded at this record's tail

The `avoid-name-abbreviations` cluster is **minted at count=1 (PRs {650})** and
**held below the floor** (K≥3 across ≥2 PRs not met). The severity bypass does not
apply: it requires a standing rule that already existed and did not bind, but the
honest finding — established by the #592 record and re-verified here — is that **no
garden seat, skill, or gate encodes identifier-abbreviation avoidance** (the
`no-latin-shorthand` skill governs Latin prose abbreviations like i.e./e.g., not
identifiers; `rename-discipline` governs gratuitous renames; the stylist/ergonomist
naming lenses carry no mechanical never-abbreviate check). The gap is a
*prevention* gap to be created, not a sense-and-correct failure of an existing
rule, and a lone `dir`→`directory` nit is `severity: minor`. Per the #592
precedent's own "consider a cluster" framing, the disciplined call is to record the
first panelled miss and accumulate. The two prior dismissals (#592 `Arg`, #127
`subDir`) are cited as evidence the maintainer's preference is real and recurring,
but do not count toward K (dismissals mint no cluster). A second panelled
abbreviation miss should trip this cluster for a `review-improve-*` dispatch.
