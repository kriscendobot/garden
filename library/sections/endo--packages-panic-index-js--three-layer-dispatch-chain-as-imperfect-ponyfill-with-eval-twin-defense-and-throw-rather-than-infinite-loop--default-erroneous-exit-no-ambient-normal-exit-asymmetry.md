---
title: §Default-erroneous-exit + no-ambient-normal-exit asymmetry
source: endo packages/panic/{index.js,README.md,SECURITY.md,CHANGELOG.md}
source-slug: endo--packages-panic
ingest-cycle: 197
ingest-date: 2026-06-06
lane: chat
authors: [Mark Miller, Kris Kowal]
keywords:
  - ponyfill-vs-shim distinction
  - Eval Twin Problem
  - registered-symbol vs novel-subclass
  - three-layer dispatch chain
  - infinite-regress check
  - throw-rather-than-infinite-loop
  - lastResortError as identity check (forgeable + non-forgeable both honestly named)
  - prepare-commit-transactional-pattern as canonical use-case
  - Don't Remember Panicking TC39 proposal
  - PanicEndowmentSymbol following passStyleOfEndowmentSymbol precedent
  - default-erroneous-exit + no-ambient-normal-exit
  - historical-note-explaining-why-ambient-panic-no-longer-loses-security
related:
  - endo--packages-pass-style (sibling: PassStyleOfEndowmentSymbol precedent + Eval Twin Problem)
  - endo--packages-errors (panic README: makeError/X/q template tag)
  - endo--packages-marshal-src-marshal-justin-and-marshal-stringify-js (cycle 189: also cites Eval Twin defenses + qp-vs-q template tag pair)
  - endo--packages-init-and-lockdown (cycle 183: two-phase init also depends on SES primordials)
parent: endo--packages-panic-index-js--three-layer-dispatch-chain-as-imperfect-ponyfill-with-eval-twin-defense-and-throw-rather-than-infinite-loop
---

The README's last paragraph is a §security-rationale-paragraph:

> If `panic` can immediately exit, then, if in an environment that distinguishes normal exit vs erroneous exit, `panic` always causes an erroneous exit. By contrast, we do not propose for there to be any similarly ambient form for normal non-erroneous exit, because that should be a privilege to be granted explicit by an object-capability.

§Asymmetry-with-rationale: §erroneous-exit-is-ambient (because: see historical note below); §normal-exit-must-be-capability-granted (because: §process-spawning-and-graceful-shutdown-are-rights-not-defaults).

The historical note that follows is striking — it admits the team *changed its mind*:

> Historical note: Before this proposal, we had been treating the ability to erroneously exit as an explicit privilege as well. But we are not in a position to prevent user code from going into an infinite loop, which is at least as bad as an erroneous exit. Thus, there is no further loss in security by providing an ambient `panic` operation.

§The-§"no-further-loss-in-security"-argument: §if-the-untrusted-party-can-already-DoS-via-infinite-loop, §denying-them-erroneous-exit-as-well-buys-nothing. §Honest-design-evolution recorded in the README — this is a §retroactive-justification-paragraph that names the prior position before naming the new one. Sibling to cycle 178 daemon-xs-worker-snapshot's §Revised-scope-2026-04-15 and cycle 192's engo-vs-endor §implicit-supersedes (engo did *not* document the supersedes explicitly; @endo/panic *does*).
