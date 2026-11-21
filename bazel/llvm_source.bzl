"""Exposes a local llvm-project checkout as the `@llvm-raw` repository.

The LLVM Bazel overlay keeps its module definition in
`utils/bazel/MODULE.bazel`, i.e. *inside* the llvm-project source tree rather
than at its root, so it cannot be consumed with `local_path_override` or
`bazel_dep`.  Instead we mirror what `utils/bazel/extensions.bzl` does: create
`@llvm-raw` (a repo whose only job is to expose `utils/bazel/configure.bzl`),
which MODULE.bazel then uses through `use_repo_rule` to instantiate the
`@llvm-project` overlay repository.

The checkout path defaults to the one used by this workspace and can be
overridden in MODULE.bazel with:

    llvm_source = use_extension("//bazel:llvm_source.bzl", "llvm_source")
    llvm_source.local(path = "/path/to/llvm-project")
"""

load("@bazel_tools//tools/build_defs/repo:local.bzl", "new_local_repository")

_DEFAULT_PATH = "/home/theo/src/llvm-project"

def _llvm_source_impl(module_ctx):
    path = _DEFAULT_PATH
    for mod in module_ctx.modules:
        for tag in mod.tags.local:
            path = tag.path

    new_local_repository(
        name = "llvm-raw",
        build_file_content = "# empty",
        path = path,
    )

    return module_ctx.extension_metadata(reproducible = True)

llvm_source = module_extension(
    implementation = _llvm_source_impl,
    tag_classes = {
        "local": tag_class(
            attrs = {
                "path": attr.string(
                    doc = "Path to the llvm-project checkout.",
                    mandatory = True,
                ),
            },
        ),
    },
)
