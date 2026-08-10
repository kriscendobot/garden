---
kind: message
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-10T21:26:15Z
---
# Dependabotany ledger: endojs/endo-but-for-bots — PR #923 terminal REJECT

project: endo-but-for-bots
repo: endojs/endo-but-for-bots
pr: https://github.com/endojs/endo-but-for-bots/pull/923

Precise one-shot `dependabotany-recheck-endo-but-for-bots-pr923` fired at the
maturity floor and reached a **terminal verdict**, so the PR's embargo row is now
closed out. The precise one-shot self-deletes on fire; the per-project daily
backstop remains for the seven approval-held MERGE-NOW rows (#867, #868, #912–#916).

## Verdict: REJECT (stale group — base moved past it), executed

- **Closed** PR #923 at 2026-08-10T21:25:33Z with the structured verdict comment
  (`#issuecomment-5246221502`). This is **not** a defect finding against any
  package; it is a rejection of a stale head that fell behind its base to the
  point of reverting it. Dependabot keeps one open PR per group, so the close
  frees it to regenerate a fresh, non-reverting `all-minor-patch` group against
  current `llm`; the dependabot-watcher will auto-post a fresh botanist job on
  the new PR.

- **Maturity leg satisfied.** Freshest moved version `ws@8.21.2`, published
  `2026-08-03T20:37:45.880Z`; floor `2026-08-10T20:37:45.880Z`. Recheck ran at
  2026-08-10T21:24Z, ~47 min past the floor. npm still serves 8.21.2 at the
  reviewed integrity; OSV and the GitHub advisory API return no advisory for it.

- **CI leg satisfied.** Head `d2635dcead1f15a4e3909a0559c0b01f9bc04b76`
  (unchanged from the fully-reviewed 2026-08-05 head): 24 check-runs, all
  `success`, 0 pending / 0 failed via `/commits/<sha>/check-runs`.

- **Conductability leg FAILED — the decisive blocker.** Head is **127 behind /
  2 ahead** of `llm` and `CONFLICTING/DIRTY`. Base `llm` (`6ba1079…`) now pins
  `@earendil-works/pi-agent-core` and `@earendil-works/pi-ai` at `^0.84.0`, while
  the PR proposes `^0.82.1` for both (`packages/agentry/package.json`). Merging
  would partially **revert** those two manifests. MERGE-NOW requires a conductable
  head that does not regress the base; this one cannot be conducted as-is, and a
  rebase/recreate produces a materially different group (fresh transitive
  versions, restarted 7-day clock) — a new proposal, not this one.

- **Advisory direction (record).** Moved `dompurify` 3.2.7 → 3.4.8 (via
  `monaco-editor@0.56.0`) is directionally better: outgoing 3.2.7 carries 18 OSV
  advisories; incoming 3.4.8 retains only `GHSA-55q2-fjhq-7xh7`,
  `GHSA-c2j3-45gr-mqc4`, `GHSA-cmwh-pvxp-8882`, `GHSA-vxr8-fq34-vvx9`, unreachable
  on the consumed Monaco path (per-call string sanitizer config; no
  `CUSTOM_ELEMENT_HANDLING`, `setConfig`/`clearConfig`, custom Trusted Types
  policy, or `IN_PLACE`). Current `dompurify@3.4.13` clears all four; the
  regenerated group should be re-checked for whether Monaco still pins 3.4.8.

Self-improvement: nothing this time.
