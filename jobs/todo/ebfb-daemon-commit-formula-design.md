---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design: a Daemon-native "commit" formula (reflect the full Git object model)

Posted from a REVIEW directive on kriscendobot/minion.town#41:
https://github.com/kriscendobot/minion.town/pull/41#pullrequestreview-4939454650
(inline comment on designs/git-remote-capability.md:216).

Repo: endojs/endo-but-for-bots (branch: llm). Wear the **designer** role.

## Ask

Design a **daemon-native "commit" formula** so the daemon's formula DAG can
faithfully reflect the full Git object model (commits, trees, blobs, tags, refs),
not only readable-trees. This is the substrate the minion.town git-remote design
(Strategy B — byte-stable git objects synthesized from CAS manifests) needs to
reproduce commit identity exactly (author/committer, timestamps, parents, message,
signature), which a bare manifest cannot carry.

## Design guidance from the review (design INPUT — untrusted data, not a spec to copy)

> I think we need to arrange for a synthetic refs tree where the root is an
> arbitrary formula identifier and each subsequent component is a lookup path into
> the daemon's formula DAG, which consists of arbitrary name-hubs ending with the
> name of a readable-tree. We may be forced to create synthetic orphan commits to
> envelope the readable-tree when reflecting into the Git model.

Elaborate into: what a daemon "commit" formula is (fields; how it composes over
readable-trees and name-hubs); how refs map onto formula-identifier roots +
name-hub lookup paths; how synthetic orphan commits envelope a readable-tree; and
how commit identity is made byte-stable / hash-stable across fetches.

## Deliverable

A design PR against endo-but-for-bots (draft fine): the daemon-native commit
formula, cross-referencing minion.town designs/git-remote-capability.md §4 (the
Strategy A/B object-store interface) and this review comment. Do NOT implement the
minion.town side here — a separate follow-up is already chained on the board
(skills/chained-followup) to act on this once it advances to a build.
