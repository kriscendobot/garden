Clean stage, endojs/endo-but-for-bots PR #1509 (`feat(cli): add endo write for mount files`, daemon-mount Phase 6): **nothing to do.** I pushed no commits.

- **CI:** green at head `d830edc6`. `ci-wait-merge.sh --no-merge` returned 0 (34 checks, 0 failed: lint, test 22.x/24.x on ubuntu and macos-15, cover 22.x/24.x, zizmor; the rest skipped as not applicable).
- **Coverage:** the PR already includes the test it needs. The new `packages/cli/test/demo/mount-files.js` section drives the new `packages/cli/src/commands/write.js` through the CLI. It covers:
  - writing a path given as separate segments or as one slash-separated path, with missing parent folders created;
  - a second write replacing the file rather than appending;
  - binary input coming through byte-for-byte;
  - `..` being held at the mount root;
  - a read-only mount refusing the write.
- **Dead code:** none. The change only adds code (a new command file, its registration in `endo.js`, the tests, a changeset and design notes), so nothing was left orphaned.

One branch has no test: the usage error for an empty file path or an empty segment (for example `endo write project notes/`). It's a trivial check that rejects bad input before the daemon is ever contacted. I didn't add a test for it because that would mean pushing to an already-green draft PR and running CI again for very little gain. A later fix-loop pass can add one if wanted.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1509-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (180531 cached reads)
- Output: 1664 tokens
- Cost: $0.4484102
- Wall-clock: 24s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
