The PR is correctly configured: draft, base `main2-11082b7`, diff is exactly `designs/fq-reference-enforcement-lane.md`, and the open-questions marker is present. The work is complete.

## Completion report

**Job:** `design-fq-reference-enforcement-lane` (issue #89, `intended_recipient: designer`)

**What I did.** Designed a fully-qualified-reference enforcement lane for outbound GitHub text, modeled on the americanizer/deslopper normalization lanes but adapted to the crux the maintainer's ask exposes.

**The design's core resolutions** (`designs/fq-reference-enforcement-lane.md`):
- **Choke point:** the fleet `gh` wrapper (`scripts/jobs/bin/gh`) is *already* the single PATH chokepoint every fleet GitHub write crosses, carrying four sourced hooks today (numeric-scope-guard, pr-job-marker, comment-body-guard, provenance footer). The design adds a fifth, `fq-reference-guard.sh`, of identical shape — so "run all comments through a filter" is literally true and enforced by code, not memory.
- **Pre-post, not panel-diff:** outbound comment/review/PR-body text is ephemeral, so a fixer-to-a-worktree pattern has nothing to edit; the gate lives at post time.
- **Detection is deterministic, no-LLM**, sparing already-linked/code-spanned/already-qualified forms; the target repo is known from `-R`/endpoint, which makes the `#99` ambiguity tractable — same-repo `#nnnn` → `/issues/nnnn` (redirects for PRs too, no network lookup), preserving GitHub's own autolink meaning while hardening it.
- **Two tiers** mirroring the wrapper's own split: safe deterministic rewrite fail-open (incl. back-reference suppression — the transform the parent applied by hand to 17 comments); the narrow ambiguous residual (foreign-repo `#nnnn`, unknown-provenance SHA) is where "dispatch an agent" is real, since only the authoring agent holds the repo context.
- **Scope boundary is free by construction** — the wrapper only ever sees bot-authored text, so no External-author calibration is needed; the design also respects External-repo etiquette (reformats existing references only, never introduces one).
- Named the concrete build files (primary lane: the guard library, the wrapper hook, a zero-false-positive test, a SKILL enforcement section; optional post-hoc panel lane: grep + juror seat + myrmidon fixer + verb, gated behind an open question).

**What changed.** Design landed bare on `main2` (commit `ef0ee04`). Because it carries five maintainer-facing open questions, it also gets an open-questions review PR per CLAUDE.md § Conventions: **[kriscendobot/garden#102](https://github.com/kriscendobot/garden/pull/102)** (draft, base `main2-11082b7`, diff = the single design file, marked `<!-- garden-design-open-questions -->`).

**Open questions for the maintainer:** (1) residual block-vs-warn; (2) `/issues/` redirect vs exact `/pull/` lookup; (3) whether to also build the committed-prose panel lane; (4) whether to expand same-repo bare `#nnnn` at all; (5) names for the panel-lane seat/role/verb.

**Follow-ups.** None owed by this job (the issue-follow-up parent already replied on the thread). The gauntlet is manual — the maintainer promotes with **run the gauntlet #102** when ready; nothing is staged automatically.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-fq-reference-enforcement-lane.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1758774 cached reads)
- Output: 25956 tokens
- Cost: $2.7737760000000002
- Wall-clock: 431s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
