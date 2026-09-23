---
ts: 2026-05-22T00:56:11Z
kind: result
role: builder
project: endo-but-for-bots
refs:
  - entries/2026/05/22/004732Z-dispatch-liaison-23d295.md
---

Mirrored endojs/endo#3047 ("docs: Populate READMEs") onto endo-but-for-bots as PR #344, draft, base master, head `b299f855cf24181811e89b25bc8fbe697aa8a4c0`.

PR URL: https://github.com/endojs/endo-but-for-bots/pull/344

**Commit shape**: cherry-picked the upstream 10-commit range cleanly, preserving the upstream commit ordering and per-package conventional-commit shape. The upstream base (`24b52d7928`) is reachable from endo-but-for-bots master, so no re-formation was needed. The two "fixup" commits (cli aliases, docs netstring) are preserved as upstream chose not to squash them. Net diff invariant against upstream PR: 29 files, +661/-41.

Commits on `mirror/3047-readmes`:

- `1db2f58f0` docs: A note about abbreviations in style
- `253d95d7c` docs(cjs-module-analyzer): Add README
- `77930ee5c` docs(cli): Expand README
- `67d8dcd3b` fixup cli aliases
- `9c11dfc2d` docs(netstring): Grow README
- `af593bff4` docs(stream-node): Complete README
- `9d830484a` docs: Normalize headers and license in READMEs
- `b360ecd23` docs(stream-node): Cross-reference Node.js docs
- `4dcc1c5d6` fixup docs netstring
- `b299f855c` docs(stream): Explain duplex streams indiom

**Merge conflicts**: none. Two commits triggered auto-merge text-merge resolution (no conflict markers): the "Normalize headers and license" commit auto-merged in `packages/bundle-source/README.md` and `packages/ocapn-noise/README.md`; the "fixup docs netstring" commit auto-merged in `packages/netstring/reader.js`. Diffs verified against upstream PR's file list.

**Local test status**:

- `yarn install`: pass (warnings about peer-dependency drift on master, pre-existing, not introduced by this PR).
- `yarn format`: pass (no changes).
- `yarn lint`: pass (two pre-existing warnings on files outside this PR's scope: `packages/evasive-transform/src/index.js`, `packages/ses/src/compartment.js`).
- `yarn docs`: pass (66 warnings, all pre-existing on master, none introduced by this PR's prose).
- `yarn typecheck`: no such script on this repo; skipped per gate's `jq -e` guard.
- `pre-push-gates.sh`: gate exits 1; findings are out of scope for a mirror dispatch and belong to the follow-on fixer:
  - `no-inline-import-jsdoc`: one finding in `packages/evasive-transform/src/index.js`, pre-existing on master, not in this PR's diff.
  - `security-md-hash-uniform`: three divergent `SECURITY.md` files (`packages/immutable-arraybuffer/`, `packages/bytes/`, `packages/hex/`, `packages/panic/`), pre-existing on master, not in this PR's diff.
  - `sentence-per-line-md`: roughly 35 multi-sentence-line findings spanning `CONTRIBUTING.md` and the touched READMEs. Some are in upstream-PR prose (the `docs(cli)`, `docs(netstring)`, `docs(stream-node)` README content); others are in pre-existing master prose the probe also reads because the whole file is in the diff. The orchestrator's follow-on fixer dispatch is the right place to land any sentence-per-line rewrites, since they overlap the upstream review-feedback surface this dispatch was told not to touch.

The lint `--fix` auto-staged edits to the two pre-existing-warning files (`evasive-transform/src/index.js`, `ses/src/compartment.js`); I reverted them before push since they were outside the mirror's scope.

**READMEs touched** (one bullet per package):

- CONTRIBUTING.md (new "Coding Style" abbreviations section)
- packages/base64/README.md (license/header normalize)
- packages/bundle-source/README.md (license/header normalize)
- packages/cache-map/README.md (license/header normalize)
- packages/captp/README.md (license/header normalize)
- packages/cjs-module-analyzer/README.md (new content, +107)
- packages/cli/README.md (expand + alias-fixup, +186/-4)
- packages/compartment-mapper/README.md (license/header normalize)
- packages/env-options/README.md (license/header normalize)
- packages/eventual-send/README.md (license/header normalize)
- packages/exo/README.md (license/header normalize)
- packages/immutable-arraybuffer/README.md (license/header normalize)
- packages/import-bundle/README.md (license/header normalize)
- packages/marshal/README.md (license/header normalize)
- packages/nat/README.md (license/header normalize)
- packages/netstring/README.md (grow + fixup, +144/-13)
- packages/netstring/reader.js (one-line comment edit, came with the netstring docs commits)
- packages/ocapn-noise/README.md (license/header normalize)
- packages/panic/README.md (license/header normalize)
- packages/pass-style/README.md (license/header normalize)
- packages/path-compare/README.md (license/header normalize)
- packages/patterns/README.md (license/header normalize)
- packages/promise-kit/README.md (license/header normalize)
- packages/ses-ava/README.md (license/header normalize)
- packages/ses/README.md (license/header normalize)
- packages/skel/README.md (license/header normalize)
- packages/stream-node/README.md (complete + cross-ref, +90/-2)
- packages/stream/README.md (explain duplex idiom, +15/-1)
- packages/trampoline/README.md (license/header normalize)

Self-improvement: the `sentence-per-line-md` probe in `pre-push-gates` reads the entire file rather than just the changed hunks; on a docs-heavy mirror where the upstream PR touches whole READMEs, the probe surfaces every existing multi-sentence line in those files (including master-side prose), not just lines the diff introduced. This is by design (PR #75 provenance) but is worth flagging in the probe's notes-from-the-field as a known noise pattern for mirror dispatches, so future builders know to triage rather than panic.
