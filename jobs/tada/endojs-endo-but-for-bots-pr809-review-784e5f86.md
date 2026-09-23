Reviewed the full review: one inline comment at `packages/daemon/designs/daemon-persistent-stores.md:80`.

No change was needed. Peer commit `735750aa5c` already clarifies that map/set iteration is deterministic passable-rank order, not insertion order; sorted variants add bounded range queries. PR #809 was merged before this review comment, so no PR update is possible.

Verified with `git show 735750aa5c` and `git diff --check 7771ad17fe..735750aa5c`.
