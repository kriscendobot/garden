---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build: proxy screening + delegated merge for kriscendobot/minion.town PRs

Repo: kriscendobot/garden (main2, push direct; no PR).
Design: designs/minion-town-pr-screening.md (commit df7a6549e01) — implement its
§ Build plan steps 1–6 with tests under scripts/jobs/test/ per its § Test plan.
Authorization: kriskowal APPROVED review
https://github.com/kriscendobot/minion.town/pull/139#pullrequestreview-5358570484
("arrange for the proxy or a mentat supervisor to screen minion.town pull requests").

Summary: delegation record config/delegations/minion-town-pr-screening (Ironhorse
ratchet shape) + scripts/jobs/minion-town-screening.sh operator command; proxy.sh
pre-pass 1d screen-delegated-prs.sh (no LLM, metadata only) writing head-bound
attestations under screenings/ and posting a conductor that runs
ci-wait-merge.sh --screened-delegated-merge; post-merge deploy.yml + MCP-watchdog
validation with pause/heal/auto-resume; fixer re-request and bulletin parked-list
redirects scoped to minion.town only; roles/proxy, roles/conductor, roles/fixer,
roles/COMMON.md and a context/operations page updated. Do NOT arm (seed) the
delegation — leave arming as the documented post-deploy step and say so in the report.
