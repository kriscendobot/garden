# Gauntlet fix round 2: kriscendobot/minion.town PR #190

I applied the panel-2 must-fix items and pushed them as two follow-up commits to `clip-gutter-reorder` (`4827a34..45bc4b8`). CI on `45bc4b8` is green (`ci-wait-merge` rc 0).

## What changed

**Locksmith and decomplector (identity-keyed write authority):** the gutter order no longer lives on `AccountStore`.
- A new module, `src/endo/gateway/clip-order.ts`, keeps each owner's order in its own file under `$GATEWAY_STORE_DIR/clip-orders/`.
- `bindClipOrderFacet(publisher, owner)` returns a facet whose `listing()` and `reorder()` take no owner argument. It rejects hashes that aren't in that owner's own listing.
- `ClipPublishFacet` now includes this facet, and `publisher.list` applies the saved order, so MCP `listSites` shows the same order as the gutter.
- The browser routes only pick the bound facet from the signed-in identity (`clipsFor` replaces `listClips`).
- These files are back to the base version: `accounts.ts`, the DynamoDB adapter, `deploy-accounts-store.sh` (IAM), `minion-mcp.service` and `designs/account-creation-open-signup.md`. That removes `clip_order` and `setClipOrder`, and makes the integrator's schema-table item moot.

**Breaker (two tabs saving out of order):** every saved order now has a revision number.
- `GET /account/clips` returns the revision, and `PUT /account/clips/order` must send back the one it read (`{hashes, revision}`).
- For each owner, the revision check and the write happen together, one save at a time. A save based on an outdated revision gets a 409 with the current revision.
- The browser shell adopts the new revision after each save, and reloads the listing when it gets a 409.

**Saboteur (stale cache):** this went away because the order is no longer in the cached account record.

**Engine-realist (should-fix):** order saves now use `keepalive`, so one started just before navigation or logout can still finish.

**Stylist:** renamed `fc` to `fastCheck` and `ids` to `identifiers`.

**Archivist:** `DEPLOYMENT.md` now lists the exact 400 cases ("`hashes` absent or not an array", the size limit, duplicates, unowned hashes, a bad revision) and documents the 200 and 409 responses. The IAM rollout step is gone.

**Prover:** the commit message and the PR body carry a regression note. For each of seven production paths I broke the code, confirmed the named tests went red, then restored it. One test (the publisher bound-facet test) originally passed even with its path broken, because the default listing order is random; I fixed it to save the reverse of that order, and it now fails as it should.

**Corner-prober, fast-checker, wire-watcher:** added tests for:
- an empty order;
- exactly 1000 hashes;
- a saved hash the owner no longer holds being ignored;
- a correctly formatted 52-character id the caller doesn't own;
- concurrent saves and outdated-revision saves;
- a fast-check round-trip of the file store, and a check that callers can't change a stored order through lists they passed in or got back.

**Spec-keeper:** the drag test is renamed and commented to say it calls the gutter's own handlers through a Node fake, and is not evidence of browser drag-and-drop behavior.

I also updated the PR body for the new design. Its `garden-job` marker is unchanged.

## Verification
- Typecheck passes.
- Full suite: 1147 passed, 1 failed, 11 skipped. The failure is `test/git-remote/capability.test.ts` ("propagates a git failure…"). That code is unchanged by this PR, and the failure looks like it comes from this host's git setup.

## Follow-ups
- The design change goes beyond a point fix: clip order is now stored by the publisher instead of on the account. Panel-3 should confirm it fully satisfies the locksmith and decomplector items.
- Concurrent saves are serialized inside a single app process, which matches the current single-instance deploy. Running more than one app instance would need a conditional write in the store.
- No real-browser, multi-engine drag-and-drop test was added.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr190-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 106 tokens (6142178 cached reads)
- Output: 45517 tokens
- Cost: $3.3224396
- Wall-clock: 2765s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
