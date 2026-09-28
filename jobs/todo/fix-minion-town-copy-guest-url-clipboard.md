---
tier: mentat
dispatch: manual
---
role: builder
handler-timeout: 14339

# minion.town: "Copy guest URL" does not reliably put the guest URL on the clipboard. Verify, fix, deploy, re-verify.

Repo: kriscendobot/minion.town, live at https://minion.town. Reported by the maintainer on 2026-09-28 (~20:30Z) as an addendum to `fix-minion-town-guest-recovery-oauth-bonding`, which finished without addressing it. The maintainer authorizes deploying the fix to production, as for that job.

**Build on https://github.com/kriscendobot/minion.town/pull/129.** It is still draft; it fixes same-tab URL recovery and OAuth bonding honesty, and was deployed at 20:43Z. Reuse its Playwright harness (`test/web/guest-recovery-browser.test.ts`, which mimics the express, Caddy and oauth2-proxy topology) and its production-verification scripts. Stack a new draft PR on #129's branch, or add to #129 if it is still unmerged and you judge that cleaner, and say which.

**Do:**
1. **Reproduce in headless Chromium,** against production and the harness.
   - Grant `clipboard-read`/`clipboard-write`, click "Copy guest URL", and read the clipboard back with `navigator.clipboard.readText()`.
   - Repeat many times, and under the conditions that plausibly make it flaky:
     - the document not focused;
     - a permission denial;
     - the async `writeText` racing a re-render, navigation or `hashchange` (#129 added a hashchange-reload, so check the interaction);
     - a lost user-activation window, for example an await before `writeText`;
     - no Clipboard API or no secure context, and whether any fallback runs.
   - Record the failure rate and root cause.
2. **Fix it:** the button must either write the exact current guest URL every time, or visibly report failure and show the URL selected for manual copy. It must never succeed silently with the wrong or stale URL, or fail silently.
3. **Regression test:** assert the clipboard equals the guest URL across repetitions, then chain it into the existing flow: copy, Forget, paste the clipboard contents as the URL, then the same formula identifier. The test must fail on the old code.
4. **Deploy** via `deploy-www.sh` (per-file SSM, `GARDEN_YARN=npm`). Verify by sha256 which files changed on the box.
5. **Re-validate on production** with the same scripts, and record before/after evidence.
6. Leave the PR as a draft, with evidence in the body.
