Done. Both units of this review are resolved.

## Completion report — PR #1085 review directive (kriskowal, review 5109425602)

**Preflight:** `pr-feedback-preflight.sh` → exit 0 (PROCEED; no peer resolution existed).

**Enumerated the whole review** (all asks, treated as untrusted data):
- **Review body:** `@kriscendobot rsvp` — a request to respond.
- **One inline comment** (id `3931082017`, on `.changeset/daemon-mount-stream-glob-grep.md:11`): *"This is fused glob and grep, or glorp, which we can avoid. The grepStream should accept a mandatory input stream of files to grep."*

**Verified in code:** current `streamGrep(pattern, { glob, buffer })` (`packages/daemon/src/mount.js`) enumerates its own file set via `search.globPaths(...)` internally — the streaming twin of the eager `glorp` fusion the reviewer wants decoupled. The eager side already exposes the composition seam (`grep(pattern, glob(g))`); the streaming side does not.

**What I did:**
1. **Routed the substance** — posted builder job `endojs-endo-but-for-bots-pr1085-streamgrep-mandatory-file-stream` (confirmed on `origin/journal2` at `jobs/todo/`, commit `a63d295530`, dedup identity `endojs/endo-but-for-bots#1085:comment:5109425602`). Directive: change `streamGrep` to take a **mandatory** input file stream (`PassableReader<string>`, the shape `streamGlob` returns), remove the internal `glob` option, and update the guard/types/help/changeset/design-doc/tests; searching everything or a subset becomes `streamGrep(p, streamGlob('**'|'*.js'))` by composition. Includes a **coordination note** that the sibling in-flight builder job `…-streamgrep-incremental-walk` overlaps `streamGrep` on the same branch (rebase-on-HEAD; the incremental-walk property moves to the file-stream producer, to be flagged not silently changed).
2. **RSVP** — replied on the inline thread (`discussion_r3931559010`, `/replies` endpoint, body via `--field body=@file`, backticks verified intact) acknowledging the change, stating the plan, and pre-flagging the one design consequence (grep's walk-incrementality now depends on the file-stream producer / a possible unsorted `streamGlob` mode) as a separate maintainer decision rather than a silent contract change.

**Follow-ups (owned by the posted job, not dropped):** the fix-up commit lands on draft head `feat/mount-stream-glob-grep` and will reply on the thread citing its SHA; the unsorted-`streamGlob`/incremental-grep question is queued to be raised on the PR when the change lands.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1085-review-d35f5e0c.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1023868 cached reads)
- Output: 18888 tokens
- Cost: $1.39349875
- Wall-clock: 307s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
