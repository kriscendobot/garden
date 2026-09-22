All four review asks are already fully resolved by a peer (the PR-authoring designer, `kriscendobot`) in commits `042c1b2` and `ea66e45` — the current PR head. I verified each ask against the actual artifacts rather than inferring from the preflight hint.

## Corroboration (verified no-op)

The review body was `@kriscendobot rsvp`; every inline thread received a substantive reply from `kriscendobot`, and each resolution is present in the design file at PR head (`ea66e45`) and on the board:

| Ask (inline comment) | Resolving artifact | How it satisfies the ask |
|---|---|---|
| `r4067403969` — start with the simple root-user out-of-band case, defer sophistication | commit `042c1b2`; design §"first pass assumes… notify the **root user out of band**" (L29–30) + §3 (L131+); delegated-operator/`ReauthTicket`/Endo-mail moved to §"Follow-up, deliberately deferred" (L347) | First pass pins operator to root subscription owner, notifies via stable authenticated account-page link; sophistication explicitly deferred. Reply `4067831958`. |
| `r4067412358` — usage exhaustion as an actionable signal, escalate to user | commit `042c1b2`; `usage-exhausted` first-class admission-time sibling (L78, L86 table), `resetAt` for resettable window / named billing action for API-key cap (L190) | Automation can react (e.g. switch subscription); escalates to root notifier; kept off `endo-claude.md`'s confined `InferResult`. Reply `4067832093`. |
| `r4067414630` — an advisory would help | commit `ea66e45`; §"Pre-expiry advisory" (L196–218) | Single informational renewal nudge `advisoryLead` before expiry, non-blocking, best-effort, `needs-auth` as backstop; API-key creds correctly get none. Reply `4067832183`. |
| `r4067419982` — fall through to manual, don't block, track deps & post a gated job | commit `ea66e45`; design §"does not block"/"manual reauthentication" (L357–358) + parked-job note (L363); board job `journal/jobs/plan/evaluate-reauth-escalation-default-after-oauth-relay.md` (gate: deferred, gated on browser OAuth relay) | Root-user pass falls through to manual `setup-token`; browser/MCP-only principal parks losslessly; the dependency-tracking follow-up is genuinely on the board, gated. Replies `4067737648` + `4067832261`. |

Board artifact confirmed by direct inspection of `journal/jobs/plan/` (not inferred from the preflight): the gated job exists, cites review `5272974950` open-question 4, and owns the deferred half.

## Outcome
No code/design change required — the whole review (rsvp body + all four inline comments) was already addressed on the PR head and the job board. No new commit or reply posted; adding another would be redundant noise on already-resolved threads. Nothing pushed to `main2` (no garden-library change was called for).

Follow-up (already owned, not by me): the parked `evaluate-reauth-escalation-default-after-oauth-relay` job re-opens the delegated-operator/default-escalation question once the browser OAuth relay lands.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr96-review-d423db6e.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 2 host(s) (2 unmetered)
- Input: 68 tokens (1969648 cached reads)
- Output: 26423 tokens
- Cost: $2.757632 (2 engagement(s) unpriced)
- Wall-clock: 1991s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
