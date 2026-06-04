---
ts: 2026-06-04T00:07:26Z
kind: result
role: gardener
host: endolinbot
to: liaison
---

# Result: general-contractor retired; design-poller skill + systemd unit landed

## Maintainer directive (2026-06-03)

> I have dismantled the contractor. The role has not been working and I
> would like to reconstruct it on the driver. That is, that there will
> be a new, deterministic systemd service in the driver container that
> will poll the llm branch for new designs that are ready to be built
> and then post a job for a driver.

## What landed

Commit `5417fc58` on `origin/main` (9 files, +167 / -321):

- **`roles/general-contractor/AGENT.md`**: deleted.
- **`skills/design-poller/SKILL.md`** (new): the contract for the
  `garden-design-poller` systemd service. Single-instance per driver
  container; walks the project's roadmap branch (today
  `endo-but-for-bots:llm`) on a 10-minute cadence; runs the
  `design-queue-drift-check` eligibility filter; posts one `build`
  job per newly-eligible design to `journal/jobs/builder/open/` via
  the standard `skills/job-board/post-job.sh` mechanism; commits the
  poster's state file to `journal/` so concurrent pollers on sibling
  hosts coordinate via the `posted_designs` slug list.
- **`scripts/systemd/garden-design-poller.service`** (new): single-
  instance unit, hard-coded to `endo-but-for-bots`. Restart-on-
  failure with a 30-second back-off. A templated variant
  (`garden-design-poller@.service` with project slug as `%i`)
  is deferred until a second project comes online.
- **`scripts/systemd/README.md`**: table extended with the new unit;
  install-time symlink command updated.
- **`CLAUDE.md`**: contractor removed from role inventory; two-
  posture contract paragraph replaces the prior three-posture
  framing; `design-poller` added to the skills list.
- **`roles/liaison/AGENT.md`**: § Posture's third-posture paragraph
  removed; § Posting jobs to the board scrubbed of contractor
  references; § Concurrent stewards updated; *Contractor adoption*
  operating norm rewritten as a redirect that surfaces the retirement
  and points at the design-poller / driver lanes.
- **`roles/steward/AGENT.md`** § Maintainer-feedback response: the
  *Ownership: steward, not contractor* subsection rewritten as
  *Ownership: steward (Monitor-surfaced), driver lanes (chain
  advancement)*. Heartbeat-shape and claim-race references scrubbed
  of contractor mentions. Notes-from-the-field row dated 2026-06-04
  records the simplification.
- **`roles/researcher/AGENT.md`**: orchestrator list dropped
  general-contractor; driver-lane builds gain an explicit note that
  the precedence applies to them via the lane's job-claim time
  integration. Notes-from-the-field row dated 2026-06-04 records the
  contractor-side integration retirement.
- **`designs/driver.md`**: new *Update — 2026-06-03 contractor
  retirement* section between the metadata table and the Summary.
  The body's existing contractor references stay as historical
  record; the update section is the authoritative current shape.

Frontmatter `updated:` bumped to 2026-06-04 on every edited file.

## Out of scope (queued for builder dispatch)

The skill is the contract; the **actual bash daemon at
`scripts/daemons/design-poller.sh`** is a separate builder dispatch.
The systemd unit's `ExecStart` line points at the intended path so
any premature `systemctl enable + start` fails fast with a clear
"file not found" rather than silently appearing to work. A builder
brief for the daemon should:

1. Read `skills/design-poller/SKILL.md` (the contract).
2. Read `skills/design-queue-drift-check/SKILL.md` (the eligibility
   filter the daemon invokes).
3. Read `skills/job-board/SKILL.md` (the post-job mechanism).
4. Read `scripts/daemons/start.sh` and the existing daemon scripts
   for the project's daemon-script conventions.
5. Land `scripts/daemons/design-poller.sh` with the cadence loop,
   state-file commit-and-push, and one-job-per-newly-eligible-design
   semantics.

## Out of scope (steward's purview)

- **Journal-side cleanup** of `journal/contractor-slots/`,
  `journal/presence/<host>/general-contractor.md`, and the
  contractor's prior heartbeat / cycle-result entries. Those are
  journal artifacts; the steward can clean them on a later cycle or
  let them age out naturally. The gardener does not edit journal
  infrastructure directly from this dispatch.

## Inbox nudges sent

Two `message: gardener → <role>` entries in the same journal push
addressed to `liaison` and `steward` so any orchestrator session
already running on this host re-reads its role file before the next
dispatch. (No contractor message: the role no longer exists.)

Self-improvement: the contractor's retirement is the second major
posture pruning this session (after the upstream-mirror-comment
retirement on 2026-05-29). The pattern of "a posture that did not pan
out gets replaced by deterministic infrastructure" is now established;
the next gardener engagement can consult the design-poller skill as
the precedent shape for similar future infrastructure-replaces-posture
moves.
