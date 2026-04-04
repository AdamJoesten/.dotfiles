export UV_TOOL_DIR="$XDG_DATA_HOME/uv/tools"
export UV_PYTHON_INSTALL_DIR="$XDG_DATA_HOME/uv/python"

# Ensure UV-installed global tools are in the path
export PATH="$UV_TOOL_DIR/bin:$PATH"

# Setup autocompletion
if command -v uv >/dev/null 2>&1; then
    eval "$(uv generate-shell-completion bash)"
fi