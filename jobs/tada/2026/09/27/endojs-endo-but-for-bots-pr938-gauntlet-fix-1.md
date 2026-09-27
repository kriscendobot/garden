**Fix round 1 for endojs/endo-but-for-bots PR #938 is pushed and CI is green.** `ci-wait-merge.sh --no-merge` returned rc 0: 5 of 5 checks passed on the new head `430d7297f5`.

**What the panel asked for.** All seven seats returned request-changes (the panel's comment-type review from 2026-09-04). Before editing, I checked each must-fix claim against the code, and each one held up.

**What changed.** One follow-up commit went onto `design/endo-reminder-familiar-integration` (2046c511 → 430d7297, pushed with `safe-push-pr-head.sh`).

In `designs/endo-reminder-familiar-integration.md`:
- **Must-fix items:**
  - **Wake path:** the reminder adapter now runs as its own limited-access guest identity, `profile-for-reminder`, and sends to the LAL agent by a pet name. The old design sent to `@self` from the agent's own identity, which `inbox-loop.js:118` silently drops as the agent's own outgoing mail. The powers-guest choice is now Decision 4 instead of an open question.
  - **Plugin loading:** `makeUnconfined` now gets a full URL, because the worker prefixes `file://` and a bare `'@endo/reminder'` fails to import. The URL points at a new one-line re-export file, `packages/lal/reminder-plugin.js`. The design now adds that file as an eighth Familiar bundle entry point and an eighth line in `expectedArtifacts`, which corrects the old "no Familiar source change" claim.
  - **Existing installs:** `setup.js` returns early when LAL is already set up. The reminder setup now sits above that early return, with each step checked separately, so existing installs still get it (Decision 2).
  - **Formatting:** the doc now has one sentence per line and no em-dashes.
- **Should-fix items:**
  - **Tools:** the agent tools are now `makeReminder`, `listReminders` and `cancelReminder`, because `list` is already taken. Cancelling goes through a table the adapter keeps from reminder id to reminder handle. The design also specifies the fired-message text and the `listReminders` output fields, and registers the new how-to in the primer.
  - **Behavior details:** `env` is documented as a first-boot seed that the stored config overrides afterwards. The doc also records the store's `list()`/`snapshot()` requirements, notes that the raw daemon mount candidate fails them, and describes what happens when a delivery fails.
  - **Readability:** I added a worked example, a short explanation of formulas and the LAL agent's parts, labels for integration points IP1–IP6, and a Prompt section. Headings are title case, the design decision 10 quote is now verbatim, sibling designs are cited as `.md` files, and the garden-internal wording is gone.

In `designs/README.md`, the design now has a summary-table row, a dependency-graph node and edge, and strategic, size and milestone (M3) rows.

Prettier passes on both files. I did not render the Mermaid diagram, because no Mermaid tool is installed.

**Follow-ups:** none from this stage. The driver re-runs the panel next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr938-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 6 on 2 host(s)
- Input: 90 tokens (3872773 cached reads)
- Output: 33316 tokens
- Cost: $4.6351692
- Wall-clock: 1103s
- Model(s): claude-opus-4-8 ×5, claude-opus-5-5 ×1

<!-- garden-usage-end -->
