---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-22T06:29:42Z
---
---
kind: result
role: prosecutor
refs:
  - endojs/endo-but-for-bots#475:review:4965188867:retro
  - endojs-endo-but-for-bots-pr475-review-1c83e1bb
---

# Retro on endojs/endo-but-for-bots #475 review 4965188867 (erights) — MISS recorded, holding

Second-loop review-retrospective for the erights review on #475 (single inline
comment on `packages/ocapn/src/syrup/compare.js`: bring the plain
backward-compat re-export into compliance with the re-export policy, AND propose
a gauntlet/memory change that prevents future violations, for both maintainers
to review).

**Verdict: miss** (`packaging-exports`). The builder authored
`compareImmutableArrayBuffers` as a plain backward-compat re-export of the
canonical `compareBytes` — the exact shape the endo re-export policy governs
(deprecate + migrate importers, not a bare re-export). The packaging seats
(curator, surfacer) read the export surface but neither brief encodes the
*deprecation* half of the policy, so surface *coherence* held while the policy's
purpose went unmet. This is a standing endo convention ("our current policy"),
not new direction — directly parallel to the recorded
`named-imports-over-namespace` miss (convention real, not yet encoded in any
seat/skill/gate). Recorded to
`review-misses/misses/endojs-endo-but-for-bots-pr475-review-1c83e1bb.md`, new
cluster `plain-reexport-deprecation-policy` (count=1, prs=[475], open).

**Threshold: hold, no dispatch.** Below the floor (K≥3 across ≥2 PRs; this is
count=1, single PR). No severity bypass: severity minor, and the policy was not
a standing rule already encoded that failed to bind (its absence is the miss).
Independent reinforcing reason to hold: the exact prevention+sensing deliverable
is already in flight through the channel the maintainer mandated —
kriscendobot's reply 3809967014 posted the garden design job
`garden-gauntlet-reexport-policy-check` (present in jobs/plan/, gate deferred) to
draft the preventive gauntlet check plus the codified author-facing policy, for
kriskowal and erights to review before landing. Dispatching a parallel
`review-improve-*` builder job now would duplicate it and bypass the
maintainer-review erights explicitly required. If the cluster later reaches the
floor (a second distinct PR authors an undeprecated plain re-export), or the
design job is dropped, revisit dispatch.

**Verified against the world, not the primary report.** The primary job was
reaper-doomed requeue-exhausted (never ran to a tada report) and sits parked in
jobs/plan/. Yet on the live PR head (`feat/narrow-bytearray-to-uint8`,
affe74453e) `compare.js` contains no `export … from` re-export at all —
`compareImmutableArrayBuffers` is now a local wrapper over `thawedBytes` +
`compareUint8Arrays` — so the first ask is genuinely resolved in the world, and
the design follow-up for the second ask genuinely exists on the board. The
primary's silent requeue-exhaustion is a machinery-reliability signal (mentor
loop), out of scope here.

Self-improvement: none this pass — the discriminator, world-grounding, and
threshold floor all applied cleanly, and the maintainer-mandated design channel
already owns the sensing deliverable, so the loop correctly held rather than
minting a redundant improvement job.
