---
posted_at: 2026-10-31T17:12:12Z
requires: host=endolin-garden-ece02cb4
pr: https://github.com/endojs/endo-but-for-bots/pull/1586
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Relay: PR #1586 body update + gauntlet fix-3 summary comment

The fix-3 gauntlet stage (job endojs-endo-but-for-bots-pr1586-gauntlet-fix-3) pushed its fixes from host oros-studio-garden-ce242c49. That host's bot PAT gets 403 on `updatePullRequest` and `addComment` for endojs. Do ONLY the following on https://github.com/endojs/endo-but-for-bots/pull/1586. Change no code.

1. Head guard: confirm the PR head (`gh pr view <url> --json headRefOid`) contains commit 71b6970c5cc. If it does not, stop and report.
2. Replace the PR body with the text between the BODY markers: write it to a file and run `gh pr edit <url> --body-file <file>`.
3. Post the text between the SUMMARY markers as one top-level comment: `gh pr comment <url> --body-file <file>`.

=====BODY BEGIN=====
Refs: #467, #1539

## Description

Completes the Phase 1 filesystem catalog surface that the portable contracts can honestly carry. Immutable snapshots expose `followNameChanges()` as an immediately-ending reader, required by `SnapshotTreeInterface`. `EndoMount.makeFile` accepts text or a readable blob and returns the live file capability.

Two catalog methods stay off the minimal portable `Directory` and `SnapshotTree` contracts. `makeFile` stays mount-specific because `EndoMountFile` is not a platform `File` (its snapshot's `sha256()` is asynchronous). `subView` stays on `EndoMount` and the extended `Directory` until the maintainer settles its public name (`mount` was requested on #464).

### Security Considerations

No new authority is introduced. `makeFile` rechecks mount liveness after probing a caller-supplied content source, so a revocation during that probe stops the write before any filesystem mutation. Blob writes retain atomic replacement.

### Scaling Considerations

Immutable change readers end immediately, and blob initialization keeps the streaming write path.

### Documentation Considerations

The design records the narrowed catalog and why, marks the superseded `streamRead` spelling historical, and the daemon help documents `EndoReadableTree.followNameChanges`.

### Testing Considerations

Type tests pin `EndoMount` as assignable to `Directory` and `WritableGitWorktree` without casts. A conformance test checks the guarded mount snapshot against `SnapshotTreeInterface` and drains its `followNameChanges` reader. Mount tests cover `makeFile` boundary cases and the revocation race; each new assertion was observed failing with its implementation disabled.

### Compatibility Considerations

Third-party `SnapshotTree` implementations, including the snapshot an `@endo/exo-git` worktree returns, must add `followNameChanges`. Callers that ignored `makeFile`'s former undefined result remain compatible.

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


=====BODY END=====

=====SUMMARY BEGIN=====
## Gauntlet fix round 3: response to panel review 5723552735

Head: `71b6970c5c` (commits `3b9923b6`, `c529b93f`, `12beca5e`, `71b6970c` on top of `a5e66392`).

**Addressed**

- **`Directory.makeFile` vs `EndoMountFile`** (assessor, breaker, purist, spec-keeper, wire-watcher, engine-realist, integrator, migrator): `makeFile` is removed from the portable `Directory` contract and stays mount-specific. `EndoMountFile` is not a platform `File` (its snapshot's `sha256()` is asynchronous), and `write(path, blob)` followed by `lookup(path)` already does the job on every `Directory` (decomplector). The `unknown` casts in the agent-tools, agentry, and daemon git fixtures are gone (pruner). `expectTypeOf<EndoMount>().toExtend<Directory>()` and `.toExtend<WritableGitWorktree>()` now pin assignability without casts.
- **`subView` name** (integrator, decomplector): `subView` is no longer promoted into the minimal portable `Directory`, `SnapshotTree`, or daemon `EndoReadableTree` contracts. It stays where it already shipped (`EndoMount`, extended `Directory`) until the maintainer settles the `mount` rename requested on endojs/endo-but-for-bots#464. This also resolves the warden (`harden(tail)`) and corner-prober (`subView` path boundaries) findings, because the snapshot `subView` code is removed.
- **Exo-level snapshot coverage** (prover): the conformance suite now checks the guarded `mount.snapshot()` against every `SnapshotTreeInterface` method and drains its `followNameChanges` reader. Both tests fail when `followNameChanges` is removed from the guard.
- **Revocation race in `makeFile`** (saboteur): liveness is rechecked after the content-source probe and before any filesystem mutation, with a gated-remotable regression test that fails without the recheck.
- **`makeFile` boundaries** (corner-prober): an existing target with omitted content returns a live file, `''` truncates, empty and multi-chunk blobs write exact bytes, and a blob that fails mid-stream leaves the existing target intact.
- **Help surface** (surfacer): `help.md` and `help-text-data.js` document `EndoReadableTree.followNameChanges`.
- **Design** (archivist, integrator): later `streamRead` mentions are marked historical, the open question and appendix tables match the code, and Phase 1 is reclassified as additive behavior. The attenuator promotion is recorded as separate work gated on the name.
- **Changeset** (changeset-auditor, releaser): rewritten as an upgrader note, one sentence per line. `@endo/exo-git` is now major (a worktree's snapshot type gains a required method) and `@endo/agent-tools` is minor.

**Declined**

- **fast-checker:** adding `fast-check` as a new devDependency is a proposed rule, not an adopted one. The new example-based boundary tests cover the empty, binary, and multi-chunk cases.

**Verification:** `@endo/platform` (380 tests), the daemon mount suites, and agent-tools `code-mode-types` pass. `tsc` passes for platform, daemon (including `test:types`), exo-git, agent-tools, and agentry. Daemon `git` / `git-remote` fixture tests could not run on the fixing host because its fake-git and askpass fixtures fail there; those files only lost type casts. CI is authoritative.

=====SUMMARY END=====
