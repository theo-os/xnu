"""Fetches https://github.com/theo-os/iig-tools as `@iig_tools`.

iig-tools upstream is a CMake project, but the tool is a handful of C++17
translation units, so we supply a small `cc_binary` BUILD file instead of
shelling out to CMake.  This keeps the tool built by Bazel (and cached) in the
exec configuration, where Bazel's default host toolchain applies.
"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

_IIG_TOOLS_COMMIT = "96c1ece6be1ceb6ee2fec6c434d080edc10da2b1"
_IIG_TOOLS_SHA256 = "af82826fc33fca00dfa6d0496340993e58906695245923570f50e4c316e0a54e"

_BUILD_FILE = """\
load("@rules_cc//cc:defs.bzl", "cc_binary")

cc_binary(
    name = "iig",
    srcs = glob([
        "src/*.cpp",
        "include/**/*.h",
    ]),
    copts = ["-std=c++17"],
    includes = ["include"],
    visibility = ["//visibility:public"],
)
"""

def _iig_tools_impl(module_ctx):
    http_archive(
        name = "iig_tools",
        build_file_content = _BUILD_FILE,
        sha256 = _IIG_TOOLS_SHA256,
        strip_prefix = "iig-tools-" + _IIG_TOOLS_COMMIT,
        urls = [
            "https://github.com/theo-os/iig-tools/archive/{}.tar.gz".format(_IIG_TOOLS_COMMIT),
        ],
    )

    return module_ctx.extension_metadata(reproducible = True)

iig_tools = module_extension(
    implementation = _iig_tools_impl,
)
