Everything is complete and verified. Draft PR #104 is open with all 4 files, the job marker present, and my inbox is empty.

---

## Completion report

**Task:** Refresh minion.town's pinned Endo daemon commit past #1310 (guest-native `EndoGuest.accept`).

**What I did**

1. **Verified upstream state live** (per `verify-upstream-state-before-pinning`): `gh api repos/endojs/endo-but-for-bots/commits/llm` → `89481580a86c7ec3ec97bbde21bc2f9b5b7ec3dd` @ `2026-09-21T21:36:20Z` — the #1310 merge commit and current `llm` HEAD. Confirmed it carries both `EndoGuest.invite` and `EndoGuest.accept`. Did **not** reuse any SHA from the job body.

2. **Bumped all three synchronized pin copies** from `f66505034…` → `89481580…`:
   - `deploy/aws/scripts/deploy-endo-daemon.sh` (`ENDO_COMMIT`)
   - `src/endo/captp-client.ts` (`PINNED_ENDO_COMMIT` + its provenance doc comment, moved together so the "single auditable fact" claim holds)
   - `.github/workflows/test.yml` (pinned checkout `ref:`)

3. **Adapted the exact-surface assertion** in `test/endo-daemon-integration.test.ts` (the only change beyond the pins, and directly required): the new daemon grows the guest/directory exo surface additively — `@agent` gains `accept, invite, listValues, loadContent`; directories gain `readOnly, listValues`. No method was renamed/removed from surfaces `src/endo/` calls.

4. **Verified against a real daemon built from the new pin** (cloned `llm`@`89481580`, `yarn install`, `better-sqlite3` native binding built, `ENDO_CHECKOUT` set, `dist/` built):
   - `npm run typecheck` — clean
   - `npm test` (full, with `ENDO_CHECKOUT`) — **38 files, 365 passed**, incl. `endo-pin-drift.test.ts` (all three copies match) and the real-daemon-gated `endo-guest-lockdown`/`endo-guest-http` suites
   - `npx vitest run test/endo-daemon-integration.test.ts` (B1, real socket) — **5 passed**

5. **Daemon history skim** (`f665…..89481580` on `packages/daemon`): overwhelmingly additive (guest-invitation stack, durable secrets, read-only directory attenuation, OCapN). Flagged in the PR body: `#1128 withhold @endo from non-root hosts`, `09bd1a9e7 fix(daemon)!: persist form fields as capdata`, and the `better-sqlite3 ^12` bump — none break minion.town's usage (integration suite green against the real new daemon).

6. **Opened draft PR** [`kriscendobot/minion.town#104`](https://github.com/kriscendobot/minion.town/pull/104) via `ensure-pr.sh` (job-marker adopted, left DRAFT, no gauntlet run). Base is the frozen snapshot `main-45e43bb` (ensure-pr.sh enforces frozen-base discipline over a floating trunk; my head is a clean descendant of `main`'s current tip) — independent of PR #81 as instructed.

**Notes / follow-ups for the reviewer**
- The job's named `test/web/guest-web-daemon.test.ts` **does not exist** in this tree; the real-daemon-gated web/local-pairing coverage lives in `endo-daemon-integration` + `endo-guest-lockdown` + `endo-guest-http`, all green. I ran the full `ENDO_CHECKOUT` suite to cover them.
- The B2 self-heal test (daemon restart + CapTP reconnect) is intermittently timing-flaky under concurrent load; passes on isolated re-run, unrelated to the pin.
- **Reminder compat-store provenance intentionally left at `f665…`** (`COMPATIBILITY_STORE_PROVENANCE.json`, `reminder-store-conformance.test.ts`, `designs/endo-reminder-minion-town.md`): it records the historical `targetDaemonCommit` a compat adapter was captured against, not the live pin — bumping it would be false provenance and break the conformance test. Whether the reminder store needs re-verification against the new daemon is a separate follow-up.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-endo-daemon-pin-refresh-20260921.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 106 tokens (4296677 cached reads)
- Output: 35212 tokens
- Cost: $4.3519915000000005
- Wall-clock: 933s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
