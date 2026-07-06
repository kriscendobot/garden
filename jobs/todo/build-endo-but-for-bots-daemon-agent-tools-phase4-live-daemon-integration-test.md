---
role: builder
---

Builder job on `endojs/endo-but-for-bots` PR #618 (draft, daemon-agent-tools Phase 4): write and run the live-daemon end-to-end integration test the Phase 4 report flagged as the un-draft blocker — provision a guest via the form (projectPath + capabilities), assert the manager mints a writable project mount and grants fs/git/shell under the canonical pet names, then confirm the guest's startup `discoverCapabilityTools` registers the backing tools; land it as a follow-up commit on the `builder/daemon-agent-tools-phase4-integration` branch so the stack is verified before un-drafting.
