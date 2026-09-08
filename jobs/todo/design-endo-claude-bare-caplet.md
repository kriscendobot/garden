---
role: designer
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-08T18:55:39Z cleared=none -->

---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design: finish the unconfined caplet that shells out to `claude -p --bare`

Repo: `endojs/endo-but-for-bots`. Base: `llm`. Child of arc
https://github.com/kriscendobot/garden/issues/89 (item 4).

`designs/endo-claude.md` exists and https://github.com/endojs/endo-but-for-bots/pull/1015
("feat(claude): add @endo/claude confinement core", draft) is its build. The PR has been
quiet since 2026-08-31. **Evolve the design and report on the build**, do not start over.

The arc's requirement, stated by the maintainer: an unconfined caplet that shells out to
`claude -p --bare` with sufficient flags to divorce the agent from its default tool-call
surface and introduce a local MCP tool-call surface instead.

Do this:
1. **Read PR #1015 as it now stands** and establish what is actually built versus what the
   design specifies. Report the delta concretely, file by file, not impressionistically.
2. **Resolve the documented-versus-observed gap.** `designs/endo-claude.md` itself flags
   its five-flag confinement stack as resting on *undocumented* behavior and defers to a
   live test. Say which claims are now observed, which are still merely documented, and
   which are still assumed. If a live spawn is needed to settle one, name the exact test
   rather than performing it here.
3. **Reconcile `--bare` specifically.** The maintainer's phrasing names `--bare`; the
   design's flag stack may not. Confirm the flag set that actually achieves the divorce
   from the default tool surface, and correct the design if it names the wrong flags.
4. **The substitution half.** Divorcing from built-in tools is only useful if the local
   MCP surface survives. State the requirement that `mcp__<server>__<tool>` tools remain
   callable with built-ins denied, and mark it as the acceptance condition. Arc item 5
   (the stdio MCP scoped to one guest) is the surface that plugs in here; keep the
   interface between the two explicit so the two designs compose.
5. **Say what it takes to un-draft #1015.** A short, ordered list of the remaining work,
   so the arc press can turn it into jobs.

Note the parallel Agent-SDK track (parked jobs `endo-claude-agent-sdk-{design,probe,backend}`).
It runs alongside this and must not block or supersede it; the CLI path stays the default.

Deliverable: the evolved design plus a written assessment of PR #1015's remaining work. Do not build.
