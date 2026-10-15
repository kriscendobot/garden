---
orchestration-failed: true
---
orchestration-failed: true

# PR #356 fix round 2: rebased onto current `llm` and pushed, but CI is red on a stale-base check

I applied panel round 2's must-fix items and pushed the result. CI came back red on one check, `format-ironhorse`, because the PR's base field still points at the old `llm-b1c3f4d`. This host's token can't change the base, so I posted a job pinned to endolin to do it.

**Where the verdict came from.** Round 2's review never reached the PR, because this host can't post reviews on endojs. Its text is in the unclaimed job `endojs-endo-but-for-bots-pr356-gauntlet-20261007-panel-2-post-review`, and I worked from that. The latest review actually on the PR is round 1's, which fix round 1 already handled.

**Rebased onto current `llm`.** Five seats (decomplector, integrator, packager and others) traced most must-fixes to the stale base: the branch was 4,219 commits behind and carried an outdated copy of the already-merged `designs/gateway-package.md`. The new head is `eff23ba5a`, two commits on `llm-863a995` (= `origin/llm` `863a9957f`):
- `72817b7e3`: the three sibling designs (`gateway-packaging-ci.md`, `gateway-aws-deployment.md`, `gateway-aws-attuned.md`), carried over with the earlier fix commits squashed in.
- `eff23ba5a`: the round-2 fixes.

The PR no longer carries the stale `gateway-package.md`, the `endo-gateway.md` edits, or the CI, tsconfig, ocapn-test and `SECURITY.md` commits. I pushed with `safe-push-pr-head.sh --mode rewrite`, which leases against the head it fetched just before pushing. `llm-863a995` already existed at the right commit.

**Matched to the merged parent.** The siblings now cite only sections that exist in the merged `gateway-package.md`:
- The resource ledger lives in the gateway, per its Design Decision 8 (the old "Feature 1b deferral" is gone).
- Restart behavior points to § Restart semantics, and the service CLI to § Root User and Service CLI.
- The default port is 8920.
- Virtual-host names come from the parent's gateway-allocated identifiers (its Open Question 3), replacing the old `authenticated-allocation` mode.
- Links to the removed `endo-gateway.md` are redirected.

I checked every link and section reference. `designs/README.md` gains only the three Proposed status rows and updated totals.

**Must-fixes applied:**
- **Tenant isolation (`gateway-aws-attuned.md`):** DynamoDB access now needs an exact key match (or one ending in a `#` delimiter for the account index), never a bare prefix. Tenant IDs have a fixed format with no `#` or `/`, so `t1` can no longer match `t10`'s rows.
- **Content-store garbage collection (`gateway-aws-attuned.md`):** the race where a write resurrects an object just as it is deleted is closed. The sweeper now marks the row "deleting" before deleting the object, and the doc tables every interleaving.
- **Forwarded headers (`gateway-aws-deployment.md`):** `X-Forwarded-*` headers are trusted only from the load balancer's subnets, never the whole VPC. The client IP is the rightmost untrusted `X-Forwarded-For` entry.
- **apt key bootstrap (`gateway-aws-deployment.md`):** the check now requires exactly one primary key matching the pinned fingerprint, and only that key goes into the keyring. Tests are listed for a mismatched key, a two-key file and an empty file.

**Should-fixes also applied:**
- `gateway-aws-attuned.md`:
  - States that a compromised instance can reach every tenant's storage.
  - Requires whole-object checksums and confirming S3 honors conditional writes on copy.
  - Pins the byte encoding of every signed message.
- `gateway-packaging-ci.md`:
  - Release tags must be strict semver on a commit already on `master`, and only full releases move `:latest`.
  - The Arch build fails if a `SKIP` checksum placeholder survives.
  - Names `node:sqlite` with an engines floor.
  - Every artifact, Docker included, uses a pinned per-architecture Node binary.
  - SES lockdown runs before anything calls `harden`.
- The packaging recipes moved under `packages/gateway/packaging/` to match endojs/endo-but-for-bots#412.
- The "seam" wording is gone from all three docs.

**Not applied:** the warden's Electron-main-process finding and the wire-watcher's signing-prefix finding are about `gateway-package.md`, which this PR no longer touches. Fixing them means changing the maintainer-approved merged design, which the decomplector said needs maintainer confirmation. They should be a separate decision.

**PR base and body.** Moving the base to `llm-863a995` and replacing the body failed with a 403 (`updatePullRequest` isn't allowed for this token on endojs). I posted `endojs-endo-but-for-bots-pr356-gauntlet-20261007-fix-2-pr-edit`, pinned to `host=endolin-garden-ece02cb4`. It carries a new body following the PR template and checks the head before moving the base. Until it runs, the PR diff also shows every `llm` commit since `llm-b1c3f4d`.

**CI: red (`ci-wait-merge` returned 3).** 37 of 38 checks passed. The one failure, `format-ironhorse`, compares `rust/engine/ironhorse-snapshot/src/format.rs` against the PR's base commit `b1c3f4d`. That file doesn't exist there, so the script crashes. The tree under test is `llm` plus Markdown files, and `llm`'s own CI at `863a9957f` is green. This should clear once the base moves and CI re-runs on a new push. A plain re-run reuses the old base.

**Follow-ups:**
- The endolin host has two unclaimed jobs: the base and body edit, and the round-2 review post.
- The next panel round should run against base `llm-863a995`.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr356-gauntlet-20261007-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 140 tokens (9049114 cached reads)
- Output: 41720 tokens
- Cost: $6.188034799999997
- Wall-clock: 3760s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
