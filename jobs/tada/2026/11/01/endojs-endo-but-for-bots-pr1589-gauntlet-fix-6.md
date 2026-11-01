Fix round 6 for PR #1589 is pushed as head `5df1895992`, and CI is green: all 36 checks pass. One check failed at first on the known `packages/sandbox` bwrap flake, and a single rerun of that job passed.

There was no pre-pass block, so I worked from panel review 5725698701. I pushed three follow-up commits with `safe-push-pr-head.sh` (a fast-forward from `6bdb495dee`).

**What changed**
- **Authority (locksmith, wire-watcher):** Fae's `createAgent` and Lal's form now look up workspace names only in a `workspaces` directory of the factory or manager store. The deployer fills that directory. A requester can no longer name `host-agent`, the provider, or anything else in the store, and a test shows `host-agent` is refused.
- **Check before creating anything (saboteur, engine-realist):**
  - Fae now sets up the workspace tools before it creates any guest, driver or pin.
  - Lal now does it before it creates the worker or replies that the agent "is now running".
  - `provisionGitWorkspaceTools` now refuses a capability that is not a Git.
  - New tests cover a non-Git grant and a read-only Git paired with a remote, and confirm nothing is left behind.
- **Types (typist, curator, integrator):** Fae and Lal now share one `GitWorkspaceGrant` type from `@endo/agent-tools`, with `git` typed as a Git (`ERef<EndoGit>`). The duplicate local typedefs and the `any` casts are gone.
- **Public surface (surfacer):** I removed Lal's `./workspace-tools.js` export, which had no type declarations and no users. The agent-tools README now lists the workspace setup functions among its exports.
- **Changesets (migrator, changeset-auditor):** the three changesets are now one, `git-workspace-grants.md`, with `@endo/fae` as a **major** bump because `setup-fs-tools` and `FAE_CWD` are removed. I also rewrote `fae-search-tools.md` to match.
- **Design doc (integrator):** `designs/daemon-git-capability.md` now says a read-only Git leaves out the mutation methods instead of throwing at runtime. Phases 0–5 are ticked, and the Phase 6 notes are updated.
- **Smaller items:**
  - New error messages use `Fail`/`q` (purist).
  - `workerP` is now `workerPromise` and the test helper's `id` is `toolCallIdentifier` (stylist).
  - The Git test fixture accepts a `GIT_EXECUTABLE` setting (transplanter).
  - The PR body now explains why Lal's XS test stays `exit 0` (coverage-auditor).
- **Summary comment (scribe):** posted at https://github.com/endojs/endo-but-for-bots/pull/1589#issuecomment-6551554877, listing each fix and each decline.

**Declined, with reasons given on the PR**
- **Renaming `maxChars` to `maxCharacters`:** that spelling is the existing option name, and renaming only the new pass-through would leave two spellings.
- **Proving a remote belongs to the same repository as the Git (purist):** this needs a combined workspace capability minted by the daemon, which is out of scope here.
- **Converting the Fae architecture diagrams to Mermaid:** a separate documentation change.
- **Replacing the Fae and Lal tool adapters with code mode (decomplector):** this is a direction call for the maintainer, not a fix-loop change. Phase 6 of the design asks for these adapters, while `daemon-git-next-steps.md` says new capability exposure should use code mode. I flagged it on the PR, and the next panel may raise it again.

**Local checks:**
- **Passed:**
  - agent-tools workspace and export tests: 12 passed.
  - Lal workspace tests: 6 passed.
  - Fae subagent-loop, workspace-tools and subagent-host tests: 48 passed.
  - `lint:types` is clean for lal and agent-tools.
  - eslint shows no errors.
- **Failed, in code this PR doesn't touch:**
  - The full agent-tools run failed one `git-flow` cherry-pick test.
  - The full Lal run failed one daemon cold-restart test.
  - The equivalent CI legs passed.

**Follow-ups:**
- The maintainer needs to decide whether to keep the JSON-catalog adapters or move them to code mode.
- The bwrap reaping flake in `packages/sandbox` keeps reddening CI. PR #1591 targets it.
- The driver should post panel-7 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1589-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 154 tokens (9589252 cached reads)
- Output: 42164 tokens
- Cost: $4.030562399999999
- Wall-clock: 5805s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
