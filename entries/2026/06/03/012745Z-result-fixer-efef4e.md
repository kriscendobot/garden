---
ts: 2026-06-03T01:27:45Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
worktree: dispatches/fixer--765f0b/project
---

Addressed kriskowal's CHANGES_REQUESTED on #392 inline at the `prependFrame`
call site ("This is a hack. Consider the necessary OCapN or OCapN Noise
Protocol refactor that would allow new sessions to be initiated with the
already-read information rather than obliging them to replay the read.").

The hack characterization is correct. The clean fix requires modifying
OCapN/Noise to accept pre-read frames at session init, which affects every
Noise responder and is out of scope for the gateway PR. The bindings layer
(`packages/ocapn-noise/src/bindings.js`) already accepts a pre-read SYN via
`responderReadSynWriteSynack(prefixedSyn, synack)`; only the network-layer
session-init entry point in `packages/ocapn-noise/src/network.js`
`handleIncoming` and the daemon-side `handleOcapnSession` exo need a parallel
shape that takes an optional pre-read SYN.

Deliverables this dispatch:

- Addressing SHA on #392: `ee8297f0c` (one commit, docs only, no behavior
  change). The commit adds a comment at the `prependFrame` call site that
  names the workaround, cites the OCapN/Noise files that would need to
  change, and references issue #406.
- Follow-up issue filed: endojs/endo-but-for-bots#406
  (https://github.com/endojs/endo-but-for-bots/issues/406)
  "OCapN/Noise: accept pre-read frames at session init (gateway hack
  carrier)". Body cites kriskowal's review thread, summarizes the gateway's
  `prependFrame` workaround, names the network-layer + daemon-exo refactor
  scope.
- Review-thread reply:
  https://github.com/endojs/endo-but-for-bots/pull/392#discussion_r3345408045
  Acknowledges the hack characterization, cites the new issue and addressing
  SHA, notes the PR is the best the gateway alone can do.
- Top-level summary comment:
  https://github.com/endojs/endo-but-for-bots/pull/392#issuecomment-4608309253

No restack: comment-only commit; successor PRs #393-#397 see no diff.

Self-improvement: nothing this time. The dispatch's framing was precise
(name the OCapN/Noise file(s), file the issue, comment + reply + summary,
do not modify behavior, do not touch successor layers) and the workflow
matched the standard fixer-on-deferral pattern documented in
`roles/fixer/AGENT.md` § Operating norms ("Skip-with-reason if a 'should
fix' item is genuinely out of scope").
