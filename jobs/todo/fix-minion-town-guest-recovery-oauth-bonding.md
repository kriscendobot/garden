---
tier: mentat
dispatch: manual
---
role: builder
handler-timeout: 14339

# minion.town: guest account recovery and OAuth recovery bonding are broken. Verify, fix, deploy, re-verify.

Repo: kriscendobot/minion.town, live deployment https://minion.town. Requested by the maintainer (liaison session, endolin-garden2, 2026-09-28 ~20:30Z). The maintainer authorizes deploying the fix to production as part of this job.

**The maintainer's report, verbatim in substance:**

1. **URL-based guest recovery fails.** Expected flow:
   - copy the guest URL;
   - "Forget" the guest in this browser;
   - load the copied URL;
   - the page recovers the SAME guest, verified by formula identifier.
   It does not appear to work.

2. **OAuth recovery bonding fails.** Pressing "Add OAuth Recovery" does not offer a choice of OAuth authentication methods. The choice may legitimately differ from a previously bonded method. Instead it sends the user back to the initial page with "Recovery provider bonded to this guest". The user lands on the same page with a forgotten guest identifier.

**Do, in order:**

1. **Reproduce empirically with a headless browser.** Use Playwright scripting; see `skills/minion-town-mcp-playwright-login/SKILL.md` and the garden's existing Playwright usage for minion.town.
   - Script both flows end to end against production, and record what actually happens: screenshots, network/console logs, the formula identifier before and after, and the resulting URL and state at each step.
   - Establish whether each defect reproduces and pin down the exact step where it diverges from expectation.
   - For OAuth, use test identities or the test Cognito client (the garden memory notes a `minion-mcp-test-cc` client; its `mcp/guest` scope may be missing). Never use or store a real person's credentials. If an OAuth provider genuinely needs an interactive human login, script everything up to the provider hand-off, assert on the provider-choice UI and the round-trip state, and say plainly which step needs a human.
2. **Find the root cause** in code (frontend, gateway, recovery/bonding endpoints, session and local-storage handling) and fix it:
   - the guest URL must restore the same guest, with the same formula identifier;
   - "Add OAuth Recovery" must present the available OAuth methods (allowing a method different from any already bonded), complete the bond, and return to the SAME, still-remembered guest, with an accurate status message;
   - the flow must not silently forget the guest or claim success when nothing was bonded.
3. **Regression test:** turn the reproduction scripts into an automated browser-based regression test in the repo, runnable in CI against a local/test deployment and optionally against production with a flag. It must fail on the old code and pass on the fix.
4. **Deploy the fix to production** using the repo's standard deploy path (garden memory: this host has AWS/SSM access; `deploy-www.sh` deploys per file over SSM with a 100KB ceiling; use `GARDEN_YARN=npm`; verify service health after deploy, for example NRestarts). Take care with anything that touches the production database or guest formula state: no destructive migrations, and back up before any schema or state change.
5. **Re-validate on production** with the same headless browser scripts. Record before/after evidence.
6. **Propose the change:** open a PR on kriscendobot/minion.town with the fix, the regression test and the evidence (what reproduced, the root cause, what was deployed, and post-deploy validation results). Leave it as a draft for the maintainer's gauntlet. Rebase before pushing, since main moves.

Report which parts could not be verified automatically and why.
