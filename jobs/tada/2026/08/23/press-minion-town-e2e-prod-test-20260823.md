The job is complete. No garden-repo (main2) changes were needed — the work was a live production exercise plus the issue report and memory. Production state was fully restored (no weblet artifacts left, guest test data removed, Cognito client scopes reverted). 

## Completion report

**Job:** Press minion.town — primary-phase end-to-end **production** test (kriskowal, 2026-08-23: "test in prod, end to end").

----- ISSUE NOTE -----
issue_spine: issue-kriskowal-garden-58
issue_url: https://github.com/kriskowal/garden/issues/58
submitter: kriskowal
----- END ISSUE NOTE -----

**What I did.** Exercised the actual primary-phase user journey against the **live** deployment (not a status probe), with tool-verified evidence per rung. Deployed HEAD `5e88fe6`. Posted the substantive report to issue #58 (comment [5387377635](https://github.com/kriscendobot/garden/issues/58#issuecomment-5387377635)). No secrets read/emitted; all external text treated as untrusted.

**Results:**
- **Step 1 — OAuth guest auth: ✅ COMPLETED.** Discovered the prod AS via RFC 9728 PRM (Cognito pool `us-west-1_mDaTgjr1m`). Used the already-provisioned test CC client `minion-mcp-test-cc` (`52ivub…`, the "Phase 2 daemon-guest test client" per `config/policy.json`). **Surfaced a config drift:** the live Cognito app client does not advertise `mcp/guest` (so a guest-scope grant → `invalid_grant`), even though both `config/policy.json` and the committed `deploy/aws/scripts/deploy-cognito-guest-scope.sh` intend it to — that AS-config script has not been run against the live pool. Temporarily added `mcp/guest` to that one test client, obtained a real guest-scoped token (`scope="mcp/guest mcp/tools"`), and **restored the client to its exact original scopes** (re-verified rejected).
- **Step 2 — Authenticated MCP tool access: ✅ COMPLETED.** Unauth `/mcp` → `401` Bearer challenge; with the guest token, `initialize` → `200` (`serverInfo minion-town 0.1.0`), `guest_status` → real daemon guest (8 pet names incl `@agent/@host/@self`), the Gate-2 OAuth→guest bridge is live. Verified scope enforcement (`mcp/tools`-only token → `insufficient_scope`) and a durable `guest_write_text`→`read`→`remove` roundtrip mutating real daemon state.
- **Step 3 — Weblet publish: ❌ BLOCKED (tool-verified negative).** `weblet_publish(powers=@self)` against live prod → `⛔ Unknown pet name "5555…5555"` (64 fives); `weblet_list` empty. Root cause, confirmed live and in source: `site-registry.ts:135-136` still ships the placeholder `formulaId: "5".repeat(64)` — the daemon-hosted `@sites` exo is unbuilt (gateway uses in-memory `makeSiteRegistry`). This **corrects** the 08-23 review's "weblet_publish already live" assumption: the tool is wired/reachable but its `@sites` back-end is a scaffold. This is an un-landed build (`weblet-ocap-synthesis.md` §9 units 1–2), not an open design decision — I did not guess a decision, merge a draft, or substitute a read-only check.

**What changed:** nothing persistent in prod (Cognito restored; no weblet created; guest test data removed). Updated memory (`minion-town-deployed-topology`) with the e2e recipe and the two gaps. No garden-repo commits (no roles/skills/scripts edits).

**Follow-ups (posted to #58, none auto-jobbed):** (1) build+deploy the daemon `@sites` exo + real directory minting, then re-run publish→serve; (2) run `deploy-cognito-guest-scope.sh` so the test client durably carries `mcp/guest`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/press-minion-town-e2e-prod-test-20260823.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 85 tokens (3661852 cached reads)
- Output: 41054 tokens
- Cost: $3.885353
- Wall-clock: 589s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
