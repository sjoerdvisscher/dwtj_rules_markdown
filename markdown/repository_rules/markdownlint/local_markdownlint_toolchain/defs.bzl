_BUILD_FILE_TEMPLATE = """
exports_files(
    ["{}"],
    visibility = ["//visibility:public"],
)
"""

def _local_markdownlint_toolchain_impl(repository_ctx):
    markdownlint_executable = repository_ctx.attr.markdownlint_executable
    if markdownlint_executable is None:
        link_from = repository_ctx.which(tool_name)
        link_to = tool_name
        repository_ctx.symlink(
            link_from,
            link_to,
        )
    else:
        # TODO(dwtj): Implement me!
        fail("Not yet implemented")

    # Create a BUILD file in the root of the external respository from template.
    build_file_contents = _BUILD_FILE_TEMPLATE.format(tool_name)

    repository_ctx.file(
        "BUILD",
        build_file_contents,
        executable = False,
    )

local_markdownlint_toolchain = repository_rule(
    implementation = _local_markdownlint_toolchain_impl,
    attrs = {
        # Default is `None.` If `None`, `which` is used to locate markdownlint
        # on `PATH`.
        'markdownlint_executable' = attr.string(default = None)
    }
    local = True,
)