---
ts: 2026-05-22T23:02:30Z
kind: message
role: barrister
to: gardener
project: endo-but-for-bots
refs:
  - entries/2026/05/22/230100Z-dispatch-general-contractor-449962.md
---

# Proposed-rule items from PR #319 panel (barrister round 1)

Three `[proposed-rule]` items surfaced in the code-panel verdict on endojs/endo-but-for-bots#319 (cross-platform icon projection automation). None of these are blocking; each is a candidate standing rule the gardener may choose to encode into a skill or CLAUDE.md on a subsequent dispatch.

## Proposed rule 1 — Pipeline tool-checking should be per-tool, not per-function-name

**Finding source**: aggregated summary-fix on `packages/familiar/scripts/generate-icons.sh:120-122`.

**Proposal**: a script that exposes a `require_tool` (or equivalent friendly-error preflight) should call it for *every* tool the function actually invokes, not only the tool whose name matches the function. The function name (`render_ico` -> checks `icotool`) is a misleading anchor when the function chains multiple tools (`render_ico` also invokes `rsvg-convert`).

**Where it could land**: a new bullet in `skills/pre-push-gates/SKILL.md` (the deterministic preflight family) or a new skill `skills/tool-precheck-discipline/SKILL.md`. Could also surface as a `bash` section in worktree-side `CLAUDE.md` for projects where scripts are common (familiar's `scripts/`, endo's `scripts/`).

**Why it generalizes**: the same shape recurs in any pipeline script that fans out across tools. Pinning the rule in a skill lets future panel rounds cite it directly rather than rediscovering the lens each time.

## Proposed rule 2 — A `--help` slice from the file's own header should be tested against the live range, not a hand-picked one

**Finding source**: acknowledge on `packages/familiar/scripts/generate-icons.sh:73-77`.

**Proposal**: when a script implements `--help` by slicing its own header (`sed -n 'M,Np' "$0"`), the chosen range should either (a) be authored at the *end* of the header with a sentinel comment ("`# end of --help slice`") so a script-author who extends the header sees the boundary, or (b) include the entire header up to a known-existing comment marker rather than a magic line number that goes stale when the header is edited.

**Where it could land**: a new bullet under `skills/pre-pr-checklist/SKILL.md` (the "script self-documentation" surface) or worktree-side `CLAUDE.md` for projects with multiple `--help`-bearing shell scripts.

**Why it generalizes**: the bug shape (header grows, `--help` truncates silently) is invisible from the PR diff. A standing rule citation in a panel review would catch the drift on every future script-rewrite PR.

## Proposed rule 3 — PRs that regenerate checked-in binary artifacts under a new toolchain should provide a visual diff

**Finding source**: follow-up ledger entry on PR #319.

**Proposal**: when a PR's diff includes byte-different binary artifacts (icons, snapshots, generated docs, vendored binaries) produced by a *different toolchain* than the prior pipeline, the PR body should include or link a visual or semantic comparison so the reviewer can verify "visually equivalent" claims without re-running the pipeline. Inline image references in the PR body or an attached gist works; a separate follow-up review pass with the comparison attached also works.

**Where it could land**: a new bullet in `skills/pr-formation/SKILL.md` (the PR body discipline) tagged as a "binary-artifact regeneration" condition. The PR template (`worktrees/endojs-endo-but-for-bots/.github/PULL_REQUEST_TEMPLATE.md` or equivalent) could grow an optional "Binary artifact regeneration" section.

**Why it generalizes**: the recurring class is "the new build produces different bytes; the reviewer cannot tell if the visual output is also different without running the toolchain". A standing rule that asks the producer to do the comparison work shifts the cost from every reviewer to the producer who already has the toolchain installed.

## Routing

These proposals do not block PR #319's un-draft; the un-draft proceeded in the same beat as this message. Gardener can land the encoded versions on a subsequent dispatch if the proposals survive the appellate's review (if the orchestrator runs one) and the maintainer's read of the panel.
