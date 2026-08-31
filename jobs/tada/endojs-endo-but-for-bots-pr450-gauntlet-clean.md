The PR is a docs-only design PR — it adds `designs/presence-severance-observation.md` (206 lines) and one line to `designs/README.md`. No packages or code are touched, and all CI checks are GREEN at the current head (not draft, OPEN).

## Completion report

**Stage: CLEAN — endojs/endo-but-for-bots PR #450**

**Idempotence check result: NO-OP.** The PR is already the right shape:
- `isDraft: false`, `state: OPEN`
- All status checks SUCCESS (browser-tests, lint, build, zizmor, test — via the "CI (docs-only)" workflow), CI GREEN at the current head.

**Coverage pass:** Not applicable. The PR's changeset is entirely documentation:
- `designs/presence-severance-observation.md` (ADDED, +206)
- `designs/README.md` (MODIFIED, +1)

There are no touched packages, no source code, and therefore no code to cover and no dead code the change could have orphaned. No follow-up commits were needed and nothing was pushed.

**CI:** Already terminal and GREEN — no wait required.

**Follow-ups:** None.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr450-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (91493 cached reads)
- Output: 1184 tokens
- Cost: $0.39420049999999995
- Wall-clock: 23s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
