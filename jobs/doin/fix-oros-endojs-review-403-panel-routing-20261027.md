---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Garden infra fix (main2). Host oros-studio-garden-ce242c49's bot token gets `GraphQL: Resource not accessible by personal access token (addPullRequestReview)` on every endojs/endo-but-for-bots PR review. Gauntlet panel stages race onto it anyway, run a full juror fan-out (~$0.4–0.9 each), and fail as panel-error, burning stage retries. Recurrences: endojs PRs #1543 (panel-2, panel-5, two panel-6 attempts; the gauntlet halted 2026-10-23), #1515, #1520, #1283, #1304, #1514, #1517 (see the maintainer inbox msg-*-panel-* files).

Make the routing deterministic so that no host claims a panel stage (or other PR-review/comment-posting stage) for a repo whose reviews its token cannot post. Two options: a cheap pre-spend write-capability check that panel.sh runs before the seat fan-out, or a host-local learned exclusion (a TTL'd marker set on that exact 403 and honored by the claim-job.sh eligibility gate, keyed by repo owner). Prefer what fails closed without publishing credential facts to the public journal. A manual per-gauntlet stopgap already exists: `gauntlet.sh --resume-from-stage <g> <stage> --stage-requires host=<GARDEN>` (main2 cd7c50a575f). Also flag to the maintainer that the lasting fix is granting the oros token PR read+write on the endojs org.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-27T01:38:04Z
