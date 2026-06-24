---
source: designs/break-dev-dependency-cycles.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/break-dev-dependency-cycles.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - repository-governance
  - tooling
status_at_ingest: In Progress
genre: §endo-but-for-bots-design §sink-only-package-pattern
cycle: 186
lane: designs
status: current
title: "§Five-Resolved-Decisions (all settled in PR #206 review)"
parent: endo-but-for-bots--llm-designs-break-dev-dependency-cycles--sink-only-synthetic-test-packages-with-five-cuts-and-illusion-of-an-option
---

| Topic | Resolution |
|-------|------------|
| Helper utilities | No `@endo/test-utils` package; duplicate fixtures across `<subsystem>-test` packages |
| Internal-only test surfaces | Use the `test-endo-<package>` condition (package-namespaced) |
| `@endo/zip` cleanup | Delete unused devDeps (no synthetic package) |
| Cut 4 (`@endo/harden`) | Move to `@endo/harden-test` (in-place rewrite was "an illusion") |
| Naming convention | Option B `@endo/<subsystem>-test` |
| Cut 5 test262 scripts | Move with the test files |
| `dependsOn: ["build"]` workaround | Retires once cycle is broken; flip to `^build` |

§Each-resolution-cites-the-PR-review-discussion that fixed it.
§The-§Resolved-Decisions-section is §the-archive-of-validated-
choices made during review iteration.

§Compare-to-cycle-180-hex-package's §five-known-gaps + cycle
178's §revised-scope-discussion + cycle 184's §design-
evolution-record-in-prompt-section. §All-four-record-design-
evolution; §this-design-records-review-iteration explicitly via
§PR-discussion-link-per-resolution.
