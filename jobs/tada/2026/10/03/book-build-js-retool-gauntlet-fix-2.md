I applied round 2's must-fix items to kriscendobot/garden-book#6 and pushed them as six follow-up commits. The PR head moved from `8fccc61` to `bfdd5b7`, and the result is green.

**What changed:**
- **Catalog anchors** (`4bfe830`, saboteur 1–2, corner-prober 4): a heading now gets a role or skill anchor only when it is that entry's own catalog heading. Before, the regex took the last backticked name, so `5.1 \`builder\` (built on \`foreman\`)` registered `foreman`. Added a regression test; the full book builds byte-identical to the pre-fix baseline.
- **Link normalization** (`25325d4`, assessor 1): an extra leading `..` is now kept, as Python's `posixpath.normpath` does, so a link with one `..` too many produces a visibly broken URL instead of quietly pointing at the wrong file.
- **Powers name** (`d898bcb`): a pet name is accepted only if it matches `garden-book-<name>`. The old check refused only `sites`; now `@agent`, the other reserved names and near-miss spellings are rejected too, with tests. This addresses breaker, purist, wire-watcher, locksmith, spec-keeper, archivist, curator and pruner. The same commit:
  - moves the constraint into JSDoc;
  - renames the read-side parameter to `builtTree`;
  - corrects the base64 exemption comment;
  - removes the README sentence about internal architecture.
- **JSON-RPC tests** (`a97fbc5`, corner-prober 3): cover an `error` reply, and several pending calls all being rejected when the bridge exits.
- **Packaging** (`59b4dfd`, engine-realist, packager): declares Node `>=20.19.0`, the minimum a markdown dependency (`entities@8`) needs, and drops the leftover Python `.gitignore` entries.
- **Lockfile** (`bfdd5b7`): `package-lock.json` updated in its own commit.

**Verification:** after `npm ci`, `npm test` passes 18/18 at every commit, and `node build/build.mjs chapters out` succeeds. The CI wait (`ci-wait-merge.sh` with `GARDEN_CI_ALLOW_NO_CHECKS=1`) returned rc 0. The repo has no Actions workflows, so that "green" means no checks exist, not that any passed.

**PR comment:** I posted a summary of this round on the PR, including what was declined and a loop-status line, which covers scribe's finding (https://github.com/kriscendobot/garden-book/pull/6#issuecomment-5967233588).

**Declined (all comment-only or should-fix):**
- Depending on `@endo/base64`; I corrected the comment instead.
- fast-check property tests, since the repo has no fast-check dependency.
- A c8 coverage report.
- A timeout on JSON-RPC calls, since the bridge is a trusted local script.
- Tests for multi-part chapters and duplicate chapter keys.
- Replacing the positional table-of-contents tuples with named fields.

**Follow-up:** scribe's root-cause point still stands. The gauntlet fix-stage directive in `scripts/jobs/gauntlet.sh` has no step to post a summary comment on the PR. That belongs to a separate garden job and is not addressed here.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/book-build-js-retool-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (2593081 cached reads)
- Output: 17518 tokens
- Cost: $1.6421762000000004
- Wall-clock: 201s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
