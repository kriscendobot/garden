PR #1652 can enter the gauntlet: it is open, nothing has replaced it, and the need behind it still holds. I changed nothing and spent no clean, panel, fix, CI-wait, or un-draft budget.

**PR facts:** #1652 is open and unmerged, and still a draft. It has one commit (`22a475e7ff`) and changes only docs: it adds `designs/unified-virtual-filesystem.md` and indexes it in `designs/README.md`. There are no comments or reviews yet.

Deciding question: Does current evidence show that `llm` and the open PRs still lack a normative contract unifying Endo's pet-name, mount, platform filesystem, storage, and agent-editing surfaces, so that #1652 is neither superseded nor pointless?

Answer: yes. That contract is still missing, so #1652 is not superseded and its premise holds.

Evidence:
- **Fresh request:** the PR body says kriskowal asked for this on 2026-11-05, and the PR opened that same day. The producing job `design-endo-unified-virtual-filesystem-20261105` is in `tada`, and its report says it queued this viability stage.
- **Base is current:** the frozen base `llm-48d6f3e` is identical to the `llm` tip (`48d6f3e08b`, ahead 0, behind 0), so there is no newer base history to displace it.
- **Design not on `llm`:** `designs/unified-virtual-filesystem.md` returns 404 on `llm`. The existing `designs/` entries are the fragmented corpus this PR consolidates, such as `daemon-mount*.md`, `fs-interface-*.md`, `endo-fs-*.md`, and `platform-fs.md`.
- **No competing PR:** searches of PR and issue titles and bodies found no other unifying design. The nearest PRs are narrower and do not displace it:
  - #1586 is a draft implementing Phase 1 of the older `fs-interface-reconciliation` design, which #1652 cites as an input. It also last changed before #1652 opened.
  - #1085, #1509, #1590, #1592, and #1510 are slices of mount or filesystem features.
  - #241 is about running applications over a VFS.
  - #464 is closed.
- **Need still holds:** by its own status labels, the design separates implemented behavior from designed and proposed behavior, and says the common interface isn't implemented yet. Its "Implemented in part" source-map row and its inconsistencies table also show the surfaces remain unreconciled. Open work such as #1586 is still adding to them.
- **Related job, no effect on this verdict:** `scholar-ingest-fudco-gist-20261105` is queued and names this design as context for a report. It may inform review later, but it does not replace the design.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1652-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (279495 cached reads)
- Output: 3533 tokens
- Cost: $0.49087099999999995
- Wall-clock: 103s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
