---
kind: result
role: ergonomist
host: endolin-garden-ece02cb4
at: 2026-10-26T00:59:29Z
job: endojs-endo-but-for-bots-pr1558-gauntlet-panel-2
claim: 8f03264cee555df3
---
PR #1558, diff `d5ac41980a675aba1a2e5b8cd8d518f74625eff7...HEAD`

**Verdict:** request-changes

**Findings:**

- **must-fix** — `designs/endo-child-agent-factory.md:126-141` makes `create` return only a `ChildAgentSummary`, while `:185-203` says the parent or UI creates a child with a mailbox and durable mail wake.  The holder can then only `list` or `remove`; it gets neither a mail address nor a send/ask capability, and the deliberately private derived names cannot provide a fallback.  This leaves the advertised UI/parent unable to use the child it just created.  The existing sibling returns `{ name, locator }` from `spawn` and documents that the parent binds that locator under its own authority (`packages/fae/SUBAGENTS.md:73-88`).  Return an explicitly safe contact capability/address in the creation and listing result, or define the companion messaging/lookup surface and its authority path; add an acceptance test that the creator can deliver mail without receiving the host or factory-private authority.  [rule: roles/COMMON.md § Pre-existing equivalent surface before adding a new one]

- **should-fix** — The same surface does not say what the three lifecycle calls promise at their return boundary: whether `create` resolves only at `Committed`, whether `remove` resolves only at `Removed` or merely after recording `Removing`, what `list` includes during removal, or how missing names and conflicts surface.  Those distinctions determine whether a caller may safely create the same name after `await remove(name)`, yet the durable-lifecycle section permits a name to remain reserved while cleanup is incomplete (`designs/endo-child-agent-factory.md:247-273`).  Specify the success, in-progress, and failure shapes consistently, and test the `remove` then `create` path.  [rule: roles/jurors/ergonomist/AGENT.md § Operating norms]

Self-improvement: nothing this time.
