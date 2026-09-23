---
ts: 2026-06-03T17:40:27Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
dispatch_root: /home/kris/dispatches/fixer--8f3bda
prs:
  - repo: endojs/endo-but-for-bots
    pr: 394
    role: target
  - repo: endojs/endo-but-for-bots
    pr: 369
    role: source
refs:
  - entries/2026/06/03/173144Z-dispatch-liaison-8f3bda.md
  - https://github.com/endojs/endo-but-for-bots/pull/394#issuecomment-4615146728
  - https://github.com/endojs/endo-but-for-bots/pull/394#discussion_r3350655684
---

# result: fixer — #394 apply git-backbone-spike (#369) discoveries

## Heads

- Pre-application head: `119d21f45` (refactor(gateway): one-repo-per-daemon, bearer-as-formula-ref shape).
- Post-application head: `a57332f69` (docs(gateway): apply git-backbone-spike (#369) discoveries to Feature 3).

## Per-axis verdict

- **Axis 1 (objects = git objects).** Deferred. Daemon-side only (rust/endo/src/cas.rs); the dispatch forbids touching rust/. No gateway-applicable code change; the spike's libgit2 ratification for the object DB binding is folded into the design's daemon-side library paragraph as context.
- **Axis 2 (trees = git trees).** Deferred. Same daemon-side scope; the gateway has no tree-object surface.
- **Axis 3 (bulk transport off CapTP).** Applied (design cross-reference). The gateway's smart-HTTP endpoint is the remote/HTTP carrier for axis 3 (pack bytes ride the smart-HTTP wire rather than CapTP turns). New paragraph in Feature 3 § Daemon-side scope.
- **Axis 4 (retention = refs + git gc).** Applied (design corrections + cross-reference). New paragraph capturing: `refs/formulas/<formula-id>` durable live-set via libgit2 ref-lock; in-process reachability sweep because libgit2 ships no `git gc` porcelain; formula-graph mirror seam lives in JS (`packages/daemon/src/daemon-database.js`) per spike Status; atomic-write order deferred per spike Open Question 3.

Additional spike-discovery corrections folded into the same section:

- **Library ratification.** Sharpened from "can bind libgit2" to "binds libgit2 via the `git2` crate, as ratified by the maintainer on the daemon-side spike", with the `gix` alternative and ruling rationale recorded.
- **Content-key correction.** The prior text "We use the SHA-256 Git variant rather than SHA-1" contradicted the spike-ratified position and was reversed: Endo's sha256 stays the content key; git's internal object DB runs in default SHA-1 format behind a `sha256 -> git-oid` index. Future transparent adoption of git's SHA-256 mode remains possible because the Endo-facing key never changes.

## Files touched

- `designs/gateway-package.md` (+ 56 / - 4): Feature 3 daemon-side scope section.
- `designs/README.md` (+ 1 / - 1): gateway-package row Updated 2026-05-29 -> 2026-06-02 per project's designs/CLAUDE.md sync rule.

No code changes. The gateway's wire shape at 119d21f45 already matches the spike's framing (one-repo-per-daemon + bearer-as-formula-ref); the applied discoveries are design-doc-level (maintainer rulings + axis composition).

## Local gates

- `yarn workspace @endo/gateway lint`: exit 0, 0 errors (170 warnings carry from earlier work; none introduced by this PR's edits, design files only).
- `yarn workspace @endo/gateway lint:types`: exit 0.
- `yarn workspace @endo/gateway ava`: 279 / 279 passing including the `git-http-integration` test that drives the real `git` CLI through push + pull with the bearer-auth contract.

## Comments

- Top-level summary: https://github.com/endojs/endo-but-for-bots/pull/394#issuecomment-4615146728 (ID `4615146728`).
- Inline reply on thread `3350596749` (@kriskowal's @-mention on `packages/gateway/test/git-http-integration.test.js`): https://github.com/endojs/endo-but-for-bots/pull/394#discussion_r3350655684 (ID `3350655684`).

## Judgment calls

1. **No code touches.** The contractor's recent CAS pivot at 119d21f45 already implemented the bearer-as-formula-ref wire shape (the maintainer's prior 4414303711 review locked the gateway-side wire). Re-litigating that shape would invert the contract; the spike confirms the wire is right. Discoveries are at the design / scope layer.
2. **Axes 1, 2 declared `deferred` rather than `partial`.** They are entirely daemon-side (Rust CAS object DB and tree objects in rust/endo/src/cas.rs); the dispatch forbids touching rust/. No partial-credit application makes sense for the gateway tree.
3. **Content-key correction was the highest-confidence applicable discovery.** The gateway design's previous text directly contradicted the spike-ratified position. Reversing it is not optional once the dispatch directive is "apply discoveries", since leaving the contradiction in place would create a maintainer ambiguity later.
4. **Axis 3 framing chosen as gateway-applicable.** The spike's axis 3 is the bulk-transport-off-CapTP rule; the gateway's smart-HTTP endpoint is precisely the wire that carries that transport for the remote/cross-peer hop. Naming the composition explicitly in the design helps future readers understand why the same smart-HTTP path is "axis 3" in the daemon-side spike's vocabulary.
5. **Formula-graph mirror seam (JS-side) noted but not pre-empted.** The spike's Status section identifies the seam is in JS (`packages/daemon/src/daemon-database.js`). The gateway's Feature 3 daemon-side scope text now mentions this seam, but does not specify the atomic-write order (the spike defers that as its Open Question 3). The gateway's contract on `serveRepo(token)` is reframed as: resolves to a capability scoped to whatever ref the daemon currently publishes for that formula -- which is mirror-implementation-agnostic.
6. **designs/README.md row sync.** Per project's designs/CLAUDE.md, any design-file modification syncs the README summary. Touched the Updated column to today (2026-06-02 per currentDate). The Status column stays Proposed (no status change from this edit).
7. **No reactji on the @-mention.** Per `roles/COMMON.md` § External-repo etiquette and `roles/fixer/AGENT.md` § Reactji-acknowledgment, the triage role typically owns the first reactji; the fixer reacts only on comments the triage did not pre-surface. The dispatch did not authorize a reactji.
8. **Spike PR not touched.** Per dispatch "Not authorized: touching the spike PR #369 itself" -- no comments, reviews, or reactjis on #369.

## Authorization compliance

- Read #369 files (any path): exercised on the design doc and Rust cas.rs via `git fetch origin pc-daemon-git-backbone` + `git show FETCH_HEAD:<path>`.
- Edit files under `packages/gateway/` and `designs/` (only gateway-related design docs): exercised on `designs/gateway-package.md` and `designs/README.md` (the latter is a sync, not a content change; per project convention design-file edits sync the README row).
- Regular-append commit + push to `design/gateway-package-phase-6`: exercised. Push line `119d21f45..a57332f69`. No force.
- Top-level PR comment on #394: exercised (`4615146728`).
- Inline reply on #394: exercised (`3350655684`).
- Not exercised: any rust/ edits, any non-gateway package source edit, force-push, touching #369, un-draft/re-draft/merge.

Self-improvement: nothing this time.
