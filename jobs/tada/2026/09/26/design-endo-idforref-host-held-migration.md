The `idForRef` design is written and open as **draft PR endojs/endo-but-for-bots#1344**. It proposes making `idForRef` resolve for every object a formula creates, while keeping ref-to-id lookups host-only. It is based on a frozen snapshot of `llm` (`llm-efabaed`), and the diff contains only the design file and the roadmap update.

**What the survey found (endo-but-for-bots @ `llm` efabaed2b5).** `idForRef` in `manager.js` only records a formula's top-level value, and only when that value is a non-null object. Everything a formula's value creates later has no formula id:
- read-only directory, mailbox and message-hub views
- mount sub-views, files and `readOnly()` views
- read-only Git views
- formula values that are functions

This already causes problems in merged code:
- **#1306's promise isn't met.** Its PR body said the `networks` option accepts a read-only directory view, but `getAgentDirectoryId` in `host.js` rejects one with "must be a daemon-minted directory".
- **`provideHostPath` refuses mount sub-views**, and its own docstring says why: they have no formula id.
- **`storeValue` and mail send fail on these objects** with "No corresponding formula".
- **Side tables stand in for formula identity:** the `mountRecords` WeakMap in `mount.js` and the liveness flag on the read-only directory view.

Guests are not given `getIdForRef` today. It reaches only the host and directory makers, the marshaller and the residence tracker, and guests only ever get names back from it.

**What the design proposes:**
- Each of these objects becomes a "derived formula" that runs in the daemon (no worker) and dies with its parent: `readable-directory`, `mount-view`, `mount-file` and `git-view`.
- Formula numbers are a hash of the parent, type and record, so repeating a `readOnly()` or `lookup()` call returns the same id. This replaces the per-object memo, bounds how much the formula store can grow, and matches the maintainer's instruction not to use throwaway wrapper objects.
- Function values are recorded in `idForRef` too.
- The consumers are updated as well: `networks` accepts a read-only view, the host methods that take a mount work from sub-views, and `mountRecords` goes away.
- A tested rule: no method a guest can reach turns an arbitrary reference into a formula id.
- The design also includes an ownership map, dependencies, four implementation phases (one PR each) and design decisions.

**Roadmap:** I added it to Milestone 10 (Capability Confinement) in `designs/README.md`, with a summary row, a dated update note, graph edges (`daemon-mount-capabilities` and `formula-inspector` feed into it, and it feeds `daemon-capability-bank`), an estimate of M / 1–2 weeks, and updated milestone totals. Both mermaid diagrams in the README parse.

**Open questions for the maintainer** (they are listed in the design, which is why it went up as a PR):
1. Should hosts get a public, host-only method that returns a reference's formula id, or should `getIdForRef` stay internal?
2. Should mount sub-paths get a formula at every `lookup`, or only when first stored, sent or passed to a host method?
3. Should read-only directory views become recursively read-only? Today `lookup` on one still returns writable children.
4. `endo-guest-stdio-mcp` passes a guest's own formula id to a process through its environment. Should the rule explicitly allow that?

The PR stays draft; say **run the gauntlet #1344** when you want the review panel on it. I couldn't check my inbox (the journal clone timed out, so it was skipped as offline); no other steps were skipped.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-endo-idforref-host-held-migration.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 84 tokens (3501846 cached reads)
- Output: 26372 tokens
- Cost: $2.1286891999999997
- Wall-clock: 405s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
