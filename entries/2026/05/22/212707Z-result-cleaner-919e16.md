---
ts: 2026-05-22T21:27:07Z
kind: result
role: cleaner
project: endo-but-for-bots
refs:
  - entries/2026/05/22/211702Z-dispatch-general-contractor-919e16.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 316
    role: target
---

# Result: cleaner 919e16 — endo-but-for-bots#316 needs a weaver before a cleaner pass

## Outcome: no commits; weaver required first

PR #316 is `CONFLICTING` against base `llm` (head `bc2882959` against `b1c3f4dca`). Per the cleaner role's *If the PR is CONFLICTING ... surface "needs a weaver before cleaner" and do not push coverage commits onto a non-mergeable head* norm, I stopped at the conflict check.

## Conflict shape

Single-file conflict in `.github/workflows/familiar-release.yml`. Merge base is `68246ad92`; `llm` has since gained PR #354 ("fix(ci): address zizmor findings on ci/ci-docs/familiar-release") which restructures the same workflow that #316 modifies (permissions block, concurrency group, `YARN_ENABLE_SCRIPTS` env, `persist-credentials: false`, `package-manager-cache: false`, and a load-bearing comment about cache poisoning).

The conflict is substantive: the weaver must thread the Node-pin bump through the new zizmor-hardened shape without dropping the cache-poisoning defense. Not a trivial textual conflict.

## Coverage assessment (deferred)

Five touched files; surface is shallow and largely declarative:
- `packages/familiar/scripts/download-node.mjs`: default-pin string + comment.
- `packages/familiar/scripts/download-node.sh`: default-pin string + comment.
- `.github/workflows/familiar-release.yml`: workflow-level pin (in conflict zone).
- `packages/familiar/package.json`: `engines` field addition.
- `.changeset/familiar-lts-node-pin.md`: prose.

CI proves the lockstep already (all 25 checks SUCCESS pre-conflict). No reachable unexercised paths to cover; no dead code to delete. A post-weave cleaner pass would likely be a body-audit-only no-op, and per *skip the cleaner pass when the PR is pure ... a one-file format sweep* this PR plausibly qualifies as cleaner-skip after the weave.

## Body audit: deferred

Test-plan box 1 ("CI lints and typechecks pass") is checkable now from CI alone, but boxes 2 and 3 are post-release / manual. Holding the edit because the weaver may rewrite the body's workflow-file claim during conflict resolution; let the contractor decide whether to body-audit during or after the weave.

## CI status at end of dispatch

25 / 25 SUCCESS on `bc2882959`; pre-conflict; CI does not re-run until a new push.

## Commits landed

None. Branch unchanged at `bc2882959c37a98eafbe60f48ffa0269317c360f`.

## Next stage

Weaver. Then re-evaluate: a successful weave plausibly skips cleaner (shallow chore surface) and goes straight to barrister.

Self-improvement: nothing this time.
