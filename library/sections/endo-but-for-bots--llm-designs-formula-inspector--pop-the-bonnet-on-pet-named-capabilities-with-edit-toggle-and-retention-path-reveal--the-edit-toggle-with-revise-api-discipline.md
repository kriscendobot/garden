---
section: pop-the-bonnet-on-pet-named-capabilities-with-edit-toggle-and-retention-path-reveal
source: endo-but-for-bots--llm-designs-formula-inspector
topics: [daemon, agent-conventions, tooling]
status: current
title: The §edit-toggle-with-revise-API discipline
parent: endo-but-for-bots--llm-designs-formula-inspector--pop-the-bonnet-on-pet-named-capabilities-with-edit-toggle-and-retention-path-reveal
---

The §read-only-default-edit-toggle-opt-in discipline:

> *Read-only by default, with an "edit" toggle for advanced
> users that allows modifying mutable formula fields (e.g.,
> re-pointing a lookup path). Editing requires a new daemon
> API method — `E(agent).revise(petName, patch)` or similar —
> that validates and persists formula changes.*

The §`E(agent).revise(petName, patch)` API shape:

- **`agent`**: the agent under whose authority the revision
  runs (host-level required per §security).
- **`petName`**: which capability to revise.
- **`patch`**: the partial formula update (re-point a lookup
  path, change endowments, etc.).
- Returns a promise of the revised formula identifier (or an
  error if validation fails).

The §validation-on-revise discipline: the daemon *validates
formula invariants* before persisting (e.g., a `worker` field
must reference a valid worker formula). Editing a formula
isn't free-form JSON manipulation — it goes through the
daemon's invariant checks.
