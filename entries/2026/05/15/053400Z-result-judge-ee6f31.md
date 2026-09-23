---
ts: 2026-05-15T05:34:00Z
kind: result
role: judge
worktree: dispatches/judge--ee6f31
repo: endojs/endo-but-for-bots
project: endo
---

PR #265 (`design: pi-harness comparative analysis + gap-closing raft (endopi)`) design panel, in-band-fallback.

Head reviewed: `b5fd77d4e` (origin/design/endopi). Files: 1 modified (`designs/README.md`) + 9 added (`designs/endopi.md` umbrella plus eight `designs/endopi-*.md` spinouts). All paths under `designs/`.

Panel kind: design-panel (design-only PR; the panel-kind discrimination at `roles/judge/AGENT.md` § Panel-kind discrimination selects the five-seat design panel for design-only PRs).

Panel execution: in-band-fallback. The harness exposed only deferred non-`Agent` tools (`EnterWorktree`, `ExitWorktree`, `Monitor`, `WebFetch`, `WebSearch`, notebook/Gmail/Calendar/Drive bindings) and no concurrent `Agent` or `Task` tool; each of the five seats was written one block at a time against `garden/roles/<seat>/AGENT.md`, then aggregated.

Copilot reviewer NOT added (design-panel rounds skip `@copilot` per `roles/judge/AGENT.md` § Design panel; the design surface is prose, not code).

Maintainer inline comments: zero. The contractor's "empty-body-with-inline-comments" lesson prompted explicit checks: `gh api repos/endojs/endo-but-for-bots/pulls/265/comments` returned `[]`, and `gh pr view 265 --json reviews` returned `"reviews":[]` (pre-submission).

### Seat findings (per-block)

- **critic**: substantive critique passes. Three comment-only items: milestone-slot framing for spinouts could mislead readers as parallel-track scheduling claims; security framing in `endopi-extension-package-manifest.md` § Security posture overstates the structural difference for skills (indirect-authority risk via agent capabilities); cross-provider tool-call schema translation in `endopi-provider-registry-and-oauth.md` is underspecified at design time.
- **skeptic**: walked the five premise categories. Five comment-only items: agentskills.io spec stability not named; Pi edit-tool unique-match convergence not verified across harnesses; subscription OAuth TOS posture not acknowledged; JSONL `compaction` privacy/purge story deferred; "short-term" framing for stdio-rpc-bridge understates the year-plus lifetime before `endor-bus-tui`.
- **copyeditor**: prose mechanics pass. Seven sentence-level cites including `endopi.md` § Background paragraph 1 "follow-on" reframing, § Architecture Comparison "Tool model" cell verb-without-object, § Built-in tool core voice shift, `endopi-edit-tool.md` § Semantics fourth-bullet fragment, `endopi-jsonl-transcript-format.md` § Writer paragraph density, `endopi-provider-registry-and-oauth.md` § Provider registry schema-vs-prose mismatch, `endopi-extension-package-manifest.md` § Security posture abrupt section opening.
- **pedant**: formal style pass. Nine items including `endopi.md` § Target disambiguation bullet-leader inconsistency, § Operating modes column-1 header non-parallel ("Pi Mode" vs "Pi Feature"), `endopi-edit-tool.md` schema vs prose return-shape mismatch, `endopi-skills-markdown-format.md` § Validation sentence-fragment ("All other fields optional."), numeral form inconsistency. Explicit note: the garden's em-dash rule does not bind project-side design documents (the project's own `CONTRIBUTING.md` uses em-dashes freely); pedant flagged zero em-dash findings on the design files. Panel body itself was swept em-dash-clean.
- **novice**: top-down clarity pass. Seven items, the load-bearing two are (a) `endopi.md` opens with a comparative table that assumes both Pi and Endo vocabularies; a glossary or grounding paragraph between *Background* and *Architecture Comparison* would carry a new reader, and (b) `endopi.md` § Background references `endoclaw.md` without a bridging sentence naming what OpenClaw is. The remaining items are mental-model gaps in spinouts read in isolation (`exo`, `capability boundaries`, `$ENDO_STATE` introduced without preamble).

### Verdict

`--comment` (self-PR fallback per `skills/panel-review/SKILL.md` § Pitfalls; `kriscendobot` is both PR author and submitting reviewer, so `--request-changes`/`--approve` are blocked at the GitHub API level).

- Must-fix in scope: 0
- Should-fix in scope: 7 (consolidated from independently-raised findings)
  1. Add a glossary or grounding paragraph at the top of `endopi.md` (novice + critic).
  2. Bridge `endopi.md` § Background to `endoclaw.md` with one sentence naming OpenClaw and the endoclaw reference (novice).
  3. One-sentence "this is a refinement of <parent>; lands after <parent>'s Phase N" prelude in each spinout's *Motivation* to disambiguate milestone-slot scheduling claims (critic).
  4. Tighten three premise statements raised by the skeptic: agentskills.io spec status; subscription OAuth TOS; stdio-rpc-bridge "short-term" framing.
  5. Two prose mechanics fixes: `endopi-skills-markdown-format.md` § Validation fragment; `endopi-edit-tool.md` § Semantics fourth-bullet fragment.
  6. `endopi.md` § Target disambiguation bullet-leader uniform separator (period vs colon).
  7. Soften `endopi-extension-package-manifest.md` § Security posture to "no *direct* execution authority" rather than "safer than `endo install` is today".
- Out of scope: 5 (JSONL privacy/purge path; cross-provider tool-call schema translation; Pi's full built-in tool list; edit-tool schema strictness vs prose; mental-model anchoring for spinouts read in isolation).

### Un-draft

Conditions for un-drafting (per dispatch prompt): "if verdict has no in-scope must-fix and no kriskowal inline comments unaddressed". Both held: must-fix count is zero; kriskowal inline-comment count via `gh api repos/.../pulls/265/comments` is zero.

`gh pr ready 265 -R endojs/endo-but-for-bots` ran successfully. PR is OPEN, isDraft=false. Loop terminates without a fixer dispatch; the seven should-fix items are advisory and the maintainer may absorb them during their own review pass.

### Formal review

Submitted as `gh pr review 265 -R endojs/endo-but-for-bots --comment --body-file /tmp/panel/aggregated.md`. The body carries the panel verdict with an explicit "Findings: must-fix before merge / None." heading so the orchestrator's dispatch matrix records the terminal verdict. Reviews on PR are now `[{author: kriscendobot, state: COMMENTED, submittedAt: 2026-05-15T05:32:47Z}]`.

Self-improvement: nothing this time. The in-band-fallback discipline is well-codified for both panel sizes now; the design-panel in-band run produced the expected ~600-1000-word aggregated body (1100-word actual, slightly long but well within the ~25% tolerance the role file names). No skill or role gap surfaced that warrants a `message` to liaison.
