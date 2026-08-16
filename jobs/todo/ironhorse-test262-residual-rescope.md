---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Re-scope the ironhorse test262 completion residual so its work fits a handler budget.

Repo: endojs/endo-but-for-bots. Accumulated branch: https://github.com/endojs/endo-but-for-bots/pull/970 (DRAFT, head b3c3ae93). Pins: test262 be13516fb, XS oracle 23b4d6b0.

Why: the campaign's premise (js-26 as a small mop-up) is disproven by its own authoritative full-suite report. 23,427 actionable cases remain (23,233 unsupported + 194 ironhorse-failure) across ~15 causal clusters, several individually multi-day: RegExp u/v/unicode 4,212; TypedArray/ArrayBuffer 3,243; language expr/stmt 2,710; Object/Array/Reflect/Proxy 2,297; eval/Function/dynamic-import 1,945. Every child posted so far carried the 2400s default handler budget, hit rc=124 at the wall, was reaped, halted its orchestration, and posted a maintainer message. That loop produced 58 parked jobs and dozens of halt/doom notices without landing the work.

Task: do NOT relaunch the existing children. Read the js-26 residual-gap-closure report and the full-suite report, then deliver a re-scoping proposal that answers:

1. Which clusters are genuinely closeable inside the ~3.98h claim-budget cap, and what handler-timeout each needs.
2. Which are multi-day and therefore need decomposition into landable increments or a different vehicle entirely.
3. What to do with the 58 parked ironhorse-* jobs in jobs/plan/ (which to rewrite with a real budget, which to drop).

Also fold in the three open items the js-26 handoff raised: js-27/js-28 ordering, the unreported death of ironhorse-js-25-temporal-integration (stuck in jobs/doin/, its commits a30cceaf30 and b3c3ae93b8 already on the branch), and the accumulated branch regressions (6 baseline-covered paths, plus 185 RegExp negative over-acceptances from missing regex early-error validation).

Output a proposal for the maintainer, not a relaunch. Post no children.

handler-timeout: 7200
