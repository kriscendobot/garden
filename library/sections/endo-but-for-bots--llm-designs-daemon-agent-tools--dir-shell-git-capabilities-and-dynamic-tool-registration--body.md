---
title: Body
source: designs/daemon-agent-tools.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: HEAD (origin/llm, fetched 2026-06-02)
source_date: 2026-05-18
source_authors: [Kris Kowal (prompted)]
source_lines: "1-350 (full file)"
topics: [daemon, capability-security]
status: current
notes: |
  Twenty-fifth endo-but-for-bots design ingest. **Status: Not
  Started**, with a §Revision note (2026-05-18) that *names three
  later designs as refining this sketch*: `daemon-mount-capabilities`,
  `daemon-git-capability`, `daemon-git-remotes`. The 350-line
  design is the *concrete-tool-shapes* design that bridges cycle
  105's daemon-capability-bank (meta-framework) with the *Claw-like*
  AI-coding-agent tool set (read / write / shell / git / search).
  Three structurally interesting moves: (1) the *Claw* naming —
  the title parenthetical *Claude-Code-like Capabilities* surfaces
  the user-facing-tool that motivates the design; (2) the
  *capability-granting via pet-name* mechanism connects the
  abstract capability model to concrete daemon operations
  (`endo grant fae fs /home/user/project`); (3) the §dynamic
  tool-discovery pattern — *the same agent code works with or
  without coding capabilities; it simply has fewer tools
  available* — encodes capability-driven configuration without
  agent-code modification.
  
  Pairs structurally with:
  - cycle 101's `daemon-commands-as-messages` (which names this
    design as a *parallel consumer* — agent tool invocations
    become commands too via the same self-addressed-message
    mechanism, giving daemon-capability-bank a built-in
    observability surface).
  - cycle 103's `daemon-value-message` (which names *future
    capability-grant-delivery* — value messages could carry the
    grants this design's capability-granting CLI uses).
  - cycle 105's `daemon-capability-bank` (the meta-framework
    this design implements concrete tool shapes for).
  - cycle 105's six Design Principles — applied directly here
    (capabilities-not-configurations, recursive attenuation,
    LLM discoverability via help() and M.interface() guards).
  
  The §Revision note pointing to three successor designs makes
  this a *partly-superseded sketch* — not deprecated like the
  cycle 99 chat-reply-chain-visualization, but explicitly
  identified as a sketch whose details are *refined* by later
  designs. Single-section cohesion-honest ingest reflects the
  design's unified Problem → Design → Granting → Discovery →
  Implementation argument.
parent: endo-but-for-bots--llm-designs-daemon-agent-tools--dir-shell-git-capabilities-and-dynamic-tool-registration
---

### §The Claw-like agent gap-framing

The §opening lines (12-16):

> AI coding agents like Claude Code ("Claw"), Cursor, and Devin have a standard set of tools: read files, write files, execute shell commands, run git operations, search codebases. These tools operate with ambient authority — the agent has the same filesystem and process access as the user running it.

The §named-agents enumeration (Claude Code aka *Claw* + Cursor + Devin) makes the design's target concrete. The §parenthetical *Claw* naming reflects the lal *Claw* framing — lal is the local-agent-library framework; *Claw* is the LAL-on-Claude-Code variant.

The §ambient-authority observation: *the agent has the same filesystem and process access as the user running it*. This is the §threat model — anything the user can do, the LLM-controlled agent can do, including operations the user never intended (data exfiltration, credential theft, lateral movement).

The §solution framing (lines 18-23):

> Endo's capability model can provide these same tools with principled confinement: an agent receives a `Dir` capability scoped to a project directory, a `Shell` capability that can only execute approved commands, and a `Git` capability scoped to a repository. The agent can do useful coding work without ambient access to `~/.ssh`, `~/.aws`, or the ability to run arbitrary network commands.

The §three-capability-equivalents: `Dir` (filesystem), `Shell` (command execution), `Git` (version control). The §design claim: *the same coding capabilities, with capability-confined authority instead of ambient authority*.

