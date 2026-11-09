---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-11-09T01:13:08Z
---
# Dependabotany — endojs/endo-but-for-bots PR #1654 — HELD (fix landed; CI green modulo pre-existing test-xs)

project: endo-but-for-bots

Update to the 2026-11-08T20:34Z row (entries/2026/11/08/203412Z-message-botanist-c57a23.md). The escalated ava 8.3.0 strict `t.timeout()` deadline repair has landed on the PR head branch (garden bot identity, head gate intact). Head is now fbccb9665aa5bbbb8010a5970293cdede52a926b:
- test: absorb ava 8.3 wall-clock t.timeout() deadline (widened <=3s budgets to 10s; the 17 MiB spawner drain runs serially at 60s; macOS fs.watch at 30s; bwrap timeout+cancel at 45s, reap wait at 10s)
- test: raise 5s t.timeout() hang guards to 10s (repo-wide sweep, 127 files)

CI on fbccb9665 (re-verified 2026-11-09 via gh pr view): cover 22.x/24.x PASS, lint PASS, test 22.x/24.x on ubuntu and macos-15 PASS (two flaky legs passed on rerun: the bwrap process-group reap flake, also red on base llm, and a macOS runner checkout failure). mergeable=MERGEABLE. The only red is test-xs: the hardened262 ThrowTypeError/intrinsic-metadata.js + @endo/benchmark threshold baseline, which predates this PR on base llm.

Row stays OPEN. The terminal verdict belongs to the daily dependabotany-recheck-endo-but-for-bots backstop: expected MERGE-NOW (migration-disclosure duty applies: the green rests on the two test commits above), modulo the pre-existing test-xs red.

Carried forward from a dead-lettered fixer message (job deadmail-20261109T010715Z-fd3af9).
