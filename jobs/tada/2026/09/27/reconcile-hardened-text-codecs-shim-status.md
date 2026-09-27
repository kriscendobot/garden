## Completion report: reconcile-hardened-text-codecs-shim-status

The M2 plan record for `hardened-text-codecs-shim` now shows **In Progress**, with evidence for each phase. I pushed the change to `journal2` as commit `bc8dd5b5`, in `plan/designs/endo-but-for-bots/hardened-text-codecs-shim.md`. The job text says the record is on `llm`, but the authoritative copy is this journal record, so that is where I made the change.

**What changed in the record**
- **Status:** `Not Started` → `In Progress`, in both the frontmatter and the body's status table. `updated` is now 2026-09-27.
- **PR link:** added `pr: endo-but-for-bots#1349`. I linked only #1349, not the already-merged endo#3322, because `plan/reconcile.sh` marks a record Complete as soon as its linked PR merges. With endo#3322 linked it would have done that right away, too early. Once #1349 merges, the record will flip to Complete automatically.
- **Reconciliation note, phase by phase** (all checked against the code on `llm@54d654000d` and `master-6ee3fda`):
  - **Phase 1, done:** upstream endojs/endo#3322 merged 2026-07-22. `TextEncoder`/`TextDecoder` are in the `permits.js` allow-list on both branches.
  - **Phase 2, done:** the tests exist under different names on each branch. `master` has `text-encoder-decoder*.test.js` plus the changeset `tender-lions-tickle.md`; `llm` has the older copies named `text-codecs*.test.js`.
  - **Test-plan item 6, open:** draft #1349 adds the XS smoke test. Its base is the frozen `master-6ee3fda` snapshot and its CI is all green. As the PR itself notes, today's `xst` has both codecs built in, so the test only exercises the path where the host's codecs are passed through and frozen. The design's no-codecs fallback path isn't exercised.
  - **Phase 3, differs by branch:** #1349 says there are no `Buffer.from(` or `.toString('utf` call sites left on `master`. `llm` still has some, in `9p-server`, `daemon` node powers, `git`, `platform/http-node` and the `sandbox` drivers. Most of that is Node host code that doesn't run under SES and is probably out of scope, but nobody has checked.
- The plan validator passed with 0 errors. The 2 warnings are in other records.

**Follow-ups**
- **Your decision:** does the Phase 3 audit on `llm` have to happen before this design counts as Complete? Right now the record will flip to Complete when #1349 merges regardless.
- #1349 stays a draft until you post **run the gauntlet #1349**.
- The design file on `llm` (`designs/hardened-text-codecs-shim.md`) still says "Not Started" in its own status table. Nothing copies the journal record's body back to that file. The index table in `llm`'s `designs/README.md` should pick up the new status at the weekly Sunday regeneration. I didn't open a PR just to change that one status line.
- The inbox check at start-up failed because the journal clone timed out. There were no messages to act on.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/reconcile-hardened-text-codecs-shim-status.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1403614 cached reads)
- Output: 9194 tokens
- Cost: $1.0137707999999999
- Wall-clock: 195s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
