# pnpm configuration
export PNPM_HOME="$XDG_DATA_HOME/pnpm"

# Add PNPM_HOME to PATH if it exists and isn't already there
if [ -d "$PNPM_HOME" ]; then
    case ":$PATH:" in
        *":$PNPM_HOME:"*) ;;
        *) export PATH="$PNPM_HOME:$PATH" ;;
    esac
fi
