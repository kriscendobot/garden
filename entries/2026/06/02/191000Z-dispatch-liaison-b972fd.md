---
ts: 2026-06-02T19:10:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--b972fd
prs:
  - repo: endojs/endo-but-for-bots
    pr: 387
    role: target
refs:
  - https://github.com/endojs/endo/pull/3294#pullrequestreview-4411367805
  - https://github.com/endojs/endo-but-for-bots/pull/387
---

# dispatch: fixer — carry gibson042 shell-scripting feedback from upstream endo#3294 to mirror #387

User directive: "apply feedback https://github.com/endojs/endo/pull/3294#pullrequestreview-4411367805 to our mirror of that PR."

gibson042 submitted a COMMENTED review on upstream endojs/endo#3294 with 10
inline shell-script suggestions on `packages/benchmark/install-engines.sh`.
Per memory rule `feedback_commented_review_with_asks_is_actionable.md` these
explicit suggestions are actionable. Apply them to our mirror #387
(`fix-benchmark-wget-engines-master`, head `c786ba635`).

## Inline comments to address

All on `packages/benchmark/install-engines.sh`:

1. **Line ~29 (XS_VERSION resolution)** — Replace the `curl -fsSL -o /dev/null
   -w '%{redirect_url}'` pipeline with the cleaner POSIX form:
   ```sh
   XS_VERSION="$(curl -fsSI \
       https://github.com/Moddable-OpenSource/moddable/releases/latest \
       | grep -i '^location:' \
       | tr -d '\r' \
       | sed -n 's#.*/releases/tag/##p')"
   ```
   `-fsSI` requests headers-only; the pipeline extracts the tag from the
   Location header. Preserve the `[ -z "$XS_VERSION" ]` fallback to the
   pinned `8.1.1`.

2. **Line ~84 (hoist `tmp` definition)** — gibson042 noted `$tmp` is
   referenced inside `install_xs` and `install_v8` (lines ~36, ~59) but
   only defined later in the `else` branch. Hoist the
   `tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT` to the top of the script
   (before the function definitions), so `$tmp` is well-defined when the
   functions are read and called. Drop the duplicate definition in the
   `else` branch.

3. **Lines ~44 and ~67 (terse missing-file checks)** — Replace the current
   `[ -f ... ] || { echo "XS extract missing xst binary" >&2; exit 1; }`
   and the matching d8 check with gibson042's preferred form using
   backticks in the message:
   ```sh
   [ -f "$HOME/.engines/engines/xs/xst" ] || { echo 'XS download missing file `xst`' >&2; exit 1; }
   ```
   and similarly for d8:
   ```sh
   [ -f "$HOME/.engines/engines/v8/d8" ] || { echo 'V8 download missing file `d8`' >&2; exit 1; }
   ```

4. **Lines ~45 and ~68 (verify execution after chmod)** — After
   `chmod +x` add an execution test:
   ```sh
   chmod +x "$HOME/.engines/engines/xs/xst"
   "$HOME/.engines/engines/xs/xst" -v || { echo 'XS download file `xst` execution failed' >&2; exit 1; }
   ```
   For d8 (note the `</dev/null` redirect since `d8 -v` is interactive):
   ```sh
   "$HOME/.engines/engines/v8/d8" -v </dev/null || { echo 'V8 download file `d8` execution failed' >&2; exit 1; }
   ```

5. **Line ~55 (use jq for V8 version extraction)** — gibson042 asked "Do
   we not have `jq`?". Replace the inline `python3 -c 'import
   json,sys;...'` with `jq -r .version`:
   ```sh
   V8_VERSION=$(curl -fsSL --max-time 60 \
       https://storage.googleapis.com/chromium-v8/official/canary/v8-linux64-rel-latest.json \
       | jq -r .version)
   ```
   jq is universally available in CI runners (Ubuntu, macOS, Linux); the
   GitHub Actions ubuntu-latest runners include it pre-installed.

6. **Line ~73 (v8 launcher shebang)** — Change the v8 launcher script's
   heredoc shebang from `#!/usr/bin/env bash` to `#!/bin/sh`. The launcher
   doesn't use bash-isms.

## Procedure

1. Edit `packages/benchmark/install-engines.sh` applying the 6 changes
   above. The file is on `fix-benchmark-wget-engines-master` head
   `c786ba635`.
2. Local smoke-check: `sh -n packages/benchmark/install-engines.sh` to
   confirm POSIX-sh syntactic validity (the shebang is now `/bin/sh`).
3. Commit:
   ```
   fix(benchmark): carry gibson042 shell-script feedback from endo#3294

   - Cleaner POSIX pipeline for XS_VERSION extraction (curl -fsSI + grep/tr/sed)
   - Hoist tmp + trap before function definitions so $tmp is defined at use
   - Terse missing-file checks with the `xst`/`d8` filename in the message
   - Verify XS/V8 execution after chmod
   - jq -r .version for V8 version extraction (drop python3)
   - v8 launcher heredoc shebang #!/bin/sh
   ```
4. Push regular append (no force): `git push origin
   HEAD:fix-benchmark-wget-engines-master`.
5. Report.

## Per-action authorizations

- Edit `packages/benchmark/install-engines.sh`. Authorized.
- `sh -n` syntax check. Authorized.
- Regular append push to
  `endojs/endo-but-for-bots:fix-benchmark-wget-engines-master`. Authorized.
- No PR comment is required (the maintainer will see the new commit and
  the upstream review will be addressed by carrying the same fix
  upstream separately when the time comes).

## Not authorized

- Editing files outside `packages/benchmark/install-engines.sh`.
- Force-pushing or retconning.
- Un-drafting / re-drafting.
- Merging.
- Posting PR comments on either repo.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/fixer--b972fd/garden/roles/COMMON.md`
2. `/home/kris/dispatches/fixer--b972fd/garden/roles/fixer/AGENT.md`
3. Skills referenced by the fixer just-in-time.

Project worktree at `project/` on `fix-benchmark-wget-engines-master`
(head `c786ba635`).

## Report

A `result` journal entry. Include: new head SHA, exact lines changed
(diff summary), `sh -n` exit code, and any deviations from the
per-comment plan above.
