'''Implements a helper macro for making platform-specific toolchain instances.
'''

load("//markdown:defs.bzl", "markdown_lint_toolchain")
load("//third_party/npm/markdownlint_cli:defs.bzl", "markdownlint_binary")

# Maps from Bazel platform constraints to the target names known to the `pkg`
# tool (from NPM).
_SUPPORTED_PLATFORM_OSES = {
    "@platforms//os:linux": "linux",
    #"@platforms//os:macos": "macos",
    #"@platforms//os:windows": "windows",
    #"@platforms//os:freebsd": "freebsd",
}

# Maps from Bazel platform constraints to the target names known to the `pkg`
# tool (from NPM).
_SUPPORTED_PLATFORM_CPUS = {
    "@platforms//cpu:x86_64": "x64",
}

def make_default_markdown_lint_toolchain_for_platform(
    platform_os,
    platform_cpu = "@platforms//cpu:x86_64"):
    '''Creates some targets which together form a `markdown_lint_toolchain`.

    The instantiated toolchain is backed by `markdownlint-cli` tool provided
    on NPM and compiled for the given target platform.

    This is designed to be a schema for creating the various platform-specific
    toolchains. See [here][1] for one example.

    NB(dwtj): Currently, only the x86_64 architecture is supported.

    NB(dwtj): Currently, only the "latest" Node.js version is used to build the
    tool

    Args:
      platform_os: One of the keys of `_SUPPORTED_PLATFORM_OSES`.
      platform_cpu: One of the keys of `_SUPPORTED_PLATFORM_CPUS`.

    [1]: //markdown/toolchains/lint/known_toolchain_instances/compiled/x86_64/linux:toolchain
    '''
    # TODO(dwtj): Does this use object identity equality or string value equality?
    # TODO(dwtj): How to I get the keys of a dictionary again?
    if platform_os not in _SUPPORTED_PLATFORM_OSES.keys():
        fail("Unsupported platform os: " + platform_os)
    if platform_cpu not in _SUPPORTED_PLATFORM_CPUS.keys():
        fail("Unsupported platform os: " + platform_cpu)

    platform_constraints = [
        platfom_cpu,
        platform_os,
    ]

    native.toolchain(
        name = "toolchain",
        exec_compatible_with = platform_constraints,
        toolchain = ":markdown_lint_toolchain",
        toolchain_type = "//markdown/toolchains/lint:toolchain_type",
        visibility = ["//visibility:public"],
    )
    
    markdown_lint_toolchain(
        name = "markdown_lint_toolchain",
        markdown_lint_tool = ":markdown_lint_tool",
    )
    
    markdownlint_binary(
        name = "markdown_lint_tool",
        target_node_version = "latest",
        target_platform = _SUPPORTED_PLATFORM_OSES[platform_os],
        target_arch = _SUPPORTED_PLATFORM_CPUS[platform_cpu],
    )
