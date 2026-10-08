**Fix round 6 for kriscendobot/minion.town#167: pushed, CI green**

I applied the round-6 panel's requested changes to `designs/root-canary-principal.md` as one follow-up commit, `d41b3ac` (pushed fast-forward over `f155401` with `safe-push-pr-head.sh`). No seat had raised a must-fix; the round was held at must-fix because of the should-fixes from the two request-changes seats, so I applied those plus the cheaper should-fixes from the comment-only seats. CI is green (`ci-wait-merge.sh --no-merge` returned 0; 3 of 3 checks passed, 0 failed).

**Critic**
- **Client secret:** the design no longer calls it a second factor. It now says the split only defeats a token leaked on its own (for example, pasted into a log). It does not protect against someone who can use the reader role or an AWS admin, because both pieces sit in the same secret. The table, § 2.3 and the A3 fallback were updated to match.
- **Alternatives (§ 4):**
  - A dedicated canary root account is now weighed instead of rejected: it costs a second Claude seat and a second GitHub account (with its terms-of-service question), and it gives real pet-name separation. The design points out that its mechanism works for either account, and open question 1 now asks which account to use.
  - A staging stack is covered as not available today.
  - The weak reasons for rejecting the `client_credentials` and native-user alternatives were replaced.
- **Refresh-token lifetime:** the design now recommends 90 days, with the reasoning given in § 2.4. The client table and open question 5 were updated.
- **§ 2.0:** it now opens with the four premises that can stall the design. It also says the spike needs only open question 2 answered, so it should run before another review round.
- **Inconsistencies:** the A5/A6/A9 fallback now makes deleting the client a required second step after revoking the token. Before, it called that the "primary" revocation, which contradicted § 2.4.

**Decomplector**
- **Cleanup after a revocation:** only the human root owns it now. The canary can't sweep once its token is revoked, because the wrapper's preflight exits 75 first. § 2.4, the runbook and the ownership map were updated.
- **Run lock:** it is now named as the garden schedule's `occupancy: skip` setting, which the job board's claim push already serializes across every host. It is added to the ownership map, and the map row the seat said contradicted § 2.6 is split into two.
- I also added a note that pulling operator levers 2 or 4 will show up as canary failures, not auth-unavailable.

**Skeptic**
- The A2 premise now names kriscendobot's exact entry in `ENDO_CLAUDE_ROOT_SUBJECTS`: `79b9090e-20a1-70d2-94c7-717257e2be34` (pool username `GitHub_279080640`). The spike compares the refreshed token's `sub` against that entry.
- The cleanup of a stray pool user now has a guard: it must never touch kriscendobot's real user.
- If the design stalls, the only path left is a person signing in by hand, and the canary reports root-only checks as "not verified", never as passed.
- The 15-minute bound on a revoked token is now marked as resting on A6 and unproven until the revocation drill runs. Dismissing the children is named as the step that stops runaway spending.

**Ergonomist, copyeditor and novice**
- The wrapper repeats the auth-unavailable reason on its stderr. The runbook's Verify step now uses a new `root-canary-status.sh --check` instead of `exec -- true`.
- I made the two copyedits ("does not validate it"; "is added to no other allowlist") and defined the spike where it is first mentioned.
- The test list now includes a human name starting with `root-canary-` that the sweep must leave alone.

I did not apply the pedant's title-case comment: every heading in the document uses sentence case consistently, and that seat was comment-only.

**Follow-ups:** the driver re-posts panel-7. Open questions 1 to 4 still block the build and need the maintainer.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr167-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1419146 cached reads)
- Output: 21881 tokens
- Cost: $1.4217052000000001
- Wall-clock: 507s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
