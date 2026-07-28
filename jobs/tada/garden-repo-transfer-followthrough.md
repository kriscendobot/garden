All work is complete. Writing the report.

---

# Repo transfer follow-through — completion report

## Transfer verified before any change

`kriscendobot/garden` resolves as the transferred repo. Both branches preserved: `main2` at `bb971c9a39`, orphan `journal2` at `e6027282cb` — identical tips via old and new endpoints. Redirects confirmed live on all three surfaces: REST API (`gh api repos/kriskowal/garden` → `kriscendobot/garden`), web (`https://github.com/kriskowal/garden` → 200 at the new URL), and both git transports (`git ls-remote` over https and scp-ssh returned identical shas). My own push printed GitHub's `This repository moved` notice — the redirect proving itself in the write path. No history was rewritten and nothing was force-pushed.

## Commits landed on main2

**`ca328dd15b`** — canonical-remote compatibility. Every journal/origin URL validates against one regex in `common.sh`, and it is the guard that refuses a root origin rewritten to a project fork (incident 2026-07-21). Split into `GARDEN_PRODUCTION_JOURNAL_REPO` (`kriscendobot/garden`), `GARDEN_PRODUCTION_JOURNAL_REPO_ALIASES` (`kriskowal/garden`), and `GARDEN_PRODUCTION_JOURNAL_URL`, with the pattern built from them. Covers `journal_remote`, `_is_foreign_github_remote`, `is_production_journal_remote`, root-repo-guard, the test-context push guard, and every operator-facing restore message; plus turnkey cloning, the bulletin blob base, and `docs/bulletin/config.js`.

The protection was not weakened. The pattern is an alternation of exact `<owner>/<name>` paths, never an owner prefix — which matters more now that the garden shares an owner with the product forks. Verified: `kriscendobot/endo-but-for-bots` and the near-miss `kriscendobot/garden-transcripts` both still classify as foreign. Guard test extended in both directions: **27 passed, 0 failed**.

**`a046d34ea6`** — a hazard the transfer created that wasn't in the brief. The ci-watcher auto-shepherds red PRs on any repo under the bot login. `kriskowal/garden` failed that gate by accident of ownership; `kriscendobot/garden` passes it, and every remaining gate passes for PR #28 — bot-authored, head pushable, updated today. A red check would have minted a shepherd to drive *"main2 review vessel — feedback only, do not merge"* to green, against CLAUDE.md's standing "no PR workflows for the garden's own repo." Denied the garden's own repo explicitly, ahead of the bot-fork arm, keyed to the canonical repo so it follows a future transfer. Case G had used `kriskowal/garden` as its "non-bot repo" fixture, so it would have kept passing for the wrong reason; it now uses a genuine upstream, with G2/G3 pinning the new rule. **45 passed, 0 failed.**

Suites run green: root-repo-guard 18, pages-watcher 16, fork-watch-provisioner 31, issue-inbox-journal-linkage 17, deploy-garden 80, comment-watcher 236, main-host 38, ci-watcher 45, journal-remote guard 27.

## Journal reconciliation — one atomic commit (`9971003d5`)

Landed as a single CAS commit so the board never passed through a state with two watchers on one surface or a cold cursor:

- `config/garden-repo` → `kriscendobot/garden`
- `comment-repos/kriscendobot-garden` added; `comment-repos/kriskowal-garden` removed. Authorization carried forward verbatim (the same authorization re-keyed, not a new widening) with `surfaces: pr-only` preserved so the comment-watcher and issue-inbox never both dispatch. Added `sender-gate: required`: under the new owner the repo falls inside `config/fork-owners`, which CLAUDE.md requires to carry that gate. It **narrows** what reaches an LLM — the old record lacked the machine-readable line despite its prose. Both lines verified to parse.
- Cursors carried forward. This was the real duplicate-dispatch trap: cursor keys are slugs, so a bare rename cold-starts a 1h re-poll, and re-dispatched comments would arrive under new basenames the dedup can't match. Old cursors left inert and rollback-safe.
- `watch-optout/kriscendobot-garden` reason rewritten. Its stated reason ("dead fork, upstream 404") was now false, but the tombstone must stay: `config/fork-owners` would otherwise auto-arm a **commit triager** the garden's own repo has never had. It suppresses only auto-provisioning; the hand-armed comment record is untouched by it.

