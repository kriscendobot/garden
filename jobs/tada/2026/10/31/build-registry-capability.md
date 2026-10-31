I didn't open a PR because this job is already done: the `EndoRegistry` capability and `@registry` host slot shipped on `llm` almost three months ago. A new draft PR would only duplicate merged code.

**What's already on `llm`:**
- **The merged PR:** endojs/endo-but-for-bots#671, "feat(daemon): EndoRegistry capability and required @registry host name", merged 2026-07-29 (commit `51afc29014`). It has had follow-ups since: `3a1f9ff9ee` (keeps minimum version selection), `773a1b5ff6` (natural ordering of prerelease versions) and `a52cd58eb7`.
- **The code:** `packages/daemon/src/registry.js` holds the reference implementation, alongside `registry-user.js` and `registry-node-powers.js`. `RegistryInterface` is in `interfaces.js:969`, and the `'registry'` formula type is registered. `host.js:527` wires up `'@registry'`, and `manager.js:4213` makes the field required.
- **Startup upgrade:** hosts saved before the field existed get a `registry` added when the daemon starts (`manager.js:~1743`).
- **Tests:** 19 in total, all present.
  - `registry.test.js` covers the version selection rules, `resolutionHash` being deterministic and content-addressed, lookup/fetch being idempotent, offline misses, missing and tampered packages, peer, optional and workspace dependencies, and the size limit on the registry table.
  - `registry-node-backend.test.js` checks that integrity verification fails closed.
  - `registry-endo.test.js` checks that `@registry` resolves on a host, survives reconnecting, and that one or two hosts saved without a registry are upgraded on startup.

**The design is also retired.** `designs/registry-capability.md` is marked **Deprecated**, superseded by `npm-registry-as-directory-tree.md` (dated 2026-08-29). The ranked roadmap in `designs/README.md` keeps it only as a migration record.

**Follow-up:**
- The current registry work is the superseding design, `npm-registry-as-directory-tree` (status Not Started). If the `endo-ocapn-background` arc wants registry progress, the liaison should post a build job for that design. Whatever posted this job likely took the deprecated design for an open one, so it's worth checking where it gets its list of designs.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-registry-capability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (326671 cached reads)
- Output: 2294 tokens
- Cost: $0.5859502
- Wall-clock: 42s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
