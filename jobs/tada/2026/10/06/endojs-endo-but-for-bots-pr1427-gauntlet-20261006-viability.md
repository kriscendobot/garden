**Viability report: endojs/endo-but-for-bots PR #1427**

PR facts: the PR is OPEN, draft and unmerged. Title: "ci: correct dorny/paths-filter pin comment to v3.0.3". Head is `fix/zizmor-paths-filter-pin-comment` @ `1b1ead43c8`. Base is `master-6ee3fda` @ `6ee3fda77b`. It changes one line in `.github/workflows/ci.yml`. It was opened 2026-10-06 by the garden job `fix-ebfb-master-zizmor-paths-filter-pin-20261006`. It has no reviews or comments yet.

Deciding question: Does `master` still pin `dorny/paths-filter@d1c1ffe…` with the comment `# v3`, while the floating `v3` tag now resolves to a different commit, with no other PR or commit already fixing it?

Answer: yes.

Evidence:
- **Master hasn't moved.** Its tip is still `6ee3fda77b` from 2026-07-22, the same as the PR's base. `.github/workflows/ci.yml:270` on master still reads `dorny/paths-filter@d1c1ffe0248fe513906c8e24db8ea791d46f8590 # v3`.
- **The premise still holds upstream.** `refs/tags/v3.0.3` is `d1c1ffe…`. The annotated `refs/tags/v3` (`15192bc…`) resolves to `0e4a8c6…`, which is v3.0.4. That mismatch is exactly what zizmor's `ref-version-mismatch` audit flags.
- **Nothing supersedes it.** Searching the repo's PRs for "paths-filter" turns up only #1002, a dependabot bump to 4.0.3 that merged into `llm`, not `master`. No other open PR targets this master pin comment.
- **The motivation is current.** The red `zizmor` check on master blocks every master-based PR, including #1425, which this PR references.

viability=proceed

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1427-gauntlet-20261006-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (211402 cached reads)
- Output: 1615 tokens
- Cost: $0.3931484
- Wall-clock: 24s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
