---
ts: 2026-06-23T07:07:41Z
kind: result
role: designer
repo: endojs/endo-but-for-bots
project: endo
worktree: dispatches/designer--ede531/project
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/463
  - https://github.com/endojs/endo-but-for-bots/pull/463#pullrequestreview-4522542131
  - https://github.com/endojs/endo-but-for-bots/pull/463#discussion_r3433853474
---

RSVP'd kriskowal's CHANGES_REQUESTED review on PR #463 (review id 4522542131, 2026-06-18T07:19:42Z).

The inline ask on `designs/gateway-aws-marketplace-publishing-path.md:11` ("Paraphrase. Nix the reference throughout. This is original.") flagged a citation of the v11 strategy document.
I read "throughout" as a sweep of the same attribution pattern across the whole design (citing a source document as if it were external prior art), not just the line-11 hit, and acted accordingly.

Two commits on `design/gateway-aws-marketplace-publishing-path`:

- `8c8f0c1f6` — line-11 paraphrase: v11 strategy citation → "The MVP is a turnkey Capability Bridge that operators deploy from cloud marketplaces..." Also added `Updated: 2026-06-22` to the metadata table per `designs/CLAUDE.md`.
- `a5a1f6efd` — throughout sweep: dropped attributions to v11 §X.Y, the resequencing draft, the scout report, and the scholar shelf; restated each substance directly. Sections touched: Background § Strategy / Resequencing / Reconnaissance (renamed "Marketplace product shapes"); Phase O1.a § Locked; Phase O1.b § state-custody bullet; Phase O2 § Built; TLS-firstboot sketch's "non-custodian-spirit contradiction"; Submission checklist hardening steps and fee table; Customer onboarding flow OAuth-bond deferral; Cross-design coordination table (rows for gateway-oauth-bonding, gateway-bundled-tls, gateway-marketplace-listing); Decisions 1, 2, 3, 5; Open Questions intro and items 1-2 (dropped the resolved-companion-scholar-gap meta item and renumbered 1-11); Dependencies table (endo-gateway-mcp, gateway-aws-deployment); Affected Designs table (familiar-release).

Left intact: the `journal/projects/endo/README.md § Identity and credentials` reference in Decision 4's reasoning, because it is internal project documentation rather than the external-prior-art attribution pattern the maintainer flagged; flagged the choice explicitly in the top-level summary for the maintainer to overrule.

Push: force-with-lease against anchor `430ad86aa92f41f67cc9431448b34b1db0e43506`.
New HEAD: `a5a1f6efd92...`.

Inline reply on comment 3433853474: https://github.com/endojs/endo-but-for-bots/pull/463#discussion_r3457702012
Top-level summary comment (@-mentioning @kriskowal): https://github.com/endojs/endo-but-for-bots/pull/463#issuecomment-4776631625

PR remains DRAFT per dispatch (no un-draft).

Self-improvement: nothing this time.