`repo-watcher` reconciled cleanly at 06:39–06:40Z: `@kriskowal-garden` comment/ci/dependabot units disarmed, `@kriscendobot-garden` armed, count steady at 16 — one swapped for one, no duplicate. No failed units.

## What I deliberately did not do

**The deploy, and therefore the origin migration.** You drained this host at 06:29Z for a manual upgrade; `deploy-garden.sh` defers while any job exceeds 5 minutes, and this job is that job — so the deploy is gated on my finishing. I did not force it: deploying would have restarted me mid-job.

That gate is correct anyway. All 45 remotes on this host (root origin, per-host cache, 42 per-instance clones) still name the old path and work via redirect. Migrating them **before** the deploy would be self-defeating — the running old code reads the new URL as the 2026-07-21 poison, logs REFUSED, alerts from root-repo-guard, and `_reheal_root_origin` reverts it on the next tick. Nothing is stranded, because the alias keeps the old path valid. Upgrade signal is armed and correct (`available: a046d34ea6`, ahead by 3).

Posted `migrate-garden-origins-to-kriscendobot` with a hard precondition (`grep -c GARDEN_PRODUCTION_JOURNAL_REPO` in the deployed tree; currently **0** — stop and requeue). It was claimed by `ps23/gardener-6`, which is the host broken by kriscendobot/garden#68; the precondition protects correctness either way.

## Cross-host status

Three hosts. This one (`endolin-garden-ece02cb4`, leader) is done bar the deploy. `endolin-garden2-5bcdff64` (8 gardeners, active) and `ps23` (8 gardeners) are not reachable from inside this container — `/home/kris/garden2` isn't mounted and ps23 is a separate machine. Neither needs action: old URLs redirect and the alias accepts them, which is exactly why the alias exists. `ps23` is separately broken per kriscendobot/garden#68.

## Verified surfaces

Issue inbox, PR comment watcher, CI and Pages watchers all armed on the new slug and ticking (correctly logging `fleet draining; skipping` — a full end-to-end tick can't be exercised until the drain lifts). Pages: source `main2` `/docs`, status `built`, builds succeeding post-transfer. **Canonical URL is `https://kriscendobot.github.io/garden/bulletin/` (verified 200).**

**The redirect gap:** Pages does not redirect across a transfer. `https://kriskowal.github.io/garden/bulletin/` is a hard 404, verified. I updated every in-repo reference; links held outside the repo are dead and I can't fix those.

## Maintainer-only action — sent

There is **no GitHub App to reinstall**: `deviceFlow.clientId`/`proxyBase` are both empty, so the optional device-flow App was never registered, and the repo has no webhooks. The at-risk capability is the **fine-grained PAT**, which is scoped to a *resource owner* — a scope that does not survive a transfer. Sent one precise request: mint under owner `kriscendobot`, repo `kriscendobot/garden`, **Contents: Read and write** only, validated by posting a reply and confirming the `journal2` commit. The bulletin's *content* path is unaffected — `bulletin.sh` writes over SSH as the bot and kept committing straight through the transfer.

## Findings I did not fix

- **`.github/workflows/checks.yml` triggers on `main`, but all development is on `main2`** — so it has never run on current work (`gh run list --workflow checks.yml` returns nothing). Pre-existing, not transfer-caused; changing CI triggers is a separate decision.
- **`issue-inbox-watcher-test.sh` silently aborts** — exits 1 after 21 PASS with 0 FAIL and no summary, killing sections I–J onward. Root cause: an unguarded handler call under `set -euo pipefail` at line 264 (handler returns 1 because the section's stub `gh` no longer satisfies it). Confirmed identical on an unmodified tree. Posted `fix-issue-inbox-watcher-test-silent-abort`, flagging that `|| true` alone would paper over the inadequate stub.

## Residual old-URL dependencies

All 45 remotes on this host, plus the remotes on the two unreachable hosts (working via redirect, pending their deploys); the inert `cursors/{comments,issues}/kriskowal-garden`; the migration alias itself; and a stale `worktrees/kriscendobot-garden.git` bare clone, held inert by the tombstone. Historical issue citations (`kriskowal/garden#N`) were deliberately left — redirects preserve provenance. Retirement conditions for the alias are documented in the new `context/operations/repo-transfer.md`. I did not recreate anything at the old path.
