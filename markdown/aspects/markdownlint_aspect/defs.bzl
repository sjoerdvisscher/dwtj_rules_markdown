'''Defines the `markdown_lint_aspect` Bazel aspect.

This aspect adds a lint as an action to `markdown` targets. The lint is
performed by the lint tool provided by the selected `markdown_lint_toolchain`.
'''

load("@dwtj_rules_markdown//markdown/rules/markdown_library:defs.bzl", "MarkdownInfo")

def _target_provides_markdown_info(target):
    return MarkdownInfo in target

def _markdownlint_aspect_impl(target, aspect_ctx):
    if not _target_provides_markdown_info(target):
        # Skip all targets which don't provide `MarkdownInfo`.
        return []

    for file in target[MarkdownInfo].direct_source_files:
        print("markdownlint " + file.path)
        # TODO(dwtj): Create actions which use aspect_ctx.toolchains['@dwtj_rules_markdown//markdown/toolchains/markdownlint:toolchain_type']

    return []

markdownlint_aspect = aspect(
    implementation = _markdownlint_aspect_impl,
    attr_aspects = ['deps'],
    toolchains = ['@dwtj_rules_markdown//markdown/toolchains/markdownlint:toolchain_type'],
)