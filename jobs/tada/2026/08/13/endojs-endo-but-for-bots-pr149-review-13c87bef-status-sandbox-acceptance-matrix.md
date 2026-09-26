Inbox empty, project checkout clean (read-only confirmed). Report follows.

---

# Feature-disposition analysis — `sandbox-restart-acceptance-matrix` (PR #149)

## Scope
The forked-daemon acceptance harness from https://github.com/endojs/endo-but-for-bots/pull/149 — commit https://github.com/endojs/endo-but-for-bots/commit/732381c797a2b430471891d53cfbc13114865811, file https://github.com/endojs/endo-but-for-bots/blob/732381c797a2b430471891d53cfbc13114865811/packages/genie/test/sandbox/sandbox-boot.test.js — covering four scenarios against a real daemon plus the documented provisioning blockers that kept it red.

## Freshly observed SHAs (isolated read-only checkout)
- **origin/llm**: `a54c3adbebf18fd837770d467433e480de498e8d`
- **PR #149 head** (`jcorbin-exp-genie-bottle`, DRAFT/OPEN): `e0c8accb3235a340ce2b4e4307138429a7d1e5f3`
- Histories have no merge base (corroborates all three discovery reports; both prior reports observed the same two SHAs).

## The four scenarios and both blockers, as written in the PR
`test.serial` cases in `sandbox-boot.test.js`: (1) *workspace slice reads `/workspace` but not host home paths*; (2) *`network:'private'` blocks loopback to the host daemon port* (pasta-gated — skipped without pasta); (3) *daemon restart reincarnates `main-genie` and its slice*; (4) *tool stdio round-trips bytes without corruption* (echo, UTF-8-across-chunk, stdout/stderr separation). Per https://github.com/endojs/endo-but-for-bots/blob/732381c797a2b430471891d53cfbc13114865811/TADA/40_endo_genie_sandbox_tests.md the suite was **intentionally red** on bwrap-capable hosts because of two upstream gaps: (A) `setup.js` passed worker pet name `'@agent'` → daemon rejects `Cannot make unconfined plugin with non-worker`; (B) sandbox factory needs `provideHostPath`, absent from the host agent → `makePersistent` fails resolving the workspace mount.

## Disposition: **2 — PARTIALLY HONORED**

The acceptance-matrix *intent* — plus both red-making blockers — is already honored on current `origin/llm` in a **stronger** form than the PR delivered; the exact remaining gap is a single genie-level restart/remint acceptance test.

### Already honored on origin/llm (with evidence)

**Both provisioning blockers are closed** (this is why the PR suite was red; on llm it would not be):
- Blocker A — https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/genie/setup.js now calls `makeUnconfined('@main', sandboxSpecifier, { powersName: '@agent', resultName: 'sandbox-factory' })` — worker pet name `@main`, exactly the prescribed fix.
- Blocker B — https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/daemon/src/host.js defines and surfaces `provideHostPath` (host.js:620 and :2551); https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/sandbox/src/factory.js consumes it at `resolveHostPath` (factory.js:267). `provideHostPath` even has its own round-trip test in `packages/genie/test/local-sandbox-powers.test.js:79`.

