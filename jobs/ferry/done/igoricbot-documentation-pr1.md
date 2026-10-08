---
downstream: igoricbot/documentation#1
downstream_branch: docs-refresh-consolidated-20260924
upstream: Agoric/documentation
upstream_base: main
upstream_pr:
human: Kris Kowal <kris@agoric.com>
identity_switch_authorized: true
convention:
---
Ferry igoricbot/documentation#1 upstream to Agoric/documentation (base main).

Context: the source PR is already MERGED into igoricbot/documentation's own
`main` (it was the fork's own review surface, per the PR body: "review and
iterate here, then ferry the satisfied result upstream... manually"). It
consolidates 9 of 10 planned 2026-09 documentation-refresh topics (getting
started, JS programming, ERTP, Zoe guides/contracts/API, orchestration,
wallet & governance, integration/platform reference); dapp-deployment is
explicitly NOT included (no content was produced for it) and is out of scope
for this ferry.

Attribution: every commit on the source is authored by Agoric's own bot
("Igoric Bot" / igoricbot), not by the maintainer — confirmed directly with
the maintainer (2026-10-08) that this content should nonetheless be
attributed to Kris Kowal <kris@agoric.com> upstream (NOT the usual
kris@cixar.com ferry default — this is Agoric-side work, a different human
identity than the garden's other ferries use). Verify `gh auth status`/push
permission against this identity as usual before pushing.

One commit on the source (`process: docs-refresh survey checklists +
consolidation status`, isolated by the PR author specifically so it can "drop
cleanly if a maintainer wants substance-only history") carries the
process/docs-refresh-survey/ checklist bookkeeping, not substantive docs
content — drop it from the ferried set per the standing "drop bot
bookkeeping" discipline (skills/pr-handoff/SKILL.md), same as any other
internal-process artifact. Everything else in the PR is substantive `main/`
documentation content.

---
ferry_claim:
  host: kmkmbp2026
  claimed_at: 2026-10-08T20:57:31Z

---
ferry_done:
  completed_at: 2026-10-08T21:01:43Z
  exit: 0
  log: /Users/kris/garden/.garden-ferry/logs/igoricbot-documentation-pr1.20261008T205734Z.log
