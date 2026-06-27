# run-test.sh: isolate self-heal/shared-clone subtests onto a dedicated throwaway clone (fix late flake under fleet load)

Map: **build** (garden infra) on the garden's own repo, branch main2. Build in an
ISOLATED worktree off origin/main2; commit explicit pathspecs (`git commit -m … --
<paths>`); push HEAD:main2 with a git-rebase CAS loop.

Problem (surfaced 2026-06-27 by the self-heal finisher): `scripts/jobs/test/
run-test.sh` reliably passes its self-heal/offline subtests in a dedicated seeded
harness (10/10) but, when run on a host with the live ~100-gardener fleet active,
~5-6 subtests flake with `rc=1 calls=0` in the shared-clone capture path
(subtests 2-5 and the daily-cap, plus any new subtest that uses the same
`ensure_clone`/`capture_blob` against the shared journal). Confirmed PRE-EXISTING:
the same failures reproduce on the unmodified base, so it is not a regression —
but it makes run-test.sh unreliable as a green gate while the fleet is busy,
because the subtests race the shared journal clone/capture state under load.

Goal: make the affected subtests hermetic so a busy fleet cannot perturb them.
Isolate each subtest's `ensure_clone` / `capture_blob` / journal interactions onto
a DEDICATED throwaway clone + state dir (the pattern the finisher's standalone
self-heal harness used to get 10/10 deterministically), rather than sharing the
host's live journal clone or GARDEN_STATE. Parameterize the clone/state path per
subtest (or per run) so concurrent fleet activity is invisible to the test.

Scope:
- Identify every run-test.sh subtest that touches a shared clone / shared
  GARDEN_STATE capture path and is subject to the flake (start with 2-5 + daily-cap
  + the self-heal SUBTEST 21 genuine-rc=128 case).
- Give each its own throwaway remote/clone/state under the test's scratch root
  ($TR), seeded as needed; never point at the host's live journal or producer/
  bulletin/self-heal state dirs.
- Re-run under simulated concurrent load (or on a live host) to prove the flake is
  gone; document the before/after.
- Keep the existing assertions intact; this is isolation, not a rewrite.

Deliverable: run-test.sh runs green on a busy host. Note any subtest that cannot be
made hermetic without a deeper change and leave it as a tracked follow-on.
