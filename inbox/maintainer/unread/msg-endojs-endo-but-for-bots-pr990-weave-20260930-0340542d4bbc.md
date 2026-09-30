from_host: endolin-garden-ece02cb4
from: gardener:endojs-endo-but-for-bots-pr990-weave-20260930
reply_to: endojs-endo-but-for-bots-pr990-weave-20260930
msg_key: msg-endojs-endo-but-for-bots-pr990-weave-20260930-0340542d4bbc
notice_count: 1
first_seen: 2026-09-30T03:14:49Z
last_seen: 2026-09-30T03:14:51Z
sent_at: 2026-09-30T03:14:51Z
---
Weave of endojs/endo-but-for-bots#990 onto current llm (7ff30afbce) is HALTED — the premise does not hold.

The frozen base `llm-a54c3ad` (9979fbb2d8) is NOT an ancestor of llm. It is a54c3ad + 18 commits from two PRs that were merged INTO the frozen base branch rather than into llm:
- endojs/endo-but-for-bots#124 slots wire protocol (slot-machine; merged 2026-08-14 into llm-a54c3ad): 111 files, +9361/-411. Adds packages/slots and rust/endo/slots and .github/workflows/rust.yml (the file zizmor flags).
- endojs/endo-but-for-bots#980 ascii strict decoding (feat/ocapn-adopt-ascii; merged 2026-08-19 into llm-a54c3ad): 30 files, +678/-84.
Current llm has no packages/slots or rust/endo/slots, and has only the older @endo/ascii. Rebasing endojs/endo-but-for-bots#990's 7 commits hits modify/delete on every packages/slots file. Weaving onto llm would pull ~140 files of unlanded endojs/endo-but-for-bots#124 and endojs/endo-but-for-bots#980 work into endojs/endo-but-for-bots#990's diff, which breaks the pinned-base rule (the diff must contain only the PR's own files). This is the same stranded-on-a-frozen-base pattern as endojs/endo-but-for-bots#621.

I aborted the rebase. Nothing was pushed and the PR base is unchanged (head 8340019845).

Options:
(a) Re-land endojs/endo-but-for-bots#124 + endojs/endo-but-for-bots#980 onto llm first (a new PR from llm-a54c3ad → a fresh llm-<sha>, resolving conflicts against 2118 llm commits). After that, weave endojs/endo-but-for-bots#990 on top.
(b) Keep endojs/endo-but-for-bots#990 on llm-a54c3ad and fix zizmor on the frozen base: re-pin rust.yml:44 to dtolnay/rust-toolchain@02cb101ec7c4 on llm-a54c3ad itself, or on a new frozen base that stacks the fix.
(c) Retarget endojs/endo-but-for-bots#990 to stack on a re-land PR once (a) exists.
Which one?
