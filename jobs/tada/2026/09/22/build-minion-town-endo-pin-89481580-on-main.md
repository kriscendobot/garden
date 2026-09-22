Done. Draft PR #110 (base `main`, MERGEABLE) is open with the pin re-applied.

## Completion report

**Job:** Land the refreshed Endo daemon pin `89481580` onto minion.town `main`.

**What I did.** #104 merged only onto its frozen base `main-45e43bb` (now 1 ahead / 14 behind `main`), so the pin never reached `main` — `origin/main` still pinned the stale `f66505034…` that predates `EndoGuest.accept`. I re-applied #104's exact four-file delta onto current `main`:

- The four pin files (`.github/workflows/test.yml`, `deploy/aws/scripts/deploy-endo-daemon.sh`, `src/endo/captp-client.ts`, `test/endo-daemon-integration.test.ts`) were **byte-identical** on `main` and #104's frozen base, so the cherry-pick of `cc53f3f` was clean — no drift conflict.
- The three synchronized copies of `PINNED_ENDO_COMMIT` now carry `89481580a86c7ec3ec97bbde21bc2f9b5b7ec3dd`; the integration test learns the additively-grown exo method surface (`@agent`: +accept/invite/listValues/loadContent; directories: +readOnly/listValues).

**Scope decision (reported, not forced).** Grep found three *remaining* `f66505034…` references — the reminder compatibility-store provenance (`COMPATIBILITY_STORE_PROVENANCE.json` `targetDaemonCommit`, `test/reminder-store-conformance.test.ts`, `designs/endo-reminder-minion-town.md`). These are **new material from `main`'s 14-commit drift** and are a **distinct, truthful fact** — the daemon the reminder compat store was *verified against* — not a copy of `PINNED_ENDO_COMMIT` (the drift guard enumerates only the three copies). Bumping them without re-verifying the compat store against the new daemon (whose directory API grew) would be a false provenance claim, so I deliberately left them stale. This is the closest thing to the job's "genuine incompatibility" clause; it does not block the core pin, which is clean.

**Verification.** `npm run typecheck` green; full local suite **428 passed / 5 skipped** (the skips are the `ENDO_CHECKOUT`-gated B1 daemon-integration tests — no local daemon build, they run against the pinned daemon in CI); `endo-pin-drift` and `reminder-store-conformance` guards green.

**PR.** https://github.com/kriscendobot/minion.town/pull/110 — DRAFT, base `main`, MERGEABLE. Opened via `ensure-pr.sh` with a **justified** `GARDEN_ALLOW_FLOATING_BASE=1`: a frozen `main-<sha>` base is precisely what stranded #104 (its merge lands on the snapshot, not `main`), and the job mandates `base = main` so the merge lands the pin on `main`. Left draft per the manual-gauntlet regime.

**Follow-ups.**
- Maintainer: **run the gauntlet #110**, then merge to land the pin on `main` and satisfy the `minion-town-guest-web-invite-accept-fallback-fix-20260922` precondition.
- Separate task worth posting: re-verify the reminder compat store against daemon `89481580` and, if it still adapts, bump `targetDaemonCommit` (+ the conformance assertion + design prose) in one honest provenance-refresh commit.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-endo-pin-89481580-on-main.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1056758 cached reads)
- Output: 13157 tokens
- Cost: $1.4282280000000003
- Wall-clock: 259s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
