---
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Post review-thread replies on endojs/endo-but-for-bots PR #1484

Handoff from job `endojs-endo-but-for-bots-pr1484-review-292b9e05`. The bot PAT on
oros-studio gets a 403 on PR comment writes to endojs, so this job is pinned to endolin.
The design revision is already pushed (head commit 28725a3e7 on
`design/https-fragment-locators`). Your only task is to post the two replies below,
each as a reply to the named inline review comment, using exactly this command:

    gh api -X POST repos/endojs/endo-but-for-bots/pulls/1484/comments/<COMMENT_ID>/replies -F body=@<file>

First check the thread with
`gh api repos/endojs/endo-but-for-bots/pulls/1484/comments --paginate --jq '[.[]|select(.in_reply_to_id==<COMMENT_ID>)|.user.login]'`
and skip any reply kriscendobot has already posted, so a rerun posts nothing twice.
Do no other work on the PR.

## Reply to comment 4344892435

Revised in 28725a3e7. The fragment is now `#ocapn=np&id=…&pk=…&at=…`, and it maps one to one onto an OCapN sturdyref (§ 2). Everything before `#` comes from a per-agent `locatorPrefixes: { adopt, accept }`, and both are empty by default (§ 7). `type` and `name` moved into the query as unauthenticated hints (§ 3.2). The path is now site steering only: `/adopt` and `/accept`, ignored by every parser (§ 3.3). `ocapn` is what marks a link as a locator on any origin (§ 4.2, § 5.1). That section also says plainly that no OS routes a *click* on an unclaimed origin to an app.

These changes open two new questions for you:
- Invitation versus adoption is no longer a field in the locator. My recommendation is that the invitation's `accept` returns the inviter's handle, so `from`/`fromNode` drop out of the locator entirely (open question 11).
- How do the legacy `tcp+netstring+json+captp0:` and `ws:` transports map onto `ocapn` values (open question 3)?

## Reply to comment 4344935804

Recorded in 28725a3e7, § 3.4. `se` is reserved as the live-reference alternative to `id`. For now a parser rejects `se` alone, and rejects `se` together with `id`, with a fixed "unsupported locator" message. Adding it later is a versioned, incompatible change. The section keeps your caveat that `se` presumes the peer never restarts and never reuses a kernel slot identifier.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-22T10:45:20Z
