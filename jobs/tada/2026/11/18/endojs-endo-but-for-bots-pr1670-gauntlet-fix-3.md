Fix round 3 for endojs/endo-but-for-bots#1670 is pushed and CI is green: 36 checks, 0 failed. There was no pre-pass block for this round, so I worked from the latest panel review (5949027843, `Must-fix before merge`).

**Must-fix items applied** (two commits pushed with `safe-push-pr-head.sh`, `0b8d55e80d → 838f9897b1`):

- **typist #1, file-wide `@ts-nocheck`:** removed from `packages/lal/transcript.js`, which now type-checks.
  - The package root's `types.d.ts` for `@endo/jsonl-transcript` declares types only, which is probably why the `nocheck` was there. The values now come from that package's subpath exports (`entries.js`, `session-path.js`, `writer.js`, `reader.js`).
  - The `any` parameters are replaced with real types: `isProjected` is now a type guard, and `makeTranscriptRoundRunner` is generic over its agent type.
  - `makeMountWriterFs` now declares `@returns {WriterFs}`, so it is checked against that interface.
  - The custom header fields are built in a variable before the `writeHeader` call, because `HeaderEntry` doesn't list the `endo:` keys.
  - This also covers typist should-fix #2 and #3: the mount, file and host types in `agent.types.d.ts` now allow promise returns, and the `markRecorded` ordering and one-round-at-a-time rule are documented there.
- **breaker #1, dangling parent link:** `recordMail` now rolls back the parent id when its write fails, the same way `recordMessages` does. A new test covers a failed mail write.
- **archivist #1, design doc out of date:** `designs/endopi-jsonl-transcript-format.md` now matches the code.
  - It describes the flat `transcripts-for-lal` mount layout and file naming, and that the transcript opens when the worker is created.
  - It drops the 0600 file-mode claim, which the code doesn't implement, and notes that the torn-tail repair is a non-atomic rewrite (breaker should-fix #4).
  - It documents the `endo:worker` and `endo:guestId` header keys and the `endo:mail` entry shape (archivist should-fix #2).
  - The `$ENDO_STATE/sessions` open question is narrowed to what is still undecided.
- **integrator #1 and #2, phase numbering and ledger:** the design's Status section and the PR body now use the same phase numbers: phase 1 shipped, and the first piece of phase 2. The body notes that #1669 renumbers the phases.
  - The body now carries a phase-and-evidence ledger marking this PR as a partial slice. The successor that owns the remaining phases is `build-endopi-jsonl-transcript-remaining-phases`, which I posted as a parked plan job.
  - I also made the pruner's cuts to the body and code comments, except the empty-`mkdir` comment: eslint rejects an empty function, so a one-line comment stays there.

**Local checks:** `tsc` is clean in `packages/lal`, eslint shows 0 errors, prettier is clean, and the `packages/lal` suite passes (210 tests).

**Not done:** coverage-auditor's suggested tests for the `make`/`spawnWorkerLoop` paths, and the integrator's should-fix items #3–#5 (the lint-comment removals, the sub-guest mount test, and checking #1669's live review state).

**Possible deadlock:** the successor job is parked until #1670 merges or closes, but the slice ledger keeps #1670 in draft until that successor supplies its evidence. The two may wait on each other. The maintainer may need to promote `build-endopi-jsonl-transcript-remaining-phases` by hand, or un-draft #1670 directly.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1670-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 102 tokens (5095226 cached reads)
- Output: 23904 tokens
- Cost: $2.4215732
- Wall-clock: 3730s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
