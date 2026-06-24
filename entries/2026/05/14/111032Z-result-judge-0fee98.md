---
ts: 2026-05-14T11:10:32Z
kind: result
role: judge
project: endo-but-for-bots
worktree: dispatches/judge--d7cac3/project
repo: endojs/endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 135
    role: source
refs:
  - entries/2026/05/14/110129Z-dispatch-judge-044181.md
  - entries/2026/05/14/110438Z-message-liaison-f197bc.md
  - entries/2026/05/14/090812Z-result-fixer-0cbacb.md
---

# Judge: PR #135 twelve-seat panel round 2 (loop terminates)

Re-paneled PR #135 (`feat/mount-core`, head `b0f02f656`) after the fixer's
iteration 3 (commits `7b9de4e..612dc60`) and the shepherd's iteration 4
(`bc59960`, `b0f02f6`). CI is 25/25 SUCCESS at the head.

## Verdict

`--comment` aggregate, must-fix count **zero**. The fixer addressed every
in-scope must-fix from the 2026-05-07 panel; the shepherd cleared the
base-staleness CI failures. The panel surfaces four in-scope should-fix items
and a handful of out-of-scope follow-ups, none of which block the loop's exit
condition ("no in-scope must-fix"). The bot is the PR's author, so GitHub
blocks `--request-changes`; per `skills/panel-review/SKILL.md` § Pitfalls the
submission falls back to `--comment` and the body carries the explicit
"Must fix before merge: (none)" heading.

Formal review URL:
<https://github.com/endojs/endo-but-for-bots/pull/135#pullrequestreview-4289432704>

## Un-draft

`gh pr ready 135 -R endojs/endo-but-for-bots` ran successfully. The PR is now
out of draft and lives in the maintainer's review queue.

## Panel execution shape

The judge role assumes an `Agent` (or `Task`) tool to dispatch each juror
concurrently. The current Claude Code harness in this dispatch surfaced no
such tool; `ToolSearch` returned nothing matching "Agent", "task spawn", or
"subagent dispatch". The judge ran the twelve seats in-band against the per-seat
role files instead, then aggregated. The compensating discipline (block each
seat to its role file's primary surface, defer dedupe until all twelve blocks
are written, extract the aggregate must-fix list only on a final read-through)
is recorded in
`entries/2026/05/14/110438Z-message-liaison-f197bc.md`. The orchestrator
(liaison) is asked there to decide between "fix the role to match the harness"
versus "fix the harness to match the role".

## Per-juror verdict summary

| seat | verdict |
| --- | --- |
| assessor | comment-only |
| typist | comment-only |
| stylist | comment-only |
| packager | comment-only |
| archivist | should-fix |
| prover | comment-only |
| curator | approve |
| migrator | approve |
| locksmith | comment-only |
| warden | comment-only |
| saboteur | should-fix |
| breaker | should-fix |

No seat returned `request-changes` on an in-scope item.

## In-scope should-fix items (loop did not block on these)

- Em-dashes added by this PR at `packages/daemon/src/capability-vfs.js:127` and
  `:136` were missed by the fixer round (the fixer cleared the module docstring
  and `mount.js` em-dashes but did not sweep the `stat` body). Archivist.
- `provideSubMount` JSDoc summary at `host.js:303-311` does not mention the
  realpath confinement check. Archivist.
- `subDir('')` (empty subpath) behavior is unspecified: filters to zero
  segments, returns a sub-mount identical to the parent. Saboteur and breaker
  both want either an explicit reject or a documented identity behavior.
- Zero-byte file behavior of `MountFile.streamBase64()` is not pinned by a
  test. Breaker.

## Out-of-scope follow-up items

- **`getScratchMountPath` is already destructured into `host.js`** (line 106,
  used at line 813 for `stageTree`) but `provideSubMount` reconstructs the same
  path inline at `host.js:339-352`. The prior panel flagged this as out-of-scope
  when the helper was not yet on the host's call surface; now that it is, the
  inline rebuild is a clean follow-up. Assessor, typist, packager all touched
  it; aggregated as out-of-scope follow-up.
- `MountContext.snapshotFn` type tightening (typist).
- Exhaustive `parentFormula.type` switch in `provideSubMount` (breaker).
- TOCTOU between `has` and `list`/`readText` in `capability-vfs.stat`
  (saboteur, carried from prior round).
- `help.md` updates for `Mount.snapshot`, `Mount.subDir`, `provideSubMount`.
- Parent-revocation non-transitivity to formulated child sub-mounts deserves
  a docstring sentence (locksmith, warden).
- `packages/daemon/CLAUDE.md` § Exo and Interface Authoring is now misleading
  after commit `750048f28` switched the guard from `.rest(M.string())` to
  `.rest(M.arrayOf(M.string()))`. Surfaced by the fixer in its own result;
  recorded here so the orchestrator can route a gardener pass.

## Next-stage owed

Per `skills/pr-creation-flow/SKILL.md` § The next-stage-owed heuristic:
the panel's verdict is `--comment` with no in-scope must-fix; the judge has
un-drafted; the PR is in the maintainer's review queue. The flow is complete
for the bot-side chain. The orchestrator should add PR #135 to the bulletin's
"Pending kriskowal reviews" section (the steward's next-cycle scan will pick
this up automatically through the maintainer's review queue, but a bulletin
update is the explicit signal).

## Files changed by the PR (scope)

10 files, ~1000 inserted / ~13 deleted, all under `packages/daemon/` plus two
SECURITY.md sidecar files in `packages/harden-test/` and `packages/hex-test/`
(landed by the shepherd to clear the lint failure on a base-stale check).

Self-improvement: the garden's judge role assumes a concurrent-dispatch
`Agent`/`Task` tool the current harness does not surface; the in-band fallback
is honest but loses the panel-bias-isolation property. Recommending the
liaison route this to the gardener for either a role-file fallback procedure
or a harness fix.
