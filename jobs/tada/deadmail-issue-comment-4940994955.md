Inbox empty. Work complete — nothing to commit to `main2` (this job was project-repo work delivered via the GitHub API to the fork; the garden dev worktree is untouched).

## Completion report

**Job:** Dead-lettered pickup of mhofman's new comment on garden#29 — adapt the fork's SDK-image build + a3p "docker" integration test to run on normal GitHub CI workers without Depot, then fold into the critical-vat branch.

**What I did:**
1. **Read the full garden#29 thread** and the fork's CI to locate every Depot binding. In `.github/workflows/integration.yml`, the a3p path is gated by two jobs: `build-sdk-ci-image` (Depot runner + `depot/build-push-action`) and `test-docker-build` (Depot runner + `depot/setup-action`/`depot/pull-action`, or `DOCKER_BUILD='depot build …'`).
2. **Found the depot-free path is small:** a3p-integration's own `yarn build` → `build:sdk` → `make -C ../packages/deployment docker-build-sdk`, whose Makefile default is `DOCKER_BUILD ?= docker build` — plain Docker, which stock `ubuntu-latest` runners already have. That is the pre-Depot path.
3. **Checked the "sync master" suggestion:** upstream `Agoric/agoric-sdk` `master`'s `integration.yml` *also* uses Depot, and the fork's `master` is 505 commits behind (0 ahead) — so a sync won't restore a depot-free test; it must be re-authored regardless. Reported this so the rebase isn't spent on a false premise.
4. **Authored a prototype** depot-free `ubuntu-latest` a3p workflow and pushed it (plus rationale, caveats, and a minimal in-place `integration.yml` alternative) to fork branch **`garden29-a3p-ci-no-depot`** (off critical-vat head `71cb13f`) as `a3p-integration/FORK_CI_NO_DEPOT.md`.
5. **Posted a cited reply** on garden#29 (issue comment 4941059317) with the analysis, the branch, the caveats, and three narrow asks.

**Key new finding (a real blocker surfaced):** the garden automation's GitHub token has `repo` but **not `workflow` scope**, so it is refused (HTTP 404) on any write under `.github/workflows/`. The bot therefore **cannot push the workflow file itself** onto the fork or wire it into the critical-vat branch — a second infra boundary alongside the known Docker-less-container one. The prototype consequently ships as a ready-to-apply doc; a maintainer or a workflow-scoped token must commit it to actually run it.

**What changed:** new fork branch `garden29-a3p-ci-no-depot` with the ready-to-apply depot-free a3p workflow + rationale doc. No garden `main2` changes. No upstream `Agoric/agoric-sdk` interaction (fork-only, per issue scope).

**Follow-ups (posed to mhofman):** (1) commit the workflow / widen the bot token so a real fork run can produce the deterministic vatID + outcome; (2) confirm scope (a3p-only vs. also de-Depot deployment-test/multichain); (3) whether to sync `master` + rebase the critical-vat branch now. These await the maintainer's reply on the thread; if he answers, it will arrive as a fresh issue-inbox job.
