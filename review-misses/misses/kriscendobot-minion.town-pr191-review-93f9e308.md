---
kind: review-miss
primary_job: kriscendobot-minion.town-pr191-review-93f9e308
verdict: miss
category: security-hardening
pr: 191
repo: kriscendobot/minion.town
surface: pr-review-body
author: kriskowal
identity: kriscendobot/minion.town#191:review:5538982218:retro
comment_url: https://github.com/kriscendobot/minion.town/pull/191#pullrequestreview-5538982218
review_at: 2026-10-15T19:46:29Z
cluster: identity-gated-authority
producing_role: designer
producing_job: claude-on-minion-town-press-20261015-192010
missed_by: designer brief (ocap per-action-authority line, 2782d6294d); design panel locksmith on the #167 lineage; no panel on #191 (gauntlet halted, floating base)
severity: moderate
grounds: |
  The reviewed head (1c3cea0ae2) framed the root-canary secret's authority as
  "which AWS principal may read it". It weighed IAM Roles Anywhere certificates,
  trust policy over the shared garden-fleet IAM user, and a dedicated EC2
  instance. All three options put authority in a principal named by a trust
  policy. That is the principal allowlist the standing designer brief line
  (roles/designer/AGENT.md, added 2026-10-07 in 2782d6294d for this cluster)
  forbids for minion.town: authority comes from a held capability, and a
  sibling identity gate becomes follow-up work, not precedent. The draft took
  the accepted design's IAM reader role (#167, root-canary-principal.md §2.3)
  as precedent and built more machinery on it. The ocap answer was already
  standard on minion.town: the root's secret formula identifier is the
  capability, and storing it on the host is enough. The maintainer rejected
  the draft on those grounds and asked which session actually authenticates.
  The review cycle never sensed this. #167 passed seven design-panel rounds
  and merged, reader role included, with no locksmith flag. #191's only
  gauntlet (kriscendobot-minion.town-pr191-gauntlet, created 19:25Z) halted
  at 19:26Z because the base was floating `main`, so no panel ran before the
  19:46Z review. Also, the C-locksmith.sh identity arm matches code-shaped
  equality and allowlist tokens. It does not match design prose such as
  "trust policy permits only X" or "which principal may read", so it would
  not have fired on this markdown diff anyway. This is not evaluator gaming:
  nothing was changed to alter what a reviewer measures.
  World check: the primary's claimed resolution is real. Head 2f0fe4f9bb
  (19:58Z) has the five-session authentication table and keeps the secret on
  endolin-garden1 only. The bot's thread reply (discussion_r4288116388) exists.
---

Draft one of the root-canary reader-identity design treated "which AWS
principal may read the secret" as the authority question. The maintainer
rejected that as overwrought. In an ocap house, the root's secret formula
identifier is the capability, and storing it on the host is enough. They
also asked the design to say exactly which session (claude, MCP, OCapN,
AWS deploy, codex) needs to authenticate. The designer brief line meant to
prevent identity-gated authority did not bind here. The locksmith probe does
not sense the pattern in design prose. Re-fetch the verbatim review at
comment_url.
