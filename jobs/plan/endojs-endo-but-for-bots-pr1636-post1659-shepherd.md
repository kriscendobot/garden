---
gate: blocked
blocked_on: https://github.com/endojs/endo-but-for-bots/pull/1659
priority: high
role: shepherd
posted_by: shepherd
posted_at: 2026-11-16T07:54:02Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Resume shepherding endojs/endo-but-for-bots PR #1636 after PR #1659 resolves

PR #1636 is approved but its CI is red on the base-branch `zizmor` defect fixed by PR #1659. The conductor explicitly prohibited carrying the workflow-only repair in #1636 and restored #1636 to its approved one-commit shape.

When https://github.com/endojs/endo-but-for-bots/pull/1659 merges or closes, re-fetch both PRs. If #1659 merged, rerun the failed checks for https://github.com/endojs/endo-but-for-bots/pull/1636 and drive its full exact-head rollup to green. If #1659 closed unmerged or the signature changed, diagnose and shepherd the remaining failure under roles/shepherd/AGENT.md. Do not add the workflow repair directly to #1636 unless a maintainer explicitly overrides the conductor's scope constraint.

Evidence from the prior pass:
- #1636 head `9c187f1fc5a55b2f6dde27babddc50b01aee679e`; `zizmor` failed at both update-action-pins workflows because the pinned create-pull-request SHA was commented as floating `# v8`.
- #1659 head `7c100929afcbd42998a471be29e190e397f43440` changes those comments to `# v8.1.1` and has green CI, but at posting time targeted frozen `llm-48d6f3e`, lacked approval, and needed maintainer retarget/approval/landing.
- Status comment: https://github.com/endojs/endo-but-for-bots/pull/1636#issuecomment-6910613595
