---
ts: 2026-05-21T11:51:37Z
kind: result
role: fixer
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
---

Fixer dispatch on PR endojs/endo-but-for-bots#125 ("Please shepherd"
follow-up).

The dispatch named a pre-existing breakage in
`packages/ocapn/test/netlayer-tcp-syrup.test.js`: the file imports
`makeClient` from `../src/client/index.js`, but the `llm` branch's
`@endo/ocapn` exports `makeOcapn` instead. The test came in via the
upstream merge of commit `bdb9ddc5` ("feat(syrup-frame): add
@endo/syrup-frame package and opt-in syrup framing for OCapN
TCP-for-testing"). Three options were offered: (1) skip the test, (2)
port to `makeOcapn`, (3) implement `makeClient` as a wrapper.

Choice: option 1 (skip the broken test). Rationale: `makeOcapn` is
async with a different call shape (`{ codec, network }` returning a
`Client`) versus the synchronous `makeClient({ debugLabel,
debugMode })` the tests use; the test bodies further call
`client.registerNetlayer`, `client.shutdown`, etc., which are not
direct surface of `makeOcapn`. A faithful port would be a substantial
rewrite, and option 3 would require introducing a `makeClient` alias
in `src/client/index.js` whose shape no longer exists. Option 1 is
the unblocker the dispatch asked for; the commit body names the
upstream-port follow-up so it survives as a tracked debt.

Mechanics:

- Rebased PR branch `feat/edit-message` onto current `origin/llm`
  (head 751c9628c). The rebase took the single PR commit cleanly; no
  conflicts. Pre-rebase HEAD was 604d88a58, post-rebase 75f6670b8
  (PR's own commit) plus 93e9cd2d0 (this commit).
- Replaced the 233-line test file with a 14-line stub: header comment
  naming the owed port, plus one `test.skip` placeholder so the file
  still parses as an AVA test module and `import/named` no longer
  resolves the stale `makeClient` import.
- Ran `pre-push-gates.sh`. The gate's auto-fix stages staged a bunch
  of unrelated format/lint drift across `llm` (better-sqlite3-xs.js,
  bus-daemon-rust-xs.js, daemon.js, host.js, etc.); those changes
  are llm's hygiene debt, not this PR's lane, and were reverted
  before commit. The gate's `no-pull-citations` probe initially
  flagged the `#3256` reference in the comment; reworded the comment
  to name the commit SHA instead.
- Force-with-lease push to `feat/edit-message` succeeded (push
  output: `+ 604d88a58...93e9cd2d0 HEAD -> feat/edit-message (forced
  update)`).

Post-fix CI sample (3 minutes after push, run 26223607702):

- `cover (20.x, ubuntu-latest)`: **pass** (was FAILURE).
- `cover (24.x, ubuntu-latest)`: **pass** (was FAILURE).
- `lint`: still **fail**, but at a different step
  (`Check SECURITY.md uniformity`), not at `yarn lint`. Root cause:
  `packages/bytes/SECURITY.md` has hash
  `d9acd9c238af1e13acd1ee0f8020dc542a579a828d70520f9829b6496ecc4e97`
  while the other 69 `packages/*/SECURITY.md` share
  `071c74499d6d695e590ea3816ab579cb2e40639adcf7cf75e2702c732071f41d`.
  This is pre-existing on `llm`, not introduced by this PR. The
  pre-push-gates `security-md-hash-uniform` probe flagged the same
  divergence; it is a separate llm hygiene fix.
- `zizmor` (workflow security audit): still **fail**, also
  pre-existing on `llm` (workflow-file findings, not PR content).

The originating dispatch's headline failure (`makeClient not found`
in the lint job, plus the `cover` jobs' test-load failure on the same
module) is resolved. The two remaining red checks are llm-base
hygiene debts that any PR open against llm will hit; addressing them
is out of scope for the "shepherd #125" ask.

Commit SHA: `93e9cd2d00bb2bd007efe2515a8b2b35f26c6364`.

Self-improvement: noting for a future row on
`skills/pre-push-gates/SKILL.md` § Pitfalls: when a fixer is invoked
on a PR whose base branch carries its own format/lint debt, the
auto-fix stages will eagerly stage drift across the base. The fixer
must `git checkout HEAD -- <unrelated paths>` before committing so
the PR's commit stays bounded to the named fix; the gate could
optionally restrict auto-fix to the changed-path set instead of
running `yarn format` over the whole tree. Posting this to the
liaison as a candidate skill row.
