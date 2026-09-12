CI came back GREEN (rc 0). The fix is pushed and all 29 checks pass.

## Completion report

**Stage:** FIX round 2 of the PR #1264 gauntlet (design PR: "Daemon storage capability matrix").

Applied the round-2 design-panel must-fix items (four seats requested changes: critic, skeptic, ergonomist, novice; plus copyeditor/pedant should-fix) as a single follow-up commit `c0f383c96` to the head branch `design/daemon-storage-capability-matrix`. I verified every factual claim against the codebase before editing:

- **critic** — confirmed `formula-view-registry.js:190,195` and `cli/src/commands/list.js:61` key on the literal `'readable-blob'`/`'readable-tree'` strings, and that `formula-record.js:307` writes `type: formula.type` verbatim through a `default`-case forward-compat fallthrough (not validation). Rewrote the migration path to apply the alias at **both** the incarnation boundary and the `FormulaRecord.type` computation, enumerate the two external string consumers, add a Phase-2 re-key step gated on a repo-wide grep, and correct the "validates each known type" claim (gate is `assertValidFormulaType`/`formulaTypes`).
- **skeptic** — confirmed the central factual error: `readable-directory` *does* exist as a real persisted formula on the Source PR #1125 (commit `4743e382b` renames `read-only-directory`→`readable-directory`, a `ReadableNameHub` view over a live `directory`); it is absent only on the `llm` base. Reconciled it as a persisted live read-only directory view, flagged the ordering dependency (added a Dependencies row), and named the load-bearing old-record round-trip regression test.
- **ergonomist** — confirmed via `interfaces.js`/`mount.js` that the live tree view (`ReadableTreeInterface`) carries **no** `getInfo()` while the live blob view (`ReadableBlobRangeInterface`) does. Stated the `getInfo` asymmetry explicitly, remarked on the inherited Blob/Tree-vs-File/Directory shape-axis root split, and related `EndoMount` vs the `directory` formula's `EndoDirectory` in the mutable cell.
- **novice** — defined "formula" and glossed "incarnate"/"exo" on first use in the Problem section; added a forward pointer from the matrix to the witness explanation.
- **copyeditor/pedant** — README enumeration colon, split the `sha256()` cleft sentence and the long migration parenthetical, retitled "Design Decisions".

Also updated the `designs/README.md` "Recently added or revised" entry for accuracy. Committed only the two design files with explicit pathspecs (reverted a spurious `packages/floot/package.json` churn from install tooling). No typist-hostile code points introduced; em-dashes are project-compliant per the round-2 pedant verdict.

**Pushed** `6b5a390e5 → c0f383c96` via `safe-push-pr-head.sh`. **CI watched to terminal: GREEN** (29/29 checks, 0 failed).

Follow-up for the next panel re-review (panel-3, re-posted by the driver): no outstanding work from this stage; the PR stays draft until the gauntlet completes.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1264-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 102 tokens (4187472 cached reads)
- Output: 34034 tokens
- Cost: $3.9539640000000014
- Wall-clock: 1023s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
