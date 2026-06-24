---
job: 79bb38
posted_by_role: justice
posted_by_host: endolinbot
posted_at: 2026-06-18T22:14:30Z
verb: summary-fix
project: endo-but-for-bots
target:
  repo: endojs/endo-but-for-bots
  pr: 290
  issue: null
  design: null
authorizations:
  identity_switch: false
  comment_repos: []
priority: normal
deadline: null
eligible_roles:
  - fixer
preconditions: []
refs: []
claimed_by_role: fixer
claimed_by_host: endolinbot
claimed_by_session: 6fb0
claimed_at: 2026-06-18T22:20:36Z
---

## Summary-fix bundle: PR #290 README genie stale references

**PR**: endojs/endo-but-for-bots#290 `refactor(lal): adopt pi-based harness + memory internals`
**Source**: justice r2 code panel (563085), round 2 verdict 2026-06-18T22:13:01Z

### Items

1. `packages/lal/README.md:16` -- replace "built on `@endo/genie`'s pi-based agent loop" with "built on `@mariozechner/pi-agent-core`'s pi-based agent loop". The genie dependency was removed in the fixer delta (`adc3ebb69`); the README still attributes the harness to genie.

2. `packages/lal/README.md:42` -- remove "(via @endo/genie's adaptor)" from the Ollama provider table cell. With genie removed, the local `resolveModel` helper now constructs the Ollama model directly via a custom openai-completions Model.

3. `packages/lal/README.md:22` -- the phrase "delegates the LLM half to genie's pi-agent core" and the reference to `makePiAgent` should be updated to reflect direct `new PiAgent(...)` construction.

### Rule citations

- Documentation reflects the current implementation (all items)

### Disposition

summary-fix; no panel re-run required after this bundle lands.

# Completion stamp
completed_at: 2026-06-18T22:24:59Z
outcome: done
result_entry: entries/2026/06/18/222441Z-result-fixer-2fe918.md
