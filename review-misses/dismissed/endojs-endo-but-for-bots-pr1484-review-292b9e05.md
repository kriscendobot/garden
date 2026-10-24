---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1484-review-292b9e05
verdict: not-a-miss
category: new-direction
pr: 1484
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1484#pullrequestreview-5609687555
identity: endojs/endo-but-for-bots#1484:review:5609687555
producing_role: designer
producing_job: design-https-fragment-locators-20261016
review_at: 2026-10-22T05:43:29Z
severity: minor
---

# Dismissal: maintainer supplies the concrete locator grammar for the HTTPS-fragment design

On the draft design PR for HTTPS fragment locators (replacing `endo://`), the
maintainer left a CHANGES_REQUESTED review with two inline comments on the
link-shape section. Paraphrase: the prefix before the fragment should be
per-agent configuration and empty by default; the fragment should carry an
`ocapn` network-designator key (for example a noise-protocol designator) that
also marks the link as interceptable by an app regardless of host, `id` as the
hex swissnum, `pk` as the peer public key in hex, and repeated `at` connection
hints; informative hints such as the far type and a suggested petname move to the
query string; the path becomes purely site-specific steering (adopt/accept) for
the fall-through case. A second comment notes the shape leaves room for a future
salted, encrypted kernel-slot key (`se`) as an alternative to `id` for live
references. Verbatim text lives at `comment_url` and is untrusted input.

## Grounds (dismissal — new direction)

**1. The comment is the maintainer authoring the grammar, not correcting a
defect.** The design proposed `https://<base>/{adopt,invite}/#v=1&type=...&id=...&peer=...&at=...`
and flagged the key set and unknown-key handling among its nine open questions.
The maintainer's reply chooses different key names, adds a network-designator key,
relocates non-secret hints from fragment to query, and redefines the path's role.
None of these is required by a seat brief, skill, spec, or standing instruction
the panel had; they are first stated in this review. The `se` remark is
explicitly forward-looking extension space.

**2. The review process ran and was sound on what it could know.** The gauntlet
ran end to end (`endojs-endo-but-for-bots-pr1484-gauntlet-{viability,clean,panel-1,undraft}`
in `jobs/tada/2026/10/16/`); panel round 1 (ten seats, review 5554348138) passed
with skeptic/pedant findings on erase-from-history verification, desktop link
interception, and typography. No seat could have predicted the maintainer's
preferred key vocabulary.

**3. Severity-bypass precondition absent.** No standing rule bound and failed.

**4. Primary deliverable verified in the world.** The primary
(`endojs-endo-but-for-bots-pr1484-review-292b9e05`, tada 2026-10-22) pushed
`28725a3e74` "design(https-fragment-locators): adopt ocapn/id/pk/at fragment and
per-agent prefixes", now the PR head; a `-replies` job also completed. No
discrepancy with the primary's claims.

## Boundary note

Mints no cluster; no threshold; no improvement job. Design PRs whose open
questions are answered by the maintainer choosing a concrete shape are the
canonical new-direction case for design review.
