# Completion report: review-improve-design-bespoke-mechanism-over-existing-path

Both parts are done: prevention and sensing. They landed directly on `main2` as `7a88d0007c2`. The cluster `design-bespoke-mechanism-over-existing-path` is now **closed**, and the closing record cites that commit and the files below. The new test and the existing panel and comment-watcher suites pass, apart from one failure that predates this change (see Tests).

## (a) Prevention
- **Builder and designer briefs** (`roles/builder/AGENT.md`, `roles/designer/AGENT.md`) have a new rule called "Existing path before a new mechanism". Before adding a channel, socket, endpoint, formula type or per-entity resource (or a runtime-derived catalog), the author must name the existing path that already gives the access and say why it isn't enough. If the work would re-open a decision a maintainer made on an earlier PR for the same design doc, the author stops and asks on the PR or issue instead of building.
  - **Change from the job spec:** the spec suggested asking through `message-user`. The repo's `maintainer-inbox-information-hiding` check rejected that, because PR-scoped roles may only talk to the maintainer through PR or issue comments (a standing 2026-06-28 directive). The rule is reworded to follow it, and all 5 checks in `scripts/checks/run-all.sh` pass.
- **Guard on the "conduct and build" path** (`scripts/jobs/comment-watcher.sh`, in the review job body). This is the route that produced #1407: the #1371 review job read "build" as "build every follow-up the bot listed". Every review job now carries a FOLLOW-UP GUARD:
  - A bare "build" covers only the items the maintainer named.
  - A follow-up the bot proposed itself is parked with `post-plan.sh --awaiting-maintainer --asked-at <review URL>` if it adds a mechanism, re-opens a design open question, or reverses an earlier maintainer decision.
  - It must never be parked with `--blocked`, which promotes it automatically.
  - A new assertion in `comment-watcher-test.sh` checks the guard is present.

## (b) Sensing
- **New probe `skills/panel-hints/probes/X-decomplector.sh`.** It fires when a code PR touches a design doc, or adds a socket, listener or serve-path call (such as `servePrivatePath`), a daemon formula type or `formulate*` maker, or a retention pin.
  - `panel.sh` runs the full code-seat list and never reads panel-hints output. So the probe also runs as a `panel.sh` pre-pass that adds the decomplector to the code panel and hands it the evidence.
- **Repeat-finding signal: new `scripts/jobs/gardening/mechanism-repeat-signal.sh`, run every round as a `panel.sh` pre-pass.**
  - It reads prior rounds from the durable `panel-runs/` records (staged runs) and from the run's own earlier rounds (classic mode), ordered by when each reviewed commit was made.
  - If the last two rounds both raised must-fix findings naming the same file, identifier or design section, it forces the decomplector to ask "is this mechanism needed?". Spelling and style seats don't count toward that overlap.
- **Decomplector brief** (`roles/jurors/decomplector/AGENT.md`) gains:
  - binding rules for its "minimum viable abstraction" category, for two cases: a design that builds on top of a surface it already cites, and repeated findings on one mechanism;
  - a code-panel mode with two questions. The first is whether an existing repository path already gives this access, answered with `git grep` and a named symbol. The second is whether a maintainer already rejected this mechanism on an earlier PR for the same design doc, checked through the design doc's `git log`, `gh pr list` and the reviews on those PRs.
- `skills/panel-hints/SKILL.md` documents the new probe and pre-passes and adds a field note.

## Re-litigation (run against the real history)
| Member | Check that now catches it | Result |
|---|---|---|
| #1226-2fc247cc (per-guest socket, design) | repeat signal over the real `panel-runs` records | fires at round 3 (`§ naming`) and at round 6, head `4e1696a4` (`SO_PEERCRED`, `§ scoping by`); decomplector binding rule |
| #1226-179ff5ab (derived tool catalog) | same signal at round 6 (`§ tool catalog`); rule for "builds on top of a cited static surface" | fires |
| #1407-1d8c37a5 (rejected socket rebuilt) | `X-decomplector` on heads `a62e91aca` and `aa79a93cce` (base `d4124e6e40`); repeat signal | probe fires on the touched `designs/endo-guest-stdio-mcp.md`, and on `socketPath` when limited to `packages/`. Repeat signal fires from round 3 (`d5d72f3b`); rounds 4–6 name `serve-guest-path.js`, `guestBootstrapPath`, `makeGuestConnect`. Follow-up guard covers the #1371 route. |
| #1125 readable-directory (folded in) | `X-decomplector` | fires on the `'readable-directory'` entry, `formulateReadableDirectory`, and `type: 'readable-directory'` |
| #1125 retention pin (folded in) | `X-decomplector` (retention group) | fires on `guestPinName` and `guestPinsDirectoryId` |

`panel-hints.sh` on #1407 at `a62e91aca` lists the decomplector under Cross-panel. The `vestigial-mechanism-unquestioned` cluster status is unchanged.

## Tests
- **New:** `scripts/jobs/test/bespoke-mechanism-probe-test.sh`, 24 passed. It covers the probe on the historical lines plus controls, the repeat signal on staged records, classic rounds, and cases that must not fire (unrelated findings, spelling/style-only overlap, a record for the commit under review), and the `panel.sh` wiring end to end.
- **Existing suites:** comment-watcher 473 passed / 0 failed; all panel tests pass; review-convention-probes 30/0; all 5 checks clean.
- **Two failures to know about:**
  - `panel-head-freshness-completion-test.sh` fails with or without this change, so it predates this work.
  - `panel-run-record-test.sh` failed once (32/1) in the first full run, then passed 33/0 on three reruns with this change in place, so it looks flaky.

## Follow-ups
- Neither check has run on a live panel yet; the first code PR that adds a socket or formula type will be the first real exercise.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/review-improve-design-bespoke-mechanism-over-existing-path.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 144 tokens (10523264 cached reads)
- Output: 54245 tokens
- Cost: $4.8060808
- Wall-clock: 1408s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
