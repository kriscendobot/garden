---
arc: endo-ocapn-background
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
requires: host=endolin-garden-ece02cb4
---
Builder handoff on endojs/endo-but-for-bots: OPEN THE DRAFT PR ONLY. No code work is needed.

Predecessor job `build-daemon-mount-next-phase` (host oros-studio-garden-ce242c49) finished daemon-mount Phase 6 and pushed:
- head branch `build/daemon-mount-phase6-endo-write-92b91a7` (commit d830edc6c)
- frozen base `llm-92b91a7` (already on the fork)

It could not open the PR there because that host's PAT gets a 403 on createPullRequest for endojs. On this host, from a project checkout of that head (`scripts/jobs/ensure-project-worktree.sh <this-job-base> endojs/endo-but-for-bots build/daemon-mount-phase6-endo-write-92b91a7`, cwd = that checkout so the phase-evidence gate can resolve `designs/*.md`), write the body below to a file **verbatim**, and keep the predecessor's `garden-job` marker so identity converges. Then run:

    scripts/jobs/gardening/ensure-pr.sh build-daemon-mount-next-phase endojs/endo-but-for-bots \
      build/daemon-mount-phase6-endo-write-92b91a7 llm-92b91a7 \
      --title "feat(cli): add endo write for mount files (daemon-mount Phase 6)" \
      --body-file <file>

Pass `build-daemon-mount-next-phase` as the job base so the marker matches. Name the resulting PR number in your completion report so the gauntlet is staged.

----- PR BODY (verbatim) -----
Refs: #283

Implements: `designs/daemon-mount.md` § Phase 6 (CLI commands for mount interaction), the design's last open phase.

## Description

Adds `endo write <mount-name> <path...>`, which streams standard input into a file inside a mount:

```
$ echo "hello" | endo write workspace notes.txt
$ endo write project src/index.js < index.js     # one slash-delimited path works too
```

The command looks up the mount by pet-name path and hands a bytes reader over stdin to `EndoMount.write`. That method already clamps `..` at the mount root, rejects symlink escapes and denied segments, creates missing parent directories, and swaps the target in only after the whole input has been read. The bytes are streamed, not decoded, so binary input round-trips unchanged.

The other two Phase 6 verbs needed no new code. `endo ls <mount>/<path>` and `endo cat <mount>/<path>` already reach into a mount, because the host's pet-name-path lookup walks into the mount's transient directory and file exos. The new demo section tests them so they stay working.

Files to review: `packages/cli/src/commands/write.js` (the command), `packages/cli/src/endo.js` (registration, Storage help group), `packages/cli/test/demo/mount-files.js` (the test). The design now shows the slash-path form for `ls` and `cat`, Phase 6 is checked off, and the status is **Complete**. Later mount extensions (revocation, deny patterns, glob/grep, `followNameChanges`) have their own designs and PRs and are not phases of this one.

This adds no new daemon mechanism. It reuses `EndoMount.write` and the `bytesReaderFromIterator` stdin bridge that `endo store --stdin` already uses. It also does not create a blob formula first, so a write leaves nothing new in the pet store.

#283 (halted) also proposes an `endo write`, as part of a larger reshape of the `store`/`cat` flags. This PR is narrower: it writes raw stdin bytes, with no `--text`/`--json` modes and no source-selection flags, so neither PR settles those questions for the other. If #283 lands later, it can add its flags on top of this command.

### Security Considerations

This grants no new authority. The CLI can only write through a mount the acting agent already names, and every confinement check (`..` clamping, symlink escapes, denied segments, read-only) stays in the daemon's `EndoMount.write`. The test checks `..` clamping and read-only refusal against the disk.

### Scaling Considerations

stdin is streamed through the existing bytes-reader protocol rather than buffered whole in the CLI, so memory use does not grow with file size.

### Documentation Considerations

`endo write --help` and the grouped `endo --help` (Storage) list the new verb. The `daemon-mount` design's CLI sketch matches the shipped forms. A changeset (`@endo/cli` minor) describes the verb.

### Testing Considerations

New `packages/cli/test/demo/mount-files.js`, run from `packages/cli/test/demo/index.test.js` against a live daemon. It mounts a temp directory, then checks each CLI result against the files on disk:

- `endo ls project` and `endo ls project/src` list the right entries
- `endo cat project/package.json` prints the file's bytes
- `endo write` with separate segments creates missing parents; with a slash path it replaces the existing file
- binary stdin (`00 ff 80 0a 7f`) round-trips byte for byte
- `endo write project ../escape.txt` is clamped and lands inside the mount
- `endo write` to a `--read-only` mount exits non-zero and leaves no file on disk

Ran locally: `ava test/demo/index.test.js --match mount-files --match trivial` passes. `eslint` and `tsc` report nothing new on the touched files.

### Compatibility Considerations

This only adds a verb; no existing command changes behavior.

### Upgrade Considerations

None. It is a CLI-only addition, with no change to formulas or persisted state.

<!-- garden-phase-evidence-ledger:v1 -->
## Phase and evidence ledger

Design: `designs/daemon-mount.md` (its index row in `designs/README.md` is updated to Complete)
Disposition: deliverable
Phase 1: satisfied | core mount exo and `mount` formula landed in `e22f71327`
Phase 2: satisfied | mutation methods landed in `e22f71327`
Phase 3: satisfied | scratch mounts landed in `e22f71327`
Phase 4: satisfied | sub-mounts landed via #656, snapshot via #339
Phase 5: satisfied | transient lookup exos landed in `e22f71327`
Phase 6: satisfied | this change: `endo write`, plus tests showing `endo ls`/`endo cat` reach into mounts through pet-name paths
Acceptance: satisfied | Phase 6 item 4 ("tests for each command") is met by `packages/cli/test/demo/mount-files.js`, which runs against a live daemon and checks every result on disk
<!-- /garden-phase-evidence-ledger -->

<!-- garden-job: build-daemon-mount-next-phase -->
----- END PR BODY -----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-19T21:47:22Z
