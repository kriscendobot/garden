The reply is posted. This was a "tell me more" conversational job — no code changes were needed, only a substantive technical reply on the issue thread.

Comment posted: https://github.com/kriscendobot/garden/issues/58#issuecomment-5235653620

## Completion report

**Job:** Dead-lettered message for `issue-kriscendobot-garden-58` — kriskowal commented on garden issue #58, "We do want true site-isolation of weblets. Tell me more," a follow-up to my prior comment that flagged the Public Suffix List as the path to true site-isolation.

**What I did:**
- Reconstructed the thread context and grounded the answer in the real `kriscendobot/minion.town` gateway code rather than from memory: `src/endo/gateway/isolation-headers.ts` (the frozen § 5.2 Layer 3 origin floor — CSP, COOP/CORP same-origin, XFO DENY, no CORS), `config.ts` (`parentDomain`/`MINION_TOWN_DOMAIN`), the Caddy blocks, and `test/gateway/cookie-scope.test.ts` (the host-only session-cookie invariant, Layer 1–2). Confirmed the design doc has no existing PSL/site-isolation section, so this is new ground.
- Posted a structured explainer that (1) separates what the *same-origin* floor already blocks from the *same-site* channels only true site-isolation closes (supercookies, `document.domain` collusion, Spectre per-site process sharing, state partitioning); (2) explains the mechanism (PSL private section, with the GitHub `github.io`/`githubusercontent.com` precedent and the "never list your app's session domain" rule); (3) surfaces the real tension with kriskowal's *prior* "drop the `weblet` label" question and lays out three concrete options with tradeoffs and a recommendation (Option A: PSL-list `weblet.minion.town` — smallest step, app untouched); (4) sets rollout expectations (PSL propagates over months → defense-in-depth, not a cutover); (5) gives the per-option code impact and offered to draft a `designs/weblet-site-isolation.md` + PR.
- Left the issue open (submitter closes), per the issue-inbox contract.

**What changed:** one issue comment. No repo/code changes.

**Follow-ups (awaiting maintainer):** kriskowal picks Option A / B / C; on his choice I (or a follow-on job) draft the design doc + PR in `kriscendobot/minion.town`. Note the flatten-to-`*.minion.town` idea from the prior comment and true site-isolation mildly conflict — Option B reconciles both but touches the Gate-1 OAuth callback surface, so it should sequence after that settles.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/deadmail-issue-comment-5235605561.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 13 tokens (358301 cached reads)
- Output: 16501 tokens
- Cost: $1.2132605000000003
- Wall-clock: 264s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
