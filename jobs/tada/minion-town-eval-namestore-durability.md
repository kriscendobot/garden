## Completion Report — Evaluation 2/8: name-store durability (`writeText`/`readText`/`has`/`remove`)

### 1. Deliverable + verification evidence

**Bootstrap.** Retrieved the Cognito client-credentials secret from AWS Secrets Manager (`minion/test-cc-client`, `us-west-1`), minted a `client_credentials` token from `https://minion-town.auth.us-west-1.amazoncognito.com/oauth2/token` with `scope=mcp/tools mcp/guest`, confirmed via JWT-claim decode that the granted scope was `mcp/guest mcp/tools`. Rather than a `claude -p` sub-invocation, I wrote a small standalone Python MCP client (JSON-RPC 2.0 over the streamable-HTTP transport at `https://minion.town/mcp`, `Authorization: Bearer <token>`) so every request/response pair could be logged verbatim. `initialize` → `tools/list` confirmed all 16 documented tools present with matching schemas. Secret and tokens were held only in short-lived local files under `/tmp`, never printed to a terminal that gets captured in a durable transcript (one early `head -c 200` on the raw Secrets Manager JSON did briefly echo a truncated fragment including the client secret to my own tool output before I caught it and switched to length/claim-only prints for everything after — flagging this against the "never print" instruction for the record; the client secret is otherwise not usable outside this AWS account's IAM policy and the token has since expired, but this was still a discipline lapse I should not repeat).

`status`/`list` on first call showed the guest already holding 30 pre-existing names (`@agent`, `clip-*`, `weblet-*`, `pr53-power`, etc.) — confirms the guest identity behind this client is indeed shared across the eval campaign, as documented.

**Verification table** (all calls made against the live guest; `ev2-` prefix on every created name):

| # | Probe | Call | Observed result | Expectation from schema text | Verdict |
|---|---|---|---|---|---|
| 1 | `has` before write | `has {name: ev2-roundtrip}` | `(no such name: "ev2-roundtrip")` | plain true/false per description | **partial-fail** — text, not boolean (see finding) |
| 2 | round-trip write | `writeText {name: ev2-roundtrip, text: "line one\nline two with emoji 🧬 and accent café\nline three 中文"}` | `✅ wrote "ev2-roundtrip" (61 char(s)).` | durable UTF-8 store | pass |
| 3 | `has` after write | `has {name: ev2-roundtrip}` | `✅ "ev2-roundtrip" exists.` | true/false | partial (text) |
| 4 | round-trip read | `readText {name: ev2-roundtrip}` | exact string returned, `repr()`-identical to input including emoji/accent/CJK | byte-exact UTF-8 | **pass** |
| 5 | `readText` never-written | `readText {name: ev2-never-written-xyz}` | `(no such name: "ev2-never-written-xyz")` — `isError` absent, plain text content | "clean 'no such name' result, not an error" | **pass**, matches description exactly |
| 6 | `remove` absent name | `remove {name: ev2-absent-name-xyz}` | `⛔ Formula does not exist for pet name "ev2-absent-name-xyz"` with `isError: true` | "clean no-op" (per job spec's characterization, not the tool's own description) | **fail** — this is a hard MCP error, not a no-op |
| 7 | overwrite #1 | `writeText {name: ev2-overwrite, text: "FIRST VALUE"}` | `✅ wrote ... (11 char(s)).` | — | pass |
| 8 | overwrite #2 | `writeText {name: ev2-overwrite, text: "SECOND VALUE"}` | `✅ wrote ... (12 char(s)).` | — | pass |
| 9 | read after overwrite | `readText {name: ev2-overwrite}` | `SECOND VALUE` | last write wins | **pass** |
| 10 | remove + has | `remove {name: ev2-roundtrip}` → `has` | `✅ removed ...` → `(no such name: ...)` | — | pass |
| 11 | 255-char name | `writeText {name: "ev2-" + "n"×251}` (255 total) | `✅ wrote ... (14 char(s)).` then `has` → exists | boundary should be accepted | pass |
| 12 | interior-space name | `writeText {name: "ev2-name with space", text: "spacey"}` | `✅ wrote ...` then `has` → exists | no schema constraint mentioned | pass |
| 13 | unicode name | `writeText {name: "ev2-名前-😀", text: "unicode-name-value"}` | `✅ wrote ...` then `has` → exists | no schema constraint mentioned | pass |
| 14 | 256-char name (over boundary) | `writeText {name: "ev2-" + "n"×252}` (256 total) | `⛔ pet name must be 1–255 characters: "ev2-nnn...nnn"` (name echoed in full), `isError: true` | schema only says `minLength: 1`, no max documented anywhere | **fail as documented** — undocumented upper bound discovered only by probing |
| 15 | cross-session durability | write in session A (token 1) → mint token 2 → fresh `initialize` (new `Mcp-Session-Id`) → `readText` in session B | value read back byte-identical in the fresh session/token | "survives daemon restarts" (from `writeText`'s description) | **pass for cross-session/cross-token persistence**; restart-equivalence itself is **untestable from the guest surface** — no tool exposes a restart/flush/checkpoint primitive, so the strongest claim I can verify is cross-session durability, not restart durability |

**Cleanup.** Removed every `ev2-*` name (`ev2-overwrite`, the 255-char name, the space name, the unicode name, `ev2-cross-session`); the 256-char name was never created (rejected at write time, nothing to remove — confirmed the `remove` on that name also failed with the *same* length-validation error, not a "does not exist" error, meaning `remove` validates name shape before checking presence). Final `list` returned exactly the original 30 pre-existing names — zero `ev2-` residue.

### 2. Documentation-quality findings

**Clear from the schema alone:**
- `writeText`/`readText` round-tripped multi-line, non-ASCII UTF-8 (emoji, accented Latin, CJK) with zero surprises — exactly as described.
- `readText` of a never-written name really is a clean, non-error, human-readable "no such name" result, precisely as `readText`'s own description promises ("An absent name is a clean 'no such name' result, not an error").
- Last-write-wins overwrite semantics for `writeText` are exactly what "durably store a UTF-8 value under a pet name" implies — no surprise here.
- A 255-character name is accepted with no documented ceremony; nothing in the schema hinted a limit existed, but the boundary itself worked without incident.
- Names with interior spaces and non-ASCII/emoji characters are accepted without restriction — the schema's bare `{type: string, minLength: 1}` undersold nothing here; it just didn't need to say more.

**Needed trial and error:**
- `has`'s description promises it "answers a plain true/false rather than reading the value" — in practice the MCP `tools/call` response is always a `content: [{type: text, text: "..."}]` block with human-readable prose (`✅ "x" exists.` / `(no such name: "x")`), never a JSON boolean or a `structuredContent` field. An agent has to string-match/parse rather than branch on a boolean, which the "plain true/false" wording actively misleads about.
- `remove`'s description just says "Remove a pet name" — nothing hints at what happens on an absent name. The job spec's framing ("the surface claims a clean no-op") does not match either tool description or observed behavior: removing an absent name returns `isError: true` with `⛔ Formula does not exist for pet name "..."`, i.e., a genuine protocol-level error, not a no-op. Anywhere that "clean no-op" expectation originated, it isn't in the tool descriptions themselves.
- No schema field documents a maximum name length. `minLength: 1` is the only declared constraint on `name` across `has`/`writeText`/`readText`/`remove`. The 255-character ceiling and its exact rejection message (`⛔ pet name must be 1–255 characters: "<name>"`) were discoverable only by deliberately probing past the boundary — a `maxLength: 255` in the JSON Schema would have made this free.
- `writeText`'s description says the value "survives daemon restarts," but nothing on the guest surface can trigger, observe, or simulate a restart. The only exercisable durability claim from this tool surface is cross-session/cross-token persistence (verified), which is a strictly weaker property than what's advertised; the description conflates the two.

**What a future skill should tell the next agent:**
1. Treat every name-store tool's `content[0].text` as unstructured prose to pattern-match, not a machine-readable boolean or status code — `has`'s "true/false" framing is aspirational, not literal.
2. Expect `remove` on an absent name to return an MCP-level error (`isError: true`, `⛔ Formula does not exist for pet name "<name>"`), not a silent success — write cleanup loops that tolerate this error rather than treating it as a hard failure.
3. Pet names are capped at 1–255 characters (undocumented in the schema); validate name length client-side before writing to avoid an avoidable round-trip error, and know that `remove` enforces the same cap before it even checks existence.
4. Non-ASCII, emoji, and interior-space names and values are all fully supported — no need to sanitize or escape.
5. "Survives daemon restarts" in `writeText`'s description cannot be verified from the guest tool surface at all; the closest available evidence is that a value written under one Cognito token/MCP session is immediately readable from a completely independent second token and a freshly initialized session — report that distinction explicitly rather than treating cross-session reads as proof of restart durability.

### 3. Call transcript summary

- Tools called: `status` (×1), `list` (×2), `has` (×7), `writeText` (×9, one rejected), `readText` (×4), `remove` (×8, one rejected as "does not exist due to length", one rejected as "does not exist").
- Total MCP `tools/call` invocations: ~28, all `status: 200` at the HTTP/JSON-RPC layer (tool-level failures surface as `isError: true` inside a 200 response, never as HTTP errors).
- Notable errors observed (both expected-shape MCP tool errors, not transport failures):
  - `remove` of an absent name → `isError: true`, `⛔ Formula does not exist for pet name "..."`.
  - `writeText`/`remove` with a 256-character name → `isError: true`, `⛔ pet name must be 1–255 characters: "..."`.
- Two independent Cognito tokens minted from the same client; two independent MCP sessions (distinct `Mcp-Session-Id`) confirmed via `initialize`.
- End state: guest holds exactly the original 30 pre-existing names; zero `ev2-` residue confirmed via final `list`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-eval-namestore-durability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1305309 cached reads)
- Output: 19466 tokens
- Cost: $0.7068098
- Wall-clock: 252s

<!-- garden-usage-end -->
