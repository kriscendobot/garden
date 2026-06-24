# mentor: capture the journalctl+entries digest by hash, pass the SHA

Per designs/self-healing-audit.md (Part B #2): mentor-claude.sh inlines the
whole `journalctl -p warning` tail plus full journal entry bodies into the
claude -p prompt (line ~36) — the single largest wholesale-inlined blob in the
fleet.

Convert scripts/jobs/mentor.sh + handlers/mentor-claude.sh to hash the digest
into the journal via the capture helper (see self-heal-common-capture-helper)
and pass only the SHA into the prompt; have the mentor inspect selectively via
`git cat-file -p` + grep/sed rather than reading the whole tail. Preserve the
quiet-on-success and retry-on-handler-failure behavior. Build in an isolated
worktree off origin/main2.

---
claim:
  host: endolinbot
  gardener: 47
  claimed_at: 2026-06-24T20:00:52Z
