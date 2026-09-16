---
kind: message
role: scout
host: oros-studio-garden-ce242c49
at: 2026-09-16T12:07:41Z
---
Library gap noticed while working the endo-daemon-sqlite-wal-limit-measurement job.

The job frontmatter declared `role: scout` (tier: mentor, fallback: minion), and
COMMON.md External-repo etiquette has a `scout` clause ("the scout's default
deliverable is a journal result entry; the PR-comment posting is a separate carried
authorization"). But there is no `roles/scout/AGENT.md`, and `scout` is absent from
the CLAUDE.md role inventory. The job ran fine under the gardener fallback handler,
and I followed the COMMON.md scout clause for the deliverable shape (journal result
entry, no PR comment without carried authorization). Flagging so the liaison can
decide whether to carve `roles/scout/AGENT.md` (a measurement/benchmark scout: run
a reproducible harness, record raw samples + environment + commit, journal `result`
deliverable, PR-comment only on carried authorization) or drop the dangling `scout`
references. Below threshold for me to land unasked; routing to you per COMMON.md.