### §The Revision note — partial supersession

The §lines 31-38:

> **Revision note (2026-05-18):** The later [daemon-mount-capabilities](daemon-mount-capabilities.md), [daemon-git-capability](daemon-git-capability.md), and [daemon-git-remotes](daemon-git-remotes.md) designs refine this sketch: local git authority should derive from `EndoMount`, path authority should flow through mount-scoped descriptors, and remote git should be granted separately through bounded `GitRemote` capabilities rather than omitted from the product model.

The §three-design refinement:

- **`daemon-mount-capabilities`** — local git authority should derive from `EndoMount`. The `Dir` capability is refined into a mount-scoped descriptor.
- **`daemon-git-capability`** — path authority should flow through mount-scoped descriptors. The `Git` capability's path semantics derive from the mount.
- **`daemon-git-remotes`** — remote git should be granted separately through bounded `GitRemote` capabilities. The original sketch *omitted* remote operations (push/pull) from the product model; the refined approach *separates* them into their own capability rather than excluding them.

The §discipline: *honest forward-referencing*. The author updated the doc *after* writing successor designs and added a revision note pointing to them. The design isn't *deprecated* (the conceptual model is still valid); it's *refined* — the implementation should use the later designs' mechanisms.

The §contrast with cycle 99's `chat-reply-chain-visualization` (deprecated, full successor pointer in Status field) vs cycle 107's `daemon-agent-tools` (still active sketch with refinement-pointer). Two different shapes of *design lifecycle*:

- **Deprecated** (chat-reply-chain) → fully superseded; the original is historical.
- **Refined** (agent-tools) → sketch still valid; successors refine the details.

### §The four-tool-group taxonomy

The §tool categories table (lines 46-52):

| Group | Capability | Tools |
|---|---|---|
| Filesystem | `Dir` | `readFile`, `writeFile`, `listDir`, `glob`, `stat` |
| Shell | `Shell` | `exec`, `execInteractive` |
| Git | `Git` | `status`, `diff`, `log`, `add`, `commit`, `checkout`, `branch` |
| Search | `Dir` | `grep`, `glob` (reuses filesystem) |

The §taxonomy discipline:

- **Three capability shapes** (Dir / Shell / Git). Search *reuses* Dir — no separate Search capability is needed because grep and glob are filesystem-scoped operations.
- **Per-capability tool list** — each capability has a small, well-defined tool set. Filesystem has 5 tools; Shell has 2; Git has 7; Search reuses Dir's grep + glob.
- **No catch-all** — there's no `Misc` or `Other` category. Every tool maps to a specific capability.

### §The filesystem tools sketch

