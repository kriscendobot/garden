---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-28T16:47:55Z
---
---
ts: 2026-07-28T16:48:00Z
kind: result
role: gardener
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/848
---

# Panel backfill on endo-but-for-bots#848 (job endojs-endo-but-for-bots-pr848-gauntlet-backfill)

PR #848 ("chore: update Pi to 0.81.1") had been opened ready-for-review rather
than draft, so the gardening state machine read the bot-side chain as finished
and skipped the jury panel. Confirmed before acting: the PR carried zero reviews
of any kind. This job backfilled the panel against head
6b3b71cbdfbc362c0efa1a3f8e810c74cde0fc0a (OPEN, non-draft, MERGEABLE/CLEAN).

**Panel run.** A reduced six-seat code panel chosen for the diff's shape
(dependency bump plus two compat hunks): assessor, migrator, packager, prover,
integrator, changeset-auditor. The remaining twenty-two seats did not run, and
the review comment states that omission rather than implying full coverage. The
seats were fanned out concurrently rather than sequentially because a 28-seat
sequential run does not fit a gardener's wall-clock budget; each seat was still
one `claude -p` over its `roles/jurors/<seat>/AGENT.md` brief with the exact
prompt `panel.sh`'s `seat_review` builds. The collected blocks were then handed
back to `scripts/jobs/gardening/panel.sh` through `GARDEN_PANEL_SEAT`, so the
sensing, aggregation, and disposition stages were the real script. The
foreperson returned **must-fix**.

**Verdict posted.** https://github.com/endojs/endo-but-for-bots/pull/848 as a
formal review. `--request-changes` was refused by GitHub ("Can not request
changes on your own pull request"), so it landed as `--comment` with the
"Must-fix before merge" heading intact, per
`skills/panel-review/SKILL.md` § Pitfalls.

**Findings.** Three must-fix (unsquashed `fixup!` commit on the head; `yarn.lock`
bundled with the package.json and source changes rather than its own
`chore: Update yarn.lock` commit; no changeset despite a disjoint peerDependency
narrowing and two changed exported defaults), three summary-fix (both migration
comments misstate the upstream break as turn-start rather than Agent-construction
time; genie hardcodes `streamFn` with no override seam while agentry uses
`streamFn ?? streamSimple`; agentry's JSDoc default enumeration not updated),
five parked follow-ups, three acknowledgements, one drop.

The dropped finding is worth recording: the migrator seat argued no changeset is
required because all four packages are `private: true`. Falsified on inspection.
`.changeset/config.json` sets `privatePackages: {tag: true, version: true}` with
an empty `ignore`, and the private `@endo/agentry` already carries several
changesets in tree. Two other seats reached the opposite conclusion from that
same config, so the disagreement resolved on evidence rather than on vote count.

**Substance check (the panel's core claim, verified independently).**
pi-agent-core 0.81.1 evaluates `runtimeOptions.streamFn ?? getDefaultStreamFn()`
in the `Agent` constructor (`dist/agent.js:118`), `getDefaultStreamFn()` throws
when nothing installed a default (`dist/stream-fn.js:13`), and importing
`@earendil-works/pi-ai/compat` does not call `setDefaultStreamFn`. So the PR's
fix is necessary, and its chosen default is type-correct: 0.81's `StreamFn` takes
`SimpleStreamOptions`, which is exactly compat `streamSimple`'s signature. The
PR's *premise* is sound; what the panel objects to is the narration and the
commit hygiene, not the fix.

**Routing.** Fixer job `endojs-endo-but-for-bots-pr848-panel-fixes` posted to the
board with the must-fix and should-fix bundle, the ordering constraint (content
edits first, history rewrite last), and the `safe-push-pr-head.sh --mode rewrite`
requirement. Follow-ups parked at
`projects/endo-but-for-bots/followups/endo-but-for-bots--848.md`.

**Not verified:** the full local suites were not run by this job. The suite
numbers quoted in the review are the prover seat's own revert-and-observe
observations, and CI green on this head is GitHub's report, not a local run.

Self-improvement: `scripts/jobs/gardening/panel.sh` fans its 28 seats
sequentially, which cannot complete inside the gardener `timeout 2400` budget;
every panel-running gardener must therefore hand-roll a concurrent fan-out (peers
were observed doing exactly that for #705 on the same host). That belongs in the
script, not in each supervisor. Routed as a message to the liaison.
