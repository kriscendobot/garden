I built the remaining unbuilt part of the `daemon-git-capability` design: a Fae agent can now be given a git workspace as a capability. It's in draft PR **endojs/endo-but-for-bots#1589**, based on the frozen `llm-9a14ddf`. CI lint passed; the full test matrix was still running when I stopped watching.

**Why this slice.** Phase 7 of the design (structured results) is already covered by draft PRs #1565 and #1568–#1572, and the capability-URL remotes work is in #1557. That left Phase 6: a `provisionWorkspaceTools` adapter existed in `@endo/agent-tools` (from #707), but no agent used it. Fae could only reach git through the `setup-fs-tools` caplets, which run unconfined at a host directory (`FAE_CWD`). This PR connects a granted `Git` to a real agent end to end. The job was posted because the `plan/README.md` row for this design is stale ("Proposed").

**What changed** (in `packages/fae`, plus design docs)
- **Factory option:** `createAgent(name, { workspace: { git, remote? } })` takes the pet names of a `Git`, and optionally a `GitRemote`, held in the factory's store.
- **Driver wiring:** `provisionFaeAgent` stores them in the agent driver's namespace as `workspace-git` and `workspace-remote`, the same way it stores `subagent-spawner`.
  - The spawner never gets them, so subagents don't inherit the workspace.
  - A remote without a `Git` is refused.
- **Tools:** the driver passes the grant to `spawnWorkerLoop`, which adds the agent-tools file, git and remote tools as built-in tools. The adapter is the new `src/workspace-tools.js`. A tool name that would shadow an existing built-in stops the agent at start.
- **The tool set follows the grant:**
  - A read-only `Git` gets only reader git tools and read-only file tools.
  - History rewrite is never offered.
  - Commits carry the identity fixed when the `Git` was created, not one the model picks.
- **Docs:** a Fae README section, the `createAgent` help text, a changeset (`@endo/fae` minor), and Phase 6 ticked off in `designs/daemon-git-capability.md` with a progress note.
- **Dependencies:** `@endo/agent-tools` added, plus `@endo/git` and `@endo/exo-git` as dev dependencies. The lockfile change is in its own `chore: Update yarn.lock` commit.

**Testing**
- **Unit tests against a real repository** (same mount, backend and exo that `provideGit` builds): a writable `Git` can edit, stage and commit, and the commit has the formula's identity; a read-only `Git` gets no write tools; a remote adds fetch, pull and push.
- **Inbox loop:** a scripted model drives write → `add` → `commit` through `spawnWorkerLoop`, and the commit shows up in `git log`. An agent with no grant is offered no file or git tools.
- **Driver wiring:** the locators reach only the driver, and a remote on its own is refused.
- **Mutation check:** forcing the writable check to always return true makes the read-only test fail.
- **Results:**
  - Fae suite: 239 passed, plus the 2 failures the suite already marks as expected.
  - Garden pre-push gates and the repo-root `tsc`: pass.
  - Fae's package-level `tsc` reports errors, but they are all in code this PR doesn't touch.
- **On CI:** lint, build, sandbox-drivers and several other jobs passed. The `test` and `cover` jobs (Node 22/24, Ubuntu and macOS), `test-xs` and `test-thixotrope-ironhorse` were still pending when I stopped watching. The gauntlet will follow them.
- **Not covered:** a driver-level test with a workspace present. The existing driver test only exercises the subscription path.

**Follow-ups**
- Lal/Genie registration over `Git` and deprecating the `FAE_CWD` path caplets are still open (Phase 6).
- `plan/README.md` still lists `daemon-git-capability` as "Proposed", which is why this job was posted. It should read In Progress.
- The gauntlet (clean → panel → fix-loop → un-draft) should stage automatically from this completion.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-daemon-git-capability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 152 tokens (9615580 cached reads)
- Output: 43354 tokens
- Cost: $4.170795999999999
- Wall-clock: 4142s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
