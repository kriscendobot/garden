#!/bin/bash
# no-pull-citations — reject pull/<n> URLs and bare #<n> issue/PR refs in
# changed paths under packages/**/*.{js,md}. Root-level docs (CHANGELOG.md,
# README.md at repo root) are exempt because they legitimately cite PRs.
# Provenance: PR #75 r3267735686 ("We do not cite pull requests in the bot
# repository" in package code).

set -uo pipefail

paths=$(git diff --cached --name-only --diff-filter=AM 2>/dev/null \
        | grep -E '^packages/.*\.(js|md|ts)$' || true)
if [ -z "$paths" ]; then
  base=$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null | sed 's|^origin/||' || echo master)
  paths=$(git diff "origin/$base...HEAD" --name-only --diff-filter=AM 2>/dev/null \
          | grep -E '^packages/.*\.(js|md|ts)$' || true)
fi

findings=""
for p in $paths; do
  [ -f "$p" ] || continue
  # Look only at lines the current diff adds (avoid flagging pre-existing refs).
  added=$(git diff --cached -U0 -- "$p" 2>/dev/null | grep -E '^\+[^+]' || true)
  if [ -z "$added" ]; then
    added=$(git diff "origin/$base...HEAD" -U0 -- "$p" 2>/dev/null | grep -E '^\+[^+]' || true)
  fi
  if echo "$added" | grep -E 'github\.com/[^/]+/[^/]+/pull/[0-9]+' >/dev/null 2>&1; then
    findings="$findings$p: pull-request URL
"
  fi
  # Bare #<n> issue/PR refs in added lines. Allow #N preceded by 'Refs', 'Closes',
  # 'Fixes', etc. in commit-message-style preamble; but those should only be in
  # commit messages and PR bodies, not in package code or test files.
  if echo "$added" | grep -E '(^|[[:space:]])#[0-9]{2,5}([[:space:]]|$|[.,;])' >/dev/null 2>&1; then
    findings="$findings$p: bare #<n> reference
"
  fi
done

if [ -z "$findings" ]; then
  echo "pass"
  exit 0
fi
printf 'fail: %s' "$findings"
exit 1
