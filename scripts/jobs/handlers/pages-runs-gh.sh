#!/bin/bash
# pages-runs-gh.sh — default GitHub-Pages-build run source for pages-watcher.sh.
#
# Invoked as: pages-runs-gh.sh <owner/name> [<workflow>]
#
# Emits one TSV line per recent run of the Pages build/deploy workflow, NEWEST
# FIRST (the order `gh run list` returns):
#
#   databaseId  status  conclusion  headSha  url
#
# `status` is queued|in_progress|completed; `conclusion` (only meaningful once
# completed) is success|failure|cancelled|timed_out|… . The watcher reads only the
# NEWEST line to decide whether the live site's last deploy is red, green, or still
# building, so a short window (a handful of runs) is plenty.
#
# The workflow defaults to `pages-build-deployment` — GitHub's built-in dynamic
# "pages build and deployment" pipeline that fires on every push to the Pages source
# branch (for kriskowal/garden that is main2/docs). Pass an explicit workflow name to
# watch a custom Pages action instead.
#
# Monitoring safety: this handler reads only WORKFLOW-RUN metadata (id, status,
# conclusion, head SHA, URL) of the garden's OWN repo — never a PR body, an issue, or
# a comment — and none of it is fed to an LLM. The watcher's job body is deterministic.
# So, like the ci-watcher, the pages-watcher is injection-safe by construction; it
# introduces no untrusted-text surface (CLAUDE.md § Monitoring safety constraint).
#
# Silent-failure discipline (the 2026-06-24 jq-outage lesson): require_tools fails
# LOUD on a missing binary; a structural gh failure surfaces its stderr and exits
# nonzero so the watcher never mistakes a broken enumeration for "no runs / all green".

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="pages-runs"

repo="${1:?usage: pages-runs-gh.sh <owner/name> [<workflow>]}"
workflow="${2:-pages-build-deployment}"

require_tools gh jq

# One read. A structural failure here must NOT be swallowed into an empty list (which
# would read as "no runs / nothing red" and silently stop every pages-shepherd) —
# surface gh's stderr and exit nonzero so the watcher skips the tick rather than guess.
gh run list -R "$repo" --workflow "$workflow" -L "${GARDEN_PAGES_RUN_LIMIT:-10}" \
  --json databaseId,status,conclusion,headSha,url \
  | jq -r '.[]
      | [ (.databaseId|tostring),
          (.status // ""),
          (.conclusion // ""),
          (.headSha // ""),
          (.url // "") ]
      | @tsv'
