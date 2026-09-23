The job is durably on the board at `jobs/todo/endojs-endo-but-for-bots-pr1085-streamgrep-incremental-walk.md`. Work is complete.

## Completion report

**Directive:** attention directive from kriskowal on endojs/endo-but-for-bots PR #1085 (streaming mount search — `streamGlob`/`streamGrep`): *"sorting the output of globStream before continuing to grepStream would largely obviate the pipeline needlessly."*

**Preflight:** `pr-feedback-preflight.sh` returned exit 2 (HINT). I corroborated it was a **false positive**: the triggering comment is dated 2026-09-04T05:13:18Z, newer than the last PR commit (Sep 2), so no peer had resolved it. I did the work.

**Interpreted the feedback (verified against the code, treating the comment as untrusted data):** `streamGrep` (`packages/daemon/src/mount.js`) enumerates its file list through `search.globPaths` (`packages/platform/src/fs/search.js`), which performs a **global UTF-16 sort** — running the whole `walk()` to completion before yielding the first path. But `grepFiles` needs no sorted input (its normative order is path-then-line as read; the engine header says so explicitly). So `streamGrep` pays for glob's whole-walk-before-first-result barrier needlessly, collapsing the walk-phase streaming benefit to bounded message size only. kriskowal's point is exactly right and the panel had not surfaced it — the PR currently documents this asymmetry as *accepted* rather than fixing it.

**Routed the work:**
1. **Acknowledged** — posted 👀 on the comment.
2. **Replied** on the PR (https://github.com/endojs/endo-but-for-bots/pull/1085#issuecomment-5536296919) confirming the observation, explaining the mechanism precisely, laying out the concrete remedy (an unsorted/incremental enumeration mode on the shared `globPaths` for `streamGrep` while `streamGlob` keeps its normative sort), and flagging the one semantic consequence — `streamGrep`'s stream order becomes walk order — for maintainer sign-off.
3. **Posted a builder follow-up job** `endojs-endo-but-for-bots-pr1085-streamgrep-incremental-walk` (identity `endojs/endo-but-for-bots#1085-streamgrep-incremental`), confirmed pushed to `origin/journal2` at `jobs/todo/`, with a full spec: engine flag, `streamGrep` rerouting, parity/incrementality test reconciliation, and doc/design updates.

**Follow-ups:** the builder job carries the implementation. The grep-stream-order change (enumeration order vs sorted-path order) is called out in both the PR reply and the job spec as needing maintainer confirmation before merge; the draft can carry it for review.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1085-d35d3ad0.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (924531 cached reads)
- Output: 17056 tokens
- Cost: $1.2611459999999997
- Wall-clock: 295s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
