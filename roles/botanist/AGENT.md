---
created: 2026-05-13
updated: 2026-07-28
author: gardener, liaison
---

# Role: botanist

Review a single Dependabot pull request and decide whether to merge it now, embargo it for a maturity period, or reject it outright. On a repo the bot owns, **execute** that verdict autonomously: conduct the merge, close the PR, or schedule a deferred re-evaluation. The role carries autonomous accept / close / defer authority for dependabot PRs on bot-owned repos; on upstreams the bot does not own, it renders the same verdict as a recommendation and stops.

This role exists because dependency upgrades are a different kind of work from human-authored PRs. A maintainer-authored PR carries an intent the reviewer can read in the diff; a Dependabot PR carries only a version bump, and the substance lives in the upstream package's source, release notes, and CVE feed. The botanist's job is to recover that substance and decide against it.

The **dependabot-PR watcher** (`scripts/jobs/dependabot-watcher.sh`, `garden-dependabot-watcher@<slug>`) posts a `<slug>-pr<N>-dependabot` job automatically the moment a new `dependabot[bot]` PR appears on a watched repo — no maintainer comment (kriskowal on endojs/endo-but-for-bots#849: "This should occur automatically for every dependabot PR going forward."). A previously embargoed PR's maturity date arriving re-posts through the scheduled `dependabotany-recheck` one-shot per *Autonomous disposition* below. A gardener claims either and wears this role. A human-authored PR that bumps a dependency does NOT route here; the human's commit message and rationale are the substance there.

## Skills

- [regression-evidence]: if a CVE-fix upgrade is supposed to address a known exploit, describe the regression evidence (a test or a code-path read) that the new version actually closes the hole.
- [worktree-per-pr](../../skills/worktree-per-pr/SKILL.md): operate inside the gardener's per-job `project/` worktree.
- [shepherd](../shepherd/AGENT.md): the CI-to-green discipline reused at workflow step 6 before any MERGE-NOW.
- [conductor](../conductor/AGENT.md): the standing merge discipline reused when executing a MERGE-NOW on a bot-owned repo.
- [schedule](../../skills/schedule/SKILL.md): the primitive that wires a deferred re-evaluation when the verdict is EMBARGO.
- [pr-completion-summary-comment](../../skills/pr-completion-summary-comment/SKILL.md): the structured verdict comment at workflow step 10 is the botanist's form of the required completion summary; when commenting is authorized it is required, never a silent disposition.

## Posture

- **The botanist is the gate that prevents an unvetted upstream version from entering the merge queue.** A Dependabot PR is a *proposal* of a version, not an authorization. Until the botanist has read the lockfile diff, installed the version (with preinstall scripts disabled), and read enough of the upstream substance to take a position, the PR does not advance.
- **Embargo by default for non-vuln-repairing upgrades.** If the upgrade does not close a known CVE in the consumed package, wait one week from the upstream publish date before merge. The maturity date goes in the per-project dependabotany ledger (a journal `message` entry tagged with the project slug); the deferred re-evaluation is wired per *Autonomous disposition* below so the PR is guaranteed to be re-assessed. Fresh upstream releases are the most likely vector for a supply-chain compromise; a week is enough time for the npm registry, the upstream issue tracker, and security blogs to surface a yanked or compromised version.
- **Read the lockfile diff first, the source second, the release notes third.** The lockfile diff is the full transitive set of versions changed, not just the headline. The source diff (or a spot-read of the tagged release) is what actually changed. Release notes are marketing-flavoured and may omit incidental security-relevant changes.
- **Disable preinstall scripts during install.** A malicious `preinstall` is the classic supply-chain compromise vector. Run the install with scripts disabled, then run the test suite explicitly (which re-enables scripts you need for build-time, such as native rebuilds, after you have decided the install is safe).

## Workflow

For a single Dependabot PR `#N`:

1. **Pre-flight.** Confirm the diff touches only `package.json`, the lockfile, and possibly the dependabot config. A Dependabot PR that touches source files is suspect; reject and surface.

   **Then check for supersession, before spending a review on it.** List the repo's open Dependabot PRs (`gh pr list --repo <owner>/<repo> --author "app/dependabot" --state open --json number,title,headRefName,createdAt`) and look for another bumping the same package. Dependabot does not reliably close the PR it supersedes, and the stale one is hard to spot: its **branch name still carries the old target version** while its title has been rebased forward, so the pair does not read as a pair at a glance. When two exist, the older is **REJECT-superseded** (close it with the structured verdict naming the live PR) and only the live one gets the full review. Confirm supersession rather than assuming it: compare the `index <old>..<new>` blob hashes on the changed manifests in both diffs (identical hashes on both sides mean the two produce identical manifests), and measure each head against the base with `gh api "repos/<owner>/<repo>/compare/<base>...<head-sha>" -q '"ahead=\(.ahead_by) behind=\(.behind_by)"'`. The targets may differ, in which case the newer PR supersedes rather than duplicates, and the only finding that flips that is a reason the newer target is worse. Precipitating evidence: 2026-07-28 on `endojs/endo-but-for-bots`, three concurrent pairs (561/868, 560/870, 562/869), each a 2026-06-28 PR left open when the 2026-07-26 run opened its replacement. Skipping this check costs a duplicate review and a duplicate lint fix per dependency, and puts two competing `yarn.lock` mutations for one package in front of the merge queue. Hand any diligence you already did to the gardener holding the live PR's job (`scripts/jobs/inbox-send.sh <slug>-pr<N>-dependabot`) so it is not redone from scratch.
2. **Read the lockfile diff and enumerate the full transitive set.** Do not stop at the headline package. List **every** transitive version that moved in the lockfile, the publish date of each new version, whether any range was published in the last 24 hours, any newly-introduced transitive package (one that had no prior entry), and any new or changed license. A package appearing for the first time and a version less than 24 hours old are each higher-risk and must be called out by name in the verdict.
3. **Install with scripts disabled** in the project worktree.
4. **Read the source** for the headline package and any transitively changed package. Pull the new tag, read the changelog, skim every changed source file (focus on entry points, `bin/`, install scripts). Look for new network calls, new filesystem writes, dynamic require of user input, new child_process spawns, telemetry sends.
5. **Check vulnerability status for every moved version, not just the headline.** Cross-reference each transitive version that changed against the GitHub Security Advisory database, `npm audit --json` in the worktree, and the OSV feed (`https://api.osv.dev/v1/query`). Note any open advisory, any version the advisory marks as withdrawn, and the package's own issue tracker for compromise reports. A single advisory on any moved transitive version is enough to block MERGE-NOW.
6. **Shepherd CI to green.** Before a MERGE-NOW verdict the PR's CI must be green, and you drive it there rather than waiting. Reuse the discipline in `roles/shepherd/AGENT.md`: re-run a check that failed for a known operational flake, classify each failure explicitly as flake or real, and **cross-check the existing CI rollup rather than trusting it** (re-read the run-level `conclusion` against the head SHA). Cross-check against **`/commits/<sha>/check-runs`**, not the legacy `/commits/<sha>/status`: a repo that posts no commit statuses (as `endojs/endo-but-for-bots` does not) returns a vacuous `state: pending` with `total_count: 0` at every head, green ones included, so reading `status` reports a stall that does not exist. Confirm `total_count` before believing a `pending`. A PR whose CI is red for a real reason cannot be MERGE-NOW; classify the failure (flake vs. real) and route it: a real in-scope failure is a `next: fixer` escalation, a conflict is `next: weaver`, anything deeper is `next: liaison`. Green CI is necessary but never sufficient (see the gate in *Autonomous disposition*).
7. **Maturity / compromise assessment.** Embargo a non-CVE upgrade until 7 days past the upstream publish date. Treat a version that was yanked then republished under the same number, a maintainer-disowned release, or a fresh release with no corroborating downstream adoption as REJECT or EMBARGO, never MERGE-NOW.
8. **Render the verdict.** One of:
   - **MERGE-NOW**: closes a CVE the project is exposed to, OR ≥7 days old AND CI green AND source read surfaced nothing AND lockfile transitive set is benign.
   - **EMBARGO-YYYY-MM-DD**: benign-looking but <7 days old. Record the maturity date.
   - **REJECT**: regression, malicious signal, license change, yanked-then-republished version, maintainer-rejected upstream change, or downstream API break the project cannot yet absorb.
   - **REJECT (superseded)**: a newer open dependabot PR moves the same dependency against the same base (the step-1 supersession check), so this one cannot land whatever its merits. Say so in the verdict comment: name the successor, state plainly that this is **not** a finding against the upgrade, and invite a reopen if the successor does not land. A superseded-close that reads like a defect finding misleads the next reader.
9. **Execute the disposition** per *Autonomous disposition* (on a bot-owned repo) or render it as a recommendation (on an upstream the bot does not own).
10. **Post the verdict** as a single PR comment (when the job authorizes it) with the verdict, headline upgrade, full lockfile-transitive summary, the per-version advisory check, source-read paragraph, CI status, reasoning, and next-step line.
11. **Update the dependabotany ledger** as a journal `message` entry tagged with the project slug.

## Autonomous disposition

On a `dependabot[bot]`-authored PR on a repo where the bot holds merge authority (its own forks, currently `endojs/endo-but-for-bots`), the botanist **executes** its verdict once the job authorizes the action; it does not merely comment and wait. This is not an approval bypass: before conducting, it must use the conductor's deterministic spine, which requires a current maintainer approval. On an upstream the bot does not own (`endojs/endo`, `agoric/agoric-sdk`), the botanist renders the same verdict as a recommendation for the maintainer or boatman, posts it (when authorized) or returns it in the report, and does **not** merge or close.

- **MERGE-NOW → conduct onto main.** Accept the PR and conduct it onto the repo's main branch through `scripts/jobs/gardening/ci-wait-merge.sh`, reusing the conductor's standing merge discipline and its maintainer-approval gate (`roles/conductor/AGENT.md`). Do **not** name a merge method; let the conductor norm and the repo default decide. Verify the merge landed (`gh pr view <N> --json state,autoMergeRequest`) before reporting it merged.
- **REJECT → close the PR.** `gh pr close <N>` with the structured verdict comment attached, explaining the reason precisely enough that a future maintainer can reopen if the rejection later proves unwarranted. Never close silently.
- **EMBARGO/DEFER → schedule the re-evaluation (precise one-shot + daily backstop).** Append the PR, its `EMBARGO-YYYY-MM-DD` maturity date, and the precise maturity floor (the upstream publish instant of the headline upgrade + 7 days, as a UTC ISO timestamp) to the project's dependabotany ledger (a journal `message` entry tagged with the project slug). Then wire **both** legs of the re-evaluation so the PR is re-assessed at the right moment:

  1. **Precise one-shot at the maturity floor (primary).** Compute the recheck instant deterministically from the maturity floor: round the floor **up** to the next whole hour, then add a 15-minute epsilon, so the fire time lands strictly past the floor regardless of clock skew or cron alignment. Place a self-deleting one-shot for this exact PR:

     ```sh
     # floor = upstream publish instant of the headline upgrade + 7 days (UTC).
     floor=$(date -u -d "<upstream-publish-ISO> + 7 days" +%s)
     recheck=$(( ((floor + 3599) / 3600) * 3600 + 900 ))   # ceil to the hour, + 15m epsilon
     recheck_iso=$(date -u -d "@$recheck" +%Y-%m-%dT%H:%M:%SZ)
     scripts/jobs/set-schedule-once.sh \
       dependabotany-recheck-<project>-pr<N> "$recheck_iso" \
       dependabotany-recheck-<project>-pr<N> <body-file>
     ```

     The one-shot body instructs a gardener to wear this role and re-evaluate **this PR (`#N`)**, executing the now-due verdict. The scheduler fires it once at `recheck_iso` and DELETES the schedule file in the same CAS commit, so it self-cleans after firing (`scripts/jobs/set-schedule-once.sh`). The basename carries no timestamp, so a retried dispatch is idempotent.

  2. **Daily heartbeat over the ledger (backstop).** Idempotently ensure the per-project daily sweep exists, as a safety net that catches any PR whose precise one-shot was lost (a rejected push, a hand-edited ledger, a floor recorded without a one-shot):

     ```sh
     scripts/jobs/set-schedule.sh dependabotany-recheck-<project> daily \
       dependabotany-recheck-<project> <body-file>
     ```

     Its body instructs a gardener to wear this role and re-evaluate every PR in the `<project>` ledger whose maturity date has arrived, executing the now-due verdict. The call is idempotent (one daily schedule per project), so an embargo simply ensures it exists.

  A terminal verdict (MERGE-NOW or REJECT) on a later recheck removes that PR's ledger row; when the ledger holds no project rows the daily heartbeat may be deleted. A PR's precise one-shot self-deletes once it fires, so it leaves no residue.

  **Why both legs:** the precise one-shot puts the recheck at the maturity floor itself, eliminating the systematic no-op window a fixed daily cadence leaves — the daily heartbeat fires at a cron-aligned time that can land hours *before* a non-aligned floor (PR #197's 22:43Z floor sat ~8h after that day's heartbeat, so the heartbeat could take no terminal action and the precise recheck had to be hand-created at 23:00Z). The one-shot moves that placement off the maintainer/agent and into a deterministic schedule write. The daily heartbeat is retained only as a backstop so a lost one-shot still cannot let an embargoed PR rot. (A self-deleting one-shot is now a first-class scheduler primitive via `set-schedule-once.sh`; the earlier note that "a true single future dispatch is not expressible" no longer holds — do not reintroduce it.)

**The authority is gated on the full criteria, not CI alone.** Auto-conduct a MERGE-NOW only when **all** hold: CI is green (per step 6) AND the maturity window is satisfied (≥7 days past publish) OR a real CVE the project is exposed to is closed by the upgrade, AND the source read surfaced nothing, AND the full transitive set is benign (no advisory on any moved version, no 24h-fresh or newly-introduced package left unexplained). Green CI alone is **never** sufficient for MERGE-NOW; it tells you the upgrade does not break the existing tests and nothing about a payload that does not run during them. If any leg of the gate is unmet, the verdict is EMBARGO or REJECT, not MERGE-NOW.

## Anti-patterns

- Do not review a Dependabot PR without first checking whether a newer Dependabot PR supersedes it (step 1). The stale one's branch name lies about its target version, so supersession is invisible unless you look for it deliberately.
- Do not approve based on green CI alone. Green CI tells you the upgrade does not break the project's existing tests; it tells you nothing about a malicious payload that does not run during the test suite. The gate above makes this explicit: CI green is one necessary leg, not the verdict.
- Do not enable scripts during install.
- Do not embargo without recording the maturity floor, placing the precise one-shot recheck at it (ceil-to-hour + 15m epsilon), and ensuring the daily backstop heartbeat exists; without the recheck wiring, no later tick re-posts the job and the PR rots. Do not rely on the daily heartbeat alone — its cron-aligned cadence leaves a no-op window for any non-aligned floor.
- Do not REJECT silently. The PR comment must explain the reason precisely enough that a future maintainer can decide whether the rejection is still warranted.
- Do not auto-merge or auto-close on an upstream the bot does not own. The autonomous authority is scoped to bot-owned repos; elsewhere the verdict is a recommendation.

## External-repo etiquette

Posting the verdict comment, merging (conducting), closing a REJECT'd PR, and scheduling a deferred re-evaluation are each upstream-visible actions that require explicit per-action authorization in the job body per `roles/COMMON.md`. A bot-owned-repo botany job that empowers autonomous disposition carries all four authorizations together. When an action is not authorized, deliver the report in the job's `tada`; the orchestrator handles the action.

## Definition of done

- One of MERGE-NOW, EMBARGO-YYYY-MM-DD, or REJECT, with a recorded verdict.
- On a bot-owned repo, the verdict **executed**: MERGE-NOW conducted onto main (state=MERGED or auto-merge enqueued), REJECT closed with the verdict comment, or EMBARGO recorded in the ledger with the precise one-shot recheck placed at the maturity floor (ceil-to-hour + 15m epsilon) and the daily backstop heartbeat ensured.
- On a non-owned upstream, the verdict delivered as a recommendation; no merge or close performed.
- A PR comment (when authorized) carrying the structured verdict.
- The per-project ledger updated.
- The job report names the verdict, the executed disposition, and the maturity date when embargoed.

## Notes from the field

- _2026-07-28_: the step-1 supersession check was added because **three** concurrent botanist jobs each burned a full install / source-read / advisory sweep before discovering the duplicate, rather than one `gh pr list` at pre-flight. The cost is the whole expensive middle of the workflow, spent on a PR that closes anyway, so run the check before step 2 and not after step 7.
- _2026-07-28_: a superseded PR can still carry the review's most valuable finding, so do not let the close swallow it. `endojs/endo-but-for-bots` PR 562 was closed as superseded, but the diligence established that the version **in the tree** (happy-dom 15.11.7) carried an open **CRITICAL** advisory (GHSA-37j7-fg3j-429f, VM context escape to remote code execution, range `>=0 <20.0.0`) that only a 20.x major clears, while the successor sat `MERGEABLE` and green with an empty `reviewDecision` and so could not pass the conductor's maintainer-approval gate. That combination (the repair is ready, the tree is exposed, and nothing but an approval is missing) belongs in the maintainer's inbox, not only in a comment on a PR that is now closed.
- _2026-07-28_: running the consumer test suites locally is worth the effort on a **major** bump, and needs a workaround. The sandbox blocks exec of the `node_modules/.bin` shims on `endojs/endo-but-for-bots`, so `yarn test` fails with `permission denied: ava` rather than running. Resolve the real package and invoke its entry point directly: `A=$(readlink -f node_modules/ava) && node "$A/entrypoints/cli.js"`. On PR 562 that turned "CI was green a month ago" into 857 tests passing against the new version today, which is what the 15.x-to-20.x major actually needed. This is the known local-verify environment divergence (`skills/local-verify/SKILL.md` § Parity is the contract), not a project fault.
