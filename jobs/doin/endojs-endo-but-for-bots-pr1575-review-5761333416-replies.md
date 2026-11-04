---
posted_at: 2026-11-04T01:05:47Z
role: fixer
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Post review replies on endojs/endo-but-for-bots PR #1575 (relay)

Relay only: host oros-studio's PAT gets a 403 on PR writes to endojs. Change no code, and do not push.
Post each reply below VERBATIM, reading the text from a file (`gh api ... -F body=@file`), per roles/COMMON.md.

- Inline replies: `gh api repos/endojs/endo-but-for-bots/pulls/1575/comments/<ID>/replies -F body=@file`
- Summary: `gh pr comment 1575 -R endojs/endo-but-for-bots --body-file file`

Before posting, list existing replies and skip any already posted, so a requeue does not duplicate them.
The review is https://github.com/endojs/endo-but-for-bots/pull/1575#pullrequestreview-5761333416

===== REPLY to 4462023866 (packages/fae/src/provider-owner.js:108) =====
Agreed, and fixed in 44be7ac43c6c148c4027b8374f71c1083f370e47 and 3d8114790770013ae7b007760f34bed071afd4c5. These sites now pass the field directly:

- all three optional fields in `provider-owner.js`
- the reserved and charged costs on in-memory turns in `inference-provider-admission.js`
- the registry test harness options

The types never required the spread, since `exactOptionalPropertyTypes` is not set in any tsconfig I checked (root and packages). The makers read these through default parameters or `=== undefined` checks, so nothing changes for them.

I left the conditional spreads in `inference-provider-registry.js`, such as `baseUrl`, `supersedes`, and the turn event costs. Those records are written to the journal snapshot and returned to owners, so an explicit `undefined` would change the key set of stored and returned data. Unlike the sites above, that is a visible difference. I can flip those too if you prefer.

===== REPLY to 4462044779 (packages/fae/test/driver-credentials.test.js:22) =====
I can't give you a recorded rationale: 88a03ee7c8 introduced `noSecretPowers` and its message doesn't explain the name. What follows is inferred from the code.

The `powers` parameter is the real Endo sense in production. `driver.js` passes through the `powers` that its `make(powers, context)` receives, and `resolveAuthToken` only calls `has` and `lookup` on it. `credentials.js` documents that same parameter as "the namespace that may hold the secret".

The test double was badly named. It has one method, `has`, which always answers false, so calling it powers claimed far more than it is. It is closer to your exo for an empty `Set<unknown>`.

I renamed it to `makeEmptyNamespace` in 44be7ac43c6c148c4027b8374f71c1083f370e47 and documented on `providerCredentialOptions` that it consults the caplet's powers as a namespace. I kept the parameter name `powers` because it still holds the caplet's real powers, and it matches `resolveAuthToken`.

===== REPLY to 4462059459 (packages/hosted-agent/src/anthropic-api-key-issuer.js:128) =====
I chose `dispose`, in 3d8114790770013ae7b007760f34bed071afd4c5. This file already says `disposeProvider`, `issuer.dispose()`, and `addDisposalHook`, so `close` was the odd one out.

I did not invert it with a `cancelled` promise, for two reasons. The factory has to dispose one provider at a time through `disposeProvider`, which a single promise passed to the maker can't express. And `dispose` is the contract of the shared grant issuer from the base branch, so inverting it would reach beyond this PR. If you would still like the inversion, I think it belongs on that issuer as its own change.

===== REPLY to 4462096862 (packages/hosted-agent/src/inference-provider-policy.js:173) =====
Yes. `makeError(details, ErrorConstructor, { cause })` from `@endo/errors` supports it, though `Fail` takes no options. In 3d8114790770013ae7b007760f34bed071afd4c5 this site now keeps the `JSON.parse` error as the `cause`, and a new test covers it. It is the only check in this validator with an underlying error to carry.

The extra information does not reach anyone in production yet. The registry catches this error at the guest boundary, discards it, records the refusal, and throws the fixed `inference-request-refused`. I kept that on purpose: V8's `SyntaxError` message can quote the request body, which is a guest's prompt, and `codex-model-read.js` avoids attaching a cause for a similar reason. Logging the cause on the daemon side is possible, but it would put prompt fragments in the logs, so that decision is yours.

===== TOP-LEVEL SUMMARY COMMENT =====
Responded to all four inline comments, and retconned.

**Retcon:** the branch is now one commit each for `hosted-agent`, `daemon`, `lal`, and `fae`, with each changeset in its package's commit. The tree at dd15773be6618c5c88852e55686da900cac70186 through 085c532d19c09772df88e19e224ec846e01bff64 is byte-identical to the approved head a1a55ea7a0215b9cc14f9b61110841a10c034368. There is no `chore: Update yarn.lock` commit because this PR doesn't change `yarn.lock`.

**Review changes:** these sit on top as two `fixup!` commits, 3d8114790770013ae7b007760f34bed071afd4c5 and 44be7ac43c6c148c4027b8374f71c1083f370e47, so you can read them separately. They are autosquashed at merge.

**Conduct:** this can't merge yet. The base is a frozen snapshot of #1573's head, and merging onto that snapshot would strand the work off every live branch. A weave onto `llm` is parked until #1573 merges (it is approved, and its conductor is queued), with the conductor parked behind the weave.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-04T02:11:55Z
