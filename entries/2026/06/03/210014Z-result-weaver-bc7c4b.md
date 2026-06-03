---
ts: 2026-06-03T21:00:14Z
kind: result
role: weaver
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 388
    role: target
  - repo: endojs/endo-but-for-bots
    pr: 389
    role: target
  - repo: endojs/endo-but-for-bots
    pr: 392
    role: target
  - repo: endojs/endo-but-for-bots
    pr: 393
    role: target
  - repo: endojs/endo-but-for-bots
    pr: 394
    role: target
refs:
  - entries/2026/06/03/205058Z-dispatch-liaison-bc7c4b.md
  - entries/2026/06/03/051106Z-result-weaver-59079d.md
  - entries/2026/06/03/204957Z-result-shepherd-9985b3.md
  - https://github.com/endojs/endo-but-for-bots/pull/388
  - https://github.com/endojs/endo-but-for-bots/pull/389
  - https://github.com/endojs/endo-but-for-bots/pull/392
  - https://github.com/endojs/endo-but-for-bots/pull/393
  - https://github.com/endojs/endo-but-for-bots/pull/394
---

# result: weaver — gateway-package stack cascade-rebase complete (phase-2 through phase-6)

All five cascade phases pushed successfully on top of the rebased
#343 foundation (`23bc11a9e`). No `gh pr edit --base` was needed
because each phase PR's base is the parent branch name (not a
frozen-base snapshot), so a force-push of the parent head
auto-shifts the diff.

## Per-phase result table

| PR | Branch | Pre-rebase head | Post-rebase head | Commits replayed | Conflicts | Push exit | Base edit |
|----|--------|-----------------|------------------|------------------|-----------|-----------|-----------|
| #388 | `design/gateway-package-phase-2` | `741890f1d` | `785ec6088` | 5 (cherry-picked from 21; 16 design-doc duplicates dropped) | none | 0 | not needed |
| #389 | `design/gateway-package-phase-3` | `bc807ca78` | `d9cd28081` | 2 | none | 0 | not needed |
| #392 | `design/gateway-package-phase-4` | `ee8297f0c` | `7f98b9968` | 3 (4th was duplicate #389 work, skipped) | none | 0 | not needed |
| #393 | `design/gateway-package-phase-5` | `04eedbedf` | `a1905d368` | 2 | none | 0 | not needed |
| #394 | `design/gateway-package-phase-6` | `a57332f69` | `0acea588b` | 7 | 3 in 2 files (admin.test.js twice, designs/README.md once) | 0 | not needed |

## Phase-2: cherry-pick strategy (deviated from straight rebase)

Initial `git rebase 23bc11a9e` produced conflicts in `designs/README.md`,
`designs/endo-gateway.md`, and `designs/gateway-package.md` on the first
commit (`41b1d400f`). The conflicts arose because phase-2's history
included 15 design-doc-only `(#343)`-tagged commits that the previous
weaver (`59079d`) had already woven into the new base. Their patch-ids
did not match (the previous weaver's woven resolutions altered the
final shape), so git could not auto-skip them and instead surfaced
each as a conflict.

