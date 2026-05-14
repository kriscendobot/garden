---
title: Putting It All Together: Digital Purse Example
source: docs/message-passing.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [exo, capability-security, eventual-send, marshal]
status: current
notes: This is the canonical end-to-end worked example for the Endo message-passing model. Each component drawn from a separate package — readers wanting to follow up should see endo--pkg-exo-readme--overview (the class API used for the purse), endo--pkg-patterns-readme--overview (the method-guard language), endo--pkg-marshal-readme--overview (the pass-style serialization that lets the purse cross a boundary), and endo--pkg-eventual-send-readme--overview (the E() invocation pattern).
---

> Abstract: Worked example: a digital purse with deposit, withdraw, getBalance methods. Demonstrates pass-style (the purse is a remotable), patterns (method guards on amounts), defensive-receive (multi-facet attenuation between mint and holder), and eventual-send (E() calls across boundary). The canonical end-to-end example for the Endo message-passing model.

## Putting It All Together: Digital Purse Example

Let's build a complete capability-based payment system that demonstrates all
four packages working together.
We'll create a mint that can create purses, which can create payments.
This pattern is fundamental to digital assets in capability systems.

### The Design

Our system will have three facets:
- **Mint facet**: Can create new purses (privileged operation)
- **Purse facet**: Holds a balance, can deposit and withdraw
- **Payment facet**: Single-use payment that can be deposited once

All three facets share the same underlying state, but expose different
authority levels.

### Complete Implementation

```javascript
import { M } from '@endo/patterns';
import { defineExoClassKit, defineExoClass } from '@endo/exo';
import { E } from '@endo/eventual-send';

// Step 1: Define interfaces (patterns)

const MintI = M.interface('Mint', {
  makePurse: M.call().returns(M.remotable('Purse'))
});

const PurseI = M.interface('Purse', {
  getBalance: M.call().returns(M.number()),
  deposit: M.callWhen(
    M.and(M.number(), M.gte(0)),
    M.remotable('Payment')
  ).returns(),
  withdraw: M.call(M.and(M.number(), M.gte(0))).returns(M.remotable('Payment'))
});

const PaymentI = M.interface('Payment', {
  getBalance: M.call().returns(M.number())
});

// Step 2: Define the Mint/Purse Kit

const makeMintKit = defineExoClassKit(
  'Mint',
  { mint: MintI, purse: PurseI },

  // init: each purse starts with 0 balance
  () => ({ balance: 0 }),

  {
    mint: {
      makePurse() {
        // Return the purse facet, not the mint facet
        // This ensures the holder of a purse can't mint
        return this.facets.purse;
      }
    },

    purse: {
      getBalance() {
        return this.state.balance;
      },

      async deposit(amount, payment) {
        // amount is validated as non-negative number by guard
        // payment is validated as remotable by guard

        // Get payment's balance (eventual send)
        const paymentBalance = await E(payment).getBalance();

        // Verify amount matches
        if (paymentBalance !== amount) {
          throw Error('Payment balance mismatch');
        }

        // Add to our balance
        this.state.balance += amount;
      },

      withdraw(amount) {
        // amount is validated as non-negative by guard

        if (amount > this.state.balance) {
          throw Error('Insufficient balance');
        }

        // Deduct from balance
        this.state.balance -= amount;

        // Create a new payment
        return makePayment(amount);
      }
    }
  }
);

// Step 3: Define single-use Payment

const makePayment = defineExoClass(
  'Payment',
  PaymentI,

  // init: payment created with specific amount
  (amount) => ({ balance: amount, spent: false }),

  {
    getBalance() {
      // Once spent, balance becomes 0
      if (this.state.spent) {
        return 0;
      }

      // Mark as spent (single-use)
      this.state.spent = true;
      return this.state.balance;
    }
  }
);

// Step 4: Usage across vat boundaries

// Create a mint (privileged)
const { mint, purse: ourPurse } = makeMintKit();

// Give someone else a purse (they can't mint!)
const alicePurse = E(mint).makePurse();
const bobPurse = E(mint).makePurse();

// Manually increase our purse (in real system, this would be privileged)
ourPurse.state.balance = 1000;

// Create a payment and send to Alice
const payment100 = E(ourPurse).withdraw(100);
await E(alicePurse).deposit(100, payment100);

// Alice can now send to Bob
const payment50 = E(alicePurse).withdraw(50);
await E(bobPurse).deposit(50, payment50);

// Check balances (all eventual sends)
const ourBalance = await E(ourPurse).getBalance();     // 900
const aliceBalance = await E(alicePurse).getBalance(); // 50
const bobBalance = await E(bobPurse).getBalance();     // 50

// Try to reuse a payment (fails - single use)
const payment = E(alicePurse).withdraw(10);
await E(bobPurse).deposit(10, payment);  // succeeds
await E(ourPurse).deposit(10, payment);  // fails - balance is 0
```

### What's Happening Here

Let's trace the flow when Alice sends money to Bob:

1. **Pass-style**: The amount (`50`) is passable as a number.
   The payment is passable as a remotable.

2. **Patterns**: When `withdraw(50)` is called:
   - The guard validates `50` matches `M.and(M.number(), M.gte(0))`
   - Negative amounts and non-numbers are rejected

3. **Exo**: The purse exo:
   - Automatically validates all inputs via InterfaceGuard
   - Encapsulates state (`balance`) that can't be directly accessed
   - Provides different facets (mint vs purse) for least authority

4. **Eventual-send**: All method calls use `E()`:
   - Works the same whether purses are local or remote
   - Provides promise pipelining to reduce round trips
   - Maintains message ordering per target

### Key Patterns Demonstrated

**Least Authority via Facets**: The mint holder has full power to create
purses, but purse holders can only deposit/withdraw, not mint new purses.

**Single-use Payments**: The payment's `getBalance()` method uses the `spent`
flag to ensure it can only be deposited once.
This prevents double-spending.

**Async Validation**: The `deposit()` method uses `M.callWhen()` because it
needs to await `E(payment).getBalance()`.
The guard validates the types, then the method validates business logic.

**Defense in Depth**: Multiple layers of protection:
- InterfaceGuards reject malformed calls
- State encapsulation prevents direct manipulation
- Business logic validates invariants (sufficient balance, etc.)

**Uniform Communication**: The same code works whether Alice and Bob are:
- In the same vat
- In different vats on the same machine
- On different machines across a network


Source: [docs/message-passing.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/docs/message-passing.md) at commit `14a0b631`.