The §`registerFsTools` sketch (lines 60-87):

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
  // ... writeFile, listDir, glob ...
};
```

The §navigation idiom: *walk the path-segments via `openDir` from the granted Dir*. The walk is bounded by the Dir's root — the agent literally cannot construct a navigation that escapes the root because `openDir` only returns sub-directories.

The §structural-confinement claim (lines 90-92):

> The `Dir` capability provides structural confinement — the agent cannot navigate above the project root, cannot access `~/.ssh` or `~/.aws`, and cannot follow symlinks that escape the mount boundary.

The §three-part confinement: *no above-root navigation* + *no `~/.ssh` access* + *no escaping symlinks*. The §discipline applies cycle 105's *capabilities are objects, not configurations* principle directly: the Dir capability *literally has no method that returns a reference to* `~/.ssh`.

### §The Shell capability — allowlist + array-execution

The §`makeShell` factory (lines 100-114):

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

The §five-parameter shape:

- **`cwd`** — working directory; bounded by the same path discipline as Dir.
- **`allowedCommands`** — `harden()`-ed array of canonical-build-tool commands. The §note: *`curl` may be restricted to specific hosts* — the design acknowledges the network-egress concern but defers the host-allowlist to a separate capability.
- **`env: filteredEnv`** — environment variables with *no secrets*. The agent doesn't see `AWS_*`, `OPENAI_API_KEY`, etc.
- **`timeout: 60_000`** — 60-second wall-clock limit on each exec call.
- **`maxOutputBytes: 1_048_576`** — 1 MiB stdout+stderr limit.

The §Shell interface (lines 118-127):

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

The §array-based-execution discipline:

> The `Shell` exo validates that the command is in the allowlist before execution. Arguments are passed as an array (no shell expansion) to prevent injection.

The §two-layer protection:

1. **Allowlist validation** — command must be in `allowedCommands`. Arbitrary commands rejected.
2. **No shell expansion** — `args` is a literal string array passed to the OS-level exec primitive (not `exec("command arg1 arg2")`). Shell metacharacters (`;`, `&&`, `|`, `>`, etc.) in arguments are passed as literal characters, not interpreted by a shell.

The §`M.interface('Shell', ...)` guard (lines 134-142) encodes the structural shape — `M.string()` for command, `M.arrayOf(M.string())` for args, `M.splitRecord({stdout, stderr, exitCode})` for the return.

### §The Git capability — local-only with exclusion list

The §Git interface (lines 150-160):

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

The §seven local-only operations: `status`/`diff`/`log` (read-only inspection); `add`/`commit` (local modification); `checkout`/`branch` (local navigation).

The §explicit exclusion (lines 162-168):

> The `Git` exo executes git commands in the repository directory. It does NOT expose:
> - `git push` / `git pull` (network access is a separate capability)
> - `git config` (prevents setting hooks or aliases)
> - `git hook` (prevents persistence attacks)
> - Raw `git` command execution (all operations are method calls with validated arguments)

The §four exclusions:

- **Network operations** (`push`/`pull`) — *network is a separate capability*. The agent might be granted local git but no network; or local git + scoped remote git for a specific repository.
- **`git config`** — prevents setting hooks or aliases. A malicious agent could otherwise install a `post-commit` hook that exfiltrates data.
- **`git hook`** — prevents persistence attacks. Without this exclusion, the agent could install hooks that fire even after the agent's session ends.
- **Raw `git` command execution** — *all operations are method calls with validated arguments*. The agent cannot call `git <arbitrary-command>`; it can only invoke the seven specific methods.

The §`M.interface('Git', ...)` guard (lines 171-180) encodes each method's shape, including the optional `M.optional(M.arrayOf(M.string()))` for methods that accept varargs.

### §The capability-granting via pet-name mechanism

The §CLI grants (lines 188-197):

```bash
endo grant fae fs /home/user/project
endo grant fae shell /home/user/project
endo grant fae git /home/user/project
```

The §pet-name discipline: the agent (`fae`) receives capability instances under specific pet-names (`fs`, `shell`, `git`). The agent looks up these pet-names in its namespace to discover what capabilities it has.

The §programmatic grants (lines 199-211):

```js
const dir = await E(powers).makeDir('/home/user/project');
const shell = await E(powers).makeShell({ cwd: '/home/user/project' });
const git = await E(powers).makeGit('/home/user/project');

