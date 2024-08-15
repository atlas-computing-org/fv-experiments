# Setup

## Install Aeneas

We will be using Nix for this. For example, `nix run nixpkgs#cargo init foo-bar` is the equivalent of `cargo init foo-bar` for some pinned version of cargo in `nixpkgs`. The Nix commands may take a long time to initialize the first time you use them. They will be much faster on the next run.

1. Install Nix and enable Nix flakes.
   If Nix is not installed, run
   ```
   sh <(curl -L https://nixos.org/nix/install) --daemon
   ```
   or if you already have Nix installed, upgrade it by running
   ```
   nix-channel --update; nix-env --install --attr nixpkgs.nix nixpkgs.cacert; systemctl daemon-reload; systemctl restart nix-daemon
   ```
   To enable Nix flakes, add the following line to `~/.config/nix/nix.conf`.
   ```
   experimental-features = nix-command flakes
   ```

2. Clone the Aeneas project.
   ```
   git clone git@github.com:AeneasVerif/aeneas.git
   ```

3. Start the Nix shell. It uses the `shell.nix` config file in the Aeneas folder.
   ```
   cd aeneas
   nix-shell
   ```

4. Run the tests in the Nix shell.
   ```
   make test
   ```

5. View the generated Lean files, e.g.
   ```
   aeneas/tests/lean/Betree/Funs.lean
   ```