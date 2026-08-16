---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Post a top-level comment on https://github.com/endojs/endo-but-for-bots/pull/389
explaining why it is stalled despite being approved and CI-green, for the
maintainer's own future reference and any other reviewer who lands on the PR.
Maintainer-authorized directly (liaison conversation, 2026-08-16): "Just post a
comment on #389 for a maintainer's consideration so they have context on why it
is stalled."

This is a pure repost of findings already produced by the
`endojs-endo-but-for-bots-pr389-conduct` job
(`jobs/tada/endojs-endo-but-for-bots-pr389-conduct.md`) and already delivered to
the maintainer's garden inbox (`inbox/maintainer/*/20260816T052256Z-02a6ed.md`) —
do not re-derive the analysis, just post it publicly. Per
skills/fully-qualified-github-urls/SKILL.md, every reference below is already a
full URL; keep it that way, do not shorten back to `#N` shorthand.

Post exactly this body with `gh pr comment 389 --repo endojs/endo-but-for-bots
--body-file <file>` (or the API equivalent), then verify with `gh pr view 389
--repo endojs/endo-but-for-bots --json comments` that it landed:

---

**Why this PR is approved and green but not merged.**

The base is [`design/gateway-package-phase-2`](https://github.com/endojs/endo-but-for-bots/tree/design/gateway-package-phase-2) — a stacked feature branch, not `llm`/trunk. The PR body's own "Restacking discipline" says the stack lands bottom-up: [phase 2](https://github.com/endojs/endo-but-for-bots/pull/388) must land to trunk first, then this PR rebases onto the new base.

That predecessor, [#388 (phase 2)](https://github.com/endojs/endo-but-for-bots/pull/388), is **closed and was never merged** — its last review was `CHANGES_REQUESTED` (2026-06-02), and it auto-closed 2026-06-30 as `base_ref_deleted` collateral seconds after [#343 (phase 1)](https://github.com/endojs/endo-but-for-bots/pull/343) merged and deleted its base branch.

So phase 2's content never reached `llm`, and the entire phase-2 through phase-12 stack — this PR plus [#392](https://github.com/endojs/endo-but-for-bots/pull/392), [#393](https://github.com/endojs/endo-but-for-bots/pull/393), [#394](https://github.com/endojs/endo-but-for-bots/pull/394), [#395](https://github.com/endojs/endo-but-for-bots/pull/395), [#396](https://github.com/endojs/endo-but-for-bots/pull/396), [#397](https://github.com/endojs/endo-but-for-bots/pull/397), [#409](https://github.com/endojs/endo-but-for-bots/pull/409), [#413](https://github.com/endojs/endo-but-for-bots/pull/413), and [#420](https://github.com/endojs/endo-but-for-bots/pull/420) — is still stacked on a stale `llm` several weeks old.

Merging this PR as-is would land phase 3 onto a dead, non-trunk branch carrying phase 2's rejected content and would not reach `llm` — so it has been left as-is (still draft, untouched) rather than forced.

**Path to land:** re-land phase 2 first (reopen [#388](https://github.com/endojs/endo-but-for-bots/pull/388) or open a fresh `phase-2 → llm` PR, address the `CHANGES_REQUESTED` feedback, restack onto current `llm`, land it), then restack this PR onto the new `llm` and re-run its review, then the remaining stack restacks upward in the same order.

---

Complete the job once the comment is confirmed posted; name the comment's URL in
the completion report.
