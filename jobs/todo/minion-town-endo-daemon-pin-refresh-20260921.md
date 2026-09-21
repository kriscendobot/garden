---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-21T22:02:27Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Refresh minion.town's pinned Endo daemon commit past #1310 (guest-native accept)

`kriscendobot/minion.town` pins the Endo commit its daemon runs (and CI tests
against) at `f66505034aaa54ac46294347b2bf0e14655b088a` (branch `llm`, dated
2026-07-22 — roughly two months stale). That pin predates
`endojs/endo-but-for-bots#1310` ("feat(daemon): guest-native invitation
acceptance `EndoGuest.accept`", merged 2026-09-21T21:36:21Z) and its
prerequisite stack (#1304 → #1306 → #1305), so the deployed/tested daemon has
no `EndoGuest.accept` and only a partial/no `EndoGuest.invite`. This blocks
`build-minion-town-invitation-onboarding` (design
`designs/invitation-only-guest-onboarding.md`) from replacing its app-mediated
guest-pairing fallback with the real guest-native primitives, because the
real-daemon integration tests need a daemon that actually has them.

## The pin has THREE synchronized copies — update all three

`test/endo-pin-drift.test.ts` is the authoritative drift guard: it fails if
these three diverge.

1. `deploy/aws/scripts/deploy-endo-daemon.sh` — `ENDO_COMMIT="..."` (the
   production deploy pin, "single source of truth" per its own header comment).
2. `src/endo/captp-client.ts` — `PINNED_ENDO_COMMIT = "..."` (§ 4c per its
   comment).
3. `.github/workflows/test.yml` — the "Checkout pinned Endo daemon" step's
   `ref:` value.

## What to do

1. Follow the [verify-upstream-state-before-pinning](../../skills/verify-upstream-state-before-pinning/SKILL.md)
   skill. Fetch the ACTUAL current `endojs/endo-but-for-bots@llm` HEAD SHA at
   execution time — do not reuse any SHA quoted in this job body, it will be
   stale by the time you run. Confirm the chosen commit is a descendant of
   #1310's merge commit (`89481580a86c7ec3ec97bbde21bc2f9b5b7ec3dd` was `llm`
   HEAD at 2026-09-21T21:36:20Z — sanity-check your fetched HEAD is at or after
   that ancestor, not a stale mirror).
2. Update all three pin copies above to the new SHA.
3. Get an isolated project worktree: `ensure-project-worktree.sh
   minion-town-endo-daemon-pin-refresh-20260921 kriscendobot/minion.town main`.
4. Build/verify against the new pin:
   - `npm run typecheck`
   - `npm test` (full vitest suite, including `test/endo-pin-drift.test.ts`
     which now must read all three copies as matching)
   - `npx vitest run test/endo-daemon-integration.test.ts` against a real
     daemon built from the new pinned checkout (`ENDO_CHECKOUT=<path>`,
     following `test/helpers/endo-daemon.ts`'s provisioning contract — clone
     the new commit, `yarn install`, build, point `ENDO_CHECKOUT` at it)
   - `npx vitest run test/web/guest-web-daemon.test.ts` against the same real
     daemon (this currently exercises the OLD app-mediated local-pairing path
     via `storeIdentifier`; it should still pass mechanically since the HTTP
     contract it asserts is unchanged — this refresh does not itself touch
     `connectLocal`, that is a separate job)
5. Since ~2 months of upstream `llm` history sit between the old and new pin,
   skim `git -C <endo-checkout> log --oneline <old-sha>..<new-sha> --
   packages/daemon` for anything beyond additive guest-invitation work that
   might affect minion.town's daemon usage (e.g. renamed/removed methods
   minion.town's `src/endo/` layer calls). Flag anything notable in the PR
   body for the reviewer; do not attempt unrelated adaptation beyond what's
   needed to keep the existing suite green.
6. This is a production deploy-pin change — open it as its OWN pull request
   against `main` (not against PR #81's branch — that PR belongs to a
   different, sibling job and this pin refresh is prerequisite infrastructure
   for it, reviewable independently). Use
   `scripts/jobs/gardening/ensure-pr.sh minion-town-endo-daemon-pin-refresh-20260921
   kriscendobot/minion.town <your-branch> main --title T --body-file F` — never
   a bare `gh pr create`. Leave it DRAFT (manual-gauntlet regime); do not run
   the gauntlet yourself.

## Definition of done

A draft PR against `kriscendobot/minion.town:main` bumping all three pin
copies to a fresh, verified `llm` commit that includes `EndoGuest.invite` and
`EndoGuest.accept`, with `npm test` (incl. the drift guard) and both real-daemon
suites green in your run, and evidence (commands + output) in your completion
report per `roles/gardener/AGENT.md` § reporting norm.
