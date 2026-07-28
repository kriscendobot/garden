<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-07-28T12:57:39Z -->

# fixer on endojs/endo-but-for-bots `llm`: close the form-data advisory in the dev toolchain

Surfaced during the botany review of
<https://github.com/endojs/endo-but-for-bots/pull/560> (closed as superseded).
This is NOT a Dependabot pull request; no Dependabot pull request covers it,
because the vulnerable package is transitive rather than direct.

## The finding

`yarn.lock` on `llm` resolves `form-data@npm:^4.0.0` to **`form-data@4.0.0`**,
which is affected by two advisories, both fixed in `form-data@4.0.6`:

- [GHSA-fjxv-7rqg-78g4](https://github.com/advisories/GHSA-fjxv-7rqg-78g4)
  CRITICAL, unsafe random function for choosing the multipart boundary.
- [GHSA-hmw2-7cc7-3qxx](https://github.com/advisories/GHSA-hmw2-7cc7-3qxx)
  HIGH, CRLF injection through unescaped multipart field names and filenames.

Both confirmed against <https://api.osv.dev/v1/query> for version `4.0.0`;
`4.0.6` queries clean.

Dependency chain, read out of `yarn.lock` on `llm`:

```
lerna@^8.2.4  ->  nx@20.8.2  ->  axios@1.10.0  ->  form-data@npm:^4.0.0  ->  4.0.0
```

## Calibration (read this before deciding urgency)

The chain is entirely **dev tooling**. `lerna` is a devDependency and
`form-data@4.0.0` is not reachable from any published package's runtime
dependency graph, so this is a build-host exposure, not something shipped to
consumers of the `@endo/*` packages. Treat it as hygiene with a
CRITICAL-labelled advisory attached, not an incident.

Note the lockfile carried a **second**, separate `form-data` resolution
(`form-data@npm:^4.0.4` to `4.0.5`, also affected by GHSA-hmw2-7cc7-3qxx) via
`openai@4.104.0`'s `@types/node-fetch` dependency. That one is removed by the
`openai` 6.48.0 upgrade in
<https://github.com/endojs/endo-but-for-bots/pull/870>, so it needs no work
here. Only the `^4.0.0` resolution is left for this job.

## The task

1. Re-confirm the finding against current `llm` before changing anything: the
   base may have moved, and `#866` (the all-minor-patch group) or `#870` may
   have landed in the meantime. `grep -n '^"form-data@' yarn.lock` and check
   each resolved version against OSV. If nothing under `4.0.6` remains,
   close the job as already-fixed and say so.
2. Otherwise, force the resolution up. The minimal change is a root
   `package.json` `resolutions` entry (`"form-data": "^4.0.6"`) plus the
   regenerated `yarn.lock`. Prefer whatever the repository already does for
   this class if there is an existing precedent in `package.json`; do not
   invent a new mechanism if one is in use.
3. Keep the `yarn.lock` change in its own `chore: Update yarn.lock` commit per
   the repository's lockfile discipline
   (`skills/yarn-lock-separate-commit/SKILL.md`).
4. Run the full local verification before pushing
   (`skills/local-verify/SKILL.md`, `skills/pre-push-gates/SKILL.md`). A
   resolution pin can move a shared transitive version under an unrelated
   package, so the test and lint suites are the check that it did not.
5. Open the pull request against `llm` and run the gauntlet
   (`skills/pr-creation-flow/SKILL.md`).

Commenting on this repository is covered by the standing authorization
(`journal/projects/endo-but-for-bots/README.md` § Standing authorizations).



<!-- garden-unpoisoned: endojs-endo-but-for-bots-form-data-advisory; spurious elapsed-constancy self-sample poison (fixed in main2 4a87fc7729); no real deadline overrun ever occurred -->

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  claimed_at: 2026-07-28T12:57:54Z