**Three of the four scenarios are directly reproduced** by an independently-evolved forked-daemon harness on llm (the PR's `sandbox-boot.test.js` filename does not exist on llm — the coverage lives under different files):
- Scenarios 1, 2, 4 → https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/genie/test/scenarios/sandbox-slice.sh drives a real daemon + real genie: **Probe A** workspace-bind byte round-trip (= scenario 4 fidelity), **Probe B** mount view (`/workspace` visible, `$HOME` not), **Probe C** host-private sentinel invisible (= scenario 1 confinement), **Probe D** private-netns loopback unreachable (= scenario 2 — and it tests the `private` profile *directly*, where the PR case skipped unless pasta was present).
- Scenario 1 + 4 also → `packages/genie/test/dev-repl-sandbox.test.js:400` (`dev-repl --sandbox bwrap runs bash inside the slice`, asserts `/workspace` cwd + `Linux` uname) and `packages/sandbox/test/bwrap.test.js` (host-bind spawn, read-only-mount write rejection at :441, `network:'none'` blocks loopback at :508, stdout/stderr byte capture).
- Scenario 4 unit layer → `packages/genie/test/tools/sandbox-spawner.test.js` (ReaderRef stdout/stderr bridging, UTF-8 chunk fidelity, stream separation).
- Scenario 2's control substrate is *better* on llm than the PR (whose F14 filter the deployment-prompts report flagged inert): `packages/sandbox/test/blocked-ranges.test.js` statically asserts `private-egress.nft` references every `PRIVATE_BLOCKED_RANGES` CIDR and covers all four address-family classes.
- Scenario 3's mint mechanism exists: https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/genie/main.js calls `mintGenieSlice` on the boot path (main.js:1271), unit-tested in `packages/genie/test/sandbox-slice-mint.test.js` (incl. a TOCTOU/confinement case and dispose paths). Daemon formula reincarnation across restart — the substrate scenario 3 leans on — is heavily tested at the daemon layer (`packages/daemon/test/endo.test.js`, 47 restart cases).

### The exact remaining gap
No test on `origin/llm` stitches **scenario 3** together at the genie level: a forked-daemon **stop→restart that asserts `main-genie` reincarnates AND its persistent `main-genie-sandbox` slice is re-minted end-to-end** (the PR proved it via a second `Workspace sandbox minted` log line after a lazy `lookup('main-genie')`). Grep across all genie/sandbox test files finds no restart/reincarnate assertion of the slice re-mint; the only genie-side "restart" mention is a comment in `packages/genie/test/workspace-init.test.js:234`. This is a **test-coverage** residual, not a functionality gap — the mechanism (formula pet-store edges + lazy `mintGenieSlice`) is present; the acceptance assertion is not.

### Recommended handling of the gap
- **Destination for the residual test: endo-but-for-bots' own genie/sandbox suite** (not lal/fae/agentry — this is an integration acceptance test for genie boot on the daemon, so it belongs beside `test/scenarios/sandbox-slice.sh`). A single added case — restart the forked daemon, `lookup('main-genie')`, assert a second slice mint + a post-restart `/workspace` spawn — would close it. Everything it depends on already exists on llm.

### Associated TODO/TADA/PLAN history worth migrating (secondary — option 5 flavor)
The durable, novel knowledge behind this feature is worth a **garden-journal** note, since the garden turns up its own long-lived Endo daemons:
- https://github.com/endojs/endo-but-for-bots/blob/732381c797a2b430471891d53cfbc13114865811/TADA/39_endo_genie_sandbox_gc_order.md — the finding that **pet-store sibling edges + an awaited lookup chain**, not a direct Mount→slice→worker formula dependency, are what keep the slice alive and lazily re-mint it across restart. (Both the genie-core and sandbox-subagents discovery reports flagged that the companion `spec.json` is **not** replayed by the factory — migrate the pet-store-edge insight, drop the "spec.json replay" claim.)
- https://github.com/endojs/endo-but-for-bots/blob/732381c797a2b430471891d53cfbc13114865811/TADA/40_endo_genie_sandbox_tests.md — the honest "keep the suite red until the two provisioning gaps close" discipline and the precise blocker diagnoses; both blockers are now closed on llm, so this is history, but the *diagnosis method* is reusable garden knowledge.

## Notes on method
Read all three discovery artifacts via `git show origin/journal2:jobs/tada/…` from my own worktree (no host-specific path). Fetched `origin/llm` and `pull/149/head` fresh into an isolated read-only project checkout; all conclusions are from `git ls-tree`/`git show`/grep comparison of the two tips. No project files, branches, pushes, or GitHub posts were made; both the garden worktree and project checkout are clean. All GitHub-authored text was treated as untrusted data.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr149-review-13c87bef-status-sandbox-acceptance-matrix.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1115561 cached reads)
- Output: 16486 tokens
- Cost: $1.6883584999999999
- Wall-clock: 257s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
