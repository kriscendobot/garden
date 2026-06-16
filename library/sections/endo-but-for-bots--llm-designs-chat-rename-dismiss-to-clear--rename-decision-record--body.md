---
title: Body
source: designs/chat-rename-dismiss-to-clear.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 8e5058304b08a4ec590a8bdcc799f78b321d5726
source_date: 2026-05-20
source_authors: [Kris Kowal]
topics: [chat-ui, repository-governance]
status: current
notes: |
  **Status: Complete** upstream (PR #93, merged 2026-05-06). A bounded
  PR-merge decision record + post-implementation retrospective. The
  document's small size (75 lines, four subsections) is honestly
  captured as a single library section rather than padded to a
  three-section ingest. The retrospective is structurally interesting
  for three reasons: (1) explicit *deprecation-period alias* retention
  pattern on the CLI side; (2) chat-vs-CLI alias asymmetry (chat had
  not shipped the command pre-rename, so no deprecation surface
  needed there); (3) *roadmap calibration* — explicit git-blame
  analysis of active-development calendar with three implementation
  bursts separated by long unattended gaps (2026-03-17 / 2026-03-20 /
  2026-05-06).
parent: endo-but-for-bots--llm-designs-chat-rename-dismiss-to-clear--rename-decision-record
---

### §The PR #93 decision record

The §Status subsection is structured as a *post-merge retrospective* — the file describes what *landed*, not what *should land*. Four concrete deliverables:

#### CLI changes

- **File rename**: `packages/cli/src/commands/dismiss-all.js` → `packages/cli/src/commands/clear.js`.
- **Command registration with alias**: `packages/cli/src/endo.js` registers `.command('clear').alias('dismiss-all')`. The `dismiss-all` name remains *hidden* in the CLI but functional — running `endo dismiss-all ...` still works.

The *hidden alias* pattern is the canonical *deprecation-without-breakage* discipline: existing users' scripts continue to work; new documentation points to `clear`; eventually (after a deprecation period) the alias can be removed.

#### Chat changes

- **Command registry**: `packages/chat/command-registry.js` exports `clear` as the canonical command.
  - `immediate mode` (no inline form; runs as soon as the user submits).
  - `category: 'messaging'`.
  - `context: 'inbox'` (only available in the inbox context).
- **Command executor**: `packages/chat/command-executor.js` dispatches `case 'clear'` to `E(powers).dismissAll()`.

The §asymmetry-with-CLI is structurally significant:

> The chat side did not retain a `/dismiss-all` alias — chat had not yet shipped the command pre-rename, so no deprecation surface was needed there.

The decision tree: **add an alias only when there are existing users to migrate**. The CLI had existing users (scripts, docs, muscle memory); chat had none. The CLI gets the alias; chat doesn't. This is the *minimal-deprecation-surface* discipline — don't carry deprecation weight you don't need to.

The §dismiss-vs-clear naming note also surfaces:

> The underlying daemon power remains `dismissAll()` — that is the internal interface, not the user-facing command name, and out of scope for the rename.

The §internal-vs-external naming separation is the *interface-stability discipline*: the internal API method name (`dismissAll`) does not change even when the user-facing command name (`clear`) does. The two are *layers* with separate evolution constraints.

#### Tab completion

- **Shortest-common-prefix advancement**: tab pressed on partial input should advance the input *as far as possible* before requiring further disambiguation. Landed alongside the rename. The §note about *a follow-up audit would confirm it on the current chat-bar implementation* signals that the feature was implemented but not formally verified at audit-quality on the chat side.

#### Regression test

- `packages/cli/test/clear-command.test.js` asserts:
  - The `clear|dismiss-all` pairing appears in `endo --help`.
  - `endo dismiss-all --help` resolves through the alias.

The §regression test is *alias-preservation evidence*. A future refactor that accidentally removes the alias would fail this test — making the deprecation policy enforceable by CI.

### §Roadmap calibration — the 65-day active-development window

The §Roadmap calibration subsection performs *git-blame analysis* of the rename's actual development cadence. The findings:

> **Active development: 2026-03-03 → 2026-05-06 (65 days, calendar; the active authoring window was three brief bursts within that span, separated by long unattended gaps).**
>
> Design phase: 2026-03-03 (single commit `b6286fba4`, "Add designs for minor fixes to chat command vocabulary"; this commit also introduced `chat-markdown-render.md`).
>
> Implementation phase: 2026-03-17 → 2026-05-06 (51 days, calendar). Burst 1: 2026-03-17 (`77d1eef37`, "Chat: renames the dismiss-all command to clear"). Burst 2: 2026-03-20 (`6b49b03dd`, CLI rename). Burst 3: 2026-05-06 PR #93 commits `2a3ec3025` + `9272463a8` keeping `dismiss-all` as alias, merged 2026-05-05 via `31df9e3cf`.

The structural reading:

- **The design-to-implementation gap was 14 days** (2026-03-03 → 2026-03-17).
- **Bursts 1 and 2 were 3 days apart** (chat rename → CLI rename).
- **Burst 3 was 47 days after Burst 2** — the long gap from the chat-+-CLI-rename to the alias-retention + final merge.

The *roadmap calibration* discipline is the *post-merge introspection* pattern: after a feature lands, document *how long it actually took*, separated into design / implementation / merge phases. The introspection makes *cycle-time* visible for future planning.

The §calibration-pattern's reusable value: any rename or refactor of this scale should expect:
- **Design**: ~1 day.
- **Initial implementation**: ~1-3 days.
- **Iteration + deprecation surface**: ~1-2 months of calendar time with long unattended gaps.

### §The two motivations

The §Motivation subsection names two reasons for the rename:

> The `dismiss-all` command name is verbose and unfamiliar. `clear` is the conventional term for this action (clearing an inbox, clearing notifications). The rename should apply consistently across the chat UI command bar and the CLI.

The §verbose-and-unfamiliar argument is *naming-by-convention*: `clear` is the established term in messaging UIs (clearing inboxes, clearing notification trays, etc.). `dismiss-all` was a custom name that didn't match user expectations.

> Additionally, `dismiss` and `dismiss-all` share a prefix, which makes tab completion in the chat command bar awkward — typing `/dismiss` and pressing tab cannot advance past the common prefix without an extra disambiguation step. Renaming `dismiss-all` to `clear` eliminates the collision entirely.

The §tab-completion-collision argument is *interface ergonomics*: prefix-shared command names defeat the *fastest-disambiguation-via-tab* discipline. Renaming one command to share no prefix with the other restores the ergonomics.

The two motivations are *complementary*: one is *user-mental-model* (convention); the other is *user-input-ergonomics* (tab completion). Both point to the same fix.

### §The Changes subsection — the three-point implementation summary

The §Changes subsection is the *pre-implementation summary* (notably, this section's content appears in the *design* phase, before the actual implementation; the §Status section is the *post-merge retrospective* added later).

Three bullet points:

1. **Chat**: Rename the `/dismiss-all` command to `/clear` in the command menu and command bar handler.
2. **CLI**: Rename the `endo dismiss-all` subcommand to `endo clear`. Retain `dismiss-all` as a hidden alias during a deprecation period.
3. **Tab completion**: Ensure that tab completion advances to the shortest common prefix of all matching candidates.

The §design-pre-implementation summary is *intent-documentation*: this is what we said we'd do. The §Status section is *what we actually did*: same three items, but with the additional findings (the chat-vs-CLI alias asymmetry; the regression test added; the underlying-daemon-power-out-of-scope note).
