def _local_markdownlint_toolchain_impl(repository_ctx):
    print("TODO(dwtj): Everything!")
    pass

local_markdownlint_toolchain = repository_rule(
    implementation = _local_markdownlint_toolchain_impl,
    attrs = {
        'markdownlint_executable' = attr.string(mandatory = True)
    }
)