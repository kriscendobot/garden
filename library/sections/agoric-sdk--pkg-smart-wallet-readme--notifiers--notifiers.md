---
title: Notifiers
source: packages/smart-wallet/README.md
source_repo: agoric/agoric-sdk
source_commit: 2e7e93fb6e84caf203dcb62c1290437b3418836b
source_date: 2022-09-13
source_authors: [Turadg Aleahmad]
ingested: 2026-05-14
ingested_by: scholar
topics: [testing, tooling]
status: current
notes: The doc explicitly admits "there are no automated tests yet verifying the smart wallet running on chain" — manual procedure is the only testing surface. Three terminals: chain, client server, interactive (`agoric open --repl`). The published.wallet vstorage key is the canonical query path.
parent: agoric-sdk--pkg-smart-wallet-readme--notifiers
---

```sh
# freshen sdk
cd agoric-sdk
yarn install && yarn build

# tab 1 (chain)
cd packages/cosmic-swingset/
make scenario2-setup scenario2-run-chain
# starts bare chain, don't need AMM

# tab 2 (client server)
cd packages/cosmic-swingset/
make scenario2-run-client
# confirm no errors in logs

# tab 3 (interactive)
agoric open --repl
# confirm in browser that `home.wallet` and `home.smartWallet` exist
agd query vstorage keys 'published.wallet'
# confirm it has a key like `published.wallet.agoric1nqxg4pye30n3trct0hf7dclcwfxz8au84hr3ht`
agoric follow :published.wallet.agoric1nqxg4pye30n3trct0hf7dclcwfxz8au84hr3ht
# confirm it has JSON data
```

Source: [packages/smart-wallet/README.md](https://github.com/Agoric/agoric-sdk/blob/2e7e93fb6e84caf203dcb62c1290437b3418836b/packages/smart-wallet/README.md) at commit `2e7e93fb`.
