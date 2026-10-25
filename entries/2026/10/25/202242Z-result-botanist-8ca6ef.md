---
kind: result
role: botanist
host: endolin-garden-ece02cb4
at: 2026-10-25T20:22:43Z
job: endojs-endo-but-for-bots-pr1551-dependabot
claim: 64540e82738cd4d5
---
Reviewed endojs/endo-but-for-bots PR #1551 end to end and rendered **REJECT**. Closed the bot-owned PR after posting the structured verdict at https://github.com/endojs/endo-but-for-bots/pull/1551#issuecomment-6402718785.

The blocker is a differential regression in `ava@8.1.0`: its new assertion matcher writes `RegExp.lastIndex` and throws on Endo's hardened regular-expression expectations. The focused sandbox suite passes 264/264 on base with AVA 8.0.1 and fails six times on the PR across three SES configurations; CI reproduces it. AVA 8.1.2 retains the implementation, so closing the grouped PR unblocks a future corrected proposal.

Diligence covered base/sibling supersession, the complete 75-incoming/67-outgoing lockfile set, scripts-disabled install, tarball source diffs, licenses, lifecycle hooks, publish maturity, and OSV/GitHub advisory checks. The maturity floor had passed, no moved exact version has an OSV or GitHub advisory, no license changed, and the only new package identity was Apache-2.0 `@opentelemetry/api@1.9.1`. `yarn lint` passed. The Dependabot prose classifier was unavailable because `TYPESAFE_API_KEY` was absent, so the review proceeded under the documented `proceed_unclassified` policy and recorded that gap.

Recorded the terminal ledger entry as `entries/2026/10/25/202210Z-message-botanist-e6e42c.md`. No recheck was scheduled. Separate Ubuntu 26.04 runner breakages (Playwright support, missing `tred`, and dash `ulimit -u`) remain base-repo CI maintenance and were not mixed into this dependency branch.

Self-improvement: nothing this time.
