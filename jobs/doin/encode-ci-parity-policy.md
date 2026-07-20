---
role: librarian
---
# Encode the standing policy: a CI lint/test failure is a defect in our automation

Garden-infra (`main2`) change — no PR (garden convention). Work in an ISOLATED
worktree off `origin/main2` per `roles/COMMON.md` § Per-subagent worktrees ("the one
correct shape for a garden-infra (main2) job": `git worktree add --detach
"$(scratch_dir infra-ci-parity)" origin/main2`; explicit-pathspec commit; push
`HEAD:main2` via a rebase CAS loop). Editing the deployed root tree directly is a
defect (COMMON.md:213).

## The policy to encode (maintainer @kriskowal, 2026-07-20, via the liaison)

> Treat **any** failure of lint or test in CI as a failure of our automation to
> anticipate the CI failure. All of these checks should be run locally before
> pushing, and a discrepancy between the local and CI environments is a **defect**.

This is a REFRAME, not a new mechanism: `skills/local-verify` already exists but sells
local verification as an OPTIMIZATION ("a change that passes here is far more likely to
be green on the first CI push"). The maintainer is elevating it to an INVARIANT with a
corollary: a red CI run is a defect in our tooling (we failed to anticipate it), and a
local-pass/CI-fail discrepancy is an environment-PARITY defect to diagnose and close —
never worked around with a one-off green push.

## Where to encode (cross-link, do NOT duplicate the prose)

1. **`roles/COMMON.md`** — add a SHORT standing norm (COMMON.md norms are terse; this is
   the index every gardener reads first). State the three points: (a) any lint/test CI
   failure is a defect in our automation, not just a PR fix; (b) every lint/test that CI
   runs MUST be run locally before pushing; (c) a local↔CI discrepancy is itself a parity
   defect to diagnose and close. Point to `skills/local-verify`, `skills/pre-push-gates`,
   `skills/ci-failure-classification-loop`. A natural home is near the Reporting /
   verification norms (the "verified requires real-execution evidence" norm at ~line 243
   is a sibling in spirit — place it adjacent).

2. **`skills/local-verify/SKILL.md`** — reframe from optimization to invariant. Add a
   "Parity is the contract" subsection: the local set MUST cover every lint/test CI runs
   (enumerate against the project's CI config, not guesswork); passing locally then
   failing CI means either local-verify omitted a check CI runs OR the environments
   diverged — both are defects. The fix is TWO-PART: (i) green the PR, and (ii) close the
   gap — add the missing check to local-verify or fix the environment parity — so the
   same class cannot recur. Reference the project-specific bin shims where relevant
   (endo local test PATH shims).

3. **`skills/ci-failure-classification-loop/SKILL.md`** — the OODA loop currently just
   drives red CI to green via four failure classes. Add that whenever a CI failure was
   one local-verify SHOULD have caught, the loop must ALSO emit the parity follow-up
   (update local-verify / fix env parity), not merely green the PR. I.e. a fifth question
   atop the four classes: "was this anticipable locally? if so, why didn't local verify
   catch it — and fix that." Cross-link to local-verify.

## Constraints / done

- Keep each edit tight and non-duplicative; the canonical prose lives once (in
  local-verify) and COMMON.md + the loop cross-link to it.
- Frontmatter/style: obey `roles/COMMON.md` § House style and § Document frontmatter
  (bump `updated:` on the two edited skills).
- If a doc/link checker is wired (`scripts/jobs/*library-link-scan*`), run it and cite
  clean output; otherwise state what you checked.
- Report the `main2` commit sha and the exact sections changed.
- ACTIVATION: this takes effect fleet-wide only after the next deliberate deploy of
  `main2` to each root (leader-supervised) — note that in your completion report.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 19
  worker_kind: gardener
  claimed_at: 2026-07-20T23:39:38Z
