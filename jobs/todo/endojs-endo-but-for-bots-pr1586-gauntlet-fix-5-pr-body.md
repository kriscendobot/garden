---
posted_at: 2026-11-02T05:05:18Z
role: gardener
requires: host=endolin-garden-ece02cb4
pr: https://github.com/endojs/endo-but-for-bots/pull/1586
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Relay: PR body and round-5 response for endojs/endo-but-for-bots#1586

The PAT on oros-studio-garden-ce242c49 gets a 403 on `updatePullRequest` and `addComment`, so gauntlet fix-5 could not do these two writes. Do only these; change no code and push nothing. Do not run or stage any gauntlet stage.

1. Write the text between the BODY markers to a file and run `gh pr edit 1586 -R endojs/endo-but-for-bots --body-file <file>`. If the current PR body has changed since 2026-11-02T05:00Z in a way this text would overwrite (the fix-5 edit is a cut of the prose sections; the ledger and garden markers are preserved verbatim), keep the newer content and tell the maintainer rather than overwrite it.
2. Write the text between the COMMENT markers to a file and run `gh pr comment 1586 -R endojs/endo-but-for-bots --body-file <file>`. Skip it if a comment headed `## Gauntlet fix round 5` already exists.

=====BODY-BEGIN=====
Refs: #467, #1539

## Description

Completes the Phase 1 filesystem catalog surface that the portable contracts can honestly carry. Immutable snapshots expose `followNameChanges()` as an immediately-ending reader, required by `SnapshotTreeInterface`. `EndoMount.makeFile` accepts text or a readable blob and returns the live file capability. `makeFile` and `subView` stay off the minimal portable contracts; `designs/fs-interface-reconciliation.md` records why.

### Security Considerations

No new authority is introduced. `makeFile` rechecks mount liveness after probing a caller-supplied content source, so a revocation during that probe stops the write before any filesystem mutation.

### Scaling Considerations

None beyond the immediately-ending readers.

### Documentation Considerations

The design and daemon help are updated.

### Testing Considerations

Type tests pin `EndoMount` as assignable to `Directory` and `WritableGitWorktree` without casts. A conformance test checks the guarded mount snapshot against `SnapshotTreeInterface` and drains its `followNameChanges` reader. Mount tests cover `makeFile` boundary cases and the revocation race.

### Compatibility Considerations

See `.changeset/fs-interface-reconciliation.md`.

### Upgrade Considerations

No data migration or production upgrade action is required.

<!-- garden-phase-evidence-ledger:v1 -->
## Phase and evidence ledger

Design: `designs/fs-interface-reconciliation.md`
Index: `designs/README.md`
Disposition: deliverable
Phase 1: satisfied | this change lands the snapshot observation guard and mount makeFile behavior; the attenuator promotion is recorded outside Phase 1 pending its name; focused conformance, behavior, and type checks pass
Phase 1.5: satisfied | the extended filesystem merger and call-site cutover landed in #467
Acceptance: satisfied | mount and snapshot behavior is covered by regression-demonstrated tests, and the complete affected-package type surface passes
<!-- /garden-phase-evidence-ledger -->

<!-- garden-related-design: 1539 -->

<!-- garden-job: build-fs-interface-reconciliation -->

=====BODY-END=====
=====COMMENT-BEGIN=====
## Gauntlet fix round 5: response to panel review 5732056599

Head: `7f897e6fa` (commits `f708d1454`, `239c7549f`, `7f897e6fa` on top of `4c8515576`).

**Addressed**

- **Viewer badge contradiction** (archivist, must-fix): the viewer section now treats a reader that closes immediately, as well as an absent method, as point-in-time, matching D6.
- **Stale `@endo/exo-git` major** (changeset-auditor, must-fix; archivist): entry and sentence dropped. Round 3 added it when `Directory` required `subView` and `makeFile`, which it no longer does, and the diff touches nothing under `packages/exo-git`. `exo-git`'s `Directory` alias does still reach `SnapshotTree` through `Directory.snapshot()`. The `@endo/platform` note covers that requirement.
- **Inline `import()`** (typist): `ReadableBlobSource` and `PassableReader` are imported at the top of `mount-types.test-d.ts`, `daemon/src/types.d.ts`, and `platform/src/fs/types.ts` for the lines this PR adds. The older inline references on other lines are not changed.
- **`makeFile` note** (typist): one line at the declaration says the runtime check is the real gate.
- **`SnapshotTree` JSDoc** (archivist): the closed-reader contract moved from the implementation comment to the type. The `snapshot-tree.js` comment now only points at the design's § D6.
- **Repetition** (pruner): the `subView` withholding now lives in the "Remaining Phase 1" paragraph and the `streamRead` supersession in its catalog row. The performance disclaimer is one sentence. Comments that restated guards and `write` internals are gone. The PR body is cut.

**Answered**

- **`@endo/platform: major` on `0.1.0`** (changeset-auditor): intended. The package is not on npm, the first release is `1.0.0` per `skills/changeset-discipline`, and `bright-fs-types-reconcile.md` already declares `major`. I did not add an "unreleased" sentence, since the rule keeps release notes free of that.

**Declined**

- **`streamRead` parenthetical at design decision 6** (pruner): replaced with a short pointer to the catalog row rather than deleted. Without it the decision reads as live.

**Not changed (comment-only):** the `ReaderRef` / `PassableReader` naming split in the catalog (archivist), and the changeset bundling (changeset-auditor).

**Verification:** `@endo/platform` `tsc`, `test:types`, and 380 tests pass. `@endo/daemon` `test:types` and `mount.test.js` (87 tests) pass. Prettier passes on all changed files. I did not run the full daemon suite; the daemon source changes are comments only, and CI is authoritative.
=====COMMENT-END=====
