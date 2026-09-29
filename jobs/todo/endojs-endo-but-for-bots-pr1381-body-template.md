---
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
dispatch: automatic
pr: https://github.com/endojs/endo-but-for-bots/pull/1381
fallback-tier: minion
---

# Apply template-conforming PR body to endojs/endo-but-for-bots#1381

Gauntlet fix-2 (`endojs-endo-but-for-bots-pr1381-gauntlet-fix-2`) pushed the doc
fixes (head `6e3fa01ae7`), but the PR-body edit got a 403 on host oros-studio,
whose bot PAT lacks PR write on endojs. The body is the panel's must-fix item
(integrator: template NONCONFORMING, and the body's "17 sites" contradicts the
doc's 16).

Do exactly this, and change no code:

1. Replace the PR body with the text between the BODY markers:
   `gh pr edit https://github.com/endojs/endo-but-for-bots/pull/1381 --body-file <file>`.
2. Post this PR comment:
   "Merge note (moved out of the PR body per panel feedback): #1355 edits the adjacent README index row and prose line. Whichever PR lands second needs a trivial conflict resolution and should also move `hardened-url-shim` in the current totals."

----- BODY -----
<!-- garden-job: design-hardened-ses-shim-status-reconciliation -->

Refs: endojs/endo#3322, endojs/endo#3340

## Description

This PR marks [`designs/hardened-text-codecs-shim.md`](https://github.com/endojs/endo-but-for-bots/blob/llm/designs/hardened-text-codecs-shim.md) as **Implemented (Phases 1-2)**. Its status was **Not Started**, but the work merged upstream in endojs/endo#3322, which is an ancestor of `llm`. The design's new `## Status` section records the evidence. The permits table now lists the `@@toStringTag` entries and the `inspect.custom` denial from endojs/endo#3340. § Test plan item 6 now reflects the XS finding from #1349. `designs/README.md` updates the index row and the current totals: Complete/Implemented goes from 76 to 77 and Not Started from 19 to 18. The groom note and the superseded totals block move to `designs/ARCHIVE.md`.

### Security Considerations

None. This is a docs-only change.

### Scaling Considerations

None.

### Documentation Considerations

This PR is itself the documentation change. The files to review are the design's `## Status` section and the README totals.

### Testing Considerations

No code changes. The design records items that remain open but do not gate the status: the XS smoke test (#1349), the optional Phase 3 `Buffer` audit (16 call sites in 10 files, all Node-host code), and Node's `TextDecoder` fast-path issue (endojs/endo#2813).

### Compatibility Considerations

None.

### Upgrade Considerations

None.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
----- END BODY -----
