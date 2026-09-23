---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-08T08:07:25Z
---
---
kind: result
role: integrator
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
---

Panel seat `integrator` on endojs/endo-but-for-bots#970 (job base
`ironhorse-js-01-lexer-parser-negatives-gauntlet-panel-2`).

Base note: the dispatch named `llm...HEAD`, but the worktree's local `llm` ref is
stale at `249e02758` (790 commits behind), so that range spans the whole branch
history. Reviewed `origin/llm...HEAD`, whose 10 commits match `gh pr view 970
--json commits` exactly.

### integrator

**Verdict:** request-changes

**Findings:**

- PR description ignores the repo's pull-request template. `.github/PULL_REQUEST_TEMPLATE.md`
  provides `Closes:`/`Refs:`, `## Description`, and the Security / Scaling /
  Documentation / Testing / Compatibility / Upgrade Considerations sections; the
  body has none of them. Refill section for section.
  [rule: skills/pr-formation/SKILL.md § Use the upstream template, section for section]

- Garden methodology leaks into the PR body and into committed project files. Body:
  "the single shared completion branch/PR for the ... orchestration", "Every later
  child builds on this branch", plus trailing `issue_spine:` / `issue_url:` keys.
  Committed: `rust/engine/ironhorse-262/baseline/README.md:8` ("This PR's branch
  stays open. Do not merge it") and `:214`/`:230` ("every later child", "the
  orchestration's final report-refresh child"). A committed README that carries a
  PR-scoped instruction and a garden orchestration role is wrong permanently in git
  history. Commit subjects leak too: `de3ae604c` ends "(child 01)" and `39f66f827`
  reads "apply panel must-fixes".
  [rule: skills/pr-formation/SKILL.md § No methodology leak]

- Title and description omit roughly 900 lines of engine semantics. The title scopes
  the PR to "shared branch + trustworthy full-suite harness", but `8dd201e19` adds
  782 lines to `rust/engine/ironhorse-vm/src/interp.rs` and `75e9b5e02` changes
  `ironhorse-compile/src/parser*` and `ironhorse-regexp`. Neither is mentioned in the
  body. Both also carry empty commit bodies, as does `cccc3f4ab`, while the branch's
  other seven commits and every commit on `llm` carry a body paragraph. And
  `fix(ironhorse-compile):` scopes a commit that is two thirds `ironhorse-regexp`.
  [rule: skills/pr-formation/SKILL.md § Title; AGENTS.md § Commit conventions]

- Convention probe on the corpus pin. The repo already vendors a full test262 tree at
  `packages/test262-runner/test262/` (38,181 tracked cases), and `locate_test262()` in
  `rust/engine/ironhorse-262/src/test262.rs:*` defaults every other binary, including the
  new `ironhorse-262-report`, to it. `rust/engine/ironhorse-262/scripts/full-run.sh:97`
  instead clones tc39/test262 at `TEST262_REVISION` into `<out>/test262-src`. Two
  independently pinned corpora now coexist, and the vendored one records no upstream
  SHA (`"version": "4.0.0-ses0"`). The fresh clone is probably the right call, but
  neither `TEST262_REVISION` nor `scripts/README.md` says why the vendored corpus was
  rejected or how the two may drift. State it at the pin.
  [rule: roles/jurors/integrator/AGENT.md § Convention probe]

- The regression invariant is prose, not an assertion. `baseline/README.md:229` claims
  "any child can check the invariant deterministically", yet nothing reads
  `baseline/baseline.json`: `git grep -n 'baseline/' -- rust/ .github/` returns nothing.
  Every follow-on change must hand-roll the comparison against a 4,856-line file. Ship
  the comparator with the snapshot (an `ironhorse-262-report compare --baseline`
  subcommand, or a `tests/` gate), so the invariant is enforced rather than narrated.
  [rule: roles/jurors/integrator/AGENT.md § Test pins what it claims, § Forward-compose probe]

- Roadmap gap. `designs/ironhorse-test262-convergence.md` § Part 2 fixes the report
  convention as the xst-shaped YAML grammar ("so tooling that reads an `xst` report
  reads an `ironhorse-xst` report"), and § What retires enumerates the binary set. This
  PR adds a third binary, a JSON plus static-HTML report, a bash orchestrator, and the
  `baseline` / `ironhorse-hang` / `compiler-unimplemented` / `runtime-reject` vocabulary,
  and edits no design file. Land the design edit alongside, or the map and the territory
  part ways at the first follow-on change.
  [rule: roles/jurors/integrator/AGENT.md § Concept-namespace coherence]

- Citation coherence, comment-only. Every existing `[[bin]]` comment in
  `rust/engine/ironhorse-262/Cargo.toml` cites "(design § Part 1)" or "(design § Part 2)".
  The new `ironhorse-262-report` entry cites `kriscendobot/garden#51`, as do seven further
  new sites across `full-run.sh`, `TEST262_REVISION`, `report.rs`, and both READMEs. Cite
  the in-repo design; keep the issue link in the PR body where a future reader can still
  reach it.
  [proposed-rule: committed source and docs cite the project's own design documents for
  rationale; a garden issue tracker is a PR-body citation, not a source-comment one.]

**Notes (out of scope but worth flagging):**

- `.github/workflows/ironhorse-full-test262.yml` exposes `subtree`, `jobs`, and `oracle`
  as dispatch inputs but not `--case-timeout`, the one knob a multi-hour sweep is most
  likely to need to retune. [proposed-rule: a workflow_dispatch wrapper exposes every
  input its underlying script documents as tunable.]
- `rust/engine/ironhorse-262/tests/errors_coercions_strict.rs:1` opens without the design
  section citation its sibling suites carry (compare `tests/reflect_intrinsic.rs:1`).
  [rule: roles/jurors/integrator/AGENT.md § Concept-namespace coherence]
- The same file's `only_strict_test262_cases_execute_instead_of_preskipping` removes its
  temp dir on the success path only, so a failing assertion leaks it. The repo's teardown
  discipline is written for AVA, not Rust, so this is a proposal rather than a citation.
  [proposed-rule: a Rust test that creates a temp dir releases it through a drop guard,
  not a trailing statement.]

Self-improvement: the seat's stale-base hazard is new and worth encoding. The dispatch's
`llm...HEAD` resolved through a local ref 790 commits behind `origin/llm`, which would
have made the review span the entire branch history. Sent to the gardener as a
proposed addition to `skills/panel-review/SKILL.md`: before reviewing, confirm the named
base ref against the PR's own commit list (`gh pr view <N> --repo <slug> --json commits`)
and prefer the remote-tracking ref when they disagree.
