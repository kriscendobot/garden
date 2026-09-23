---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr719-review-69684243
verdict: miss
category: docs-drift
pr: 719
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/719#pullrequestreview-4701132491
identity: endojs/endo-but-for-bots#719:review:4701132491:retro
producing_role: builder
producing_job: gauntlet-endo-but-for-bots-pr719-hardened-url-shim
missed_by: archivist documentation-closure lens, omitted from the focused code-panel composition
severity: minor
cluster: new-behavior-documentation-closure
cluster_pattern: A PR adds or changes a user-visible SES capability or lockdown option without updating the authoritative lockdown/package guidance, because a narrowed code panel omits the archivist's explicit new-behavior documentation check.
---

# Miss: URL lockdown behavior reached review without documentation closure

The maintainer's review on #719 required the new URL and URLSearchParams lockdown
behavior to be documented in the lockdown reference and the SES guide (verbatim
untrusted review text remains only at `comment_url`). The primary loop added that
documentation in `66204ddbbc`; this record concerns the earlier review gap.

## Grounds

This is a review miss, not new direction. The PR introduced user-visible SES
behavior: the `urlBlobMethods` option, its environment configuration, and the
different URL capability surfaces available to initial and shared compartments.
`roles/jurors/archivist/AGENT.md` already directs the archivist to verify that new
behavior is documented in the appropriate package documentation or design prose.
The feedback therefore asks for existing documentation closure, rather than first
announcing a new product requirement.

The gauntlet report records a 12-seat focused code panel and its formal panel
review confirms its scope was security, tests, types, and engine edges. Neither
the archivist nor another documentation-closure seat was included, and the panel
did not identify the absent lockdown reference or stale SES guide. The docs were
not changed until the maintainer's review. This is precisely the documentary
accuracy surface the archivist brief assigns to review, so the review should have
caught it.

## Threshold call

This mints `new-behavior-documentation-closure` at count=1 and prs={719}, below
the default floor of three misses across two PRs. Hold: this is a minor
documentation omission and the durable sensing gap (ensuring the archivist is
present for user-visible behavior changes) has not yet shown a cross-PR pattern.
The severity bypass does not apply. A future matching miss should join this
cluster and retain the distinction between prevention (documentation-closure
guidance) and sensing (archivist/panel selection check).
