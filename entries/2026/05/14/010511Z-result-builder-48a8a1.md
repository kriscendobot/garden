---
ts: 2026-05-14T01:05:11Z
kind: result
role: builder
project: ocapn
to: liaison
prs:
  - repo: endojs/ocapn-test-suite
    pr: 1
    role: target
refs:
  - entries/2026/05/13/013503Z-dispatch-liaison-f447a9.md
  - entries/2026/05/13/012400Z-result-steward-da0309.md
---

# Result: builder opened endojs/ocapn-test-suite#1 (draft) for syrups framing

Draft PR: https://github.com/endojs/ocapn-test-suite/pull/1
Topic branch: `feat/syrups-framing` on `endojs/ocapn-test-suite`.
Head SHA: `89e80d70cf0689fce0b92936f22a84b02e9e1aee`.
Base: `main` at `74db78f08a40efba1e2b975d809374ff0e7acf60` (matches the pinned baseline in the *Pre-staged authorizations* row).

## Pre-staged authorization consumed

Cleared the precondition. The bulletin's *Pre-staged authorizations* row for `kriscendobot` write access to `endojs/ocapn-test-suite` carried a pending GitHub collaboration invitation that had not yet been accepted; the kriscendobot account had only `pull` permission at dispatch start (`gh api repos/endojs/ocapn-test-suite --jq '.permissions'` returned `push: false`). Accepted the invitation via `gh api -X PATCH user/repository_invitations/318502568`; permissions now read `pull: true, push: true, triage: true`. The push succeeded after that.

Note for the liaison: the bulletin row can now be cleared (or kept as a standing reminder that the grant is in effect, depending on the liaison's pattern for these rows).

## Diff summary

Two files changed, 47 insertions, 6 deletions.

- `netlayers/base.py` (44 +, 5 -): `CapTPSocket.send_message` prepends an `<ascii-decimal-length>:` prefix to the syrup-encoded payload. `CapTPSocket.receive_message` reads the prefix one byte at a time until a colon, then reads exactly the declared number of payload bytes (accumulating across `recv` chunks) and `syrup_decode`s the result. New `FramingError` raised on non-digit-non-colon prefix bytes, oversize prefix (>12 digits), and empty prefix.
- `README.md` (3 +, 1 -): the TCP-testing netlayer description now names the length-prefixed framing and notes the equivalence to a wrapping Syrup byte-string record.

No test-vector content touched. `tests/`, `utils/`, `contrib/`, `netlayers/onion.py`, `netlayers/testing_only_tcp.py`, `test_runner.py` all unchanged.

## Local validation outcome

The Python test harness in `tests/` requires a live OCapN peer (every test class derives from `CapTPTestCase` whose `setUp` calls `netlayer.connect(self.ocapn_uri)`); the harness is a conformance runner against an external implementation, not a standalone unit-test suite, so it cannot validate the framing change in isolation. Instead, ran a framing-self-consistency smoke against the modified `base.py` using `socket.socketpair()` and a stub for `decode_captp_message`:

- Round-trip of a single `op:deliver` record: passes (label and args preserved).
- Five back-to-back messages on one socket: each decodes in order with correct payload contents.
- Byte-by-byte prefix followed by 7-byte chunked body (simulating TCP fragmentation): the reader reassembles before decoding; round-trip passes.
- Malformed prefix (`12X:foo`): raises `FramingError("Invalid length-prefix byte b'X' at offset 2")`.
- Oversized prefix (13 ASCII digits): raises `FramingError("Length prefix exceeds 12 digits: ...")`.
- Empty prefix (immediate colon): raises `FramingError("Empty length prefix")`.
- All three netlayer modules and `utils.test_suite` still import cleanly; `python3 -m py_compile` on all three netlayer files passes.

The end-to-end validation against a live JS peer running the `@endo/syrups` framing is the broader engagement this PR enables, not something the Python suite can self-validate.

## Identity verification

Commit author and committer are both `kriscendobot <279080640+kriscendobot@users.noreply.github.com>`. `git interpret-trailers --parse` on the commit message returns empty (no `Co-authored-by` or `Generated with` trailers).

## Follow-up builder identifier

The follow-up endo-but-for-bots builder (the dispatch that pivots the JS peer to consume the framing change) should reference:

- Branch: `feat/syrups-framing` on `endojs/ocapn-test-suite`.
- Head SHA: `89e80d70cf0689fce0b92936f22a84b02e9e1aee`.

These are the exact identifiers a JS-side CI pin or local checkout would consume.

## Self-improvement

The dispatch carried the kriscendobot push grant in the bulletin's *Pre-staged authorizations* section but the underlying GitHub invitation had not been accepted; the precondition was latent until the first push attempt surfaced it. Two lessons that may want capturing somewhere durable (but neither rises to a role or skill edit on a single occurrence): (a) when a `Pre-staged authorizations` row references a GitHub collaboration grant, the bulletin row should ideally distinguish "grant offered" from "grant accepted" so the first subagent does not have to handle the invitation acceptance as an unexpected step; (b) the pre-flight that the `pr-creation-flow` skill recommends ("verify no open PR already implements the issue") generalizes to "verify the push surface is actually pushable", and the cheap check `gh api repos/<owner>/<repo> --jq '.permissions'` would have surfaced the latent invitation before the branch was constructed. I judged neither lesson worth a skill-edit on one occurrence; if a second dispatch hits the same shape, the `pre-pr-checklist` skill is the right place to add a "permissions probe" step.

Self-improvement: nothing role-level this time; the operational observations above are captured for the liaison's reading.
