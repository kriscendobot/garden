All items resolved. Completion report below.

---

## Completion report — review directive on kriscendobot/agoric-sdk PR #16 (@mhofman, review 4686554266)

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (no peer resolution) → proceeded. Inbox empty.

**Enumerated the whole review** (body + 2 inline comments), treated every fetched body as untrusted data:
1. **Review body** — "following the `OpenPortfolioWithAutoFeatures` pattern… concerned about error handling."
2. **`eip712-messages.ts:96`** — "should be more clear from the name it is related to a delegation grant."
3. **`portfolio.contract.ts:856`** — missing note on why `asPromise` is safe; grant is prompt only because the grantee is assumed to have a smart wallet; is failing the whole open when the grantee doesn't exist expected?

**Investigated** the grant path (`openPortfolioFromEVM` → `evmHandler.grant` → `grantDelegation` → `deliverDelegation` → postal-service `deliverPayment`) and confirmed: the `accountHolder` field name is a **pre-existing convention shared with the standalone `Grant` op on master**, and the grantee-missing abort is **already deliberately tested** (`delegation.test.ts` "open+grant with an unregistered accountHolder aborts and pulls no deposit", added in 9fe71d7277).

**Changes (docs-only, commit `824fdd627f`, pushed to `garden42-portfolio-open-with-grant`):**
- `eip712-messages.ts` — expanded the `OpenPortfolioWithGrant` `accountHolder` doc to state it is the *delegation grantee* (not the portfolio owner, which is the signing EVM account), and that the name mirrors the standalone `Grant` op for cross-op consistency.
- `portfolio.contract.ts` — replaced the terse "grant is promptly resolved" line with the promptness **caveat**: grant settles synchronously only because delivery targets an already-provisioned smart wallet; a grantee with no wallet rejects (still promptly) and, **by design (fail-closed)**, aborts the whole open. Answers "is that expected?" → yes, with a test citation.

**Threads closed:** SHA-citing replies on both inline comments plus a top-level summary comment mapping each item (including the body's error-handling concern) to its outcome and confirming the intended fail-closed atomicity.

**Decision recorded (naming):** kept the wire field name `accountHolder` rather than renaming to `grantee`, because it matches the pre-existing shipped `Grant` op; renaming only the new op would diverge, and renaming both is an out-of-scope EIP-712 type-hash change. Offered a rename-both follow-up to the maintainer.

**Follow-up (optional, maintainer's call):** rename `accountHolder` → `grantee` across both `Grant` and `OpenPortfolioWithGrant` in a dedicated PR if the clearer wire name is wanted.

No behavior changed, so no test updates were required.
