---
title: ContractGovernor (legibility + ParamManager + Governing APIs + Governed Contracts)
source: packages/governance/README.md
source_repo: agoric/agoric-sdk
source_commit: 92fa9a262b1b190d8535f826197a5df0c1ba9958
source_date: 2023-04-20
source_authors: [Turadg Aleahmad]
ingested: 2026-05-14
ingested_by: scholar
topics: [capability-security, exo, patterns]
status: current
notes: The "powerful private facet kept inside the contract, governor holds a separate change-power facet" pattern is canonical capability-discipline for governance. The Invitation-parameter exception (only the invitation's amount appears in `terms`; the actual invitation passes via `privateArg`) is the load-bearing subtlety for clients who want to see what they're voting on without holding the power to exercise it. The YES/NO position structures (parameters: changed-list / `{noChange: parameterNames}`; APIs: `{name, args}` / `{dontInvoke: methodName}`; offer-filter: new-strings / `{dontUpdate: strings}`) are the canonical question shapes for PARAM_CHANGE elections.
---

> Abstract: ContractGovernor makes a contract's governance legible. Governed aspects: parameter changes, declared-API invocations, offer-filter blocking. **Legibility pattern**: the contract holds mutable state in a `ParamManager` with two facets — an accessor facet (read, visible to all observers) and a setter facet (write, only accessible to the external ContractGovernor). The contract retains only the accessor internally; the setter is held by the visible governor. **ParamManager construction**: `makeParamManager(zoe, {paramName: [type, startingValue], ...})` returns a manager with `get*` / `update*` methods per param; `makeParamManagerSync` is the no-zoe-dependency variant. **Governing APIs**: contracts opt in by including `getGovernedApis` in their creator facet (passed to `wrapCreatorFacet`); returns a Far object with the methods to be called under governance. **Governed Contracts**: `contractHelper`'s `handleParamGovernance()` validates parameter declarations in `terms` and returns `augmentPublicFacet` + `makeGovernorFacet`. **Question structures** for PARAM_CHANGE elections: parameter YES lists `{paramName: newValue}`; parameter NO is `{noChange: paramNames}`. API YES is `{apiName, args}`; NO is `{dontInvoke: methodName}`. Filter YES is `{strings}`; NO is `{dontUpdate: strings}`.

## ContractGovernor

We want some contracts to be able to make the manner of their governance legible. Contracts can specify aspects that are governed by a public process, specifically:

* changes to declared parameters
* invocation of declared methods
* blocking exercise of some invitations

The governance package makes it possible for contracts to provide *legiblity*, meaning that observers (clients and voters) are able to see who has control, and what actions can be taken. To make control of parameters legible, the contract will hold its mutable state in a ParamManager. ParamManager has facets for accessing the param values, and for setting them. The APIs that allows setting the values and that can make particular changes to the behavior of the contract will only be accessible to an external ContractGovernor.

The governed contract will only retain the accessor facet internally, and will also allow external observers to see those values. The private facet, which can change the values, is only accessible to the visible ContractGovernor. The ContractGovernor makes the Electorate visible, while tightly controlling the process of creating new questions and presenting them to the electorate.

The governor starts up the Contract and can see what parameters and APIs are subject to governance. It provides private facets that carry the ability to request votes on changing parameters and invoking the controlled APIs.

The party that has the question-creating facet of the ContractGovernor can create questions on parameters or APIs for that contract instance. The electorate object creates new questions, and makes a new instance of a VoteCounter so everyone can see how questions will be counted. Electorates have a public method to get from the questionHandle to a question. Ballots include the questionSpec, the VoteCounter instance and closingRule. For contract governance, the question specifies the governed contract instance, the parameter to be changed and proposed new value, or the method to be invoked and the arguments to be provided.

This is sufficient for voters and others to verify that the contract is managed by the governor, the electorate is the one the governor uses, and a particular voteCounter is in use.

The governed contract uses a ContractHelper to return a (powerful) creator facet with two methods: `getParamMgrRetriever` (which provides access to read and modify parameters), and `getLimitedCreatorFacet`, which has the creator facet provided by the governed contract and doesn't include any powerful governance capabilities. ContractGovernor starts the governed contract, so it gets the powerful creatorFacet. ContractGovernor needs access to the paramManager, but shouldn't share it. So the contractGovernor's `creatorFacet` provides access to the governed contract's `publicFacet`, `creatorFacet`, `instance`, `voteOnApiInvocation`, `voteOnOfferFilter` and `voteOnParamChange`. The contract's owner should treat `voteOnApiInvocation`, `voteOnOfferFilter` and `voteOnParamChange` as particularly powerful.

The questions for parameter changes have **YES** positions that list the parameters to be changed and their proposed values. The **NO** positions list is `{ noChange: parameterNames }`. For API invocation questions, the **YES** position gives the API name and arguments, while the **NO** position is `{ dontInvoke: apiMethodName }`. When proposing to change filter settings, the **YES** position shows the new value (the list of all strings that will be blocked), while **NO** has the same strings under `dontUpdate`: `{ dontUpdate: strings }`.

### Governing Electorates

In order to allow the Electorate that controls the ContractGovernor to change, the Electorate is a required parameter in all governed contracts. Invitations are an unusual kind of managed parameter. Most parameters are copy-objects that don't carry any power. Since invitations convey rights, only the invitation's amount appears in `terms`. The actual invitation must be passed to the contract using `privateArg`. This combination makes it possible for clients to see what the invitation is for, but only the contract has the ability to exercise it. Similarly, when there will be a vote to change the Electorate (or any other Invitation-valued parameter), observers can see the amount. When contracts are written so the handling of the ParamManager is clearly limited, reviewers can see that the actual invitation will only be exercised if/when the vote is successful.

### ParamManager

`ContractGovernor` expects to work with contracts that use `ParamManager` to manage their parameters. `makeParamManager()` is designed to be called within the managed contract so that internal access to the parameter values is synchronous. A separate facet allows visible management of changes to the parameter values.

`makeParamManager(zoe)` makes a ParamManager:

```javascript
  const paramManager = await makeParamManager(
    {
      'MyChangeableNumber': ['nat', startingValue],
      'ContractElectorate': ['invitation', initialPoserInvitation],
    },
    zcf.getZoeService(),
  );

  paramManager.getMyChangeableNumber() === startingValue;
  paramManager.updatetMyChangeableNumber((newValue);
  paramManager.getMyChangeableNumber() === newValue;
```

If you don't need any parameters that depend on the Zoe service, there's an alternative function that returns synchronously:

```javascript
  const paramManager = await makeParamManagerSync(
    {
      'Collateral': ['brand', drachmaBrand],
    },
  );
```

See [ParamTypes definition](./src/constants.js) for all supported types.

### Governing APIs

`ContractGovernor` has support for contracts that declare that some internal APIs should only be invoked under the control of governance. To opt in to this support, the contract should include `getGovernedApis` in its creator facet (passed to `wrapCreatorFacet`). That method should return a `Far` object with the methods to be called.

### Governed Contracts

`contractHelper` provides support for the vast majority of expected clients that will have a single set of parameters to manage. A contract only has to define the parameters (including `CONTRACT_ELECTORATE`) in a call to `handleParamGovernance()`, and add any needed methods to the public and creator facets. This will
 * validate that the declaration of the parameters is included in its `terms`,
 * add the parameter retriever appropriately to the publicFacet and creatorFacet

When a governed contract starts up, it should get the parameter declarations from `terms`, use them to create a paramManager, and pass that to `handleParamGovernance`. `handleParamGovernance()` returns functions (`augmentPublicFacet()` and `makeGovernorFacet()`) that add required methods to the public and creator facets.

Governed methods and parameters must be included in terms.

```javascript
  terms: {
    governedParams: {
      [MALLEABLE_NUMBER]: { type: ParamTypes.NAT, value: number },
      [CONTRACT_ELECTORATE]: {
        type: ParamTypes.INVITATION,
        value: invitationAmount,
      },
    },
    governedApis: ['makeItSo'],
  },
```

When a contract is written without benefit of `contractHelper`, it is responsible for adding `getSubscription`, and `getGovernedParams` to its `PublicFacet`, and for adding `getParamMgrRetriever`, `getInvitation` and `getLimitedCreatorFacet` to its `CreatorFacet`.

Source: [packages/governance/README.md](https://github.com/Agoric/agoric-sdk/blob/92fa9a262b1b190d8535f826197a5df0c1ba9958/packages/governance/README.md) at commit `92fa9a26`.
