---
ts: 2026-06-02T19:14:38Z
kind: dispatch
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/builder--b6cf01
short_id: b6cf01
refs:
  - designs/gateway-package.md
---

# dispatch: builder — yarn shellcheck + CI workflow over all .sh files

Branch off `endojs/endo-but-for-bots:master` (HEAD 814dfa1f).
Open DRAFT PR.

Deliverables:

1. **Top-level `yarn shellcheck` script** in the root
   `package.json` that runs shellcheck against every `.sh` file
   tracked in the repo.
2. **GitHub Actions workflow** running `yarn shellcheck` on PR
   and push. The workflow either uses `paths: ['**/*.sh',
   '**/package.json']` filtering OR the script itself detects
   no-`.sh`-diff-from-base and exits 0. Maintainer asked for
   skip-when-no-`.sh`-touched; either shape satisfies it (the
   builder picks the cleaner option).
3. Apply (or surface) any existing shellcheck failures the
   first run catches. The repo's existing `.sh` files
   (`packages/benchmark/install-engines.sh`,
   `packages/hex/test/run-benches.sh`, others) may already be
   clean; if not, the builder fixes the smallest set to make
   the gate green or surfaces the diagnostics as a top-level
   PR comment for triage.

The builder uses `-S warning` severity per recent garden
precedent unless the existing `.shellcheckrc` (if any) overrides.

Full brief in the prompt.
