**Viability report: endojs/endo-but-for-bots PR #762**

PR facts: OPEN, not merged, not a draft. Title is "chore: lint mixed-case file names with wildcard exemptions". The head `reconstruct/kebab-case-lint-wildcard-exemptions` is at `f129f92247a`, on frozen base `master-77d9d0c`. Current `master` is 77 commits ahead of that base, at `6ee3fda77bf`.

Deciding question: Does current `master` still lack a mixed-case file-name lint, with the upstream ask (endojs/endo#2947 and erights' request for directory and wildcard exemptions) still unmet and no newer PR replacing this one?

Evidence:
- The upstream PR endojs/endo#2947 ("chore: Lint for kebab-case") is still OPEN and unmerged. PR #762 carries out erights' requested change on it: directory and wildcard exemptions instead of a 9,775-line generated allowlist.
- Current `master` has no file-name lint:
  - The root `package.json` `lint` is still `lint:prettier && lint:eslint && lint:sh`, with no `lint:file-names`.
  - No `filename-case` rule appears in its eslint config.
  - No file in the `master` tree matches `file-name`, `kebab`, `mixed-case` or `exemption`.
- No competing PR replaces it:
  - #1324 (kebab-case renames in pass-style) is a different change that sits alongside this one.
  - #1293 is a closed pass-style naming design.
- The last activity was two panel follow-ups on 2026-09-27, ending at `f129f92247a`, plus a bot assessor review that approves. No maintainer comment rejects or replaces the approach.

Both conditions hold: nothing has superseded the PR, and the reason for it still stands. The gauntlet may begin. Because the base is 77 commits behind `master`, the PR may need a weave later, but that does not stop the gauntlet. I spent no clean, panel, fix or CI budget.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr762-gauntlet-20261007-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 18 tokens (388836 cached reads)
- Output: 3732 tokens
- Cost: $0.8249991999999999
- Wall-clock: 62s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
