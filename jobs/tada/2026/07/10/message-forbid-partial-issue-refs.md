Work complete. Report follows.

---

**Job: forbid partially-qualified issue/PR references in posted messages (upstream fix)**

**SHA:** `afcdfe8dd` — pushed to `origin/main2` (clean, first-attempt CAS).

**What I did**

Fixed the bare-`#N` problem at the source: message-posting now rejects an apparently partially-qualified issue/PR reference, so a bare `#N` never enters the bus (the bulletin's downstream resolver stays as a harmless legacy fallback, untouched).

**Files touched (17)**

- **New `scripts/jobs/check-issue-refs.sh`** — deterministic, Markdown-aware gate (one `awk` pass, no LLM). Reads a body from a file arg or stdin; reports + fails (exit 1) on a partial ref, exit 0 when clean/exempt.
- **Wired into the author-written send primitives** before the push: `send-msg.sh`, `inbox-send.sh`, `maintainer-reply.sh`. `message-user.sh` and `block-job.sh` enforce transitively through `inbox-send.sh`.
- **`GARDEN_SKIP_REF_CHECK=1` bypass** set on every machine/relay producer that posts generated or forwarded bodies: `foreman`, `orchestrate`, `triager`, `identity-drift-guard`, the `common.sh` watchdog alert, the `proxy-claude`/`follow-up`/`follow-up-claude`/`watchman-claude` handlers, `deploy-garden`, the `issue-inbox-watcher` relay (2 sites), and `maintainer-reply`'s own already-checked delivery. This keeps only author bodies gated so no fleet path wedges on a legitimate generated `#N`.
- **`skills/message-bus/SKILL.md`** — added a short "Fully-qualify issue/PR references" note.
- **`scripts/jobs/test/run-test.sh`** — added SUBTEST 29 (11 assertions).

**The exact rule implemented**

- **Forbidden (partial):** bare `#N` (`#` + 1–6 digits at a word boundary), `owner#N` (word + `#N`, no `/repo`), `GH-N`.
- **Allowed (fully-qualified):** `owner/repo#N`; full `https://github.com/owner/repo/(issues|pull)/N` URLs (optional `#fragment`).
- **Exempt (never scanned):** fenced code blocks (```` ``` ````/`~~~`, indented/info-string) and inline `` `code` `` spans; ATX heading markers and `#RRGGBB` hex colours are dodged by the digits-only rule + code-span exemption.

**Send primitives wired:** `send-msg.sh`, `inbox-send.sh`, `maintainer-reply.sh` (direct); `message-user.sh`, `block-job.sh` (via `inbox-send.sh`).

**Verification (cited)**

- `bash -n` + `shellcheck -S warning` clean on every touched file; warning counts identical to the `origin/main2` baseline (I introduced none — the only flagged items are pre-existing `GARDEN_TAG`/`common.sh` patterns in untouched code).
- SUBTEST 29 run in a focused harness (avoids the known-pre-existing SUBTEST 6 `no reply_to` baseline failure): **11 passed, 0 failed** — covers bare `#652` rejected-with-report, `owner/repo#N` pass, full URL pass, fenced-block `#N` pass, inline-span `#N` pass, ATX heading not flagged, `owner#N`/`GH-N` rejected, report-names-ref-and-remedy, and the real `send-msg.sh` path (reject bare / post qualified / honor bypass).
- Real-path observation via an actual `send-msg.sh`:
  - Bare `#652` → `message REJECTED — … line 1: #652 … remedy: fully-qualify …` then `[send] FATAL: message not posted …`, exit 1 (not posted).
  - `kriskowal/garden#652` → `[send] sent → broadcast (20260710T222701Z-65ca2d)`, exit 0.
  - `message-user.sh` with bare `#7` → rejected via `inbox-send.sh` (`line 1: #7`, exit 1), confirming transitive enforcement.
- Audited existing test bodies: no current test sends a bare `#N` through the four primitives, so no regression.

**Follow-ups / notes**

- The known pre-existing SUBTEST 6 failure (`maintainer-reply … has no reply_to`, reproduces on pristine baseline) is unrelated and unaffected; my assertions were run in a focused harness to avoid masking, as the spec directed.
- If a currently-unbypassed *machine* producer ever emits a genuine bare `#N`, it would now be rejected there; the bypass surface I set covers all such producers I found in `scripts/jobs/`, but any future machine sender of author-style text should either fully-qualify refs or set `GARDEN_SKIP_REF_CHECK=1`.
