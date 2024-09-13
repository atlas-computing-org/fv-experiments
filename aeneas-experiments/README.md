# Setup

## Install Aeneas

We will be using Nix for this. For example, `nix run nixpkgs#cargo init foo-bar` is the equivalent of `cargo init foo-bar` for some pinned version of cargo in `nixpkgs`. The Nix commands may take a long time to initialize the first time you use them. They will be much faster on the next run.

1. Install Nix and enable Nix flakes.
   ```
   sh <(curl -L https://nixos.org/nix/install) --daemon --yes
   mkdir -p ~/.config/nix && echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
   ```

2. Clone the Aeneas project, and navigate to the project folder.
   ```
   git clone https://github.com/AeneasVerif/aeneas.git
   cd aeneas
   ```

3. Start the Nix shell. 
   ```
   nix develop
   ```

4. Build Charon, build Aeneas, and run the tests in the Nix shell.
   ```
   make setup-charon
   make
   make test
   ```

5. View the generated Lean files, e.g.
   ```
   aeneas/tests/lean/Betree/Funs.lean
   ```

## Running Charon

After invoking the Nix shell with `nix develop`,

```
alias charon='~/aeneas/charon/bin/charon'
cd tests/src/betree
charon --polonius --opaque=betree_utils
```

Options for `charon` can be found in `aeneas/tests/src/betree/aeneas-test-options` under `charon-args`.

## Running Aeneas

After invoking the Nix shell with `nix develop`,

```
alias aeneas='~/aeneas/bin/aeneas'
cd tests/src/betree
aeneas -backend lean betree.llbc
```

The Lean file `Betree.lean` will be generated.

## Adding Aeneas, Charon packages in Nix

```
{
  inputs.aeneaspkgs.url = github:AeneasVerif/aeneas/e31b9a627463cd653b9aa8f59679f3eb2ca8cffd;

  outputs = { self, aeneaspkgs, ... }: 
    let

      system = "x86_64-linux";
      inherit (aeneaspkgs.packages.${system}) aeneas charon;

    in 
    {
      devShells."${system}".default = pkgs.mkShell {
        buildInputs = [ 
          aeneas
          charon
        ];
      };
    };
}
```