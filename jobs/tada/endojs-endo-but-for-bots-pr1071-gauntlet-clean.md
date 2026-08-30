The PR touches only a single design markdown file (`designs/ocapn-network-transport-separation.md`) — no code, no packages. A coverage pass is inapplicable (nothing to cover, no dead code to orphan), and CI is all-GREEN at the current head. This clean stage is a no-op.

## Report

Stage: **CLEAN** for endojs/endo-but-for-bots PR #1071 ("design(ocapn): one hint per transport protocol").

- **Idempotence check:** `gh pr view` shows all 6 checks SUCCESS (browser-tests, lint, build, zizmor, test — the "CI (docs-only)" suite) at the current head. PR is OPEN/draft.
- **Scope:** The diff is a single file, `designs/ocapn-network-transport-separation.md` (+91/−46) — a pure design/docs change touching no package source.
- **Coverage pass:** Not applicable. There are no touched code packages to run coverage on and no code the change could have orphaned. Nothing to push.
- **CI:** Already terminal-GREEN; no wait needed.

No changes made; no follow-up needed.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1071-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (102263 cached reads)
- Output: 1130 tokens
- Cost: $0.36321149999999996
- Wall-clock: 20s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
