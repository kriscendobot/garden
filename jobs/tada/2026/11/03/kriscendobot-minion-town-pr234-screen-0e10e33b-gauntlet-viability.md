**Viability verdict for kriscendobot/minion.town PR #234: proceed**

PR #234 is still open and not a draft. Its head is `0e10e33b` and its base is the frozen `main-3f6c2b2`. That base matches the current `main` tip exactly (`3f6c2b24`, the merge of #233), so `main` has not moved past it. The PR was opened today (2026-11-03T09:22Z).

Deciding question: Does current `main` already carry a guest contact-forget route, a mail dismiss-all route, or a local invitation round-trip check in the prod probe, from this PR or another one?

Answer: No. So the PR has not been superseded, and the need behind it still holds.

Evidence:
- **No overlap on `main`.** A search of `src/web/guest-web-router.ts` and `deploy/probe/prod-objectives.mjs` on `main` finds no `contacts/:petName` route, no `dismiss-all` route and no `local-invitation-roundtrip` check.
- **The only nearby merge does something else.** #233 (merged today) adds the `invite` and `cancelInvite` tools for the MCP guest. It does not add the guest HTTP forget or dismiss routes or the probe check that #234 adds. No other open or closed PR implements this probe.
- **The reason for the PR still holds.** The prod probe still has no check of local invitation onboarding (#81), and garden tracker issue kriscendobot/garden#58 is still the context. Standing probe guests are still needed because anonymous guest minting is expected to close (#199 is still open).
- **Review is moving, not stuck.** The panel review so far has two request-changes verdicts (saboteur, locksmith) with should-fix findings and one approve (assessor). Those are ordinary work for the fix loop and do not suggest the PR is obsolete.

I spent no clean, panel, fix, CI-wait or un-draft budget, and changed no garden files.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr234-screen-0e10e33b-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (186381 cached reads)
- Output: 1639 tokens
- Cost: $0.4672322
- Wall-clock: 26s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
