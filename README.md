# HelloWorld

A minimal, dependency-free Foundry project. `HelloWorld.greet()` returns exactly
`"Hello, world!"` for every caller. It is a pure function with no storage, external
calls, constructor arguments, owner, upgrade mechanism, or configurable greeting.
Calls with ETH, plain ETH transfers, and unknown function selectors revert.

## Build and test offline

Prerequisites: Foundry (`forge`) and the official Solidity **0.8.24** compiler
already installed in Foundry's compiler cache. The compiler is a toolchain
prerequisite; it is not bundled in this repository. Development checks used
Forge 1.7.1 and the existing cached compiler. There are no external Solidity
libraries, package installs, or git submodules to fetch.

```sh
forge build
forge test
forge fmt --check
```

`foundry.toml` pins Solidity 0.8.24 and the Paris EVM target, and enables offline
mode for both build and test. FFI and filesystem cheatcode permissions are
disabled. A missing compiler must be provisioned before entering an offline
environment; these commands will not download it.

The four unit tests check the exact greeting, rejection of ETH sent to `greet()`,
rejection of an unknown function, and rejection of a plain ETH transfer. Both
ETH rejection tests check that the sender retains its funds. Tests use native
Solidity assertions and a small interface to Foundry's built-in `deal` cheatcode,
so `forge-std` is unnecessary.

## Deployment parameters and responsibilities

- Target: `src/HelloWorld.sol:HelloWorld`, on an EVM chain supporting Paris.
- Constructor arguments: none. Deployment value: **0 ETH**.
- Initialization, libraries, admin accounts, and ongoing funding: none.
- The operator chooses and verifies the chain, RPC endpoint, and signer, and
  supplies only the gas required for deployment. No network or wallet is chosen
  by this project.

An operator can review a deployment dry run using a locally configured Foundry
keystore account:

```sh
forge create src/HelloWorld.sol:HelloWorld --rpc-url "$RPC_URL" --account "$DEPLOYER_ACCOUNT"
```

Set those shell variables locally. Adding `--broadcast` sends a real deployment
transaction and is a separate operator decision. No transaction was submitted
as part of this assignment. After deployment, record the chain and contract
address and check that `greet()` returns the expected string. Keep signing keys
outside the repository.

No maintenance transactions are required. A behavior change requires deploying
a new contract and updating callers. This example has no asset management or
withdrawal functionality: do not send tokens or forcibly transfer ETH to it,
because such assets cannot be recovered through the contract. Passing tests
are not a security audit.
