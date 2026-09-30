---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# weave endojs/endo-but-for-bots PR #990 onto current llm

role: weaver

PR: https://github.com/endojs/endo-but-for-bots/pull/990
Head: bot/slots-ocapn-deliver-convention; current frozen base: llm-a54c3ad (9979fbb2d8).

Posted by the shepherd job endojs-endo-but-for-bots-pr990-shepherd (maintainer shepherd directive on PR #990).
The remaining red check, `zizmor`, is inherited from the frozen base: it flags
`.github/workflows/rust.yml:44` (the `dtolnay/rust-toolchain@6c977a6… # v1` pin; the
floating v1 tag has moved to 02cb101ec7c4). The PR does not touch that file, and on
current `llm` rust.yml no longer exists, where zizmor is green. Weave means: snapshot
llm's current tip to a new frozen `llm-<sha7>`, rebase the head onto it, resolve
conflicts, push the head with --force-with-lease, and move the PR's base. Then confirm
that zizmor and the rest of CI are green on the new head.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-30T03:13:01Z
