---
ts: 2026-05-29T04:02:22Z
kind: result
role: builder
repo: endojs/endo
project: endo
---

Hardened `packages/benchmark/install-engines.sh` against the
intermittent download flakiness from #3289 (Moddable XS release on
GitHub; V8 canary on Google's chromium-v8 GCS bucket).

PR: https://github.com/kriscendobot/endo/pull/1 (draft).
Base: `master-052b048` (frozen snapshot of upstream master at the
dispatched HEAD; pushed to kriscendobot/endo).
Head: `fix/3289-install-engines-retry`.
Affected packages: `@endo/benchmark` (private; CI helper only).

The change wraps each `yarn dlx esvu install <engine>` call in a
small retry loop (three attempts, five-second backoff). Semantics
preserved:

- `are_engines_installed` short-circuit unchanged.
- Both engines still attempted even if the first ultimately fails.
- On final failure, both captured outputs are printed and the script
  exits 1 with the existing diagnostic.
- `chmod +x` and the `eshost --add` / `eshost --list` tail unchanged.
- No CI workflow YAML changes.

Pre-push gate (skills/pre-push-gates/SKILL.md): the staged diff
passed the auto-fix stages cleanly (Prettier nudged the file's own
trailing whitespace; no unrelated changes were staged). The
`security-md-hash-uniform` probe failed on pre-existing SECURITY.md
drift in three packages (immutable-arraybuffer, hex, panic) that are
out of scope for this PR; left unaddressed and noted here. The
`no-inline-import-jsdoc` probe also surfaced a pre-existing finding
in evasive-transform; that auto-fix attempted by `yarn lint --fix` on
an unrelated file (compartment.js) was unstaged. Both findings are
unrelated drift, not introduced by this PR.

Changeset: not added. The change is to a CI helper shell script in a
private package (`@endo/benchmark`); none of the past three commits
that touched `packages/benchmark/install-engines.sh` shipped a
changeset entry. The script does not affect downstream consumers of
the published npm package contents.

Next: liaison runs the gamut (cleaner / judge / fixer / un-draft) per
`skills/pr-creation-flow/SKILL.md`.

Self-improvement: the frozen-base-branch skill enumerates
kriscendobot/endo-but-for-bots and kriscendobot/agoric-sdk as the
fork-side-PR forks; this dispatch added kriscendobot/endo to that
set. A one-line *Notes from the field* row on the skill (or a scope
sentence update) would record that the convention now extends to
endojs/endo via the kriscendobot/endo fork, so the next builder doing
a cross-org PR against endojs/endo does not need to reason it out
from the existing endo-but-for-bots example.
