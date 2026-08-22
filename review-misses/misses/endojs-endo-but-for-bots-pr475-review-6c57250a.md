---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr475-review-6c57250a
verdict: miss
category: docs-drift
pr: 475
cluster: cross-package-fidelity-contract-ownership
cluster_pattern: A client package begins depending on a provider package's deliberate fidelity loss, but the change records the dependency and regression guard only on the client side instead of specifying and pinning the provider-side contract too.
review_at: 2026-08-17T21:57:08Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#discussion_r3799112565
identity: endojs/endo-but-for-bots#475:review:4954925589
producing_role: fixer
producing_job: endojs-endo-but-for-bots-pr475-39621e7f
missed_by: fixer completion review; archivist and prover/spec-keeper lenses
severity: moderate
grounds: |
  On June 30, the feedback-fix job added an @endo/bytes regression test whose
  correctness depended on a deliberate fidelity loss in the
  @endo/immutable-arraybuffer shim. The PR thread and the job's own report made
  that cross-package dependency explicit, but the resulting change pinned it
  only in the client package. It did not update the provider package's README or
  add a provider-side regression test. The maintainer therefore had to ask on
  August 17 that the provider own both the specification and its half of the
  guard. This was anticipatable from the diff and discussion, not first-stated
  product direction: the archivist brief requires new behavior and invariants to
  be documented in the package README/design, while the prover and spec-keeper
  require tests to pin the claimed contract and its engine-sensitive behavior.
  The journal has no gauntlet or panel verdict between the June 30 client-only
  fix and this review; the only recorded PR #475 gauntlet ran August 19, after
  this feedback and its remedy. Current pr-creation-flow policy deliberately
  sends post-maintainer-review fixes back to the maintainer without a fresh panel
  by default, so this is not filed as a panel-bypass process miss. It is the
  narrower review gap: completion review failed to follow an explicit
  cross-package invariant to the package that provides it. The later primary
  initially implemented the comment's pre-edit integer-indexed interpretation,
  and a separate follow-up then supplied the corrected Symbol.toStringTag
  provider spec and tests. Severity is moderate because the missing contract
  made a future apparently-correct shim fidelity repair capable of silently
  breaking a client, but the dependency was caught in review before merge.
---

The maintainer identified that a client-side regression guard depended on a
deliberate shim fidelity loss and asked that the provider package specify that
behavior and carry its own regression guard. The prior fix had documented the
reasoning in the review thread and tested only the client, leaving ownership of
the provider-side contract implicit. See comment_url for the untrusted original
text.
