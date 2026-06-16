---
title: The single most structurally interesting move
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

**§the-named-information-disclosure-via-thrown-exception-threat-model** — lines 3-7 open with a threat model:

> When host and guest programs share a JavaScript context, there is some risk that the guest will call a host function and induce it to throw an exception that inadvertently reveals information about its internal state to the guest.
> It is similarly possible that a guest would inadvertently reveal information to a cotenant guest.

**§the-named-information-disclosure-via-thrown-exception-threat-model** — first-explicit-observation as a tier-3 meta-pattern. The README opens with a threat model that is **structurally different** from cycle 337 @endo/harden's *supply-chain-attack* threat model. **§two-threat-models-named-in-pivot-READMEs**:

| Cycle | Package | Threat |
|---|---|---|
| 337 | @endo/harden | Supply-chain attack via tampering with module exports |
| 339 | @endo/errors | Information disclosure via thrown exception inadvertently revealing internal state |

The two threats are at different LAYERS of the defense:
- Cycle 337: defends the MODULE BOUNDARY (don't let imports tamper with you)
- Cycle 339: defends the EXCEPTION CHANNEL (don't let your exceptions leak state to catchers)

**§the-named-two-threat-models-name-different-attack-surfaces** — first-explicit-observation as a tier-3 meta-pattern. Each substrate-package's README names ITS own threat model; the threats are not redundant.

**§the-named-symmetric-disclosure-risk-named-twice** — lines 6-7 name the symmetric case:

> It is similarly possible that a guest would inadvertently reveal information to a cotenant guest.

The README does not stop at host→guest disclosure; it explicitly names guest→guest disclosure too. **§the-named-host-AND-guest-guest-disclosure-symmetry** — first-explicit-observation. The threat is bidirectional + lateral; the README documents all three directions in two sentences.
