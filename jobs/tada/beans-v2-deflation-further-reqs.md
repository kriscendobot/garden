Folded the HackMD spec's further requirements into the beans-v2 deflation design and updated PR #10; the inbox was empty at checkpoint.

**What I did**
- Fetched the HackMD spec (hackmd.io/@michaelfig/B1kUP-XMGg) and revised `designs/beans-v2-deflation.md` on the existing `design/beans-v2-deflation` branch of `kriscendobot/agoric-sdk`, pushed as commit `13a7799e4c` so draft PR https://github.com/kriscendobot/agoric-sdk/pull/10 now reflects the further requirements. The PR remains **draft**; upstream `Agoric/agoric-sdk` untouched.
- Replied on the issue thread: https://github.com/kriskowal/garden/issues/32#issuecomment-4909750750 (issue left open for the submitter).

**What changed in the design**
- The charge path is rebuilt around the HackMD's `ChargeBeans` split: `AddBeansOwing` (accounting-only debt tracking; all `vm.ControllerAdmissionMsg` paths switch to it) plus `ConvertBeansOwing` (ante-time drain of the owed beans into a gas amount and a fee amount) — replacing the first draft's immediate per-message coin conversion. Draining the whole balance also sweeps debt accrued under the old `minFeeDebit` batching.
- The HackMD's `AnteHandlerDecorator` changes and the design's `BeanFeeDecorator` are reconciled as the same component (design keeps the name `BeanFeeDecorator`): it enforces `gasLimit > 0` and the minimum effective gas price when executing, counts bean gas against the gas meter, and splits the bean fee into a burned fraction (`bean_fee_burn_fraction`) and a collector remainder (`bean_fee_collector`) before builtin Cosmos fee processing.
- `bean_gas_price` is reconciled with the HackMD's minimum-gas-price parameter — same knob, widened from simulation-only translation into a dual role that also floors the execution-time gas price so the gas-meter expression of fees is sound.
- Migration now includes the HackMD's step 4: seed `msg_type_bean_overrides` (≡ the HackMD's `msgTypeBeanOverrides`) from the hardcoded Go admission formula so the formula itself becomes a governance parameter.

**Open questions surfaced (not decided)**: override entry semantics (per-type price menu vs. unit counts — the two readings differ in whether size-dependent charges are expressible), builtin `DeductFeeDecorator` interplay (net-of-beans fee), ante decorator ordering, where the minimum gas price is encoded (dedicated DecCoin param vs. inside `beansPerUnit`), and residual `beansOwing` uses such as `ChargeForSmartWallet`.

**Follow-ups**: none required; un-drafting PR #10 and closing issue #32 are the maintainer's calls.