Following the role's "do not silently drop commits" norm I considered
each commit explicitly. Decision: abort the straight rebase, then
cherry-pick onto `23bc11a9e` only the genuinely-new (source-touching)
phase-2 commits, in original order:

  - `c131b15e4` feat(gateway): UDS bootstrap registrar + proof-of-possession (#343)
  - `f8d1d223b` chore: Update yarn.lock
  - `59abce943` fix(gateway): @endo/hex, rename helpers, early-break nonce sweep
  - `f3de0d0fa` chore: Update yarn.lock
  - `741890f1d` refactor(gateway): rename UDS to sock terminology; drop Windows named-pipe scope (#388)

All 5 cherry-picks applied clean. The dropped commits (`41b1d400f`,
`6fe0f04b8`, `0c6693726`, `1ee0a73ba`, `48a4e98d5`, `4e2869ab1`,
`a7474b94d`, `ba4c81236`, `3a50d7b25`, `b8594c48e`, `13a2c4469`,
`e8d2aa445`, `adafd6f59`, `5ada59b4f`, `184dfdb99`, `89d68e71e`)
are all `(#343)`-tagged work that lives on the rebased new base
under different SHAs (see #343's rebased commits at `23bc11a9e..`).
Of these 16 dropped, git itself had detected 4 (`e8d2aa445`,
`5ada59b4f`, `184dfdb99`, `89d68e71e`) as previously-applied during
the initial straight-rebase attempt; the other 12 are dropped via
cherry-pick selection rather than via patch-id skip.

Result diff (`23bc11a9e..785ec6088`) is the genuine phase-2
delta: the bootstrap registrar files (bootstrap.js,
node-crypto-powers.js, proof-of-possession.js, sock-paths.js
plus tests), the #388 rename diff applied on top, and yarn.lock.
14 files changed, 2847 insertions, 76 deletions. No designs/
files touched.

## Phase-3: clean replay

`git rebase --onto 785ec6088 741890f1d bc807ca78` replayed both
phase-3 commits (`cdaf62756 admin daemon` and `bc807ca78 admin
sock ACL guarantee`) without conflict. Result: 9 files changed in
the diff vs new phase-2 head, all under `packages/gateway/`.

## Phase-4: one duplicate commit skipped

`git rebase --onto d9cd28081 bc807ca78 ee8297f0c` hit a conflict
on the first commit `baebd422c feat(gateway): separate admin sock
from bootstrap sock with ACL guarantee (#389)`. Inspection: the
commit message and title are identical to the #389 commit already
on the new base as `d9cd28081`. The diffs differ slightly (the new
base version has 5 additional insertions reflecting weaving with
the phase-2 sock terminology and explicit feature toggle
enumeration), but the intent is the same: this is the pre-rebase
phase-3 #389 commit duplicated into phase-4's history. Skipped via
`git rebase --skip`. The remaining 3 commits (`05966c5c9`,
`a658ea60e`, `ee8297f0c`) applied clean.

## Phase-5: clean replay

`git rebase --onto 7f98b9968 ee8297f0c 04eedbedf` replayed both
commits (`31ae4a6ff relay-policy admission` and `04eedbedf
Uint8Array + types.d.ts`) without conflict.

## Phase-6: three content-merge conflicts in 2 files; all woven

`git rebase --onto a1905d368 04eedbedf a57332f69` produced
conflicts in `packages/gateway/test/admin.test.js` twice and
`designs/README.md` once. All resolved per
`skills/conflict-resolution/SKILL.md` (no `--ours` / `--theirs`).

### Conflict 1: `admin.test.js` during commit `c606b6f57 feat(gateway): Git smart-HTTP handler`

Region: the `Gateway getAdmin works when sockBootstrap is disabled`
test's clarifying-comment block.

  - HEAD (= rebased phase-5 head): a paragraph enumerating OCapN-WS,
    captp-relay, git-HTTP, chat-hosting as features with dependencies
    on `sockBootstrap` or other toggles, framing the test as
    enumerating the minimal feature set.
  - REBASE_HEAD (= phase-6 c606b6f57): a paragraph naming only
    OCapN-WS as bootstrap-dependent, then adding a specific
    git-HTTP rationale (Feature 3, independent powers axis, needs
    `resolveRepo`; disabled to focus on admin facet's
    bootstrap-independence).

Both sides clarify the same `enableFeatures` configuration but
from different angles (HEAD: enumeration-style; REBASE_HEAD:
git-HTTP-specific). The woven third state kept HEAD's enumeration
(which already names git-HTTP) and appended REBASE_HEAD's specific
git-HTTP rationale (3 sentences).

Additional cleanup: the merged `enableFeatures` block had
`gitHttp: false` listed twice (once from HEAD's enumeration at
line 437, once added by phase-6's diff at line 442). The duplicate
was an artifact of the rebase combining HEAD's explicit
enumeration with the phase-6 diff that added `gitHttp: false`
as a new entry. Removed the duplicate; the remaining `gitHttp:
false` (HEAD's enumeration entry) provides the intended toggle.

### Conflict 2: `admin.test.js` during commit `119d21f45 refactor(gateway): one-repo-per-daemon`

Same region in the same test, but this commit's purpose is the
`resolveRepo` -> `serveRepo` rename per kriskowal review on #394.
The HEAD side (= my just-resolved Conflict-1 paragraph) said
"needs `resolveRepo`"; the REBASE_HEAD side updated the same
paragraph to say "needs `serveRepo`". Wove: kept my prior
paragraph but applied the `resolveRepo` -> `serveRepo` rename
verbatim.

### Conflict 3: `designs/README.md` during commit `a57332f69 docs(gateway): apply git-backbone-spike`

Region: the summary table's gateway-related rows.

  - HEAD (= rebased phase-5): two rows present, `endo-gateway-mcp`
    `(2026-05-29 | 2026-05-29 | Not Started)` and `gateway-package`
    `(2026-05-22 | 2026-05-29 | Proposed)`.
  - REBASE_HEAD (= phase-6 a57332f69): single `gateway-package` row
    with Updated date bumped to `2026-06-02` and Status text
    `Proposed (absorbs the removed endo-gateway design)`. Missing
    the `endo-gateway-mcp` row because the original phase-6 commit
    predates the `endo-gateway-mcp` design's addition to the table.

Wove: kept both rows; kept the `endo-gateway-mcp` row intact;
applied REBASE_HEAD's `2026-05-29 -> 2026-06-02` date bump on the
`gateway-package` row.

## Push results

All five force-with-lease pushes returned exit 0:

  - `741890f1d -> 785ec6088` on `design/gateway-package-phase-2`
  - `bc807ca78 -> d9cd28081` on `design/gateway-package-phase-3`
  - `ee8297f0c -> 7f98b9968` on `design/gateway-package-phase-4`
  - `04eedbedf -> a1905d368` on `design/gateway-package-phase-5`
  - `a57332f69 -> 0acea588b` on `design/gateway-package-phase-6`

PR base verification post-push: each PR still names its parent
branch in the natural chain (`#388:gateway-package`,
`#389:gateway-package-phase-2`, ..., `#394:gateway-package-phase-5`).
GitHub's PR view will recompute the diff against the parent's new
head automatically; no `gh pr edit --base` needed on any of the
five.

## Syntactic sanity

`node --check` passed on every touched JS file in every phase:

  - Phase-2: `bootstrap.js`, `config.js`, `node-crypto-powers.js`,
    `proof-of-possession.js`, `sock-paths.js`, `index.js`,
    `bootstrap.test.js`, `config.test.js`, `gateway.test.js`,
    `proof-of-possession.test.js`, `sock-paths.test.js`.
  - Phase-3: `admin.js`, `bootstrap.js`, `config.js`, `sock-paths.js`,
    `index.js`, `admin.test.js`, `config.test.js`, `sock-paths.test.js`.
  - Phase-4: `bootstrap.js`, `config.js`, `ocapn-ws.js`,
    `index.js`, `gateway.test.js`, `ocapn-ws.test.js`.
  - Phase-5: all 15 touched JS files including the new
    `relay-policy.js` and `types.d.ts`.
  - Phase-6: `git-http.js`, `types.d.ts`, `index.js`, the four
    affected test files including the rewoven `admin.test.js`.

No conflict markers remain in any tree. Full package tests not
run (the cascade replayed 19 distinct commits across 5 branches;
test-suite scope is CI's job and shepherd's next-stage concern).

## Definition of done

  - All 5 branches on their named new bases. [done]
  - Tree changes match each PR's original intent plus the noted
    conflict resolutions. [done]
  - Tests in affected packages pass: not run; rebases merged via
    git tree-merge plus my explicit resolutions; touched JS files
    pass `node --check`. CI will run on push. [partial]
  - All 5 force-with-lease pushes succeeded. [done]
  - PR base updates: not needed for any phase (natural chain). [done]
  - Result journal entry: this entry. [done]

Self-improvement: the phase-2 cherry-pick deviation worked well
but cost the rebase's auto-skip protection for the dropped
commits — I had to reason explicitly about each of the 16 dropped
commits to confirm they were `(#343)` duplicates. A weaver dealing
with a similarly-shaped cascade (where the upstream rebase wove
many commits and the dependent's history duplicates them) could
benefit from a pre-flight inventory: `git log --oneline
<new-base>..<head>` filtered against the upstream rebased range
to surface "commit X has equivalent Y on new base" pairs. The
straight-rebase auto-skip catches the patch-id-identical case;
the cherry-pick selection catches the patch-id-equivalent
("same intent, different woven shape") case. Worth a one-line
addition to `skills/conflict-resolution/SKILL.md` § Pitfalls or
to the weaver role's pre-rebase survey step (item 1). Marginal
value (the reasoning was discoverable from the conflict text
itself), so reportable here rather than escalated.
