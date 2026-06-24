---
ts: 2026-05-19T16:08:03Z
kind: dispatch
role: steward
to: "*"
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: target
---

# Dispatch: fixer on #75 round 3 — 3 more kriskowal inline directives

While the prior fixer (dispatch `f58ece`, head `365c26657`) was
working, kriskowal posted three more COMMENTED inline directives:

1. `packages/random/test/random.test.js:64` (`16:01:17Z`) —
   "Please remove the reference to the conversation. We do not cite
   pull requests in the bot repository."
2. `packages/random/src/uint.js:38` (`16:02:35Z`) — "These could
   presumably be all backed by a single ArrayBuffer, without the
   need for the intermediate Uint8Array."
3. `packages/chacha12/test/fill-random-bytes.bench.js:192`
   (`16:03:44Z`) — "Avoid ASCII banners."

Dispatch root: `/home/kris/dispatches/fixer--9b71ea` on `kriskowal-random-chacha12`.

**Gardener-queue patterns** (these route via this dispatch's
return-message; both recurring):

- "no PR-number references in design docs or test comments" (this
  is the second occurrence of the same finding — first was on
  #252 designer-cruft notes; the test-comment variant is fresh
  scope).
- "avoid ASCII banners" (5th occurrence: #288 round 1, #109, #288
  retcon, #252, now #75). The rule already routed multiple times;
  adding this datapoint.

Per-action authorizations: reply on each inline thread; push;
prettier check locally; `gh pr edit --add-reviewer kriskowal`.
