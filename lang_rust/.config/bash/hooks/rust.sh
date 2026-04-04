export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

# Add CARGO_HOME/bin to PATH if it exists and isn't already there
if [ -d "$CARGO_HOME/bin" ]; then
    case ":$PATH:" in
        *":$CARGO_HOME/bin:"*) ;;
        *) export PATH="$PATH:$CARGO_HOME/bin" ;;
    esac
fi
