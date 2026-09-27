---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr1226-review-2fc247cc
verdict: miss
category: process
pr: 1226
cluster: design-bespoke-mechanism-over-existing-path
cluster_pattern: A design invents a bespoke per-entity channel or mechanism where the repository's existing client/connection path already provides the access, and successive design-panel rounds patch that mechanism's recurring must-fix findings instead of asking whether it is needed at all.
review_at: 2026-09-17T05:59:05Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1226#pullrequestreview-5231787250
identity: endojs/endo-but-for-bots#1226:review:5231787250
producing_role: designer
missed_by: decomplector (category f, minimum viable abstraction) and critic, across six design-panel rounds
severity: moderate
grounds: |
  PR #1226 ran six design-panel rounds (reviews 5146306612..5147898267,
  2026-09-08), every one must-fix. Round 1's critic flagged that the
  broker/adapter connection channel was undefined; later rounds repeatedly
  raised must-fix findings on the resulting per-guest Unix-domain-socket
  mechanism: abstract-namespace enumerability, per-spawn vs per-guest mount
  slices, SO_PEERCRED pid-reuse, Node's inability to read peer credentials, and
  the operational cost of a persistent per-guest broker. Each round resolved
  those findings by adding more mechanism. No seat asked whether the bespoke
  endpoint could be removed by reusing the existing daemon client, even though
  that path (getBootstrap -> bootstrap root host resolves a formula id to the
  guest) already existed in the repository. The decomplector's standing brief
  category (f), "minimum viable abstraction: find the smaller primitive that
  subsumes the larger one", already covered this question and did not bind.
  Accumulating must-fix findings on one mechanism is also a signal to question
  the mechanism itself. The maintainer's simplification uses only existing
  infrastructure, so it is not new direction. Moderate severity: the review
  happened on a design and was caught before the builder step. The primary job
  adopted the simplification, and the merged design on llm now threads the
  formula id through the MCP config environment and uses the bootstrap-host
  lookup.
---

The maintainer suggested dropping the per-guest socket or named pipe. The MCP
server can receive the guest formula identifier through its configured
environment or an initial stdin handshake, then connect with the ordinary Endo
daemon client and look up the guest from the bootstrap root host. The
maintainer also asked for a thorough account of how this is threaded from the
config, noting that process substitution can often avoid a temporary config
file. The design panel had spent several rounds hardening the bespoke socket
without questioning it. This record paraphrases the review; re-fetch
`comment_url` for the untrusted verbatim text.
