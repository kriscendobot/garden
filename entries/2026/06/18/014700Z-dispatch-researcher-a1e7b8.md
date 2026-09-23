---
ts: 2026-06-18T01:47:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: researcher
dispatch_root: /home/kris/dispatches/researcher--a1e7b8
model: sonnet
prs: []
refs:
  - https://github.com/endojs/endo/pull/3036
---

# dispatch: researcher — exo-stream mirror scope + chat iterator migration

User request: "Please create a mirror of
https://github.com/endojs/endo/pull/3036 based on the llm branch
and reconstruct the migration of iterators to streams since
there is considerably more usage of these patterns in the chat
application now."

This dispatch precedes the actual builder dispatch (per the
researcher-precedence rule). Deliverable: a `## Library and
project references` section that the orchestrator inlines into
the builder dispatch.

## State at dispatch time

- **Upstream PR**: endojs/endo#3036
  ("feat(exo-stream): Introduce Exo streams") by kriskowal,
  base `master` on endojs/endo. Adds `@endo/exo-stream` package
  (63 files changed; +6612/-245). Removes
  `packages/daemon/src/reader-ref.js` +
  `packages/daemon/src/ref-reader.js` from daemon; refactors
  daemon + cli to use exo-stream.
- **Mirror target**: endojs/endo-but-for-bots, base `llm` at
  `5be4392`. Project worktree synced to this tip.

## Task

In your `project/` worktree at `5be4392`:

1. Read `garden/roles/COMMON.md` and `garden/roles/researcher/AGENT.md`.
2. **Read upstream #3036 in full**:
   - Fetch the PR's file list and patch via
     `gh api repos/endojs/endo/pulls/3036/files --paginate`
   - For each file in the new `packages/exo-stream/` directory,
     read the source via
     `gh api repos/endojs/endo/contents/packages/exo-stream/<file>?ref=ce7293d6 --jq '.content' | base64 -d`
     (head SHA `ce7293d677956d3937f8ed9c8afd62cb7ec2639d`).
   - Note the exo-stream package's exports (the 4 conversion
     functions: iterator ↔ stream, bytes-reader/writer,
     reader/writer-from-iterator, iterate-* on the consumer side).
   - Note the daemon refactor shapes: how `reader-ref.js` /
     `ref-reader.js` consumers were rewritten to use exo-stream
     equivalents.
3. **Survey iterator/stream usage in packages/chat on llm**:
   - `grep -rn "AsyncIterator\|async function\\*\|yield\|for await" packages/chat/src/` etc.
   - Identify each callsite that:
     - Produces an async iterator that crosses a CapTP boundary
       (would benefit from `iteratorToStream` / `readerFromIterator`
       style conversion).
     - Consumes a remote presence as an async iterable (would
       benefit from `iterateReader` / `iterateBytesReader`).
   - Cite file:line.
4. **Survey other llm-only packages** that might have similar
   iterator patterns needing migration. Candidates to grep:
   - `packages/goblin-chat/`
   - `packages/llm/` (if exists)
   - `packages/gateway/`
   - `packages/genie/`
   - `packages/jaine/`
   - `packages/fae/`
   - Any other package with .js sources that uses async iterators
     across what looks like a CapTP boundary.
   - Compare against master: `git log master..llm --name-only`
     to identify net-new packages on llm vs. master.
5. **Compare reader-ref.js / ref-reader.js usage**: are these
   files present in the llm tree (they're removed by #3036 on
   master)? If present, where are they used?
   - `git ls-files packages/daemon/src/reader-ref.js packages/daemon/src/ref-reader.js`
   - `grep -rn "reader-ref\|ref-reader" packages/`
6. **Identify potential conflicts** between #3036's daemon
   refactor and llm-only daemon changes:
   - `git log master..llm -- packages/daemon/src/` — what has
     llm changed in the daemon since master diverged?
   - Are any of those changes in files #3036 modifies (e.g.,
     daemon.js, host.js, guest.js, directory.js)?
7. **Return the Library and project references section** in
   your result entry. Structure:

   ```
   ## Library and project references

   ### Upstream PR #3036 substance
   - Files added under packages/exo-stream/: <list with one-line purpose each>
   - Daemon refactor touchpoints: <file:line list>
   - CLI refactor touchpoints: <file:line list>
   - Removed: reader-ref.js, ref-reader.js (file paths)

   ### Chat application iterator surfaces (llm-only)
   - <file:line> — <pattern description, recommended migration>
   - ...

   ### Other llm-only packages with iterator patterns
   - <package/file:line> — <pattern, recommended migration>
   - ...

   ### Llm-only daemon changes that intersect with #3036
   - <file:line> — <change description, conflict shape>

   ### Mirror-vs-reconstruct distinction
   - Which #3036 files mirror cleanly (same path on llm).
   - Which need adaptation to llm-only changes.
   - Which net-new migration work is reconstructed (chat etc.).
   ```

## Authorizations

- Read-only access to all source files (no commits).
- Read upstream endojs/endo via gh api.

## Out of scope

- Do NOT push or commit.
- Do NOT open a PR.
- Do NOT modify any source files.

## Deliverable

A `result` entry under `journal/entries/2026/06/18/` containing
the `## Library and project references` section verbatim (the
orchestrator will inline it into the builder dispatch). End your
turn with a concise summary back to the orchestrator.
