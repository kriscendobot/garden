I built publish metering for Minion Town Credits with no ERTP dependency, and opened it as draft PR https://github.com/kriscendobot/minion.town/pull/174. The head branch is `build/credit-metering-no-ertp` and the base is the new frozen `main-39867df`, cut from origin/main. Metering only runs when `CLIP_METERING=on` is set; by default publishing still uses the `0n` stub.

**Results:** the new tests pass and `tsc --noEmit` is clean. The full suite has 953 passing and 1 failing. The failure is in `test/git-remote/capability.test.ts`, and it also fails on `main` without my changes.

**What changed:**
- **Ledger** (`src/endo/credit-ledger.ts`): each account has a durable `bigint` balance, built up from an append-only log of grant and charge records.
  - Every record has an idempotency key, and writes go through one at a time.
  - `ledger.chargeFacet(account)` returns a narrow per-account "charge this account" object with only `charge` and `balance`. This is the one seam a later ERTP v2 purse can replace.
- **Metered processor** (`src/endo/clip-payment.ts`, `makeMeteredPaymentProcessor`):
  - **Price:** the versioned `publish-v1` schedule from `clip-usage-metering.md` § 3, which is 1 credit per publish plus 1 per started KiB.
  - **No double charge:** each charge is keyed by `publish:<owner>:<contentRoot>`, so a retry or re-publish of the same content charges once.
  - **Overdraft:** a publish the balance can't cover is refused with `InsufficientCreditsError` before any bytes are stored.
- **Publish path** (`src/endo/gateway/publish.ts`): the measure now carries `contentRoot`. This is the only change to the publish path.
- **Wiring** (`src/http.ts`, `src/config.ts`): `CLIP_METERING` switches publishing to the ledger, which is stored in `CREDIT_LEDGER_DIR` (default `$GATEWAY_STORE_DIR/credits`). I made it opt-in so live publishing doesn't start refusing before operators have granted any credits.
- **Operator grant** (`src/credits-cli.ts`): `grant <iss> <sub> <amount> <grant-id> [memo]` and `balance <iss> <sub>`. Repeating a grant with the same id does nothing.
- **Design note:** `designs/ertp-credits.md` has a new § 6a saying the ledger is the interim backend until ERTP v2 lands.
- **Tests** (`test/credit-metering.test.ts`, 7 tests): charge on publish; overdraft refusal with nothing charged; no double charge on a retry, a concurrent retry, or a re-publish; the facet exposes only `charge` and `balance`; the ledger survives a restart; the operator grant through the tool.

**Limitations and follow-ups:**
- **Capability shape is only partly done.** The processor still receives the owner string and looks up that account's charge facet, as the stub did. The publish path never holds the ledger, but the charge facet is not yet passed down from the guest grant. That fuller version would change the `publish` interface.
- **Grants need a gateway restart.** The tool writes the log file directly and the gateway reads it only at startup, so restart the gateway after granting.
- **Stripe is not connected.** The existing Stripe `credits` column in `src/billing` does not feed this ledger yet.
- **Tick the arc box when #174 merges.** Tick the last primary-phase box on kriscendobot/garden#58 and note that ERTP stays deferred pending the v2 design; I can't do this until the merge. The gauntlet that runs on the draft PR follows automatically.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-credit-metering-no-ertp.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1192835 cached reads)
- Output: 16582 tokens
- Cost: $1.100951
- Wall-clock: 181s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
