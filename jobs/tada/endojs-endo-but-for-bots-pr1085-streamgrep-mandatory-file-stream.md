The sibling job just completed; my coordination message was dead-lettered and will be promoted to a fresh job, so its intent is preserved. All work is done and verified.

## Completion report

**Job:** Decouple `streamGrep` from internal globbing per PR #1085 review (kriskowal, comment 3931082017) — grep must accept a **mandatory input stream of files**, not fuse glob+grep.

**What I did** (isolated worktree off PR head `feat/mount-stream-glob-grep`, rebased clean on `10a1531efe`):

1. **`streamGrep` signature** (`packages/daemon/src/mount.js`): `streamGrep(pattern, { glob?, buffer? })` → `streamGrep(pattern, files, { buffer? })`. Removed the internal `globPaths` enumeration and the `glob` option entirely. `files` is a `PassableReader<string>` (the shape `streamGlob` returns); it's adapted via `iterateReader` (one path per singleton batch) into the path-batch source `grepFiles` consumes. One walker — in the producer; grep never walks.
2. **Liveness/confinement preserved**: `assertLive()` at invocation, between file-stream pulls (`assertLivePathBatches`, now interposed on the external reader), and before each yield. Confinement/deny/directory/unreadable filtering still runs per supplied path in `grepFiles` — verified by a new authority-envelope test.
3. **Interface guard** (`interfaces.js`): `streamGrep` now takes `M.string(), M.or(M.remotable('PassableReader'), M.promise())` and `{ buffer }`.
4. **Types** (`types.d.ts`) + **regenerated** `packages/agent-tools/generated/code-mode-globals/fs-declarations.js` (`yarn gen:code-mode-types`, not hand-edited).
5. **Help** (`help.md`) + **regenerated** `help-text-data.js` (`yarn generate:help`).
6. **Changeset** rewritten to the composed-stream narrative.
7. **Design doc** reconciled throughout (Surface, Producer implementation, Backpressure/Cancellation, Revocation, Design Decisions incl. new decision #9, Test Plan, Follow-up).
8. **Tests** (`mount-stream-search.test.js`): every call site moved to `streamGrep(p, streamGlob(...))`; reframed the two directory-walk-incrementality tests (grep no longer walks) into producer-walk + content-read-incrementality pins; added two new tests (decoupling: greps exactly a supplied stream; authority: denied/missing/directory/escaping supplied paths skipped silently). Also updated two engine comments in `platform/src/fs/search{,-types}.ts` to frame `sorted:false` as the substrate for a future unsorted producer (kept the `sorted` flag itself untouched).

**Verification**: mount-stream-search 36/36, daemon conformance+mount 96/96, platform search 13/13 (incl. `globPaths sorted:false`), exo-stream 135/135, agent-tools code-mode/mount-fs suites green. `lint:types` clean on daemon/platform/agent-tools; 0 eslint errors. (Pre-existing, unrelated: one `agent-tools/git-flow.test.js` cherryPick failure in the git backend's `assertNoExecutableRepoConfig` — environmental, untouched by this change; and a pre-existing malformed `.changeset/lucky-planes-resolve.md` that trips `changeset status` — not my file; mine parses fine.)

**Pushed**: `aa15e2478632ca0e0aef53ea06afd982db500601` → `feat/mount-stream-glob-grep` (fast-forward, no conflicts). Replied on review thread 3931082017 (reply `r3931755768`, body verified intact) citing the SHA.

**Flagged for sign-off** (per the coordination note, not blocked): walk-incrementality moved to the producer. `streamGlob` keeps glob's global sort, so `streamGrep(p, streamGlob('**'))` reads contents incrementally but is not walk-incremental. Restoring first-match-before-full-walk wants an unsorted `streamGlob` mode over the existing `globPaths({ sorted:false })` — left as a follow-up rather than changing `streamGlob`'s sort contract without the maintainer's decision. This is called out both in the design doc § Follow-up and on the PR thread.

**Follow-ups**: none owned here. No un-draft/merge (not implied by this job). Sibling `streamgrep-incremental-walk` completed while I worked; my rebase advisory to it was dead-lettered and will be promoted to a fresh job automatically.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1085-streamgrep-mandatory-file-stream.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 254 tokens (18564609 cached reads)
- Output: 91746 tokens
- Cost: $12.91579775
- Wall-clock: 1389s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
