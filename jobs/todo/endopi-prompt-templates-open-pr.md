---
posted_at: 2026-11-02T17:28:39Z
role: builder
arc: moonshots
requires: host=endolin-garden-ece02cb4
dispatch: automatic
tier: mentor
fallback-tier: minion
---
# Open the draft PR for the endopi prompt-templates build

Repo: https://github.com/endojs/endo-but-for-bots. Relay from job `endopi-prompt-templates-build` on oros-studio-garden-ce242c49, whose bot PAT gets 403 on createPullRequest for endojs.

The head `endopi-prompt-templates` (be54e6b8332202bf4af372c4b1cd4f1bd264e07d) and the frozen base `llm-48d6f3e` (48d6f3e08bcc37fdd4c0dc8b85d1481ca861320c) are ALREADY pushed. Do not modify the branch. Your only task is to open the DRAFT PR, from a project checkout (ensure-pr.sh's phase-evidence gate resolves `designs/*.md` from its cwd), by saving the body below to a file and running:

    /Users/dom/garden/scripts/jobs/gardening/ensure-pr.sh endopi-prompt-templates-build endojs/endo-but-for-bots endopi-prompt-templates llm-48d6f3e --title "feat(prompt-templates): markdown prompt templates in the Chat command bar (endopi-prompt-templates)" --body-file <file>

Report the PR URL. If ensure-pr.sh finds an existing PR (marker `garden-job: endopi-prompt-templates-build`), adopt it. Completion stages the gauntlet as for any builder PR.

PR body (between the BODY markers, verbatim):

----- BODY -----
Refs: endopi-prompt-templates design (`designs/endopi-prompt-templates.md`)

## Description

Adds reusable prompt templates to the Chat command bar. A markdown file such as `~/.pi/agent/prompts/review.md` appears in the `/` menu as `/review`. Selecting it fills the editor with the template's text; nothing reaches an agent until the user presses Enter.

`{{name}}` placeholders take positional arguments from the slash line, so `/review "memory safety"` expands directly. If arguments are missing, the chat bar's inline command form asks for them. Too many arguments shows an error and keeps the line for correction.

Three parts to review, most critical first:

- **`packages/spaces-util/src/chat-bar-component.js`**: the invocation flow. In the `/` menu, Space now completes a template's name and begins its arguments, where a built-in command's selection is still confirmed by Space. Built-in behavior should be unchanged.
- **`packages/spaces-util/src/prompt-template-catalog.js`**: reads the templates from the daemon and presents them as commands. The catalog rereads each time `/` opens the menu, so an edited file needs no reload command.
- **`packages/prompt-templates`** (new): parser, single-pass substitution, shell-style argument splitting, and discovery. `parse.js`, `substitute.js`, and `load.js` run in the browser; `node.js` holds the directory walk.

`packages/chat/setup-prompt-templates.js` connects the disk to the browser, which cannot read it: it finds the conventional directories and mounts each one that exists, read-only, under the pet name `prompt-templates`. An agent without that name sees no change.

<!-- garden-phase-evidence-ledger:v1 -->
## Phase and evidence ledger

Design: `designs/endopi-prompt-templates.md`
Design: `designs/README.md`
Disposition: deliverable
Phase 1: satisfied | loader and discovery in `packages/prompt-templates` at 37a2ec035, tested against real files
Phase 2: satisfied | templates listed in the `/` menu and command popover at 37a2ec035, tested in `packages/chat/test/component/chat-bar.test.js`
Phase 3: satisfied | substitution, positional arguments, and the form for missing variables at 37a2ec035, tested in the same file
Acceptance: satisfied | the design names no acceptance evidence beyond its phases; the setup script and catalog ran against a real isolated daemon, as Testing Considerations records, and a real browser was not exercised
<!-- /garden-phase-evidence-ledger -->

### Departures from the design

The design's implementation notes record these:

- **The variable form is the chat bar's inline command form**, not the form from `lal-fae-form-provisioning`, which renders a form request delivered as a message. An editor expansion has no message or recipient.
- **The walker is not shared with skills.** `endopi-skills-markdown-format` is not built yet, so this package owns the scan for now.
- **Pi's `$1` and `$@` are not substituted.** The design specifies `{{name}}`, so a template written for Pi expands with those placeholders intact.

The design's composition section needs no code here: a `/skill:gh-cli` reference in a body passes through literally, and a test pins that. Processing it on submit depends on the unbuilt skills design.

### Security Considerations

A template comes from a file, possibly a project's, so its text is untrusted. These limits apply:

- Chat gains access only through mounts the user creates by running the setup script. It holds no new filesystem authority, and the mounts are read-only (`Mount is read-only` is enforced by `assertWritable` in the daemon).
- Expansion never sends. The user sees the text first and decides. Text renders through `textContent` and Preact text nodes, so markup in a template stays literal, and a written `@name` is plain text rather than a capability token.
- A template cannot take a built-in command's name or alias, so a project file cannot redefine `/clear` or `/help`. It is skipped with a console warning.
- The walk stops at the repository root and at the home directory. Outside a repository only the working directory counts, so a stray `/tmp/.agents/prompts` is not picked up.

One limit remains: a long template can hide text the user does not scroll to before pressing Enter. Project templates carry this risk in Pi as well, where they load only after the user grants project trust. Here, the equivalent step is choosing to run the setup script against a project.

### Scaling Considerations

Opening the `/` menu lists each mount and reads each template over CapTP. Prompt directories are small and non-recursive. A file over 1 MiB is skipped with a warning. An older reload that finishes late is discarded.

### Documentation Considerations

`packages/prompt-templates/README.md` covers authoring, directories, and Chat setup. The design moves to **In Progress** with implementation notes, and `designs/README.md` reflects the status. `/help` does not list templates; they appear in the `/` menu and the command popover.

### Testing Considerations

- `@endo/prompt-templates`: 32 tests, including discovery against real files for directory order and repository bounds.
- `@endo/chat`: catalog unit tests plus chat-bar component tests for the menu, Space completion, direct expansion, the form path, too many arguments, built-in protection, and the popover. Each expansion test asserts that no message was sent.
- Each of the changes below made a test fail when reverted: the `hasOwn` guard, override order, walk order, the outside-a-repository rule, CRLF handling, the reserved-name filter, the stale-reload guard, source sorting, slash-line filtering, expansion routing, and the too-many-arguments check.
- Against a real isolated daemon, `setup-prompt-templates.js` granted four directories and the catalog read them through real mounts, with project-over-global precedence and `clear.md` skipped.
- `yarn lint:types` and `yarn build` pass in `packages/chat`; the 453 chat tests run (units plus the chat-bar, command-selector, inline-form, and help-modal component tests) pass.

**Not exercised:** a real browser. The component tests run under happy-dom, so caret placement and multi-line display in the contenteditable editor have not been confirmed in one.

### Compatibility Considerations

Additive. `filterCommands`, `commandSelectorComponent`, and `createInlineCommandForm` each gain an optional parameter. Someone with a template in place sees only the `/` menu differ.

### Upgrade Considerations

None. Run `yarn setup-prompt-templates` in `packages/chat` to opt in.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
----- END BODY -----
