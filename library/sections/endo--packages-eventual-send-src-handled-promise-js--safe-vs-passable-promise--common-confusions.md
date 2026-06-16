---
title: Common confusions
source: packages/eventual-send/src/handled-promise.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/eventual-send/src/handled-promise.js
source_line_range: "369-401"
source_commit: ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2
comment_subject: "isSafePromise: the safety predicate, its relationship to marshal's passable-promise classification, and the residual reentrancy gap the check cannot close"
ingested: 2026-05-15
ingested_by: scholar
topics: [eventual-send, capability-security, marshal]
status: current
parent: endo--packages-eventual-send-src-handled-promise-js--safe-vs-passable-promise
---

- **"`isFrozen` is the same as `harden`."** No.
  `Object.isFrozen` is the host's structural test; `harden` is
  the SES recursive transitive freeze. The shim uses `isFrozen`
  because the predicate is run on a promise the shim itself
  cannot harden (it does not own `p`). A locally-constructed
  promise that the shim *can* harden gets the deeper guarantee.
- **"Why not call `harden(p)` before the check?"** Hardening
  would mutate the promise's metadata in a way the caller did
  not consent to. The shim's contract is to read `p` without
  side-effecting on it.

Source: [packages/eventual-send/src/handled-promise.js](https://github.com/endojs/endo/blob/ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2/packages/eventual-send/src/handled-promise.js#L369-L401) at commit `ec42cb7b`.
