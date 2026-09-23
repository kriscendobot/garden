---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr475-review-5aae699b
verdict: miss
category: test-gap
pr: 475
cluster: type-representation-matrix-coverage
cluster_pattern: A PR that introduces or narrows a value type with multiple representations (frozen/thawed, mutable/immutable, native/emulated) ships without panel-required tests exercising the full representation matrix against the platform APIs/consumers that flow through the type; the corner-prober/coverage seats do not enumerate the intersection, so the maintainer must ask for the missing matrix.
review_at: 2026-08-19T21:38:58Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#pullrequestreview-4976976834
identity: endojs/endo-but-for-bots#475:review:4976976834
producing_role: designer
producing_job: design-endo475-istypedarray-isview
missed_by: corner-prober (emulated/genuine and shim/hardener capture-order matrix); secondarily critic (composition with the already-requested getter replacement)
severity: minor
grounds: |
  PR #475's design-endo475-istypedarray-isview increment retained the captured
  TypedArray toStringTag getter as an internal-slot brand check and added a
  DataView negative test, while an earlier maintainer review had already directed
  the same PR to replace that getter so it would recognize emulated TypedArrays.
  The interaction was therefore anticipatable from the live review history: a
  receiver-aware replacement changes the result of the captured brand check when
  the hardener initializes after the shim. The five-lens gauntlet ran before this
  later increment and no panel reviewed the increment before the maintainer had to
  ask about the interaction. The corner-prober's standing brief requires
  enumeration of untested boundary cases for every modified claimed contract,
  including identity/prototype-modified cases; the critic also requires designs to
  compose with adjacent modules and downstream consumers. Neither check bound.
  This is a test-gap rather than new direction: the maintainer's earlier review
  had already specified replacement of the getter, and the eventual separate fix
  demonstrated the omitted matrix directly. It made isTypedArray classify an
  emulated wrapper differently depending on shim-before-hardener versus
  hardener-before-shim capture order. The reroute proved benign in both orders, so
  there was no runtime correctness bug, but that empirical compatibility result
  and its regression coverage were missing until the maintainer raised the
  question. The primary deliverable exists, but its initial reply incorrectly
  narrowed the possible fidelity fix to a data property; later thread replies
  corrected that claim and commit fc2238dcb added the receiver-aware getter and
  capture-order verification. Severity is minor because the interaction proved
  benign and was caught before merge. This joins type-representation-matrix-coverage:
  it is another untested native/emulated representation intersection with a
  platform consumer, here crossed with initialization/capture order. The cluster
  remains below the dispatch floor because both members are on PR #475.
---

The maintainer asked whether repairing the emulated TypedArray toStringTag getter
would change or break the hardener code that captures that getter as a brand check.

The review miss was the absent native/emulated and initialization-order interaction
test despite the getter replacement already being requested in this PR's review
history. See comment_url to re-fetch the verbatim untrusted review text.
