Fix round 5 for kriscendobot/minion.town PR #190 is pushed and CI is green. I fixed both request-changes seats (decomplector and pruner) from panel review 5537756284. The new PR head is `c99ca91`.

**Decomplector: the clip order is now saved last-writer-wins**
- I removed the revision check, the per-owner save queue, `ClipOrderConflictError` and its 409 response, `InvalidClipOrderError`, and the browser's conflict/refresh path.
- `PUT /account/clips/order` now takes `{ hashes }`, at most 1000 distinct clip labels, and returns 204. It overwrites the owner's order file using the same temp-file-then-rename write as before.
- `ClipPublisher.list` and `bindPublishFacet` are back to their base-branch form. Listing stays a pure ownership listing, and the MCP publish facet no longer has any ordering methods.
- `ClipOrderer`, `ClipOrderFacet` and `bindClipOrderFacet` are replaced by one owner-bound function, `bindClipOrder(list, store, owner)`. Only the HTTP route uses it.
- The browser still sends one save at a time and folds queued saves into the latest one. This keeps the round-1 fix: a tab's later reorder always lands last.
- Saves no longer check that the caller owns each hash. A saved hash the owner doesn't hold is skipped when the order is read, so a stale save can't leave the browser stuck on a 400. This also removes the assessor's comment-only concern about a lost response causing a spurious 409.
- `designs/clip-shell-framework.md` §2 now says that a clip's `order` comes from its position in the listing. It also explains why each owner's order is kept in its own file beside the clip records rather than on them.

**Pruner: prose cuts**
- The repeated Express 4 note now points to the explanation above it.
- The repeated "no owner selector" lines were deleted along with the types they described.
- The test caveat is down to two lines.
- The design's gutter bullet no longer mentions the facet.

**Checks**
- `tsc --noEmit` is clean.
- Locally, vitest had 1146 passing and 1 failing. The failure is `test/git-remote/capability.test.ts`, which depends on the host's git setup and was already listed in the PR body as outside this PR.
- `ci-wait-merge.sh --no-merge` returned 0 (green).

I also updated the PR body to describe the new behavior and posted a round-5 summary comment on the PR. The panel has not reviewed the last-writer-wins version yet; panel-6 will do that.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr190-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 82 tokens (4038683 cached reads)
- Output: 28098 tokens
- Cost: $2.3583446000000006
- Wall-clock: 1271s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
