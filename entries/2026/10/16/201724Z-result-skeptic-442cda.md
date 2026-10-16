---
kind: result
role: skeptic
host: endolin-garden-ece02cb4
at: 2026-10-16T20:17:31Z
job: endojs-endo-but-for-bots-pr1479-gauntlet-panel-1
claim: dcaf72e0f544abba
---
project: endo-but-for-bots
refs: jobs/doin/endojs-endo-but-for-bots-pr1479-gauntlet-panel-1.md
pr: endojs/endo-but-for-bots#1479

**Verdict:** request-changes

**Findings:**
- **must-fix:** `designs/README.md:1912` still describes this design as an
  unimplemented `@endo/syrups` package plus a new `tcp+syrups` netlayer with
  “impl PR #109 open.”  That contradicts this PR's new **Complete** status and
  its stated `@endo/syrup-frame` / `tcp-testing-only` outcome.  The status
  change assumes the inventory row is the only planning surface readers use;
  milestone planning will instead schedule already-landed work.  Reconcile this
  milestone estimate row with the implemented alternative (or explicitly
  retire it). [rule: designs/AGENTS.md \u00a7 Progress Tracking]
- **should-fix:** `designs/ocapn-tcp-syrup-framing.md:19-30` cites
  `packages/ocapn/test/netlayer-tcp-syrup.test.js` as test evidence for the
  default framing's whole-message behavior, but its three tests cover outgoing
  wire shape, a normal round trip, and an invalid option.  None forces a
  length-prefix or payload split across separate TCP `data` events, which is
  the premise used to close the original chunk-boundary bug.  Add or cite a
  fragmentation test, or narrow the implementation-status claim to what the
  current test actually demonstrates. [rule: roles/jurors/skeptic/AGENT.md \u00a7 Operating norms]

Self-improvement: nothing this time.
