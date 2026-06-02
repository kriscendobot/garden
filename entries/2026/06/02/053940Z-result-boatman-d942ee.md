---
ts: 2026-06-02T05:39:40Z
kind: result
role: boatman
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/02/053340Z-dispatch-liaison-d942ee.md
---

First-time Shape-1 ferry of endo-but-for-bots#387 (esvu-replacement / direct-download approach for #3289) to a NEW DRAFT upstream PR.

**Upstream PR:** https://github.com/endojs/endo/pull/3294 (DRAFT)
**Branch:** `kriskowal-3289-wget-engines`, head `e0d7a8622a0eac02a7072bb4f98b37d79abe7a70`.
**Source:** endo-but-for-bots#387, branch `fix-benchmark-wget-engines-master`. Source fetched directly (endo-but-for-bots is not a git fork of endo).

**Source-shape divergence from the prompt.** The prompt named a 3-commit head `dceb649b3` with a separate `.bench-engines` → `.engines` rename commit. The live source branch had been rebased to a cleaner 2-commit shape (head `c786ba63`): the rename is already folded into the substantive commit, which references the `.engines` cache directly and leaves no `bench-engines` refs in tree. Ferried the 2-commit shape.

**Per-commit attribution (verified, `git log origin/master..HEAD --pretty=fuller`):**
- `da8dd72d` fix(benchmark): install xs/v8 via direct download, drop esvu — author `0xPatrick <patrick@0xpatrick.dev>` (PRESERVED via `--amend --author=` without `--reset-author`), committer `Kris Kowal <kriskowal@kriskowal.com>`. 0xPatrick's substantive credit is intact.
- `e0d7a862` chore: Update yarn.lock — author AND committer `Kris Kowal <kriskowal@kriskowal.com>` (normalized via `--reset-author`).
- Per-commit `interpret-trailers --parse` empty on both (no Co-Authored-By, no Generated-with-Claude-Code). Source carried no trailers to begin with.

**Host preconditions:** `gh auth status` = kriskowal active; `gh api repos/endojs/endo --jq .permissions` = `push:true, admin:true`. Passed.

**PR body:** behavior-over-diff per pr-formation, upstream template section-for-section, `Refs: #3289` (NOT `Closes`, since #3289 is open and this is one of several attempts). No fork-side refs, no `(#386)`/`(#387)`, no checklists. Body notes the esvu-hangs-on-Node-24 rationale.

**CI:** No checks reported yet at report time (just pushed).

**MERGEABLE: CONFLICTING (DIRTY).** This is a REAL conflict, not GitHub lag. Master advanced from the prompt-named base `c49fb048b` to live `3c5753b6` between the prompt's pre-fetch and the ferry: the new tip includes #3292 "chore: dependency maintenance" which heavily rewrote `yarn.lock`. The only conflicting path is **`yarn.lock`** (`git merge-tree --write-tree` reports exactly `CONFLICT (content): Merge conflict in yarn.lock`). Per pr-handoff § Scope boundary, master-merge conflict resolution is the weaver's job; the boatman surfaces and does not rebase. **A weave of #3294 is owed** to resolve the yarn.lock collision against current master.

**Garden-side cross-link:** posted on endo-but-for-bots#387 as comment 4599031642 (https://github.com/endojs/endo-but-for-bots/pull/387#issuecomment-4599031642), body `Mirror of https://github.com/endojs/endo/pull/3294 (head e0d7a8622).`, under kriskowal (only authenticated identity on this host; skill permits on the garden repo).

**Upstream-side cross-link:** routed to steward via separate `message: boatman → steward` entry (primary-repo comments route through the steward under kriscendobot). No steward runs this session; written for the record.

Self-improvement: nothing this time. The prompt's pre-fetched base going stale (master moving between dispatch authoring and ferry execution) is already covered by pr-handoff's standing re-fetch and the scope-boundary handoff to the weaver; the boatman correctly surfaced the conflict rather than rebasing.
