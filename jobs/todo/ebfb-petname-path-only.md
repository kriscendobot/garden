---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Endo Exo surface: accept only pet-name PATHS, reject single pet-name strings

Repo: endojs/endo-but-for-bots (base: current `llm`, pin a frozen base per ensure-pr.sh).
Requested by kriskowal in the review on PR #1343:
https://github.com/endojs/endo-but-for-bots/pull/1343#pullrequestreview-5360774903

Task: simplify the union of "pet name OR pet name path" throughout the Endo
daemon Exo surface (host/guest/directory/etc. methods, their interface guards /
M.* shapes, types, CLI callers, tests, docs). Anywhere we currently accept either a
pet name or a pet name path, accept ONLY a pet name path (an array of path
components) and REJECT a single pet-name string. This is a breaking change;
update all internal callers and the CLI accordingly, with a changeset.

Motivation (capture this in the PR body, changeset, and relevant docs/guard
comments): these methods are primarily geared toward agents, and agents are
susceptible to the same confusion as people. Accepting a string invites confusion
about whether the string may be a delimited path and ambiguity about what the
delimiter is in our virtual file (and other capabilities) system. Eliminating this
ambiguity ensures an agent receives feedback that its invocation with a delimited
string was invalid, and that it should try again with an array of path components.
Make the rejection error message say exactly that (use an array of path
components).

Coordinate with PR #1343 (endowments value side is being moved to the pet-name
path shape there); do not duplicate that change — rebase over it if it lands first.
