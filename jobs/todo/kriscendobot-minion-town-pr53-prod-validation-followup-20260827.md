---
role: fixer
handler-budget-role: review
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Finish production validation and approved review for kriscendobot/minion.town#53

Continue the approved review at https://github.com/kriscendobot/minion.town/pull/53#pullrequestreview-5044915726 from head 46f3210. The inline ask is resolved by f9c9661 and reply https://github.com/kriscendobot/minion.town/pull/53#discussion_r3875363821.

Remaining work owned by this successor:

1. Diagnose and fix the production live-daemon failure. With the PR app deployed and `WEBLET_SITES_LIVE=1`, boot succeeds, the machine-client MCP probe reaches the zero-cost charge, then `weblet_publish` fails with `Connection stream ended` while the Endo eval worker exits. An earlier production failure in `provideGuest(..., { introducedNames })` was fixed in 46f3210. Production was restored to `WEBLET_SITES_LIVE` unset and the non-serving scaffold log was confirmed before handoff.
2. Re-run `npm run typecheck`, `npm test`, `npm run build`, and the `ENDO_CHECKOUT`-gated `@sites units 1-2` test against pinned Endo f66505034aaa54ac46294347b2bf0e14655b088a with pin-compatible dependencies.
3. Validate in production end-to-end through the MCP machine client: publish returns `serving:true`, the edge URL serves the marker, list contains the hash, and unpublish removes it. Preserve or restore a safe production posture based on the verified result and record exact evidence on kriscendobot/minion.town#53.
4. Confirm the PR is mergeable and checks green, then post a conductor job to un-draft and merge kriscendobot/minion.town#53. Do not name a merge method.

The prior attempt also ran the one-time Cognito guest-scope migration successfully after fixing its order-sensitive read-back check in 46f3210; the full test client can now request `mcp/tools mcp/guest`.
