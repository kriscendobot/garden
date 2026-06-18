---
ts: 2026-06-18T07:23:31Z
kind: result
role: conductor
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/18/052492483-dispatch-conductor-4a78b9.md
---

## Conductor result: PR #461 stalled — CI red

### State at dispatch time

- PR #461: `feat(exo-stream): Introduce Exo streams (llm mirror of endojs/endo#3036 + chat/agent migration)`
- `isDraft: true`, `reviewDecision: APPROVED`, `mergeable: MERGEABLE`, `mergeStateStatus: UNSTABLE`
- Base: `llm-5be4392` (frozen snapshot; live base would be `llm`)
- Head: `kriskowal-exo-stream-llm`
- kriskowal APPROVED at 07:21:03Z with empty body

### Actions taken

None. No commits pushed, no merge issued, no branch state changed.

### Blocker: CI red

All test and coverage checks are failing on CI run `27735265214`. The failures are substantive, not infrastructure noise:

- `sandbox-drivers`: repeated `TypeError: target has no method "next", has ["__getInterfaceGuard__","__getMethodNames__","readReturnPattern","streamBase64"]`
- `cover (22.x)`, `cover (24.x)`, `lint`, `test (22.x/24.x, ubuntu/macos)`: all fail

The `next` method is a standard iterator method that callers expect on a stream. Its absence from the exo interface suggests the PR's exo-stream implementation does not yet expose the iterator protocol on the Exo-guarded surface. This is a code-level defect in the PR's own domain, not a pre-existing base-branch issue.

### Conductor norm applied

Per `roles/conductor/AGENT.md` § Operating norms: "Only merge CI-green PRs. An APPROVED + red PR is not a merge candidate; it is a shepherd dispatch. Stall with `ci red: needs shepherd`."

The dispatch prompt directed the conductor to proceed given kriskowal's APPROVED + empty-body "merge as-is" signal, but the APPROVED review covers the code as written; CI failing on the PR's own interface is a blocker the conductor cannot override. The standing norm requires CI green.

### Stall reason

`ci red: needs shepherd` (or fixer — the `next` method gap on the exo stream interface is likely a one-line guard addition or an interface-definition fix within the PR's scope).

### Next steps for orchestrator

1. Dispatch shepherd against PR #461 to classify the CI failure and drive it to green.
2. After CI is green, re-dispatch conductor to complete: un-draft, unfreeze base (`llm-5be4392` to `llm`), merge.
3. After merge: close PR #330 as superseded by #461.

### PR #330

Not closed. The close was gated on #461 merging first; #461 did not merge.

Self-improvement: nothing this time.
