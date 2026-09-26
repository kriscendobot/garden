Panel backfill complete.

**What I did**

Ran the missing jury panel against PR #848 (`chore: update Pi to 0.81.1`, head `6b3b71cbdf`, OPEN / non-draft / MERGEABLE-CLEAN). Confirmed first that the PR carried **zero reviews of any kind**, so the backfill was warranted and not duplicative.

- **Panel:** a reduced **six-seat** code panel chosen for the diff's shape (dependency bump plus two compat hunks): assessor, migrator, packager, prover, integrator, changeset-auditor. The other 22 seats did **not** run, and the posted review states that omission rather than implying full coverage. Seats were fanned out concurrently (each still one `claude -p` over its `roles/jurors/<seat>/AGENT.md` brief with `panel.sh`'s exact `seat_review` prompt); the blocks were handed back to `scripts/jobs/gardening/panel.sh` via `GARDEN_PANEL_SEAT` so sensing, aggregation and the disposition decision were the real script. Foreperson returned **`must-fix`**.
- **Verdict posted:** https://github.com/endojs/endo-but-for-bots/pull/848 as a formal review. `--request-changes` was refused by GitHub ("Can not request changes on your own pull request"); it landed as `--comment` with the "Must-fix before merge" heading intact, per `skills/panel-review/SKILL.md` § Pitfalls.

**Findings** — 3 must-fix, 3 summary-fix, 5 follow-up, 3 acknowledge, 1 drop:

1. Unsquashed `fixup!` commit on the head (4 seats); the parent fails `yarn format` in isolation.
2. `yarn.lock` bundled with the package.json and source changes instead of its own `chore: Update yarn.lock` commit (4 seats).
3. No changeset, despite a disjoint 0.x peerDependency narrowing and two changed exported defaults. One seat argued private packages are exempt; **dropped** after I checked `.changeset/config.json` (`privatePackages: {tag: true, version: true}`, empty `ignore`) and existing changesets on the private `@endo/agentry`.
4. Both migration comments and the PR body misstate the break as turn-start; pi-agent-core 0.81.1 throws in the **`Agent` constructor** (`dist/agent.js:118` → `dist/stream-fn.js:13`). I verified this independently, along with the fact that importing `pi-ai/compat` does not call `setDefaultStreamFn`, and that `StreamFn` takes `SimpleStreamOptions` (so `streamSimple` is type-correct). **The PR's fix is sound; the panel objects to the narration and the commit hygiene, not the change.**
5. Genie hardcodes `streamFn` with no override seam while agentry uses `streamFn ?? streamSimple`; agentry's JSDoc default enumeration not updated.

**Routing / artifacts**

- Fixer job **`endojs-endo-but-for-bots-pr848-panel-fixes`** posted to the board (must-fix plus should-fix bundle, ordering constraint of content edits before history rewrite, `safe-push-pr-head.sh --mode rewrite` requirement). It has **already been claimed** by a peer (`jobs/doin/`).
- Follow-up ledger landed at `projects/endo-but-for-bots/followups/endo-but-for-bots--848.md` (5 parked items).
- Journal `result` entry `entries/2026/07/28/164745Z-result-gardener-69df1d.md`; `message` entry to liaison `entries/2026/07/28/164824Z-message-gardener-12e918.md` carrying the proposed rules.

**Not verified:** I did not run the full local suites. The suite numbers quoted in the review are the prover seat's own revert-and-observe observations; CI green on this head is GitHub's report, not a local run.

**Follow-ups for the garden (routed to the liaison, not landed by me)**

- `panel.sh` fans its 28 seats **sequentially**, which cannot finish inside a gardener's `timeout 2400` budget. This job was requeued 3 times before delivering, and a peer was observed hand-rolling the same concurrent workaround for #705 on this host. Proposal: bounded concurrency inside the script (or a `GARDEN_PANEL_CONCURRENCY` knob), keeping retry-on-empty and per-seat stderr capture.
- `/tmp` is `noexec` here, so a hook script handed to `GARDEN_PANEL_SEAT` / `GARDEN_PANEL_FIXER` fails with exit 126; hooks must live under `$GARDEN_SCRATCH`. Worth a line in `skills/panel/SKILL.md`.
- `skills/panel-review/SKILL.md` § Pre-round state check tells a gardener to short-circuit on `isDraft == false`; the gauntlet-backfill job shape is the intended exception but is not named, so a literal reading would no-op the backfill.
- Candidate for `skills/changeset-discipline/SKILL.md`: `private: true` is **not** a changeset exemption in this repo.

The project worktree is left in place for the scratch janitor (removing it would need git in the bare clone under the garden root).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr848-gauntlet-backfill.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 33 tokens (2805564 cached reads)
- Output: 21121 tokens
- Cost: $3.549852
- Wall-clock: 370s

<!-- garden-usage-end -->
