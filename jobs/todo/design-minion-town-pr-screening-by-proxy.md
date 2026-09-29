---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design: proxy / mentat-supervisor screening for kriscendobot/minion.town PRs

Source directive: kriskowal APPROVED review on https://github.com/kriscendobot/minion.town/pull/139#pullrequestreview-5358570484
(paraphrase): minion.town PR review is beneath maintainer attention; arrange for
the **proxy** or a **mentat supervisor** to screen minion.town pull requests. The
purpose of minion.town is to validate in production and get to a point where the
garden can supervise and self-heal the production system.

Design (then land/stage builds for) the mechanism by which minion.town PRs are
screened and approved-to-merge by the garden instead of the maintainer:
- Where kriskowal is currently pulled in (gauntlet un-draft review requests,
  bulletin review-requested listing, fixer re-requests) for kriscendobot/minion.town,
  and how to redirect that to a garden screener.
- Proxy (roles/proxy/AGENT.md; note its boundary currently forbids merge "where
  not already authorized" — this directive is that authorization for minion.town
  only) vs. a mentat supervisor job (scripts/jobs/post-manual-job.sh) — pick one
  and say why; the screener's gate criteria (panel verdict, CI green, production
  validation / deploy-verify evidence) and hand-off to the conductor for merge.
- Scope strictly to kriscendobot/minion.town; other repos keep maintainer review.
- Keep the maintainer informed (inbox/bulletin summary), not gated.