await E(powers).grant('fae', 'fs', dir);
await E(powers).grant('fae', 'shell', shell);
await E(powers).grant('fae', 'git', git);
```

The §two-step pattern: *make-then-grant*. The host (via `E(powers)`) constructs the capability instances *with the host's authority* (only the host has the underlying ambient OS access), then grants them to the agent. The agent receives only the wrapped/attenuated capability.

### §The dynamic tool-discovery pattern

The §`setup` sketch (lines 218-249):

```js
const setup = async (powers) => {
  const tools = makeToolRegistry();
  registerMessageTools(tools, powers);

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

The §three-try-catch idiom:

- **Try to look up the capability** by pet-name in the agent's namespace.
- **If present**, register the per-capability tools.
- **If absent** (lookup throws), skip silently.

The §observation (lines 251-254):

> This means an agent's tool set is determined by the capabilities granted to it. An agent with only `fs` can read and write files but cannot execute commands. An agent with `fs` + `git` but no `shell` can do file operations and git operations but cannot run arbitrary processes.

The §discipline: *the same agent code works with or without coding capabilities*. The agent doesn't need a configuration file or compile-time switch; it discovers its capabilities at runtime and adapts. This is the §capability-driven-configuration pattern — the agent's behavior is determined by what it was *granted*, not by what was *configured*.

### §The form-based capability provisioning

The §lal-fae-form-provisioning integration (lines 261-270):

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

The §discipline: *capability grants are part of agent provisioning*. The manager agent's form asks the human to specify which capabilities the worker agent should receive. The §`capabilities` field's `example: 'fs,shell,git'` shows the comma-separated convention.

The §form-based-provisioning + capability-granting bridge: the daemon-form-request pattern (cycle 103 mentions form messages as the §reply-pattern donor for value-message) flows through to capability-grant-form-submission, making the *whole agent setup* a single form-flow operation.

### §The four-phase implementation plan

The §phases (lines 286-307):

- **Phase 1: Filesystem tools** (depends on `daemon-capability-filesystem`). The `Dir` capability provides the foundation. Most immediately useful + fewest security concerns (structural confinement via Dir).
- **Phase 2: Shell capability** with command allowlist. Can start simple (hardcoded allowlist) and evolve to configurable. The OS sandbox plugin design can later provide true process isolation.
- **Phase 3: Git capability**. Largely a wrapper around `child_process` git commands with argument validation and method-level guards.
- **Phase 4: Integration and discovery**. Wire up dynamic tool discovery so agents auto-register tools based on granted capabilities. Update form-based provisioning to include capability configuration.

The §dependency-ordered phasing: each phase depends on its predecessor's capability shape. The §filesystem-first discipline is structurally important — Dir is the strongest-confinement shape, so the highest-value-lowest-risk capabilities ship first.

### §The five Design Decisions

The §rationale points (lines 311-333):

**§(1) Capabilities, not configurations** — applies cycle 105's foundational principle to the agent-tools case. *The agent receives a `Dir` object, not a "filesystem access descriptor." It cannot name paths outside the `Dir`'s root because no method returns a reference to them.*

**§(2) Dynamic tool registration** — *agents discover capabilities at startup by looking up known names in their namespace. This means the same agent code works with or without coding capabilities — it simply has fewer tools available.* The §discipline keeps the agent code stable across deployment configurations.

**§(3) Git split by authority** — *the local `Git` capability deliberately excludes network operations. Fetch / pull / push belong on separately granted remote-git capabilities so product workflows can exist without smuggling network and credential authority into local repository access.* The §discipline preserves the *one-capability-one-authority-domain* invariant.

**§(4) Shell is array-based** — *commands are passed as `(command, args[])` tuples, never as shell strings. This prevents shell injection and makes the allowlist enforceable.* The §technical mechanism: the OS-level exec primitive accepts (command, args[]) directly; the shell-string form is never constructed, so shell metacharacters cannot inject.

**§(5) Phased approach** — *filesystem tools are the most immediately useful and have the fewest security concerns (structural confinement via Dir). Shell and git capabilities are progressively harder to confine safely.* The §discipline justifies the four-phase ordering by *user-value vs security-difficulty* trade-off.

### §The dependency graph and related designs

The §Dependencies table (lines 277-282):

| Design | Relationship |
|---|---|
| `daemon-capability-filesystem` | Provides `Dir` and `File` capabilities |
| `daemon-capability-bank` | Framework for capability categories |
| `lal-fae-form-provisioning` | Manager/worker architecture for agent setup |
| `daemon-os-sandbox-plugin` | OS-level process confinement for `Shell` |

The §Related Designs (lines 337-350) adds three §Revision-note successors:

- `daemon-mount-capabilities` — concrete completion plan for the live mount capability this sketch now builds on.
- `daemon-git-capability` — revised local git design over `EndoMount`.
- `daemon-git-remotes` — companion remote-git design for fetch/pull/push/credentialed endpoints.

The §design-graph reading: this design *sits between* the meta-framework (capability-bank) and the per-resource designs (capability-filesystem, capability-mount, capability-git). It's the *concrete-tool-shapes* layer that LAL/Fae actually register.
