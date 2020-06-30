'''Provides the implementation for the `markdownlint_toolchain` rule.

Markdown lint toolchain instances are created by writing
`markdownlint_toolchain` rule instances.
'''

MarkdownLintToolchainInfo = provider(
    fields = [
        "markdownlint_tool",
    ],
)

def _markdownlint_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        markdownlint_tool = MarkdownLintToolchainInfo(
            markdownlint_tool = ctx.file.markdownlint_tool,
        ),
    )
    return [toolchain_info]

markdownlint_toolchain = rule(
    implementation = _markdownlint_toolchain_impl,
    attrs = {
        "markdownlint_tool": attr.label(
            allow_single_file = True,
            mandatory = True,
        ),
    }
)
