---
child-endojs-endo-but-for-bots-pr995-endo-claude-followup-design-reap-count: 0
order: serial
children: endojs-endo-but-for-bots-pr995-endo-claude-followup-design endojs-endo-but-for-bots-pr995-conduct endojs-endo-but-for-bots-endo-claude-build
on-child-failure: halt
state: running
created_by: liaison
created_at: 2026-08-17T04:57:13Z
---

# Orchestration: resolve PR #995 review (endo-claude), merge, then build

Owns the full resolution of the kriskowal APPROVAL review on
endojs/endo-but-for-bots PR #995
(https://github.com/endojs/endo-but-for-bots/pull/995#pullrequestreview-4948539393).

Serial, halt-on-failure. Children in order:
  1. endojs-endo-but-for-bots-pr995-endo-claude-followup-design
       — designer: address the inline comment (explicitly threaded / follow-up
         session capability) in designs/endo-claude.md; push to design/endo-claude;
         reply to the inline thread.
  2. endojs-endo-but-for-bots-pr995-conduct
       — conductor: un-draft + merge PR #995 into llm; post completion summary.
  3. endojs-endo-but-for-bots-endo-claude-build
       — builder: implement @endo/claude per the merged design ("Post a builder").

Halt if the conductor cannot merge (PR not mergeable / checks red) so the build
does not run against an unmerged design.
