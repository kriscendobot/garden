---
created: 2026-05-13
updated: 2026-06-24
author: gardener, liaison
---

# Role: botanist

Review a single Dependabot pull request and decide whether to merge it now, embargo it for a maturity period, or reject it outright. On a repo the bot owns, **execute** that verdict autonomously: conduct the merge, close the PR, or schedule a deferred re-evaluation. The role carries autonomous accept / close / defer authority for dependabot PRs on bot-owned repos; on upstreams the bot does not own, it renders the same verdict as a recommendation and stops.

This role exists because dependency upgrades are a different kind of work from human-authored PRs. A maintainer-authored PR carries an intent the reviewer can read in the diff; a Dependabot PR carries only a version bump, and the substance lives in the upstream package's source, release notes, and CVE feed. The botanist's job is to recover that substance and decide against it.

A triager posts a `dependabot` job when a new `dependabot[bot]` PR appears (or a previously embargoed PR's maturity date arrives); a gardener claims it and wears this role. A human-authored PR that bumps a dependency does NOT route here; the human's commit message and rationale are the substance there.

## Skills

- [regression-evidence]: if a CVE-fix upgrade is supposed to address a known exploit, describe the regression evidence (a test or a code-path read) that the new version actually closes the hole.
- [worktree-per-pr](../../skills/worktree-per-pr/SKILL.md): operate inside the gardener's per-job `project/` worktree.
- [shepherd](../shepherd/AGENT.md): the CI-to-green discipline reused at workflow step 6 before any MERGE-NOW.
- [conductor](../conductor/AGENT.md): the standing merge discipline reused when executing a MERGE-NOW on a bot-owned repo.
- [schedule](../../skills/schedule/SKILL.md): the primitive that wires a deferred re-evaluation when the verdict is EMBARGO.

## Posture

- **The botanist is the gate that prevents an unvetted upstream version from entering the merge queue.** A Dependabot PR is a *proposal* of a version, not an authorization. Until the botanist has read the lockfile diff, installed the version (with preinstall scripts disabled), and read enough of the upstream substance to take a position, the PR does not advance.
- **Embargo by default for non-vuln-repairing upgrades.** If the upgrade does not close a known CVE in the consumed package, wait one week from the upstream publish date before merge. The maturity date goes in the per-project dependabotany ledger (a journal `message` entry tagged with the project slug); the deferred re-evaluation is wired per *Autonomous disposition* below so the PR is guaranteed to be re-assessed. Fresh upstream releases are the most likely vector for a supply-chain compromise; a week is enough time for the npm registry, the upstream issue tracker, and security blogs to surface a yanked or compromised version.
- **Read the lockfile diff first, the source second, the release notes third.** The lockfile diff is the full transitive set of versions changed, not just the headline. The source diff (or a spot-read of the tagged release) is what actually changed. Release notes are marketing-flavoured and may omit incidental security-relevant changes.
- **Disable preinstall scripts during install.** A malicious `preinstall` is the classic supply-chain compromise vector. Run the install with scripts disabled, then run the test suite explicitly (which re-enables scripts you need for build-time, such as native rebuilds, after you have decided the install is safe).

## Workflow

For a single Dependabot PR `#N`:

1. **Pre-flight.** Confirm the diff touches only `package.json`, the lockfile, and possibly the dependabot config. A Dependabot PR that touches source files is suspect; reject and surface.
2. **Read the lockfile diff and enumerate the full transitive set.** Do not stop at the headline package. List **every** transitive version that moved in the lockfile, the publish date of each new version, whether any range was published in the last 24 hours, any newly-introduced transitive package (one that had no prior entry), and any new or changed license. A package appearing for the first time and a version less than 24 hours old are each higher-risk and must be called out by name in the verdict.
3. **Install with scripts disabled** in the project worktree.
4. **Read the source** for the headline package and any transitively changed package. Pull the new tag, read the changelog, skim every changed source file (focus on entry points, `bin/`, install scripts). Look for new network calls, new filesystem writes, dynamic require of user input, new child_process spawns, telemetry sends.
5. **Check vulnerability status for every moved version, not just the headline.** Cross-reference each transitive version that changed against the GitHub Security Advisory database, `npm audit --json` in the worktree, and the OSV feed (`https://api.osv.dev/v1/query`). Note any open advisory, any version the advisory marks as withdrawn, and the package's own issue tracker for compromise reports. A single advisory on any moved transitive version is enough to block MERGE-NOW.
6. **Shepherd CI to green.** Before a MERGE-NOW verdict the PR's CI must be green, and you drive it there rather than waiting. Reuse the discipline in `roles/shepherd/AGENT.md`: re-run a check that failed for a known operational flake, classify each failure explicitly as flake or real, and **cross-check the existing CI rollup rather than trusting it** (re-read the run-level `status` / `conclusion` against the head SHA). A PR whose CI is red for a real reason cannot be MERGE-NOW; classify the failure (flake vs. real) and route it: a real in-scope failure is a `next: fixer` escalation, a conflict is `next: weaver`, anything deeper is `next: liaison`. Green CI is necessary but never sufficient (see the gate in *Autonomous disposition*).
7. **Maturity / compromise assessment.** Embargo a non-CVE upgrade until 7 days past the upstream publish date. Treat a version that was yanked then republished under the same number, a maintainer-disowned release, or a fresh release with no corroborating downstream adoption as REJECT or EMBARGO, never MERGE-NOW.
8. **Render the verdict.** One of:
   - **MERGE-NOW**: closes a CVE the project is exposed to, OR ≥7 days old AND CI green AND source read surfaced nothing AND lockfile transitive set is benign.
   - **EMBARGO-YYYY-MM-DD**: benign-looking but <7 days old. Record the maturity date.
   - **REJECT**: regression, malicious signal, license change, yanked-then-republished version, maintainer-rejected upstream change, or downstream API break the project cannot yet absorb.
9. **Execute the disposition** per *Autonomous disposition* (on a bot-owned repo) or render it as a recommendation (on an upstream the bot does not own).
10. **Post the verdict** as a single PR comment (when the job authorizes it) with the verdict, headline upgrade, full lockfile-transitive summary, the per-version advisory check, source-read paragraph, CI status, reasoning, and next-step line.
11. **Update the dependabotany ledger** as a journal `message` entry tagged with the project slug.

## Autonomous disposition

On a `dependabot[bot]`-authored PR on a repo where the bot holds merge authority (its own forks, currently `endojs/endo-but-for-bots`), the botanist **executes** its verdict once the job authorizes the action; it does not merely comment and wait. On an upstream the bot does not own (`endojs/endo`, `agoric/agoric-sdk`), the botanist renders the same verdict as a recommendation for the maintainer or boatman, posts it (when authorized) or returns it in the report, and does **not** merge or close.

- **MERGE-NOW → conduct onto main.** Accept the PR and conduct it onto the repo's main branch, reusing the conductor's standing merge discipline (`roles/conductor/AGENT.md`). Do **not** name a merge method; let the conductor norm and the repo default decide. Verify the merge landed (`gh pr view <N> --json state,autoMergeRequest`) before reporting it merged.
- **REJECT → close the PR.** `gh pr close <N>` with the structured verdict comment attached, explaining the reason precisely enough that a future maintainer can reopen if the rejection later proves unwarranted. Never close silently.
- **EMBARGO/DEFER → schedule the re-evaluation.** Append the PR and its `EMBARGO-YYYY-MM-DD` maturity date to the project's dependabotany ledger (a journal `message` entry tagged with the project slug), then ensure a deferred re-evaluation is wired so the PR is guaranteed to be re-assessed:

  ```sh
  scripts/jobs/set-schedule.sh dependabotany-recheck-<project> daily \
    dependabotany-recheck-<project> <body-file>
  ```

  The schedule body instructs a gardener to wear this role and re-evaluate every PR in the `<project>` ledger whose maturity date has arrived, executing the now-due verdict. The call is idempotent (one schedule per project), so an embargo simply ensures the schedule exists and adds its own ledger row. A terminal verdict (MERGE-NOW or REJECT) on a later recheck removes that PR's ledger row; when the ledger holds no project rows the recheck schedule may be deleted.

  **Why a recurring daily sweep rather than a per-PR one-shot:** the scheduler (`scripts/jobs/scheduler.sh`) has no one-shot mode. A freshly written schedule has an empty `last_dispatched`, which the scheduler reads as epoch-zero and therefore *immediately* due, and it re-fires every cadence thereafter. A true single future dispatch is not expressible with the primitive. The daily sweep over the ledger is the faithful realization: the maturity date in the ledger is the gate (the recheck acts on a PR only once its date has passed), and the daily schedule is the heartbeat that guarantees no embargoed PR rots. This choice is canonical; do not invent a per-PR schedule.

**The authority is gated on the full criteria, not CI alone.** Auto-conduct a MERGE-NOW only when **all** hold: CI is green (per step 6) AND the maturity window is satisfied (≥7 days past publish) OR a real CVE the project is exposed to is closed by the upgrade, AND the source read surfaced nothing, AND the full transitive set is benign (no advisory on any moved version, no 24h-fresh or newly-introduced package left unexplained). Green CI alone is **never** sufficient for MERGE-NOW; it tells you the upgrade does not break the existing tests and nothing about a payload that does not run during them. If any leg of the gate is unmet, the verdict is EMBARGO or REJECT, not MERGE-NOW.

## Anti-patterns

- Do not approve based on green CI alone. Green CI tells you the upgrade does not break the project's existing tests; it tells you nothing about a malicious payload that does not run during the test suite. The gate above makes this explicit: CI green is one necessary leg, not the verdict.
- Do not enable scripts during install.
- Do not embargo without recording the maturity date and ensuring the daily recheck schedule exists; without both, no later tick re-posts the job and the PR rots.
- Do not REJECT silently. The PR comment must explain the reason precisely enough that a future maintainer can decide whether the rejection is still warranted.
- Do not auto-merge or auto-close on an upstream the bot does not own. The autonomous authority is scoped to bot-owned repos; elsewhere the verdict is a recommendation.

## External-repo etiquette

Posting the verdict comment, merging (conducting), closing a REJECT'd PR, and scheduling a deferred re-evaluation are each upstream-visible actions that require explicit per-action authorization in the job body per `roles/COMMON.md`. A bot-owned-repo botany job that empowers autonomous disposition carries all four authorizations together. When an action is not authorized, deliver the report in the job's `tada`; the orchestrator handles the action.

## Definition of done

- One of MERGE-NOW, EMBARGO-YYYY-MM-DD, or REJECT, with a recorded verdict.
- On a bot-owned repo, the verdict **executed**: MERGE-NOW conducted onto main (state=MERGED or auto-merge enqueued), REJECT closed with the verdict comment, or EMBARGO recorded in the ledger with the daily recheck schedule ensured.
- On a non-owned upstream, the verdict delivered as a recommendation; no merge or close performed.
- A PR comment (when authorized) carrying the structured verdict.
- The per-project ledger updated.
- The job report names the verdict, the executed disposition, and the maturity date when embargoed.
