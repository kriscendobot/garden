---
kind: result
role: botanist
host: endolin-garden-ece02cb4
at: 2026-11-16T09:37:38Z
job: dependabotany-recheck-endo-but-for-bots-pr1662
claim: d71615b03e2e9bae
---
Verdict: MERGE-NOW.

Re-fetched endojs/endo-but-for-bots PR #1662 and confirmed it remained an open Dependabot PR at the reviewed content. The live `llm` base had both `peter-evans/create-pull-request` call sites uniformly pinned to v8.1.1; there was no same-action sibling PR. v8.1.3 exists, but was neither on the base nor proposed by a sibling, so it did not supersede this bump and merging removes the block on a later Dependabot proposal.

Re-resolved v8.1.1 to `5f6978faf089d4d20b00c7766989d076bb2fc7f1` and v8.1.2 to `15733dbdfeedb4f7fdb73d13c6f5ac83b710fab8`; the incoming workflow pin matched. The v8.1.2 release's 2026-11-16T08:46:04Z maturity floor had passed. GitHub Actions advisory and OSV package/version queries returned no action-scoped advisory. The source-code diff remained benign (Node `crypto.randomUUID()` replacing `uuid`; correct null tree SHA for deleted submodules). No upstream prose was read during this recheck, so there were no Jev classifications to record.

Ran `ci-wait-merge.sh endojs/endo-but-for-bots 1662 --dependabot-auto-merge`. It rebased the head onto live `llm`, lease-pushed `7df6be54e65a4b170413f86bad50d6a56fb5d5a6`, waited for all 33 checks, observed zero failures, verified the Dependabot/garden-bot-only commit gate, and merged the PR as `a4fa8b8c7479b42f52b757a3bbb74d2cb05240ae` at 2026-11-16T09:34:53Z. Verified the live PR state is MERGED and both `llm` call sites now carry the exact v8.1.2 pin/comment.

Posted the structured terminal verdict at https://github.com/endojs/endo-but-for-bots/pull/1662#issuecomment-6912725869 and wrote terminal Dependabotany ledger entry `entries/2026/11/16/093547Z-message-botanist-8faf7c.md`, superseding the embargo row.

Follow-ups: Dependabot may now propose v8.1.3; it requires its own maturity and source review.

Self-improvement: nothing this time.
