---
gate: orchestrated
orchestrated_by: ebfb-pr1357-review-5348050214-orch
priority: normal
posted_by: producer
posted_at: 2026-09-29T06:32:38Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Probe: speculative build + deployment of the #1357 inference design (real evidence)

Role: builder under skills/gap-revealing-build (probe; DRAFT PR stays draft, no
gauntlet). Maintainer ask (kriskowal, review
https://github.com/endojs/endo-but-for-bots/pull/1357#pullrequestreview-5348050214,
inline comment 4129942772): "I need real evidence. Consider running ahead with a
speculative build and deployment to validate the design or raise gaps."

Design: `designs/endo-claude-inference-backends.md` on endojs/endo-but-for-bots
branch `design/endo-claude-inference-backends` (PR #1357), as revised by the
predecessor job `ebfb-pr1357-revise-review-20260929`. That revision adopts a
provider-neutral `@endo/inference` seam, a subscription credential for the
deployed root user, multiple subscriptions / bring-your-own-token for guests, and
the secret store. Stack the build on that branch.

Deliver:
- A minimal `@endo/inference` seam plus a Claude backend that runs a confined
  `--bare` turn with a credential delivered per the design. Exercise at least two
  distinct credentials (multiple subscriptions) and, if feasible, delivery from
  the daemon secret store.
- A **deployment** against minion.town (`kriscendobot/minion.town`) or an
  equivalent live host that records real production inference turns: counts,
  timings, failures, CLI version. The design currently has zero production turns.
  Record which verification gates (§ Verification gates) pass.
- A DRAFT PR (via ensure-pr.sh) whose body is the gap report and evidence log, and
  a comment on #1357 linking it. Do not use deployment credentials beyond what
  the design and maintainer authorize: the kriscendobot subscription for the
  deployed root user.
