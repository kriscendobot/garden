---
title: Body
source: "Distributed Electronic Rights in JavaScript (ESOP 2013, Springer LNCS 7792)"
source_kind: paper
source_authors: [Mark S. Miller, Tom Van Cutsem, Bill Tulloh]
source_year: 2013
source_venue: "ESOP 2013, Springer LNCS 7792, pp. 1-20"
source_url: https://papers.agoric.com/papers/distributed-electronic-rights-in-javascript/abstract/
source_pdf_sha256: 061ab339fb204ad2d609ce44130146bf9cb0897bf7c6d9e21248cac412454593
source_paper_pages: "10-14 (§3 Toward Distributed Electronic Rights; §4 Money as an Electronic Right)"
ingested: 2026-05-30
ingested_by: liaison-direct-draft
topics: [capability-security, patterns]
status: current
parent: papers--miller-vancutsem-tulloh-distributed-electronic-rights-2013--rights-as-property-and-money-as-right
---

### §3 The rights-as-property framing

The §3 opening sets the metaphor: *the fabric of the global economy is held together by contracts*. Just as society uses contracts to organize rights-transfer between mutually-suspicious parties, distributed computational systems can use *smart contracts* — programs whose behavior enforces the terms of the contract. The §3.1 paper invokes Steiner's *An Essay on Rights* (1994) as the philosophical anchor: *rights help people coordinate plans and resolve conflicts over use of resources. Rights partition the space of actions to avoid interference between separately formulated plans, thus enabling cooperative relationships despite mutual suspicion and competing goals.*

The §3 paper makes the **central architectural claim of the paper**:

> Historically, two broad strategies for avoiding the tragedy of the commons have emerged: a governance strategy and a property rights strategy. The governance approach solves the open access problem by restricting access to members and regulating each member's use of the shared resource. The property rights approach divides ownership of the resource among the individuals and creates abstract rules that govern the exchange of rights between owners. These approaches have their analogues in computational systems: **ocap systems pursue a property rights strategy, while access control lists implement a governance strategy**.

The §3.1 paper notes that *governance regimes have proved successful in managing shared resources in many situations. However, they tend to break down under increasing complexity.* As the number of users and types of access increases, the ability of governance systems to limit external access and manage internal use breaks down. Perimeter security can no longer cope with the pressure for increased access, and access control lists cannot keep up with dynamic requests for changes in access rights.

The §3.2 paper develops the analogy between ocap systems and individual-rights legal systems:

> The ocap approach can be seen as analogous to an individual rights approach to coordinating action in society. The local unforgeable object reference and the remote unguessable reference represent one kind of eright — the right to invoke the public interface of the object it designates. In ocap systems, references bundle authority with designation. Like property rights, they are *possessory rights*: possession of the reference is all that is required for its use, its use is at the discretion of the possessing entity, and the entity holding the reference is free to transfer it to others.

The §3.2 paper develops the parallel between *property law / contract law / tort law* and ocap system primitives:

- **Property law** determines the initial acquisition of rights ↔ The rules of object creation make it easy to create objects with only the rights they need.
- **Contract law** governs the transfer of rights ↔ The message-passing rules govern the transfer of rights between objects.
- **Tort law** protects rights from interference ↔ Encapsulation protects rights from interference.

The §3.3 paper closes with the **four dimensions along which money differs from object references**:

| Dimension | Object reference | Money |
|---|---|---|
| **Shareable vs Exclusive** | Shareable. Alice copying a reference to Bob does not deprive Alice of her access. | Exclusive. Bob considers himself paid only when he has exclusive access to the funds. |
| **Specific vs Fungible** | Specific. Designates a particular object. | Fungible. Quantity matters; particular bills do not. |
| **Opaque vs Measurable** | Opaque. Clients invoke but do not know implementation. | Measurable (assayable). Bob must determine he has a certain quantity. |
| **Exercisable vs Symbolic** | Exercisable. The right is to invoke. | Symbolic. Value only in exchange; no direct use. |

(*Library cross-note: this taxonomy is the 2013 paper's reprise of the 2000 paper's §6.2 four-axis rights taxonomy. The 2000 taxonomy used Shareable/Exclusive, Specific/Fungible, Opaque/Assayable, Exercisable/Symbolic — same four axes. The 2013 framing applies them directly to the *reference-vs-money* contrast as the architectural motivation for why money needs *additional* machinery beyond bare references.*)

### §4 The makeMint code in JavaScript

§4 walks the JavaScript enactment of the mint-purse pattern. The §4 code (Figure 1):

```
var makeMint = () => {
  var m = WeakMap();
  var makePurse = () => mint(0);

  var mint = balance => {
    var purse = def({
      getBalance: () => balance,
      makePurse: makePurse,
      deposit: (amount, srcP) =>
        Q(srcP).then(src => {
          Nat(balance + amount);
          m.get(src)(Nat(amount));
          balance += amount;
        })
    });
    var decr = amount => { balance = Nat(balance - amount); };
    m.set(purse, decr);
    return purse;
  };
  return mint;
};
```

The §4 paper walks the structural reading layer by layer:

- **Line 2**: `m = WeakMap()` — the per-currency *brand* table. Only purses created by *this* `makeMint` invocation have entries in this table; the WeakMap is reachable only by inner closures of this currency.
- **Line 3**: `makePurse = () => mint(0)` — creates a fresh empty purse of this currency.
- **Lines 5-14**: `mint = balance => {...}` — the per-purse constructor. Each invocation creates a new `purse` (defensible object exposing `getBalance`, `makePurse`, `deposit`) plus a hidden `decr` function with closure over `balance`.
- **Line 16**: `m.set(purse, decr)` — register *this* purse's `decr` in the brand table, keyed by purse-identity. This is the operational form of the 2000 paper's `sealer seal(decr)`.
- **Lines 8-11**: `deposit` method — the rights-amplification step. `m.get(src)` looks up the source purse's `decr` *only if* `src` was minted by this same currency (otherwise `undefined`). If found, call `decr(Nat(amount))` to decrement the source. If `src` was not from this currency, `m.get(src)` returns `undefined` and `undefined(...)` throws — the deposit fails, the balance is not changed, the promise rejects.

The §4 closing paragraph names the key insight: *the success callback in the `deposit` method implicitly returns `undefined`, fulfilling Bob's promise for the result of the deposit request, triggering Bob to release the good to Alice in exchange*. The atomic commit point is the assignment `balance += amount` — all the tests have already passed, all the bookkeeping is done, and any local-visible failure paths have been exhausted.

**The same six security properties hold** as in the 2000 paper §3.4 mint-purse-money — verifiable by visual inspection of the code:

1. Only mint-holders can violate currency conservation (only `mint` is in `m`'s closure scope).
2. The mint can only inflate its own currency (the WeakMap is per-currency).
3. No one can affect the balance of a purse they don't have (balance is per-purse closure scope).
4. With two purses of the same currency, one can transfer money between them (deposit's WeakMap lookup verifies same-currency).
5. Balances are always non-negative (Nat guards).
6. A reported successful deposit can be trusted as much as one trusts the purse one is depositing into (deposit's success callback is the atomic commit).

The §4 paper provides the *contemporary JavaScript* enactment of the architectural pattern the 2000 paper introduced in E.
