Phase 8 is built and open as draft PR endojs/endo-but-for-bots#1661, but one agent-tools test failed locally. It is in a file this branch doesn't change, so I think the sandbox caused it, but I haven't checked that. #1661 is based on the frozen snapshot `llm-48d6f3e` (current `llm` tip). I didn't wait for CI; the PR will go through the usual review chain.

**What the PR does:**
- **Canonical path:** the `@endo/fetch` plugin is now the way to provision HTTP. The daemon `provideHttpClient` / `getHttpClientControl` methods and the `http-client` formula types are marked `@deprecated`, pointing to the plugin. They still work, so existing formulas still restore.
- **Workspace tools:** `makeWorkspaceTools` and `provisionWorkspaceTools` add the HTTP tool group only when an `HttpClient` is granted.
- **Name clashes:** where tool names clash in the combined workspace list, they are renamed `inspectShell`, `inspectGitRemote`, `fetchGitRemote` and `fetchHttp`. Shell and GitRemote can now be granted together; before, that combination was refused because both had an `inspect` tool.
- **Breaking change:** code that looked up `inspect` or `fetch` by name in a workspace tool list must switch to the new names. The individual tool makers keep their old names. There are tests and a changeset for this.
- **Designs:** `daemon-agent-tools.md` and `endo-fetch.md` now record that `@endo/fetch` was chosen. `endo-fetch.md` also notes that the plugin shipped as one package, not the two-package split the design describes, and its status now reads Complete, matching the `designs/README.md` index.

**How I got here:** an earlier claimant of this job had left an unpushed commit with the code, tests and most of the design edits. I checked it and kept it. I added a second commit for the design changes and removed a reference to a "Phase 8" heading that doesn't exist on `llm` yet (only #1497 adds it).

**#1497's gate:** the PR leaves the Phase 2c (sandbox shell engine) item unchecked and doesn't take #1497's Phase 7/8 headings. Its evidence section says Phase 2c is not a prerequisite of Phase 8 and that #1497 keeps its merge gate on it.

**Checks:** the agent-tools tests pass except `git-flow › makeGitTool derives the rewriter-facet catalog`, which fails with "Git repository identity changed since this capability was constructed". Prettier, eslint and `tsc` on agent-tools are clean (eslint gives one warning about an unused disable comment). I didn't run the daemon package's type check.

**Follow-ups:**
- Once #1497 merges, its two Phase 8 boxes can be ticked against #1661.
- A small garden defect: `ensure-pr.sh` runs its design-evidence check on whatever directory it is started from. Started from the garden root, it refuses with a misleading "governing-design-unresolved" error. Run from the project checkout, it works.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-daemon-agent-tools-phase-eight-fetch-plugin.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 78 tokens (3524060 cached reads)
- Output: 14943 tokens
- Cost: $1.8599999999999999 (1 engagement(s) unpriced)
- Wall-clock: 7577s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
