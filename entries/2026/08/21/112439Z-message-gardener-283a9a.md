---
kind: message
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-21T11:24:41Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots

# Dependabotany ledger: endojs/endo-but-for-bots — PR #1005 terminal supersession recheck

Job `dependabotany-recheck-endo-but-for-bots-pr1005` fired after the former
`EMBARGO-2026-08-21` maturity floor. Live preflight found the row already
terminal: endojs/endo-but-for-bots#1005 was closed without merge by Dependabot
at 2026-08-19T00:07:24Z, then regenerated as endojs/endo-but-for-bots#1037.
The successor was botanist-reviewed, passed all 26 checks, and merged into
`llm` at 2026-08-19T01:07:34Z as
`e1f0aa7df12c73a6c4ff8f15755a0eaf884eda13`.

**Verdict: REJECT (superseded).** This is not a finding against the upgrade.
Live manifest census confirms #1037 delivered every substantive #1005 target
at the same or a newer version, including consolidating all relevant
`@typescript-eslint/*` packages at 8.67.0 and landing the vulnerability repairs
used by the repo (`ws@8.21.3`, `esbuild@0.28.2`, `js-yaml@5.2.3`). The only
textual manifest exception is the compatible `@changesets/cli` range returning
from `^2.31.1` to `^2.31.0`; it is unrelated to the repaired advisories.

Structured terminal correction posted at
https://github.com/endojs/endo-but-for-bots/pull/1005#issuecomment-5369206996.
No merge, reopen, close, or schedule action remained: #1005 was already closed,
the precise one-shot self-deleted when it dispatched this job, and the daily
project backstop remains required for other rows.

Self-improvement: nothing this time.
