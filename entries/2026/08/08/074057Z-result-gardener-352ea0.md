---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-08T07:41:00Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
pr: 969
seat: warden

## warden

**Verdict: request-changes**

Scope reviewed: the 5 `ironhorse-262` commits on top of the merge base with `origin/llm` (`65959a5d5..HEAD`, 12 files). The worktree's local `llm` ref is stale and `git diff llm...HEAD` pulls in ~3400 unrelated files; the real PR scope is the sweep automation.

No JavaScript ships in this diff, so there is no `harden` call site, no `globalThis` write, no prototype walk, and no capability crossing a vat boundary to audit. `escape_html` (`report.rs:956`) covers `& < > " '` and every interpolation in `to_html`, `category_table`, and `reason_table` is escaped; the document contains no `<script>` and no attribute-position interpolation, so the gh-pages artifact is injection-clean. The workflow indirects every `workflow_dispatch` input through `env:`, pins actions by SHA, and holds `contents: read` with `persist-credentials: false`.

The seat's findings are about the hardened-JS axis this automation publishes claims over.

**1. must-fix — the published report never discloses that the SES axis is absent.** `full-run.sh:189` hardcodes `ses_mode="none"` and neither the script nor `.github/workflows/ironhorse-full-test262.yml` plumbs `--ses-mode`, so every report this automation can produce is a non-hardened run: no `lockdown()`, no `Compartment` (`xst.rs:135-144`), with `lockdown` / `Compartment` / `ses-xs-parity` on the unconditional skip list (`xst.rs:65-70`). The lede at `report.rs:1018-1021` names the strict-mode gap and flips its oracle claim off a typed field (`oracle_description`, `report.rs:1013-1017`) but has no equivalent for SES. A reader of the published page sees "The complete authoritative TC39 test262 corpus run against the Ironhorse engine, oracle-locked to XS ... strict-mode executions are not implemented" and the sole SES signal is a `SES mode: none` row far below, a token they cannot interpret without reading `xst.rs`. An engine whose reason for existing is Hardened JavaScript must name the missing hardened-JS axis where it names the missing strict-mode axis. Fix: add a `ses_description` beside `oracle_description` on the same typed field, and state it in `scripts/README.md`, which mentions the SES axis nowhere.
[proposed-rule: skills/regression-evidence/SKILL.md - a published conformance artifact discloses every axis it did not run at the same altitude as its headline claim, derived from a typed provenance field, never from a provenance table row alone.]

**2. should-fix — `is_whole_corpus()` ignores `completion`.** `report.rs:289-296` gates the "complete authoritative TC39 test262 corpus" claim on `scope == "whole-corpus"` plus a 40-hex SHA, but not on `completion`. A batch that fails three attempts is quarantined and still promoted into `results/` (`full-run.sh:284-292`), so the completeness gate at `full-run.sh:311` passes, `completion` is set to `incomplete` (`full-run.sh:317-320`), and the report publishes the unqualified "complete" headline with the quarantined cases folded into Infrastructure. The typed-provenance guard exists precisely so "a crafted `config` string can never publish a false whole-corpus claim" (`report.rs:266-269`); it is incomplete along the axis the same PR introduced. Fix: require `completion == "complete"`, or carry the quarantined batch count into the lede.
[rule: roles/COMMON.md § Reporting - a "verified" claim requires real-execution evidence; the artifact-level analogue is that a report must not assert a completeness it did not observe.]

Nothing else on my surface. No unguarded global, no prototype-pollution vector, no unhardened object crossing a boundary.

Self-improvement: the panel dispatch handed me `llm` as the diff base, but the worktree's local `llm` was ~30 commits stale and produced a 228k-line diff spanning the entire Ironhorse engine; the real scope was `git merge-base origin/llm HEAD..HEAD`. Message to liaison: `skills/panel/SKILL.md` should have the panel resolve the diff base against `origin/<base>` and pass the merge-base SHA to each juror, so no seat reviews a stale-ref diff or silently reviews the wrong 3400 files.
