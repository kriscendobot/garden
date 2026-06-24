---
title: Common confusions
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

- **"`Claw` is just Claude Code by a different name."** It is — the parenthetical *Claude-Code-like Capabilities* in the title names the target explicitly. *Claw* is the lal-on-Claude-Code framing; the same shape applies to Cursor, Devin, and any LLM-tool-using agent.
- **"Why allowlist commands? Just sandbox the whole shell."** Sandboxing requires OS-level support (`daemon-os-sandbox-plugin` is the named future design). The allowlist + array-execution + filtered-env approach is *capability-discipline at the JavaScript layer* — it works on any OS without requiring kernel features.
- **"`git push` should be allowed for some agents."** It is — but as a *separate capability* (`daemon-git-remotes`). The §Design Decision #3 names *Git split by authority*: local Git is local-only; remote Git is its own capability with its own credentials and host allowlist.
- **"`try { lookup('fs') } catch` is fragile — exceptions for control flow."** The §discipline is *capability-driven-configuration*. The lookup throws when the capability isn't granted; the catch handles the *capability-absent* case explicitly. The agent code is *correct under any subset of granted capabilities*.
- **"`filteredEnv` is hand-wavy — what's filtered?"** The §design names the discipline (*no secrets*) without enumerating which env-vars are filtered. The detail belongs in `daemon-capability-bank`'s per-category design `daemon-capability-env`. The §design-doc-as-meta-sketch passes this detail to a sister design.
- **"Why exclude `git config` — it's read-mostly."** *`git config --set` can install hooks or aliases*. A malicious agent setting `commit.template` or `core.editor` could exfiltrate data or persist arbitrary code. The §exclusion is *not-because-config-is-bad* but *because-config-can-set-hooks*.
- **"The Revision note (2026-05-18) means this design is obsolete."** It does *not*. The Revision note says the *sketch is refined* by successors — the conceptual model is still valid. Successors add details about how the underlying mount/path/remote authority is structured. The §sketch is *still the entry-point design* for the agent-tools layer.
- **"Phased approach is just project management."** It is — *plus security ordering*. The §design notes that *filesystem first because structural confinement is strongest*. The phasing is driven by *security-difficulty-vs-user-value*, not just engineering convenience.
- **"`registerMessageTools` is undefined — the agent has no messaging."** The §setup sketch shows `registerMessageTools(tools, powers)` at the top *before* the try-catch capability lookups. Messaging tools are *always available* (they're the agent's core messaging surface, not a coding capability). The coding capabilities are *additionally registered* if their pet-names exist.
- **"`harden(['node', 'npm', ...])` is just a constant — why harden?"** The §allowlist is hardened so it cannot be mutated *after construction*. If the allowlist could be modified, a compromised agent might add commands to it. The §discipline ensures the allowlist is *immutable from-construction*.
