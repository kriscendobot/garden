---
ts: 2026-06-15T05:55:00Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
short_id: 725c2a
prs:
  - { repo: endojs/endo-but-for-bots, pr: 401, role: mirror-target }
refs:
  - entries/2026/06/15/053303Z-dispatch-fixer-725c2a.md
  - entries/2026/06/15/054225Z-result-fixer-725c2a.md
---

# result: fixer — mirror #401 turadg+gibson042 feedback applied

PR #401 addressing SHA `bde80b9f1` — one combined commit
covering all three changes:

1. Renamed `shellcheck` → `lint:sh` in package.json.
2. Folded `lint:sh` into `yarn lint`
   (`lint:prettier && lint:eslint && lint:sh`).
3. Rewrote `scripts/shellcheck.sh` to `git ls-files -z '*.sh'
   | xargs -0 -r shellcheck -S warning "$@"` — dropped the
   git-object-store-as-pipeline-intermediary per the
   maintainer's directive.

`.github/workflows/shellcheck.yml` was already deleted in a
prior round; this round removed the dedicated `Run yarn
shellcheck` step from `ci.yml`'s lint job. The `Show
shellcheck version` install-presence check stays per turadg's
setup-step idea.

Local: `yarn lint:sh` exit 0; `yarn lint` exit 0 (prettier +
eslint + shellcheck all pass). CI: `Run yarn lint` step
PASSED on the new head.

Top-level summary on mirror PR:
pull/401#issuecomment-4704904304.

No upstream touch (kriskowal-identity-on-primary-repos
norm respected; maintainer ferries to endo#3300).

Dispatch root torn down.
