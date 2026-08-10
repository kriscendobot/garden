Work complete. Summary of what I did:

## Completion report

**Directive** (PR #34 review by kriskowal): *"Please link to an example weblet."* on the merged design PR `Design isolated weblets on ocap.site` (`designs/ocap-site-weblet-isolation.md`).

**Preflight**: `pr-feedback-preflight.sh` failed open (evidence tool 404'd on the comment id → exit 0, infra failure, not a resolution finding). No peer resolution existed on the board or PR, so I did the work.

**What I found**: The `ocap.site` gateway is actually **live** (contrary to the merged doc's "nominal name" status). Via SSM into `i-0380cd68b90020fad` I enumerated the CAS store's 5 seeded vhost records, converted their hex ids to the 52-char base32 labels using the repo's `idToLabel`, and probed each live. I selected the canonical edge-verification fixture as the example because it demonstrates the design's entire edge contract, all verified live:
- `https://f45ulxdnsrpxbfu5cuc5f2ukypfobxskyq5jmsomjki4p2ekszzq.ocap.site/` → HTTP 200, own `<hash>.ocap.site` origin
- Full isolation floor (COEP `require-corp`, COOP `same-origin`, CORP, `Origin-Agent-Cluster: ?1`, CSP, `X-Frame-Options: DENY`, nosniff, `no-referrer`, permissions denials)
- `Cache-Control: …immutable` + `ETag`; conditional GET returns `304`; no `Set-Cookie`
- Apex `https://ocap.site/` `302`s to `https://minion.town/`

**Changes** (isolated project worktree, branch `design/ocap-site-example-weblet-link`, commit `1ad196c`):
- Added an **Example weblet** section to the design doc linking the live weblet and enumerating the edge properties it demonstrates.
- Updated the status line to reconcile the now-stale "nominal name" claim: the apex redirect and content edge are deployed/live; PSL submission remains future work. `git diff --check` clean; docs-only.

**Artifacts**:
- Follow-up PR: https://github.com/kriscendobot/minion.town/pull/35 (base `main`; #34 was already merged, so a new PR rather than an amend).
- Reply on #34 pointing to the example and PR #35: https://github.com/kriscendobot/minion.town/pull/34#issuecomment-5247308601

**Follow-ups**: PR #35 needs maintainer review/merge. The linked fixture is content-addressed and persists (GC is deferred per the design), so the URL is stable; if weblet GC later ships, the link should be re-pointed at a then-current weblet. No garden `main2` changes were needed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr34-9bbe293f.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 59 tokens (1840102 cached reads)
- Output: 21035 tokens
- Cost: $2.1098830000000004
- Wall-clock: 361s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
