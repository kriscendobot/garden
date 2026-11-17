Clean stage for endojs/endo-but-for-bots#1669 is done. Nothing needed changing, so I pushed nothing, and CI is green.

- **PR:** "design(endopi): settle JSONL transcript capability boundary (Chat, Familiar, Gateway)". It is a draft, open, with head `endojs:design/endopi-jsonl-transcript-format` at `eabd104dbd`.
- **Coverage pass:** The only file the PR touches is `designs/endopi-jsonl-transcript-format.md`, a design document. There is no code, so no package to run coverage on and no dead code the change could orphan. I did not create a project checkout.
- **CI:** `ci-wait-merge.sh endojs/endo-but-for-bots 1669 --no-merge` returned rc 0: all 31 checks are terminal with 0 failures (7 passed, 24 skipped because the PR changes only docs).
- **Follow-ups:** None. The gauntlet can move on to the panel stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1669-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (127946 cached reads)
- Output: 895 tokens
- Cost: $0.4040732
- Wall-clock: 25s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
