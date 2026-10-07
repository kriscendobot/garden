# Design: the proxy screens and merges kriscendobot/minion.town pull requests

| Created | 2026-09-29 |
| Author  | gardener (designer, job `design-minion-town-pr-screening-by-proxy`) |
| Status  | Accepted; widened 2026-10-07 |

## Mandate

The binding authorization is the maintainer's 2026-10-07 directive in
`entries/2026/10/07/203746Z-message-gardener-a253b1.md` on `journal2`.
The maintainer delegated the whole `kriscendobot/minion.town` review-and-merge
surface to the supervisors for the
[minion.town objective](https://github.com/kriscendobot/garden/issues/58) and the
[claude-on-minion.town objective](https://github.com/kriscendobot/garden/issues/89),
choosing “Everything, no escalations.”
The authorization includes gauntlet, fixes, un-draft, weave, restack, and merge
for that repository only.
Endo changes retain maintainer review.

## Where the maintainer is pulled in today

A bot PR on minion.town reaches kriskowal at four points. Each one gets a
minion.town-only redirect:

| # | Touchpoint | Today | After |
| --- | --- | --- | --- |
| 1 | **Merge gate.** `scripts/jobs/gardening/ci-wait-merge.sh` refuses an ordinary merge without an effective `APPROVED` review from `maintainers/allowlist` (`handlers/pr-maintainer-approval-gh.sh`). | The only way a minion.town PR merges. | A new `--screened-delegated-merge` mode substitutes the proxy's exact-head screening attestation for the approval signature, on minion.town only. |
| 2 | **Merge trigger.** The comment-watcher's `finalize` verb posts a conductor job when a trusted maintainer APPROVES. | The maintainer's approval *is* the trigger. | The proxy's screener posts the delegated conductor job itself. The `finalize` path stays as the maintainer's manual override. |
| 3 | **Fixer re-request.** `roles/fixer/AGENT.md` re-requests maintainer review via `requested_reviewers` after CI goes green. | Puts the PR on kriskowal's review-requested list, and so in the bulletin's parked section. | On minion.town the fixer re-requests **only** a human whose review is a live `CHANGES_REQUESTED`. Otherwise it skips the re-request; the head change already invalidates the old screen and the proxy re-screens. |
| 4 | **Bulletin parked listing.** `bulletin.sh` `fetch_parked_rows` lists `--review-requested kriskowal` PRs. | A minion.town PR appears whenever touchpoint 3 fires. | Delegated repositories are excluded from the parked query. A new **Screened by proxy** section lists the last 24 h of screen verdicts, merges, and deploy outcomes. |

The gauntlet's terminal `undraft` stage (`scripts/jobs/gauntlet.sh`) is unchanged.
Supervisors un-draft after a passing feature gauntlet; the screen never merges a
PR that remains draft.
A probe gauntlet has `kind: probe`, never reaches that stage, and stays draft.
The screen also rejects a PR body marked `gap-revealing`, so accidentally
un-drafting a probe cannot turn it into a merge candidate.

## Choice: the proxy, not a mentat supervisor

The **proxy** screens. The reasons:

- **The judgment is already made upstream of the screen.** The staged gauntlet's
  panel is the substantive review, and CI is the correctness check. What remains
  is to confirm that those verdicts hold at the exact head about to merge, that no
  human veto stands, and that the change stays inside the delegated scope. That is
  a deterministic predicate. The proxy already runs deterministic pre-passes in
  plain code (`scripts/jobs/proxy.sh`: the watchdog auto-clear, the PR-comment
  auto-clear) before its cost-gated `claude -p` handler. The screener is one more
  pre-pass of that kind.
- **Mentat is manual by construction.** `skills/model-selection/SKILL.md` refuses
  `tier: mentat` without `dispatch: manual`. The only exception is the
  journal-authorized Ironhorse watcher. A per-PR automatic mentat supervisor
  would need a second delegated-watcher exception to that gate, and it would spend
  the scarcest tier on a repository the maintainer called beneath attention.
- **The proxy's safety story already fits.** It runs on the leader every 5 minutes
  (`garden-proxy.timer`), it is the garden's standing stand-in for the absent
  maintainer, and it reports every decision to the maintainer inbox. "Keep the
  maintainer informed, not gated" is its existing contract.

Considered and rejected: a mentat supervisor job per PR, posted via
`post-manual-job.sh`. Reason: a human would have to post each one, which
reintroduces the maintainer gate the directive removes.

Considered and rejected: an LLM judgment inside the screen. The remaining gates
are deterministic, and PR body text cannot argue past them.

## Delegation record

This design reuses the Ironhorse delegated-ratchet shape
(`context/operations/ironhorse-ratchet.md`, `scripts/jobs/ratchet/policy.py`)
rather than inventing a new one:

- The journal `message` entry named in § Mandate records the authorization.
- `config/delegations/minion-town-pr-screening` is JSON. It binds the entry's
  SHA-256 and these fields:
  - `schema: 2` (schema 1 names the narrower #139 semantics and is rejected)
  - `repository: kriscendobot/minion.town`
  - `base: "*"` (all bases are admitted for supervision)
  - `author: kriscendobot`
  - `status: active|paused|revoked`
  - empty `escalate_paths`, `escalate_except`, and `escalate_sections`
- `config/delegations/minion-town-pr-screening.revoked` is a permanent tombstone.

A missing, unreadable, digest-mismatched, paused, or revoked record **denies**
the delegation. Denial falls back to today's behavior, maintainer approval.
Journal push access is the authority boundary. A PR body can never grant the
delegation.

The operator entry point is `scripts/jobs/minion-town-screening.sh
seed|pause|resume|revoke <reason-file>|status`. It mirrors
`ironhorse-ratchet.sh`: its own journal clone, CAS pushes, and no git in the
deployed root.

## The screen (proxy pre-pass, no LLM)

`scripts/jobs/screen-delegated-prs.sh` is invoked from `proxy.sh` as pre-pass 1d,
after the PR-comment auto-clear and before the gating enumeration. It exits
immediately when the delegation is not `active`. Otherwise it lists every open
PR on the delegated repository, including frozen and stacked bases, and evaluates
each at its current `headRefOid`.
It reads GitHub metadata, CI rollups, diff metadata, and journal records.
The only PR-body matches are the exact heal marker and fixed probe markers
(`gap-revealing`, `kind: probe`, `verb: probe`, or `<!-- garden-probe -->`);
no PR or comment text reaches an LLM.

A PR **passes** only when every gate holds on that exact head:

1. **Scope.** The repository and author `kriscendobot` match the delegation.
   Any readable base is admitted for supervision.
   The PR is OPEN, not draft, and not a probe by body or gauntlet-job marker.
2. **Panel verdict.** The staged gauntlet for this PR has a terminal
   `undraft=done` record in `jobs/gauntlet/`, and the panel's last verdict was a
   pass. The gauntlet's last pushed head must equal the current head. A later push
   (a fixer or shepherd follow-up) invalidates the verdict, and the screener
   re-requests a gauntlet (`run the gauntlet #N`, the existing staged-gauntlet
   trigger) instead of passing.
3. **CI.** The status rollup is terminal-green on the current head, with at least
   one check (`test.yml`). A PR with no checks does not pass.
4. **No human veto.** No live `CHANGES_REQUESTED` review from any human. A
   maintainer who objects keeps the veto they have today on every repository.
5. **Landing base.** A stacked PR waits after review until its parent has merged
   and a weaver has restacked it onto `main` or a frozen `main-<sha>` snapshot.
   The conductor may unfreeze a `main-<sha>` base, rebases the head onto live
   `main`, and the final policy check requires `baseRefName: main`.
   It can therefore never merge a child into its parent branch or a stale snapshot.
6. **Production health baseline.** The most recent `deploy.yml` run on `main`
   succeeded, and the `garden-minion-mcp-watchdog` heartbeat on the leader is
   `ok` and fresh (under 3 ticks old). The screener does not merge onto a
   production system that is already broken, because a failed post-merge deploy
   could not then be attributed to this PR.
7. **Complete comparison.** The GitHub compare has fewer than 300 files.
   Reaching the API limit is a correctness refusal, not a policy escalation.

On pass, the screener writes an attestation to
`screenings/kriscendobot-minion.town/<pr>/<head-sha>.json`. The record holds the
gate inputs it read: the gauntlet record path, the CI run IDs, the deploy run ID,
and the heartbeat timestamp. It is CAS-pushed, then the screener posts a delegated
conductor job, base `screen-minion-town-pr<N>-<short-sha>-conduct`. The base is
deterministic, so a re-screen of the same head is a no-op post. The conductor job
runs `ci-wait-merge.sh kriscendobot/minion.town <N> --screened-delegated-merge`.

On a gate that is not yet satisfied (pending CI, gauntlet in flight), the
screener does nothing, and the next tick re-evaluates. It is idempotent and holds
no state beyond the attestation files.

## The delegated merge (conductor spine)

`ci-wait-merge.sh --screened-delegated-merge` is a sibling of
`--ratchet-delegated-merge` and runs the same stages:

- **Scope gate before any mutation.** Delegation active, repository and author
  match, the base is readable, and the PR is not a probe. Anything else exits 1 with `merge blocked: outside
  screening delegation`.
- **Stacked-base gate.** Frozen `main-<sha>` bases are retargeted to live `main`
  by the existing unfreeze step. A child still based on a parent head cannot pass
  the final policy gate; it waits for the parent merge and a weave/restack.
- **Rebase through `safe-rebase.sh`, then CI freshness on the rebased head.** This
  step is unchanged from the ordinary path.
- **Attestation gate at merge time.** An attestation file must exist for the
  **post-rebase head**. A rebase that moved the head therefore stalls the job
  with `awaiting re-screen`, and the next proxy tick screens the new head and
  posts a fresh conductor. This matches the ratchet rule that rebasing
  invalidates the attestation. The spine re-reads the human-veto gate
  (touchpoint 4) at merge time.
- **Merge `--merge` only.** Never queue `--auto`, following the ratchet rule. The
  downstream-branch retention rule is unchanged.
- **Log line:** `approval-bypass repo=… pr=… mode=screened-delegated-merge head=…`.

`roles/conductor/AGENT.md` gains a `## Minion Town screened merge` section
parallel to § Ironhorse delegated ratchet. The ordinary path's "stall `merge
blocked: no maintainer approval`" rule is untouched for every other repository.

## Production validation and self-healing (post-merge)

A merge to `main` fires `deploy.yml`, the continuous-deployment workflow. The
screener's next ticks watch the deploy run whose `head_sha` is the merge commit.
For each merged PR, the attestation record gains `deploy: pending|success|failure`
and `health: ok|down`:

- **Deploy `success` and watchdog `ok` within 30 minutes.** The record closes as
  validated.
- **Deploy `failure`, or the watchdog `down` after a successful deploy.** The
  screener:
  1. **Pauses the delegation** (`status: paused`, reason naming the PR and run).
     This stops further delegated merges onto a broken production system.
  2. Posts a **heal job**, a fixer with base `heal-minion-town-<merge-short-sha>`.
     Its body names the merge commit, the failed run URL, and the watchdog
     detail. It is instructed to restore production by the cheapest correct
     route: a forward fix PR, or a revert PR of the merge. Either PR goes back
     through the same gauntlet and screen, which are allowed while paused for
     PRs marked `<!-- garden-heal: <merge-sha> -->`.
  3. Sends one `message-user.sh` notice to the maintainer. This informs; it does
     not gate.
- **Auto-resume.** When a later `main` deploy succeeds and the watchdog reports
  `ok`, the screener sets the delegation back to `active` and logs the recovery.
  A pause made by the maintainer through `minion-town-screening.sh pause` carries
  `paused_by: maintainer` and is never auto-resumed.

The screener never force-reverts `main` directly. Every change to production goes
through a PR and CI.

## No policy escalations; comparison still fails closed

The schema-2 record requires all three escalation lists to be empty.
Workflows, deployment scripts, provisioning scripts, and continuous-deployment
documentation are inside the delegation.
The screen still refuses a compare response with 300 files because GitHub may
have truncated it; that limit means the screen lacks evidence about the complete
diff.
It records a `blocked-<head>.json` event and does not request maintainer review.

## Keeping the maintainer informed

- **Bulletin section *Screened by proxy (minion.town)*.** It lists, for the last
  24 h, each screen pass, each merge, each deploy outcome, each comparison block, and
  the delegation status. Each entry carries links.
- **Maintainer inbox.** Pause, heal, comparison-limit, and stalled-conductor events go to the inbox.
  Routine passes and merges do not; the bulletin is their record. Each inbox
  message is sent as `from: proxy:screen`, so the proxy's own PR-comment
  auto-clear does **not** sweep it (it carries a real PR reference, so it is
  exempted by sender).
- **The maintainer's overrides** remain: a `CHANGES_REQUESTED` review blocks a
  merge; `minion-town-screening.sh pause|revoke` stops everything; an APPROVED
  review still triggers the ordinary `finalize` conductor.

## Build plan

The build is one builder job on `kriscendobot/garden` `main2`. Every step lands
with tests under `scripts/jobs/test/`, using the existing fake-`gh` harnesses:

1. **Delegation record and operator command.** `minion-town-screening.sh`, with a
   policy module under `scripts/jobs/screening/`, binds the journal authorization
   entry and the delegation record.
2. **Screener pre-pass.** `screen-delegated-prs.sh`, gates 1–7, attestation
   writes, the conductor post, and the proxy wiring as pre-pass 1d. Document it in
   `roles/proxy/AGENT.md` as a new § Screened-merge delegation, next to the two
   auto-clear exceptions.
3. **Conductor spine mode.** `--screened-delegated-merge` in `ci-wait-merge.sh`,
   plus the conductor role section.
4. **Post-merge validation, pause, heal, auto-resume.**
5. **Touchpoint redirects.** The fixer re-request rule (`roles/fixer/AGENT.md`,
   `roles/COMMON.md` § fixer bullet), the bulletin parked exclusion, and the
   Screened-by-proxy section.
6. **Operations page.** `context/operations/minion-town-screening.md`, plus
   CLAUDE.md § Monitoring safety constraint, which gets one sentence noting that
   the screener reads only metadata and does not widen surveillance.

Arming happens after the build deploys: running `minion-town-screening.sh seed`
is the arming act, and until then the screener is inert.

## Test plan

- A delegation that is missing, digest-mismatched, paused, or revoked denies
  both the screen and the merge. The ordinary approval path is unchanged.
- The screener admits live, frozen, and stacked bases, but refuses a non-bot
  author, draft or probe state, a stale gauntlet head, red/pending/no-check CI, a
  human `CHANGES_REQUESTED`, a red last deploy, a down or stale watchdog, or a
  300-file comparison.
- Workflow, deployment-script, and deployment-document changes do not escalate.
- A stacked child does not receive a merge conductor until its parent has merged
  and it has been woven onto the live-base line; the final merge gate independently
  requires live `main`.
- An attestation exists and a conductor is posted on a full pass. A re-tick does
  not create a duplicate conductor.
- The spine refuses a merge when the post-rebase head has no attestation, and
  merges when it has one. The spine never uses `--auto`.
- A failed post-merge deploy pauses the delegation, posts the heal job, and sends
  one inbox message. A green deploy auto-resumes a proxy-made pause but not a
  maintainer-made pause.
- The bulletin parked query omits the delegated repository, and the new section
  renders.
