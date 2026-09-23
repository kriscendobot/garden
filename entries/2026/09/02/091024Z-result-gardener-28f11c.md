---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-09-02T09:10:26Z
---
---
kind: result
role: purist
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
---

Per-juror block for the code panel on endojs/endo-but-for-bots PR #1085
(`feat/mount-stream-glob-grep`, diff base `origin/llm`, head `ed5fbadabe`).

### purist (ocap purity and conceptual integrity)

**Verdict:** request-changes

**Findings:**

- `packages/daemon/src/mount.js:103-112,121-125,1018` — `STREAM_STRING_LENGTH_LIMIT`
  bounds nothing and only adds an abort mode. By the time the reader pump runs
  `mustMatch(result.value, readPattern)` (`packages/exo-stream/reader-pump.js:112`),
  `grepFiles` has already read the whole file into one string and split it
  (`packages/platform/src/fs/search.js:493-511`) — the daemon's memory is committed
  before the check. So the ceiling's only observable effect is that a matched line
  over 10,000,000 characters (a source map, a minified bundle) rejects the *entire*
  stream, while eager `grep` returns the record: the same parity break round 2 set
  out to close, moved rather than removed. The comment's "an absurd length is still
  bounded" claims a protection the check cannot provide. Use
  `stringLengthLimit: Infinity` — the guard is `length <= stringLengthLimit`
  (`packages/patterns/src/patterns/patternMatchers.js:1046`), so `Infinity` keeps
  the shape self-description while dropping the abort — or truncate at the producer.
  The new long-line test stops at 100,001 characters, so the residual is unpinned.
  must-fix-adjacent; I file it should-fix. [rule: roles/jurors/purist/AGENT.md
  § Operating norms — family-consistency and edge-case enumeration on values]

- `packages/daemon/src/mount.js:121-125` — `grepMatchPattern` is an *exact*
  copyRecord, strictly tighter than every other `GrepMatch` surface.
  `SearchFilePowers.search` is a declared pluggable native engine
  (`packages/platform/src/fs/search-types.ts:76-89`); a native engine that adds one
  field to its match records leaves `grep`/`glorp` working and aborts `streamGrep`.
  `M.splitRecord({ file, line, text })` matches the eager surface's tolerance. Same
  root cause as above: `readPattern` is enforced as a producer-side abort, not a
  consumer-side check. should-fix. [rule: roles/jurors/purist/AGENT.md
  § family-consistency across related symbols]

- `.changeset/daemon-mount-stream-glob-grep.md:14` — advertising `clampStreamBuffer`
  as newly public. `STREAM_BUFFER_MAX` earns its export (a caller cannot otherwise
  discover the ceiling); the clamp *function* is a test-reachability export whose
  behavior is already pinned observably at
  `packages/daemon/test/mount-stream-search.test.js:722`. `./src/mount.js` is in the
  package `exports` map, so the changeset commits `@endo/daemon` to a helper's
  signature it does not need. Drop that sentence. should-fix.
  [rule: AGENTS.md § Thunk modules ¶2 "Public-interface filtering"]

- `packages/daemon/src/help-text-data.js:229,241,257` and `src/help.md:837,853,869` —
  `glob` and `grep` each gained a "for incremental or unbounded result sets use
  streamGlob/streamGrep" pointer; `glorp`, the third member of the same family,
  gained none — even though `streamGrep(pattern, { glob })` *is* its streaming form.
  Add the pointer. should-fix. [rule: roles/jurors/purist/AGENT.md
  § family-consistency across related symbols]

- `packages/daemon/src/mount.js:1056-1057` — `denied` is one unfrozen array instance
  shared by the `globPaths` and the `grepFiles` call; eager `glob` and `grep` each
  build a fresh spread per call. The deny list is the confinement boundary; hand a
  hardened copy to an extension point. `harden([...deniedSegments])`. comment-only.
  [proposed-rule: a capability-bounding argument (deny list, confinement root)
  passed to a pluggable engine is hardened, never a live mutable array shared
  across calls.]

**Notes (out of scope but worth flagging):**

- The per-stream revocation-latency window and its k-concurrent-streams
  multiplication are documented thoroughly at `mount.js:41-67` and in
  `designs/mount-stream-glob-grep.md § Revocation`, with `buffer: 0` the default
  hard-cutoff. Correctly scoped; acknowledge, no work. [rule:
  roles/jurors/purist/AGENT.md § side-channel closure]
- `M.remotable('PassableReader')` in `interfaces.js:701,715` matches the exo's own
  interface name at `packages/exo-stream/reader-from-iterator.js:52`. Family-
  consistent with `followNameChanges`. No finding.

Self-improvement: the readPattern finding generalizes past this PR — a
producer-side `mustMatch` on a stream element is an *abort surface*, not a bound,
whenever the producer already materialized the value. I have sent that as a
`[proposed-rule]` candidate for the purist's *Notes from the field*: when a PR
adds a validation guard justified as a resource bound, check whether the resource
was already committed upstream of the guard; if it was, the guard buys only a new
failure mode.
