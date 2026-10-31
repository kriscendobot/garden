---
posted_at: 2026-10-31T05:17:49Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repair an Ironhorse fuzz **timeout** finding in `differential_regexp`, found on PR CI and not by the scheduled fuzzer. Repo: endojs/endo-but-for-bots. Standing findings PR: #1298 (`kriscendobot:ironhorse-fuzz-findings`); use `ensure-pr.sh --find-only` and reuse it.

- Source: CI run https://github.com/endojs/endo-but-for-bots/actions/runs/41162305359 (job fuzz-ironhorse, PR #1501, head d4117a1e33, base llm-9a14ddf = llm 9a14ddf660). PR #1501 touches no Rust, so this finding comes from llm.
- libFuzzer: "ALARM: working on the last Unit for 1789 seconds" / "ERROR: libFuzzer: timeout after 1789 seconds" (timeout 1200) — a single input hangs: catastrophic backtracking, or an unmetered loop in Ironhorse's or the XS oracle's regexp engine. First decide which engine hangs. If Ironhorse hangs, the meter or budget must bound it; if XS hangs, lock it as an oracle-side finding.
- Artifact: run artifact `ironhorse-fuzz-tripwire-artifacts`, file `differential_regexp/timeout-021e38de3b479435cb566d1201f5baf50cd260ff` (664 bytes, sha256 prefix f9cde0bda6f97f6c).
- input_base64: gFCAHPyNr2IrmPj4Jvj4+Pj4+Pj4+Pgy+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4BQz/IWX/+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Mv4+Pj4+Pj4+Pj4+vj4+Pj4+Pj4+Pj4xfgm+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+PgFDP8hZf/4+Pj4+Pgm+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4uAz/IWX////4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4y/j4+Pj4+Pj4+Pj4+Pj/+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Cz4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+PgM/yFl//j4+Pj4+Cb4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4y/j4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+PjF+Pj4+PiAUON6Z2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ8zMLPj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Az/IWX/+Pj4+Pj4Jvj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+PgFDP8hZf/4+Pj4+Pgm+Pj4IsDr////A1iePGfU+Pj4+Pj4+Pj4+Pj4+Pj4+G1tbW34BQz/IWX/+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+LgM/yFl//////8DBA==
- Reproduce: `cargo +nightly-2026-08-15 fuzz run -s none differential_regexp <input> -- -runs=1 -timeout=60` in rust/engine/ironhorse-fuzz.

Lock the input with a regression test on the standing branch, the way earlier findings were locked, and fix the hang if it is in Ironhorse.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-31T05:18:15Z
