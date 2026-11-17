I reviewed the three EndoPi designs against `llm` and the two open PRs, wrote up the remaining gaps, and opened it as draft design PR endojs/endo-but-for-bots#1675 (`design/endopi-extension-manifest-prereqs`, based on the pinned snapshot `llm-0368767`). It changes design docs only; nothing was built or tested.

**What changed:** I added a "Prerequisite reconciliation (2026-11-17)" section to `designs/endopi-extension-package-manifest.md` and updated that design's date in the `designs/README.md` index.

**Where each design stands:**
- **Edit tool:** the core is already on `llm` in `@endo/agentry/edit-text` and is wired into the Fae and Lal tools. #1501 (draft) adds the last missing piece, the diff preview in Floot, and marks the design Complete.
- **Stdio RPC bridge:** #667 builds phases 1–4 in `@endo/agentry/rpc`. The `endo agent rpc` command and phase 5 (multiplexing) are still unbuilt. kriskowal's July review asked to move this code into agentry or agent-tools. It now lives in agentry, but the review still shows changes requested and needs a re-review.
- **Skills format:** nothing is built. No `SKILL.md` parser, discovery or prompt injection exists, and the daemon-side skill registry hasn't been started.

**Gaps the manifest design was assuming were closed:**
- **`endo install` does not exist.** It appears only in the CLI help grouping in `packages/cli/src/endo.js`. No command is registered and there is no guest-plugin store. The manifest design calls it "the existing `endo install` path", so phase 1 has to create the command and an install record that uninstall can read back.
- **Phase 1 would do nothing as written.** It installs skills into `~/.agents/skills/`, but nothing reads that folder yet. The section proposes either starting with the guests kind or waiting until the skills design reaches phase 2.
- **Prompts and providers have nowhere to land.** The prompt-templates design is only proposed, and the provider registry is only partly built.
- **What can be built now:** the manifest reader, source resolution, and an `install` command for the guests kind. Skills can follow once the skills design reaches phase 2. Prompts, providers, `endo config` and `endo update` wait on designs that are still only proposals.

**Follow-ups for the maintainer:**
- Both #1501 and #667 include unrelated files (action-pin workflow edits and `hardened262` test-baseline changes). These should be dropped before either merges.
- #667 needs kriskowal to re-review it.
- The extension-package-manifest design job waiting on the board should build on #1675's ordering, starting with the `endo install` command and the guests kind.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endopi-extension-package-manifest-prerequisite-check.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1320360 cached reads)
- Output: 9609 tokens
- Cost: $1.018908
- Wall-clock: 272s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
