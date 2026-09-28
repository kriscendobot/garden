CI on #131 is green and the inbox message (a status request from before my detailed report) is already answered. The job is complete — writing the completion report.

**Completion report — fix-minion-town-copy-guest-url-clipboard**

**Deliverable: draft PR https://github.com/kriscendobot/minion.town/pull/131** (`fix-copy-guest-url-clipboard`), **stacked on #129's branch** via frozen base `fix-guest-recovery-oauth-bonding-1cd7a86` — a new stacked PR rather than adding to #129, so the still-draft #129 keeps its own reviewed scope and this PR's diff shows only the clipboard change. CI green (test + both harness checks). Deployed to production 21:06Z and re-validated.

**Root cause (reproduced in headless Chromium, harness + prod-identical bytes):** the button copied `location.href`, which is only the guest URL when the fragment happened to be normalized. A returning visitor (guest restored from localStorage on a bare URL) got `https://minion.town/` — no guest fragment — on the clipboard while the shell announced "Guest URL copied." (0/10 correct, deterministic). With a pending invitation fragment it copied the invitation URL instead. On `writeText` failure (permission denial: 5/5 failures in an ungranted context) there was no fallback and the advice — "copy the address bar manually" — pointed at the same wrong URL. Focus loss and #129's hashchange-reload were tested and not implicated.

**Fix (deploy/aws/www/guest.js, guest.html):** the guest URL is now built from the live credential (`guestUrl()`, shared with `normalizeGuestUrl`), snapshotted synchronously inside the click so no await can race a re-render/navigation/hashchange; on `writeText` failure it falls back to `execCommand` copy, and if that fails too it shows the real URL in a new `#guestUrl` element, selected for manual copy, with an explicit failure status — never a false success, never a stale/wrong URL, never a pointer at the address bar.

**Regression tests** (extended `test/web/guest-recovery-browser.test.ts`, prod-capable): repeated copies from normalized and bare pages must equal the canonical guest URL; copy-from-bare → Forget → paste-clipboard → same formula identifier; both copy paths stubbed dead → visible failure + selected URL. All three **fail on the old shell (3/7)** and **pass on the fix (7/7)**, verified both ways; `npm run typecheck` clean.

**Deploy + prod re-validation:** `deploy-www.sh` (per-file SSM) at 21:06Z; sha256 over SSM confirms **only `guest.html`/`guest.js` changed** on the box and the edge serves the new bytes. `MT_E2E_ORIGIN=https://minion.town`: **6 passed / 1 skipped**, including all three clipboard tests against live production.

**Production incident found and resolved en route (not caused by this job):** the guest API was 503 at reproduction time — endo-daemon crash-looping since 20:49:23Z because the #117 CD deploy's restart orphaned a `manager-node` holding `127.0.0.1:8920` (EADDRINUSE on every restart, NRestarts→182; the deploy's rollback couldn't heal either). Coordinated over the bus with the live peer `kriscendobot-minion.town-pr117-review-e2f26bcf` (whose PR #130 is the durable script fix); on its explicit request I performed the guarded live recovery at 21:07Z (stop unit → kill verified PPID-1 orphan → start → `endo daemon ready`; then restarted `minion-mcp`, which held the dead CapTP connection) → `POST /api/guest` 201. Full observations reported to the peer's inbox.

**Follow-ups:** (1) merging #129 then #131 is what makes the deployed guest.js durable — the CD pipeline deploys www from `main`, so the next successful CD run reverts the box to pre-#129 until they merge (flagged in the PR body and to the peer); (2) the daemon spawn-race durable fix rides the peer's kriscendobot/minion.town#130.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-minion-town-copy-guest-url-clipboard.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 134 tokens (7976616 cached reads)
- Output: 60802 tokens
- Cost: $14.461835999999998
- Wall-clock: 1138s
- Model(s): claude-fable-5 ×1

<!-- garden-usage-end -->
