---
handed-off: endopi-prompt-templates-open-pr
deliverable-complete: false
---
The prompt-templates implementation is finished and pushed, but the draft PR isn't open yet. This host's bot token gets a 403 on `createPullRequest` for endojs, the known permission gap. I handed PR-opening to `endopi-prompt-templates-open-pr`, pinned to `endolin-garden-ece02cb4`, with the PR body embedded.

## Branches
- **Head:** `endopi-prompt-templates` at `be54e6b83`, on endojs/endo-but-for-bots, with `yarn.lock` in its own commit.
- **Base:** frozen `llm-48d6f3e`, which is the current tip of `llm`.

## What changed
All three design phases are built:
- **New package `@endo/prompt-templates`:**
  - parsing, with optional `description` frontmatter
  - single-pass `{{name}}` substitution
  - shell-style argument splitting
  - directory discovery with override order
- **Chat bar (`@endo/spaces-util`):**
  - Templates appear in the `/` menu and the command popover, and are reread each time `/` opens the menu.
  - Selecting a template fills the editor and never sends anything.
  - Arguments on the slash line fill the variables, the inline form asks for any that are missing, and too many arguments shows an error.
  - A template can't take a built-in command's name or alias.
- **Chat setup (`packages/chat/setup-prompt-templates.js`):** the browser can't read the disk, so this script mounts each existing template directory read-only under the pet name `prompt-templates`.
- **Docs:** added a README and a changeset, and moved the design to In Progress with implementation notes.

## Departures from the design
These are recorded in the design notes and the PR body:
- The variable form is the chat bar's inline command form, not the `lal-fae-form-provisioning` form, because that one renders a form request delivered as a message.
- The directory walker isn't shared with skills yet, because the skills design isn't built.
- Pi's `$1` and `$@` are left as literal text, because the design specifies `{{name}}`.
- Space in the `/` menu now completes a template's name and starts its arguments. Built-in commands still confirm on Space.

## Verification
- **Tests:** all 32 `@endo/prompt-templates` tests pass. So do 453 `@endo/chat` tests: the unit suite plus the chat-bar, command-selector, inline-form and help-modal component tests. I did not run the rest of the chat component suite.
- **Static checks:** `lint:types` and `yarn build` pass in `packages/chat`, and the pre-push probes pass.
- **Test strength:** I broke the code in 12 places. Tests caught 11; the 12th, dropping the extra commands from the selector's initial `show()`, went undetected because the post-refresh filter adds them anyway.
- **Real daemon:** on an isolated daemon, the setup script granted four directories. The catalog read them through real mounts, applied project-over-global precedence, and skipped `clear.md`.
- **Not tested:**
  - A real browser: component tests run under happy-dom, so caret placement and multi-line display in the editor are unconfirmed.
  - CI hasn't run, since there's no PR yet.
  - Write rejection on read-only mounts: I confirmed it by reading `assertWritable` in the daemon, not by running it.

## Follow-ups
- Endolin jobs can sit unclaimed for an hour or more if that host is over its cap. If this one stalls, it needs a maintainer nudge.
- Completing the successor job names the PR, which stages the gauntlet as usual.
- `/help` doesn't list templates.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endopi-prompt-templates-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (5515175 cached reads)
- Output: 77740 tokens
- Cost: $4.391354999999999
- Wall-clock: 3425s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
