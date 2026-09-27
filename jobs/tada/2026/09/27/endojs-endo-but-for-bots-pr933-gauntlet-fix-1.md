## Fix round 1 for PR #933: done, CI green

The panel's must-fix items were already applied and pushed before this attempt. After the requeue, the PR was conflicting with `llm`, so CI could not run. I rebased it, pushed it, and CI then passed with 30 of 30 checks green.

**What an earlier attempt did (commit `76431cccc`, 2026-09-04).** It applied the fixes from the panel-1 review (5104613636):
- **skeptic:** the design now says the XS host re-prepares the SQL on every call. So `{ simple: true }` would run an action pragma such as `wal_checkpoint` or `incremental_vacuum` twice. The parity guarantee is limited to pragmas that are safe to run twice, the reason given for rejecting a dedicated `sqlitePragma` host callback is corrected, and an action-pragma test case is added.
- **pedant/copyeditor:** em-dashes are removed from the "Files to Modify" list, and the Unicode ellipsis (`…`) is replaced with ASCII `...`.
- **copyeditor/ergonomist:** the binding is spelled `sqliteStmtColumns` everywhere, and the internal shim method is renamed `_columns()`.

**What this attempt did:**
- **Diagnosed the stall:** the first CI wait returned rc 3 because the PR could not merge into `llm` (it had moved a long way), so no checks were attached.
- **Rebased:** I moved the 2-commit head onto current `llm` (`efabaed2b`). The only conflict was in the roadmap file, `designs/README.md`. I kept everything from `llm` and re-added this PR's entries:
  - the design-index row and the roadmap table row;
  - the estimates row;
  - the diagram node, with its edge redrawn from `llm`'s existing `dsql` node rather than the old duplicate `dsqlite` node;
  - M11 now counts 7 designs at "15-22 weeks + 1 day", and the total is 66 designs plus "+ 1 day".

  The new design file `designs/daemon-sqlite-pragma-simple.md` came through unchanged.
- **Pushed:** I used `safe-push-pr-head.sh --mode rewrite` with the lease check, moving the head from `76431cccc` to `f5bc30ede`.
- **Watched CI:** `ci-wait-merge.sh --no-merge` returned rc 0.

**Follow-ups**
- Panel-2 should look at the hand-resolved milestone totals in `designs/README.md`.
- These non-blocking comments from panel-1 were not addressed:
  - critic: the design says XS shim tests already exist, but none do, so the harness has to be built from scratch.
  - decomplector: looking up the first column by name can break when two result columns share a name.
- I couldn't read my inbox because the journal clone timed out.
- The PR is still a draft. No garden files changed.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr933-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 6 on 2 host(s)
- Input: 90 tokens (2680843 cached reads)
- Output: 21520 tokens
- Cost: $2.89030045
- Wall-clock: 1835s
- Model(s): claude-opus-4-8 ×5, claude-opus-5-5 ×1

<!-- garden-usage-end -->
