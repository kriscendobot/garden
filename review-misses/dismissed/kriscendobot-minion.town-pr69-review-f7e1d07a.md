---
kind: review-miss-dismissed
primary_job: kriscendobot-minion.town-pr69-review-f7e1d07a
verdict: not-a-miss
category: new-direction
review_at: 2026-09-05T04:55:05Z
repo: kriscendobot/minion.town
pr: 69
comment_url: https://github.com/kriscendobot/minion.town/pull/69#pullrequestreview-5119837026
identity: kriscendobot/minion.town#69:review:5119837026
producing_role: builder
producing_job: kriscendobot-minion.town-pr69-build
severity: minor
---

Maintainer architectural-direction ask on the gateway daemon site registry
(inline comment 3939501084 on `src/endo/gateway/daemon-site-registry.ts`). The
reviewer stated that the `identify` / `storeIdentifier` methods on Guest agent
facets are slated for retirement, that the code should carry a name rather than
an intermediate formula identifier (the name was already in scope a few lines
up), and asked for a sweep of the change for similar intermediate-formula-id
round trips.

Dismissed as new-direction on three grounds. (1) No standing rule bound: no
juror seat brief, skill, context page, or COMMON norm says to avoid minting or
threading formula identifiers across the Guest boundary when a pet name will do,
or that `identify`/`storeIdentifier` are deprecated; a grep of roles/, skills/,
and context/ finds neither term. The retirement is a forward-looking Endo API
direction ("we will need to retire"), first stated in this review; the pinned
daemon still exposes both methods, so no panel could have flagged their use as a
violation. (2) It is not the `prefer-endo-primitives` pattern (reuse an existing
Endo helper instead of hand-rolling one) nor `capability-hardening-attenuation`
(narrow a granted power): the code used a supported Endo primitive; the ask is to
change which primitive the design routes through. (3) No panel ran on #69 and
none was due under the manual-gauntlet-trigger regime (no gauntlet/panel job for
this PR in jobs/tada/), matching the sibling dismissal
kriscendobot-minion.town-pr69-review-6989f40d; even a panel would carry no seat
lens for this Endo-internal API direction.

World check on the primary: the deliverable exists — commit ddb13cba on #69
("copy guest powers by name") removes the intermediate power formula id and its
guest identify/storeIdentifier round trip; #69 later merged. The follow-up sweep
(#100) left one `identify` for the new directory's own id and the operator-side
`storeIdentifier`, with replies explaining why; two sweep replies on the thread
disagree in wording (one says "declined for now", the next reports the power
round trip removed), a minor reply-hygiene inconsistency, not a review miss.

Adjacency note: this is the second Endo-naming-flavored ask on minion.town #69
(after the pet-name vocabulary probe, 6989f40d), both on the same PR. A one-PR
pair does not form a systemic cluster. If "prefer a name over a formula
identifier across agent facets" recurs on a second PR, mint a cluster (e.g.
`names-over-formula-identifiers`) and consider a purist/locksmith brief line plus
a panel-hints probe on `identify(`/`storeIdentifier(` in diffs.
