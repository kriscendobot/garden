---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr475-review-1c83e1bb
verdict: miss
category: packaging-exports
pr: 475
cluster: plain-reexport-deprecation-policy
cluster_pattern: A plain backward-compatibility re-export (`export { orig as alias } from '…'`) is authored instead of deprecating the alias and migrating importers to the original export; the endo re-export policy (deprecate plain re-exports, point importers at the source) is not encoded in any seat brief, skill, or gate.
review_at: 2026-08-18T19:53:55Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#pullrequestreview-4965188867
identity: endojs/endo-but-for-bots#475:review:4965188867:retro
producing_role: builder
missed_by: curator, surfacer (packaging/public-surface seats)
severity: minor
---

Maintainer erights, replying on an existing thread on
`packages/ocapn/src/syrup/compare.js`, invokes the project's standing re-export
policy: a *plain* re-export must be deprecated (pointing importers at the
original export) and all importers migrated to import only from the original. He
asks that, if the re-export is still present, it be brought into compliance, and
— separately — that a gauntlet/memory change be proposed (for both maintainers'
review) so the review process prevents and never re-authors such violations.

The indicted artifact: in June 2026 the builder, resolving kriskowal's request to
route byte comparison through `@endo/bytes`, added `compareImmutableArrayBuffers`
to `compare.js` as a *plain backward-compatibility re-export* of the canonical
`compareBytes`. That is exactly the shape the policy governs — a bare re-export
kept "for backward compatibility" rather than a deprecation + importer migration.

Grounds (a miss, `packaging-exports`). This is a pre-existing endo house policy
("our current policy for re-exports"), not new direction, taste, or a
first-stated requirement: the maintainer names it as *current* policy and asks
for it to be *encoded*, which is the signature of a standing convention the
review lacked a check for — directly parallel to the recorded
`named-imports-over-namespace` miss ("no garden seat brief, skill, or gate
encodes this yet"). The panel's packaging/public-surface seats (curator,
surfacer) are the ones positioned to catch it: both briefs already read the
export surface and the `index.js` re-export thunk, but neither encodes the
*deprecation* half of the policy, so an undeprecated backward-compat re-export
passes their measurable checks (surface *coherence* holds) while the policy's
purpose goes unmet. A backward-compat re-export authored in place of a
deprecation is a canonical surface smell those seats should question; that it
was not in their briefs is precisely why this is a review miss and why the
sensing half is needed. Severity minor: the re-export had correct runtime
behavior; the defect is policy/hygiene, not correctness.

Verified against the world, not the primary report. The primary job
(endojs-endo-but-for-bots-pr475-review-1c83e1bb) did NOT close cleanly — the
reaper doomed it requeue-exhausted (doomed_at 2026-08-19T02:03:05Z, 5 cycles)
and it now sits parked in jobs/plan/ under gate go-ahead, never having run to a
tada report. The directive was nonetheless satisfied by a later independent
action: on the current PR head (`feat/narrow-bytearray-to-uint8`,
affe74453e) `compare.js` no longer contains any `export … from` re-export —
`compareImmutableArrayBuffers` (lines 98–99) is now a locally-defined wrapper
that imports `thawedBytes` from `@endo/immutable-arraybuffer` and calls the
local `compareUint8Arrays`. So the plain re-export the policy targeted is gone
in the world (first ask genuinely resolved, not an unverified peer no-op), and
kriscendobot's reply 3809967014 (2026-08-19T04:06:04Z) additionally posted the
garden design follow-up `garden-gauntlet-reexport-policy-check` (present in
jobs/plan/, gate deferred) that will draft the preventive gauntlet check + policy
codification for kriskowal and erights to review before landing — the exact
prevention+sensing deliverable this loop would otherwise mint, already in flight
through the maintainer-mandated review channel.
