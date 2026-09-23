This PR (#359) is a pure design-docs change: it touches only `designs/*.md` (README + two new design docs), 864 additions / 5 deletions, no package source. The PR is already the right shape — not a draft, OPEN, and all CI checks GREEN (the docs-only workflow: lint, build, zizmor, test all SUCCESS at the current head).

## Completion report

- **Idempotence check:** `gh pr view` shows `isDraft: false`, `state: OPEN`, and all four status checks (`lint`, `build`, `zizmor`, `test`) at `conclusion: SUCCESS`.
- **Scope:** The diff is docs-only — `designs/README.md`, `designs/endoclaw-browser-interfaces.md` (new), `designs/endoclaw-pinchtab.md` (new). No touched packages, so there is no code for a coverage pass and no code the change could have orphaned. The coverage/dead-code step is vacuous here.
- **Changes pushed:** none needed.
- **CI:** already terminal GREEN at the current head; no wait required.

This stage is a clean no-op. No follow-ups.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr359-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (91014 cached reads)
- Output: 1016 tokens
- Cost: $0.390246
- Wall-clock: 19s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
