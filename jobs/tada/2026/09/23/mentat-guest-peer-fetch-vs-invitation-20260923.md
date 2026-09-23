Everything is verified: the withdrawal tombstone and the annotation are on `origin/journal2`, and the closing note is live on garden#58. Final report:

## Completion report — mentat-guest-peer-fetch-vs-invitation-20260923

**Verdict: the guest-to-guest invitation workflow overtakes the formula-id peer fetch. Decision: RETIRE. Executed.**

**The reasoning.** The user-facing goal of garden#58's chain (kriskowal's 2026-08-28 ask, comment 5447180549) was to prove a minion.town guest is a first-class, remotely reachable Endo object a peer can connect to and invoke. Invitation now achieves that goal fully, and in a strictly better posture: `EndoGuest.invite`/`accept` merged upstream (endojs/endo-but-for-bots#1310), cross-host invite/accept against minion.town's public daemon route was already proven end-to-end with a capability round-trip (endojs/endo-but-for-bots#693, M5), and the merged capability-first onboarding design (kriscendobot/minion.town#56, build draft #81) explicitly forbids ambient/host-authority introduction. Peer fetch by *revealed formula id* is not just redundant — it is the ambient-fetch posture the design rejects. **The blocking security question (public route to the guest-substrate daemon, comment 5447765615) is moot as asked:** same-daemon pairing needs no public route, and remote introduction rides single-use invitation locators, not a resolve-any-formula-id surface. The one residual — advertised public transport hints so an off-town party can accept an invitation from an app-substrate guest — is already owned in invitation terms by minion.town `designs/remote-guest-endo-cli.md` §5, so nothing needed absorbing.

**Actions taken:**
1. Withdrew `minion-town-guest-peer-fetch-verify-await-auth` via `withdraw-plan.sh --by designer` with a supersession reason; tombstone verified at `jobs/withdrawn/` on `origin/journal2`.
2. Posted the courteous closing note on garden#58 with fully-qualified cross-repo references: https://github.com/kriscendobot/garden/issues/58#issuecomment-5801937146 (provenance footer auto-injected by the fleet `gh` wrapper).

**Deliverable 3 — the parked fallback-fix job is NOT unblocked; the job spec's premise was stale.** #104 merged the refreshed pin only onto frozen base `main-45e43bb`. The pin *did* then reach `main` via minion.town#110 (2026-09-22) but crash-looped the production daemon (pre-registry host formulas; tada `minion-town-endo-daemon-deploy-fail-89481580`) and was **reverted by #111** — I verified live that `origin/main:src/endo/captp-client.ts` still pins stale `f66505034…` today. Upstream ebfb#1329 landed the registry migration, and the new re-pin vehicle is minion.town#112 (draft, pinning `f9cbcfc426…` — a *different* hash than the `89481580…` the parked job's precondition literally names, which will now never land). To defuse that trap without promoting anything, I annotated `minion-town-guest-web-invite-accept-fallback-fix-20260922` via `annotate-plan.sh` (key `repin-observable-post111-20260923`, verified on `origin/journal2`): read the observable as "main pins any commit carrying `EndoGuest.accept` + the registry migration". Promotion remains the maintainer's call in the muster — the natural moment is after #112 gauntlets and merges.

**Follow-ups (maintainer's):** promote the fallback-fix job once #112 (or an equivalent re-pin) reaches `main`; nothing else remains from the retired chain. No garden `main2` changes were needed; both board mutations went through the sanctioned journal scripts.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/mentat-guest-peer-fetch-vs-invitation-20260923.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1683916 cached reads)
- Output: 17896 tokens
- Cost: $4.196876
- Wall-clock: 270s
- Model(s): claude-fable-5 ×1

<!-- garden-usage-end -->
