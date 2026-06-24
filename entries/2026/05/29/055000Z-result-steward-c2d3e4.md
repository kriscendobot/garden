---
ts: 2026-05-29T05:50:00Z
kind: result
role: steward
host: endolinbot
to: "*"
refs:
  - entries/2026/05/29/053130Z-dispatch-steward-f9a0b1.md
  - entries/2026/05/29/054200Z-dispatch-steward-b1c2d3.md
  - entries/2026/05/29/053831Z-result-gardener-095818.md
  - entries/2026/05/29/054727Z-result-gardener-7406cd.md
  - entries/2026/05/29/054559Z-result-fixer-bc7a55.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 377
    role: target
---

# result: gardener (missed-feedback fix) + fixer (mirror #3291) — both complete

## Gardener `d94d11` outcomes

Investigation + structural fix landed on `origin/main` over two commits:

- **`ccb4599b`** — `roles/steward/AGENT.md` gets a new *Maintainer-
  feedback response* section codifying that the steward owns
  Monitor-surfaced maintainer feedback on every garden-authored DRAFT
  PR regardless of who opened it. Dispatch-by-shape: design-only PRs
  to designer, source-touching to fixer. Composition with the
  per-cycle PR-creation-flow scan is documented. `skills/monitor-endo-
  but-for-bots/SKILL.md` `PullRequestReviewEvent` row split by PR
  shape so design-only routes to designer and source-touching to
  fixer. Notes-from-the-field rows on both files cite the
  28-minute-miss on PR #376 as precipitating evidence.
- **`7406cd35`** — `roles/fixer/AGENT.md` line 54: corrected the
  literally-wrong `gh api ... requested_reviewers -f reviewers[]=<login>`
  example to the working `--input -` JSON-body shape. This was the
  one-occurrence pitfall the designer flagged on #376; the gardener
  picked it up and named both failing shapes so future readers
  recognize the trap.

The contractor's gardener pass (`002debba monitor-endo-but-for-bots:
widen authority to every commenter (2026-05-29 directive)`, landed
inter-cycle) is unrelated to this dispatch's scope but provides
additional context on the per-skill skill's evolution today.

Garden main on `endolinbot` now at `7406cd35` (fast-forwarded).

## Fixer `bc7a55` outcomes

PR #377 opened cleanly on `endojs/endo-but-for-bots`:
- **URL**: https://github.com/endojs/endo-but-for-bots/pull/377
- **Title**: `fix(benchmark): retry esvu installs in install-engines.sh`
- **State**: OPEN, DRAFT
- **Head**: `fix-benchmark-install-engines-retry@f43996e07`
- **Base**: `master-c49fb04` (frozen base)
- **Upstream source**: `endojs/endo#3291` commit `44b80546d6...`
- **Patch applied cleanly** via `git apply` (the bot's copy of
  `packages/benchmark/install-engines.sh` happened to also include
  the trailing-whitespace fixups upstream's commit dropped; no
  rejected hunks).
- **Atomic commit** with conventional header, body cites the mirror
  source, `Co-Authored-By: Kris Kowal <kriskowal@kriskowal.com>`
  trailer for attribution.
- **Changeset added** under `.changeset/retry-esvu-installs.md`
  (`@endo/benchmark: patch`).
- **PR body** filled per upstream's PULL_REQUEST_TEMPLATE.md,
  references #79 + #375 as on-fork failures this addresses, notes
  in passing the meta-irony that #3291's own CI is currently
  failing on the same signature (the very retry fix can't ride
  through its own bootstrap).
- **Pre-push gates** probes-only summary: all 7 deterministic probes
  passed.

The PR sits DRAFT awaiting the cleaner / judge / fixer-loop / un-draft
chain (the next per-cycle PR-creation-flow scan picks it up, or the
contractor's slot machinery if it's slot-eligible).

## Cleanup

Tearing down both dispatch roots:
- `/home/kris/dispatches/gardener--d94d11/`
- `/home/kris/dispatches/fixer--bc7a55/`

(The designer `512216` root was already torn down in the prior result.)

## What now sits in maintainer's queue (from this morning's session)

- **PR #79** (test-xs V8 flake, 17 of 18 green) — awaits maintainer
  review or judgment on the esvu flake. PR #377 (the mirror of
  #3291) is the long-term mitigation.
- **PR #376** (endo-gateway-mcp design) — re-request kriskowal review
  posted at 05:39Z; awaits next round.
- **PR #375** (the kumavis... wait, 0xpatrickbot EndoMount fix) —
  maintainer's "reconstruct" directive is still impasse'd on the
  master-vs-llm question; the steward's 05:15Z clarification comment
  awaits maintainer reply.
- **PR #377** (new this engagement) — esvu-retry mirror of #3291,
  DRAFT, awaiting gauntlet.

Self-improvement: the gardener pass codified the missed-feedback
ownership question that motivated this dispatch; the steward will
follow the new rule from cycle 11 onward.
