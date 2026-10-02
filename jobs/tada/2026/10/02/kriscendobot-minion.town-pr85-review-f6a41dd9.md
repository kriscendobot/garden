I answered kriskowal's question on PR #85 and posted a fixer job for the change it points to. No code on the PR changed in this job.

**The question:** review 5393724080 asked why this PR defers upgrading the clip's powers. The review had no inline comments. The preflight check exited 0 (no peer had already answered), so I did the work.

**The answer:** the PR's stated reason is out of date. The code (`daemon-site-registry.ts`, module header R2(a)) rejects a powers rewrite because "the deployed gateway serves with its powers plane off", which would make a rewrite invisible. That premise is wrong now:
- The tracked `deploy/aws/systemd/endo-gateway.service` turns the powers plane on: it sets `GATEWAY_ENDO_SOCK`, under a comment saying "ARMED".
- The prod containment drop-in was disabled on 2026-08-27 under issue #58, and the boot log then showed `powers plane : ENABLED`. This comes from the garden's own memory note; I did not check the prod box from here.
- `powers-plane.ts` reads the clip directory's `back` fresh for every WebSocket session, so rewriting it would change what the next visitor gets.
- The test comment at `test/gateway/gateway.test.ts:163` repeats the same stale claim.

What's actually missing is implementation work, not a design blocker:
- `resolvePowerReference` still throws on the live path.
- The `back` rewrite needs to happen inside the caller's own guest.
- A powers upgrade hands new authority to every public visitor of the clip, since `back` is what they all receive.

The content upgrade is unaffected, because served bytes come from the record's `contentRoot`, not the directory `front`.

**What I posted:**
- **Reply on PR #85:** https://github.com/kriscendobot/minion.town/pull/85#issuecomment-5955947150. It gives the answer above and offers to narrow the scope if he'd rather keep powers out of this PR.
- **Fixer job `minion-town-pr85-powers-upgrade`** (confirmed in `origin/journal2` under `jobs/todo/`). It will implement the powers rewrite on `feat/clip-upgrade-in-place`, add tests, and correct the stale reasoning in the code comments, the test comment and the PR body. It first checks the PR thread: if kriskowal says to keep powers out of scope, it only fixes the stale reasoning and records the powers rewrite as a follow-up.

**Follow-ups:** the fixer job above; kriskowal's possible scope reply.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr85-review-f6a41dd9.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (894970 cached reads)
- Output: 6906 tokens
- Cost: $0.7917940000000001
- Wall-clock: 93s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
