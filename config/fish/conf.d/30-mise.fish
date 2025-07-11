#!/usr/bin/env fish

set --global --export MISE_CARGO_HOME "$HOME"/.local/share/cargo
set --global --export MISE_RUSTUP_HOME "$HOME"/.local/share/rustup

"$XDG_BIN_DIR"/mise activate fish | source

### 10-mise.fish ends here
