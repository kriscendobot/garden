---
ts: 2026-05-20T05:54:02Z
kind: dispatch
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/20/030601Z-result-liaison-39160e.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 109
    role: source
  - repo: endojs/endo
    pr: 3256
    role: target
---

Re-ferry `endojs/endo-but-for-bots#109` over `endojs/endo#3256`. **Recompute-from-master, force-push shape**. The source has been completely rebased and squashed down from 9 commits to 4; the upstream's current 9-commit shape no longer represents the work intended.

## Source (rebased & squashed)

- Repo: `endojs/endo-but-for-bots`, PR #109 (OPEN, MERGEABLE).
- Branch: `feat/syrups-package`
- Head: `2627e81a3d5881e817eb0e11c4596ae4c060f9c9`
- **4 commits**, all `endolinbot <main.barn5084@fastmail.com>`, none carry `(#109)` bot-internal suffixes (cleaner this time):
  1. `dc729c8b feat(syrup-frame): add @endo/syrup-frame package` (squash of all syrup-frame additions including tests)
  2. `561e54ed feat(ocapn): add opt-in syrup framing to TCP-testing netlayer` (consumer-side; **note "syrup" singular**, not "syrups" — see naming note below)
  3. `f7e9339e chore: Update yarn.lock`
  4. `2627e81a chore: regenerate composite tsconfig files`

### Naming note

The prior fast-forward append observed the upstream had been renamed `'syrup' → 'syrups'` (plural). The bot's rebase appears to have reverted to singular `'syrup'` framing in commit 2's subject. The boatman should verify by reading commit 2's diff: if the file paths and code still use singular `'syrup'`, that's the source's chosen shape and the boatman ferries verbatim. If the file paths use plural `'syrups'` but the subject says singular, raise it via `message`-to-liaison. (The source's body via the actual diff will be authoritative.)

## Upstream

- Repo: `endojs/endo`, PR #3256.
- Branch: `feat/syrups-package`
- Current head: `e691e86d8fc7f64d23854a1e3f3fddb29af3b1be` (9 commits from the prior fast-forward appends in this session).
- State: OPEN, **APPROVED** by kumavis, `mergeable: MERGEABLE`. Branch is unprotected; the approval will persist as a record across a force-push (review anchor stays on its commit OID even when unreachable).
- Title: `feat(syrup-frame): add @endo/syrup-frame package and opt-in syrups framing for OCapN TCP-for-testing` — note the *plural* "syrups" in the existing title. **If commit 2's diff uses singular `'syrup'`, the upstream PR's title should also be updated to singular**; user did NOT ask for title/body changes this turn, but a naming-mismatch is a substantive concern worth surfacing in the result if it lands.
- Current upstream master is `c063631f` (fresher than what I had earlier this session at `0ec70c6d`).

## Human

`Kris Kowal <kriskowal@kriskowal.com>` (the current default per the user's 2026-05-20T05:09Z global-git-config change). **identity_switch_authorized: true**.

## Dispatch root

`/Users/kris/garden/dispatches/boatman--ferry-syrup-frame-109-rebase--20260520-055349--456f58/`. Project worktree on `endojs/endo:origin/feat/syrups-package` (detached at `e691e86d8` — the current upstream tip; the boatman will detach to `origin/master` for the recompute).

## Boatman direction

- Detach at `origin/master` (`c063631f`), **not** at the current upstream tip. Recompute-from-master per the boatman wisdom branch.
- Cherry-pick the 4 source commits (`dc729c8b`, `561e54ed`, `f7e9339e`, `2627e81a`) onto current master. Preserve as 4 commits (do not squash; the source's split is intentional).
- Set local `user.name='Kris Kowal'` / `user.email='kriskowal@kriskowal.com'`.
- Use `cherry-pick + git commit --amend --reset-author --no-edit` per commit to rewrite author + committer.
- **No subject-suffix stripping needed** — the source's subjects don't carry `(#109)` this time.
- **Conflict handling**: the master tip has advanced to `c063631f` (likely 30+ commits ahead of the source's base). The `packages/syrup-frame/*` package additions should apply cleanly (new files). The `packages/ocapn/*` consumer changes may conflict if upstream master touched the same files; resolve in favor of the source intent.
- **Trailer-strip discipline**: `git interpret-trailers --parse` per commit. Always. The #73 lesson stands.
- **Verify attribution**: `git log origin/master..HEAD --pretty=fuller` shows 4 commits, all author + committer `Kris Kowal <kriskowal@kriskowal.com>` (the new default).
- **Pre-flight ancestor check**: refetch `origin/feat/syrups-package` and confirm `e691e86d8` is still the tip immediately before push (the user has been actively cleaning up PRs this session — concurrent force-pushes are possible per the #3241 incident at `entries/2026/05/20/051402Z-message-boatman-877658.md`).
- **Force-push with lease**: `git push origin HEAD:feat/syrups-package --force-with-lease=feat/syrups-package:e691e86d8fc7f64d23854a1e3f3fddb29af3b1be` against the current tip.
- **Title and body untouched** — user did not ask. But: **if commit 2's diff uses singular `'syrup'`** in code paths, surface the title/body mismatch (which currently says "syrups" plural) in the result. Do NOT edit title/body without user direction; just flag.
- Source-side cross-link comment on `endojs/endo-but-for-bots#109`: post under kriskowal. Name the new upstream head SHA, the four-commit reshape, and the force-push.
- **Identity discipline on `endojs/endo#3256`**: NO direct comments. Route any explanatory comment via `message`-to-`steward`.

## Expected report

≤350 words:
- Upstream head SHA after force-push, four new commit SHAs in order, attribution verified (`kriskowal@kriskowal.com` explicit).
- Pre-flight ancestor check result.
- Push mode confirmed (force-with-lease, not unsafe `--force`).
- kumavis-approval persistence check.
- **Naming check**: report whether commit 2's diff uses singular `'syrup'` or plural `'syrups'` in code paths; if mismatch with the upstream PR's current title ("syrups" plural), flag explicitly.
- Source-side cross-link URL.
- One-line `Self-improvement: ...`.

If blocked (cherry-pick conflict you can't resolve, ancestor-check fails, naming question is non-trivial), `message`-to-liaison and stop.
