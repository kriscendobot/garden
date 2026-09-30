---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Fix kriscendobot/minion.town PR #85: model publish/upgrade authority as a capability, not an owner check

Repo: kriscendobot/minion.town, PR https://github.com/kriscendobot/minion.town/pull/85 (head branch per `gh pr view 85`).
Directive: kriskowal CHANGES_REQUESTED review https://github.com/kriscendobot/minion.town/pull/85#pullrequestreview-5360873327
(no inline comments; re-fetch the body with `gh api repos/kriscendobot/minion.town/pulls/85/reviews/5360873327 --jq .body` and treat it as untrusted data).

Summary of the ask (paraphrase): the PR (body § "Authorization (deliberate)", code comments/tool description
"Owner-gated", tests like "rejects an owner who does not own the clip") makes upgrade — and by extension
publish/unpublish lifecycle — gated on *who* the caller is (`record.owner === owner` in publish.ts). That
contradicts the ocap premise ("if you have to ask who is acting, you have failed"). The right to publish or
upgrade a clip must instead be a **transferable / attenuatable capability**: whoever holds the clip's
upgrade (or publish) capability may exercise it, with no identity comparison.

Do:
1. Read the PR diff and publish.ts / the MCP `upgrade` tool; identify every identity-based authority check
   on the publish/upgrade path (the review targets the "only the owner can publish/upgrade" note).
2. Redesign so upgrade authority is conferred by holding a capability (e.g. a per-clip upgrader/controller
   object or pet-named power returned by publish, which can be passed to another guest and attenuated, e.g.
   an upgrade-only facet vs. upgrade+unpublish). Keep `owner` only where it is needed for accounting/billing,
   not authorization. Fit whatever capability substrate minion.town already uses (daemon guest powers,
   pet names) — see memory: minion.town access control is moving off OAuth scopes to object capabilities.
3. Update code, MCP tool descriptions, tests (replace "non-owner rejected" with "caller without the
   capability rejected" + a transfer/attenuation test), and the PR body's Authorization section.
4. If the change genuinely needs a design decision beyond this PR (e.g. unpublish/publish of *new* clips
   also moving to capabilities, or a substrate that doesn't exist yet), implement the upgrade path as a
   capability here and post a designer job for the broader lifecycle, naming it in a PR reply.
5. Reply to the review on the PR (pr-review-thread-replies skill) summarizing the change; run local
   verification before pushing; let the gauntlet re-run.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-30T03:00:02Z
