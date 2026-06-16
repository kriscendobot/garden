---
title: §the-named-package-coordinates-with-named-other-package
source: endo--packages-errors-README-md
url: https://github.com/endojs/endo/blob/master/packages/errors/README.md
authors: [Kris Kowal, Mark S. Miller, Endo project (collective)]
repo: endojs/endo
path: packages/errors/README.md
total-lines: 13
ingest-cycle: 339
ingest-date: 2026-06-15
lane: designs
section-tags:
  - the-named-information-disclosure-via-thrown-exception-threat-model
  - the-named-host-vs-guest-information-disclosure
  - the-named-symmetric-disclosure-risk-named-twice
  - the-named-host-AND-guest-guest-disclosure-symmetry
  - the-named-redacted-messages-as-package-purpose
  - the-named-package-coordinates-with-named-other-package
  - the-named-coordination-with-ses-for-console-reveal
  - the-named-redacted-vs-revealed-asymmetry
  - the-named-two-audiences-different-privileges
  - the-named-NEW-SHORTEST-README-in-pivot
  - the-named-thirteen-line-README-as-floor
  - the-named-fifteenth-package-in-the-pivot-cluster
  - the-named-collection-package-and-substrate-policy-third-shape-emerges
  - the-named-streak-of-zero-cross-package
  - two-threat-models-named-in-pivot-READMEs
  - thirty-cycles-with-named-pivot-domain-stay
  - sixty-eight-citation-arc-closures-in-pivot-now
parent: endo--packages-errors-README-md--fifteenth-package-information-disclosure-threat-model-with-package-coordinates-with-ses
---

Lines 11-13:

> In coordination with [ses](../ses/) in the host realm, the information redacted by these utilities will be revealed to the realm's console for use in debugging, but be invisible to code that catches them.

**§the-named-package-coordinates-with-named-other-package** — first-explicit-observation as a tier-3 meta-pattern. The README NAMES THE COORDINATION: @endo/errors does not work alone — it coordinates with `ses` in the host realm. The coordination provides:
- **Safety**: information invisible to code that catches the errors
- **Debuggability**: information revealed to the realm's console

**§the-named-redacted-vs-revealed-asymmetry** — first-explicit-observation. Two audiences with different privileges:

| Audience | What they see |
|---|---|
| Code that catches the error | Redacted message (no internal-state leak) |
| Realm's console | Full message (for debugging) |

**§the-named-two-audiences-different-privileges** — first-explicit-observation as a tier-3 meta-pattern. The discipline: when an artifact must serve both *defender* and *debugger*, route different content to each audience based on capability. Compare to:
- Cycle 87 pass-style/error.js: §V8-stack-accessor-channel — stack is a capability channel
- Cycle 337 @endo/harden: intrinsic-over-endowment for capability protection
- Cycle 339 @endo/errors: redaction channels by audience capability

**§three-cycles-with-named-capability-channel-by-audience** (87 + 337 + 339) — first-explicit-observation as a tier-3 meta-pattern. Three different shapes of routing capabilities/information by audience-capability.

**§the-named-coordination-with-ses-for-console-reveal** — first-explicit-observation. The README points to `../ses/` (relative path within the monorepo). The coordination is *named* and *located*. Compare to cycle 337 @endo/harden's *"prepare-* convention"* (named cross-package relationship via naming convention); cycle 339's coordination is a direct path-citation to the coordinating package.
