---
slug: daemon-agent-tools
repository: endo-but-for-bots
status: In Progress
size: L
milestone: M3
depends_on: [endo-posix-sandbox]
created: 2026-03-02
updated: 2026-10-31
source: imported from origin/llm designs/README.md
---

# Daemon Agent Tools (Claw-like Capabilities)

| | |
|---|---|
| **Created** | 2026-03-02 |
| **Updated** | 2026-10-31 |
| **Author** | Kris Kowal (prompted) |
| **Status** | In Progress |

## Implementation status (reconciled 2026-10-31)

This record was imported from the 2026-03-02 sketch and had never been
advanced. The authoritative design is now `designs/daemon-agent-tools.md`
on `llm` (rewritten by #611 on 2026-07-09, last updated 2026-10-06), and
its pending re-sweep, design PR
[#1497](https://github.com/endojs/endo-but-for-bots/pull/1497), adds
§ Next Slice and Phases 7–8. The phase numbering below follows that
design. The sketch's *Phased implementation* section at the end of this
record is kept for history only. Do not dispatch from it.

### Landed on `llm` (do not re-dispatch)

| Phase | Deliverable | PR(s) |
|---|---|---|
| 0 | Substrate: `EndoMount`, local `Git` over the mount, `GitRemote` + askpass, `Git.filesystemAt`, `@endo/agent-tools` `ToolRecord` + code-mode renderer | #364, #371, #367, #365, #368, #408, #523, #524 |
| 1 | File tools `list` / `edit` / `stat` (`makeMountFsTools`); mount search tools | #614; #681, #986 |
| 2a / 2b | `Shell` capability (`provideShell`, host-spawner engine) + `makeShellTool` | #615 |
| 3 | Push tier `makeGitRemoteTool`, `push({ forceWithLease })` | #705 |
| 3.5 | Mount-bridged local git tools (`status`, `add`, `checkoutConflict`) | #616 |
| 3.6 | `makeHttpTool` + daemon `provideHttpClient`; `@endo/fetch` plugin | #661; #723 |
| 4 | Workspace provisioning (`makeWorkspaceTools` / `provisionWorkspaceTools`) + the worked edit → build → commit → push → `filesystemAt` loop | #707 |
| 5 / 6 | `commit({ amend })`, `reword`, `cherryPick`, rebase controls, `checkoutConflict` (agentry eval lane) | landed per the `llm` design; contract-test item still open (below) |
| — | MCP-adapter projection of the tool surface | #1336 |

The sketch's original Phase 4, *dynamic tool discovery* by probing the
petstore for `fs` / `shell` / `git`, is **intentionally not built**. The
landed model takes explicit grants (`provisionWorkspaceTools`; #1348's
`defineWorkspaceAgent` "without reviving dynamic capability discovery").
The JSON `ToolRecord` wrappers are parked behind code mode (#731, scoped
by #733). Only the reviewed tail (#705, #707, #950) is grandfathered.

### In flight (open PRs, as of 2026-10-31)

| Phase | PR | State | Note |
|---|---|---|---|
| design | [#1497](https://github.com/endojs/endo-but-for-bots/pull/1497) re-sweep: § Next Slice, Phases 7–8, OQ 4–6 | ready, unmerged | gauntlet completed and un-drafted 2026-10-19; needs a maintainer merge |
| 2c | [#1504](https://github.com/endojs/endo-but-for-bots/pull/1504) sandbox engine for `Shell` (`makeSandboxSpawner`, `ShellPolicy.engine`) | draft, CI green, mergeable | gauntlet halted 2026-10-19 on a panel **review-submission permission error**, not a verdict; bwrap fixes split out as [#1591](https://github.com/endojs/endo-but-for-bots/pull/1591) (draft) and [#1542](https://github.com/endojs/endo-but-for-bots/pull/1542) |
| 7 | [#1544](https://github.com/endojs/endo-but-for-bots/pull/1544) endo-claude sandboxed acceptance loop | draft, CI green | stacked on #1504 (pinned `17c61dd8e4`); **canonical** Phase 7 PR |
| 7 (dup) | [#1547](https://github.com/endojs/endo-but-for-bots/pull/1547) | draft, CI red | duplicate of #1544 (viability = overtaken, 2026-10-24); close it |
| 8b | [#1593](https://github.com/endojs/endo-but-for-bots/pull/1593) `http` group in `makeWorkspaceTools` | draft, CI green | gauntlet halted 2026-10-31 after panel round 1 (must-fix); the open item is the cross-maker tool-name collision (`fetch`: HTTP vs `GitRemote`; `inspect`: Shell vs `GitRemote`) |
| 8a | [#1588](https://github.com/endojs/endo-but-for-bots/pull/1588) `@endo/fetch` / `@endo/confined-fetch` split | draft, CI green | advances the plugin side of Open Question 4; gauntlet halted 2026-10-31 |
| 4 consumer | [#1348](https://github.com/endojs/endo-but-for-bots/pull/1348) explicit-grant `defineWorkspaceAgent` harness | ready, **CHANGES_REQUESTED**, idle since 2026-10-05 | already qualifies composed names as `inspectShell` / `inspectGitRemote`, which overlaps #1593's collision question |
| 4 consumer | [#1589](https://github.com/endojs/endo-but-for-bots/pull/1589) lal / fae on one `@endo/agent-tools` catalog over daemon `Git` | draft | `daemon-git-capability` Phase 6; gauntlet halted after 3 panel rounds |
| tail | [#950](https://github.com/endojs/endo-but-for-bots/pull/950) package-manager facet projection; [#1017](https://github.com/endojs/endo-but-for-bots/pull/1017) result presentation policy | draft, idle since Aug/Sep | #950 is #731-grandfathered |

### Remaining unblocked integration work

In order. None of these duplicates a landed phase.

1. **Merge the design re-sweep #1497** (maintainer). It is the only
   record of Phases 2c, 7, and 8 on `llm`. Until it lands, the `llm`
   design still lists 3.6 and 4 as open.
2. **Land Phase 2c.** Land #1591 (and #1542) first, then re-run #1504's
   panel on a host whose token can post reviews, and un-draft it. This
   is the gate for Phase 7: a host-engine `Shell` granted to a confined
   guest escapes its OS slice.
3. **Close #1547** as a duplicate of #1544 (maintainer).
4. **Settle one workspace-catalog naming rule** for colliding tool names
   across makers. #1348 qualifies them (`inspectShell`,
   `inspectGitRemote`); #1593 fails closed on `fetch` / `inspect`. Then
   finish #1593's fix round and resolve #1348's requested changes on
   the same rule.
5. **Phase 5 contract-test item.** Extend the `473b718b3` contract test
   so the exo type, `GitInterface`, `exo-git` types, and the generated
   code-mode declarations cannot drift. It is unblocked and has no PR.

Gated, not yet dispatchable:

- **Phase 7 (#1544)** waits on step 2. It also waits on a maintainer
  call on design PR [#1543](https://github.com/endojs/endo-but-for-bots/pull/1543),
  which proposes superseding `endo-claude` because `claude --bare`
  rejects subscription credentials. If #1543 lands, Phase 7's guest
  target changes and #1544 may need re-targeting rather than a merge.
- **Phase 8a, the canonical HTTP provisioning path** (daemon
  `provideHttpClient` vs the `@endo/fetch` plugin, Open Question 4), is a
  maintainer decision. #1588 advances the plugin side; removing the
  losing path follows that decision.
- **#1589** waits on its panel must-fix list.

Status stays **In Progress**. The M3 pillar is demonstrated with the host
engine (#707). What remains is the confined-guest half: Phase 2c, then
Phase 7.

## What is the Problem Being Solved?

AI coding agents like Claude Code ("Claw"), Cursor, and Devin have a
standard set of tools: read files, write files, execute shell commands,
run git operations, search codebases. These tools operate with ambient
authority — the agent has the same filesystem and process access as the
user running it.

Endo's capability model can provide these same tools with principled
confinement: an agent receives a `Dir` capability scoped to a project
directory, a `Shell` capability that can only execute approved commands,
and a `Git` capability scoped to a repository. The agent can do useful
coding work without ambient access to `~/.ssh`, `~/.aws`, or the ability
to run arbitrary network commands.

This design bridges the capability system designs
([daemon-capability-filesystem](daemon-capability-filesystem.md),
[daemon-capability-bank](daemon-capability-bank.md)) with the concrete
tools an AI agent uses for coding assistance. It defines the tool
interface that Lal and Fae register when granted these capabilities.

> **Revision note (2026-05-18):** The later
> [daemon-mount-capabilities](daemon-mount-capabilities.md),
> [daemon-git-capability](daemon-git-capability.md), and
> [daemon-git-remotes](daemon-git-remotes.md) designs refine this sketch:
> local git authority should derive from `EndoMount`, path authority should
> flow through mount-scoped descriptors, and remote git should be granted
> separately through bounded `GitRemote` capabilities rather than omitted
> from the product model.

## Design

### Tool categories

An agent with coding capabilities needs four tool groups:

| Group | Capability | Tools |
|-------|-----------|-------|
| Filesystem | `Dir` | `readFile`, `writeFile`, `listDir`, `glob`, `stat` |
| Shell | `Shell` | `exec`, `execInteractive` |
| Git | `Git` | `status`, `diff`, `log`, `add`, `commit`, `checkout`, `branch` |
| Search | `Dir` | `grep`, `glob` (reuses filesystem) |

### Filesystem tools

Backed by the `Dir` capability from
[daemon-capability-filesystem](daemon-capability-filesystem.md). The
agent receives a `Dir` rooted at the project directory and registers
tools that delegate to its methods.

```js
const registerFsTools = (tools, dir) => {
  tools.register('readFile', async ({ path }) => {
    const segments = path.split('/');
    let current = dir;
    for (const seg of segments.slice(0, -1)) {
      current = await E(current).openDir(seg);
    }
    const file = await E(current).openFile(segments.at(-1));
    return E(file).readText();
  });

  tools.register('writeFile', async ({ path, content }) => {
    // Similar navigation to parent dir, then writeText
  });

  tools.register('listDir', async ({ path }) => {
    let target = dir;
    if (path) {
      target = await E(dir).subDir(path);
    }
    return E(target).list();
  });

  tools.register('glob', async ({ pattern }) => {
    return E(dir).glob(pattern);
  });
};
```

The `Dir` capability provides structural confinement — the agent cannot
navigate above the project root, cannot access `~/.ssh` or `~/.aws`,
and cannot follow symlinks that escape the mount boundary.

### Shell capability

A `Shell` capability wraps `child_process` execution with confinement.
The host constructs the shell with an allowlist of commands and a working
directory:

```js
const shell = makeShell({
  cwd: '/home/user/project',
  allowedCommands: harden([
    'node', 'npm', 'npx', 'yarn',
    'python', 'python3', 'pip',
    'make', 'cargo', 'go',
    'grep', 'find', 'sed', 'awk',
    'curl',  // may be restricted to specific hosts
  ]),
  env: filteredEnv,  // no secrets
  timeout: 60_000,
  maxOutputBytes: 1_048_576,
});
```

The shell interface:

```ts
interface Shell {
  exec(command: string, args: string[]): Promise<{
    stdout: string;
    stderr: string;
    exitCode: number;
  }>;
  help(): string;
}
```

The `Shell` exo validates that the command is in the allowlist before
execution. Arguments are passed as an array (no shell expansion) to
prevent injection.

```js
const ShellI = M.interface('Shell', {
  exec: M.call(M.string(), M.arrayOf(M.string()))
    .returns(M.promise(M.splitRecord({
      stdout: M.string(),
      stderr: M.string(),
      exitCode: M.number(),
    }))),
  help: M.call().returns(M.string()),
});
```

### Git capability

A `Git` capability wraps git operations scoped to a repository:

```ts
interface Git {
  status(): Promise<string>;
  diff(args?: string[]): Promise<string>;
  log(args?: string[]): Promise<string>;
  add(paths: string[]): Promise<void>;
  commit(message: string): Promise<string>;
  checkout(ref: string): Promise<void>;
  branch(args?: string[]): Promise<string>;
  help(): string;
}
```

The `Git` exo executes git commands in the repository directory. It does
NOT expose:
- `git push` / `git pull` (network access is a separate capability)
- `git config` (prevents setting hooks or aliases)
- `git hook` (prevents persistence attacks)
- Raw `git` command execution (all operations are method calls with
  validated arguments)

```js
const GitI = M.interface('Git', {
  status: M.call().returns(M.promise(M.string())),
  diff: M.call().optional(M.arrayOf(M.string())).returns(M.promise(M.string())),
  log: M.call().optional(M.arrayOf(M.string())).returns(M.promise(M.string())),
  add: M.call(M.arrayOf(M.string())).returns(M.promise(M.undefined())),
  commit: M.call(M.string()).returns(M.promise(M.string())),
  checkout: M.call(M.string()).returns(M.promise(M.undefined())),
  branch: M.call().optional(M.arrayOf(M.string())).returns(M.promise(M.string())),
  help: M.call().returns(M.string()),
});
```

### Capability granting

The host grants coding capabilities to an agent via the existing
pet-name mechanism:

```bash
# Grant project directory access
endo grant fae fs /home/user/project

# Grant shell access with defaults
endo grant fae shell /home/user/project

# Grant git access
endo grant fae git /home/user/project
```

Or programmatically in a setup module:

```js
const dir = await E(powers).makeDir('/home/user/project');
const shell = await E(powers).makeShell({
  cwd: '/home/user/project',
});
const git = await E(powers).makeGit('/home/user/project');

await E(powers).grant('fae', 'fs', dir);
await E(powers).grant('fae', 'shell', shell);
await E(powers).grant('fae', 'git', git);
```

### Agent tool discovery

When an agent (Lal or Fae) starts, it checks its namespace for known
capability names and dynamically registers tools:

```js
const setup = async (powers) => {
  const tools = makeToolRegistry();

  // Always available: messaging tools
  registerMessageTools(tools, powers);

  // Conditionally available: coding tools
  try {
    const dir = await E(powers).lookup('fs');
    registerFsTools(tools, dir);
  } catch {
    // No filesystem capability granted — skip
  }

  try {
    const shell = await E(powers).lookup('shell');
    registerShellTools(tools, shell);
  } catch {
    // No shell capability granted — skip
  }

  try {
    const git = await E(powers).lookup('git');
    registerGitTools(tools, git);
  } catch {
    // No git capability granted — skip
  }

  return tools;
};
```

This means an agent's tool set is determined by the capabilities
granted to it. An agent with only `fs` can read and write files but
cannot execute commands. An agent with `fs` + `git` but no `shell` can
do file operations and git operations but cannot run arbitrary processes.

### Form-based capability provisioning

Building on [lal-fae-form-provisioning](lal-fae-form-provisioning.md),
the manager agent can include capability grants in its provisioning form:

```js
await E(powers).form('@host', 'Configure agent workspace', [
  { name: 'name', label: 'Agent name' },
  { name: 'host', label: 'API host', example: 'https://api.anthropic.com' },
  { name: 'model', label: 'Model name', example: 'claude-sonnet-4-6-20250514' },
  { name: 'authToken', label: 'API auth token' },
  { name: 'projectPath', label: 'Project directory', example: '/home/user/project' },
  { name: 'capabilities', label: 'Capabilities', example: 'fs,shell,git' },
]);
```

When the form is submitted, the manager creates the appropriate
capabilities and grants them to the new worker agent.

## Dependencies

| Design | Relationship |
|--------|-------------|
| [daemon-capability-filesystem](daemon-capability-filesystem.md) | Provides `Dir` and `File` capabilities |
| [daemon-capability-bank](daemon-capability-bank.md) | Framework for capability categories |
| [lal-fae-form-provisioning](lal-fae-form-provisioning.md) | Manager/worker architecture for agent setup |
| [daemon-os-sandbox-plugin](daemon-os-sandbox-plugin.md) | OS-level process confinement for `Shell` |

## Phased implementation

> **Historical (2026-03 sketch).** Superseded by § Implementation status
> above. Phases 1–3 and the provisioning half of Phase 4 have landed;
> dynamic discovery was dropped in favor of explicit grants.

### Phase 1: Filesystem tools (depends on daemon-capability-filesystem)

Implement `Dir`-backed filesystem tools in Lal/Fae. The `Dir` capability
from the filesystem design provides the foundation. This alone gives
agents useful file browsing and editing capabilities.

### Phase 2: Shell capability

Implement the `Shell` exo with command allowlist. This can start simple
(hardcoded allowlist) and evolve to configurable allowlists. The OS
sandbox plugin design can later provide true process isolation.

### Phase 3: Git capability

Implement the `Git` exo. This is largely a wrapper around `child_process`
git commands with argument validation and method-level guards.

### Phase 4: Integration and discovery

Wire up dynamic tool discovery so agents automatically register tools
based on granted capabilities. Update the form-based provisioning to
include capability configuration.

## Design Decisions

1. **Capabilities, not configurations.** The agent receives a `Dir`
   object, not a "filesystem access descriptor." It cannot name paths
   outside the `Dir`'s root because no method returns a reference to
   them.

2. **Dynamic tool registration.** Agents discover capabilities at
   startup by looking up known names in their namespace. This means
   the same agent code works with or without coding capabilities —
   it simply has fewer tools available.

3. **Git split by authority.** The local `Git` capability deliberately
   excludes network operations. Fetch / pull / push belong on separately
   granted remote-git capabilities so product workflows can exist without
   smuggling network and credential authority into local repository access.

4. **Shell is array-based.** Commands are passed as `(command, args[])`
   tuples, never as shell strings. This prevents shell injection and
   makes the allowlist enforceable.

5. **Phased approach.** Filesystem tools are the most immediately useful
   and have the fewest security concerns (structural confinement via
   `Dir`). Shell and git capabilities are progressively harder to
   confine safely.

## Related Designs

- [daemon-capability-filesystem](daemon-capability-filesystem.md) —
  `Dir` and `File` capabilities used by filesystem tools.
- [daemon-capability-bank](daemon-capability-bank.md) — capability
  framework and category taxonomy.
- [daemon-mount-capabilities](daemon-mount-capabilities.md) — concrete
  completion plan for the live mount capability this sketch now builds on.
- [daemon-git-capability](daemon-git-capability.md) — revised local git
  design over `EndoMount`.
- [daemon-git-remotes](daemon-git-remotes.md) — companion remote-git
  design for fetch, pull, push, and credentialed endpoints.
- [daemon-os-sandbox-plugin](daemon-os-sandbox-plugin.md) — OS-level
  process confinement for shell execution.
- [lal-fae-form-provisioning](lal-fae-form-provisioning.md) — form-based
  agent setup that can include capability grants.
