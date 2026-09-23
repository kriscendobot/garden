---
ts: 2026-06-02T23:23:01Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
dispatch_root: /home/kris/dispatches/fixer--7fea4c
prs:
  - repo: endojs/endo-but-for-bots
    pr: 387
    role: target
refs:
  - entries/2026/06/02/231831Z-dispatch-liaison-7fea4c.md
  - https://github.com/endojs/endo/pull/3294#pullrequestreview-4414262302
  - https://github.com/endojs/endo/pull/3294#discussion_r3344974262
  - https://github.com/endojs/endo-but-for-bots/pull/387#issuecomment-4607773122
---

# result: fixer — #387 carry gibson042 relative-traversal suggestion

Carried gibson042's inline suggestion from upstream endo#3294
review `4414262302` (comment `3344974262`) into the v8 wrapper
heredoc in `packages/benchmark/install-engines.sh` on mirror PR
endojs/endo-but-for-bots#387.

## Decision: Option B (retcon)

Per the dispatch brief, preserved the two-commit shape the
maintainer prefers for this PR. Tagged pre-retcon at
`e22369065`, reset --mixed to `origin/master-814dfa1`,
restaged impl files in one commit (5 files: README.md,
install-engines.sh, package.json, run-tests.sh,
packages/hex/test/run-benches.sh), restaged yarn.lock in a
separate `chore: Update yarn.lock` commit. Net-diff invariance
verified: `git diff pre-retcon-7fea4c..HEAD` showed exactly the
heredoc edit and nothing else.

The benchmark + hex split was kept inside the single
`fix(benchmark)` commit because the hex `run-benches.sh` change
is a co-touch of the same engine-install rename (consults
`$HOME/.engines/bin/` instead of `$HOME/.esvu/bin/`); the
original maintainer-reviewed grouping had them together, and
the dispatch brief's preserve-two-commit-shape instruction took
precedence over the per-package retcon norm here.

## Layout mismatch resolution: Option 1

gibson042's suggestion assumed `~/.engines/{bin,v8}/` (one
level under `.engines`). The actual layout in this branch is
`~/.engines/{bin,engines/v8}/` (v8 lives one level deeper).
The wrapper at `~/.engines/bin/v8` resolves
`dirname(dirname($0))` to `~/.engines`, so the d8 invocation
inside the wrapper uses `"$engines_dir/engines/v8/d8"` rather
than the `"$engines_dir/v8/d8"` from gibson042's literal text.
Same pattern (relative traversal from `$0`); the path-segment
count adjusts to the actual on-disk layout.

Layout-flattening (the other resolution path) was explicitly
out of scope per the dispatch brief.

## Final heredoc body

The replacement in `install-engines.sh` (the `install_v8` func):

```sh
    # Launcher script: d8 finds icudtl.dat in its own directory; the
    # snapshot blob is passed explicitly. Use relative traversal from $0
    # so the install is relocatable (the absolute $HOME is not baked in
    # at install time).
    cat > "$HOME/.engines/bin/v8" <<'EOF'
#!/bin/sh
engines_bin_dir="$(dirname "$0")"
engines_dir="$(dirname "$engines_bin_dir")"
"$engines_dir/engines/v8/d8" --snapshot_blob="$engines_dir/engines/v8/snapshot_blob.bin" "$@"
EOF
    chmod 0755 "$HOME/.engines/bin/v8"
```

Quoted heredoc terminator (`<<'EOF'`) so the inner `$0`,
`$(dirname …)`, and `$@` are resolved at wrapper runtime, not
at install time. The wrapper file written to
`$HOME/.engines/bin/v8` contains the literal four lines after
the shebang.

Wrapper-invocation trace on a sample install:

- `$0` = `$HOME/.engines/bin/v8`
- `engines_bin_dir` = `$HOME/.engines/bin`
- `engines_dir` = `$HOME/.engines`
- exec = `$HOME/.engines/engines/v8/d8 --snapshot_blob=$HOME/.engines/engines/v8/snapshot_blob.bin "$@"`

Sanity-tested in a `/tmp` simulation: `dirname` traversal
resolves as expected.

## Gates

- `bash -n packages/benchmark/install-engines.sh` exit 0.
- `shellcheck -S warning packages/benchmark/install-engines.sh` exit 0.

## Push

- Pre-retcon head: `e22369065bc48d72346f4159fe78e8be568f16eb`.
- Post-retcon head: `a179d5aa8`.
- `git push --force-with-lease=fix-benchmark-wget-engines-master:e22369065... origin HEAD:fix-benchmark-wget-engines-master`
  succeeded; lease anchor honored.

## Top-level PR comment

Posted on endojs/endo-but-for-bots#387:
https://github.com/endojs/endo-but-for-bots/pull/387#issuecomment-4607773122
(comment id `4607773122`). Acknowledges gibson042's suggestion,
explains the one-segment layout adjustment, names the new head,
cites the green gates.

The upstream-side ack on endo#3294 thread `3344974262` is left
for the boatman on the next ferry, per the dispatch brief.

Self-improvement: nothing this time. The dispatch brief's
layout-mismatch callout was load-bearing and prevented a
copy-paste application of a suggestion that would have shipped
a broken wrapper; the existing `retcon` skill + brief-supplied
Option 1 vs Option 2 framing covered the decision cleanly.
