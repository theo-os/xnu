load("//bazel:toolchain.bzl", "cc_toolchain_config", "tool_binary")

package(default_visibility = ["//visibility:public"])

exports_files(["genassym.py"])

# Linux platform used to build host tools (the llvm-project binaries and iig)
# from source.  See the transition in //bazel:toolchain.bzl.
platform(
    name = "linux_x86_64",
    constraint_values = [
        "@platforms//cpu:x86_64",
        "@platforms//os:linux",
    ],
)

# Toolchain binaries built from the local llvm-project checkout via the LLVM
# Bazel overlay.  `tool_binary` pins them to the Linux host configuration, and
# `cc_toolchain` builds this filegroup in the exec configuration; the artifact
# paths are therefore the same in both places.
tool_binary(
    name = "clang_tool",
    binary = "@llvm-project//clang:clang",
)

tool_binary(
    name = "clang_headers_tool",
    binary = "@llvm-project//clang:builtin_headers_gen",
)

tool_binary(
    name = "ld64_lld_tool",
    binary = "@llvm-project//lld:ld64.lld",
)

tool_binary(
    name = "lld_tool",
    binary = "@llvm-project//lld:lld",
)

tool_binary(
    name = "llvm_ar_tool",
    binary = "@llvm-project//llvm:llvm-ar",
)

tool_binary(
    name = "llvm_libtool_darwin_tool",
    binary = "@llvm-project//llvm:llvm-libtool-darwin",
)

tool_binary(
    name = "llvm_nm_tool",
    binary = "@llvm-project//llvm:llvm-nm",
)

tool_binary(
    name = "llvm_objdump_tool",
    binary = "@llvm-project//llvm:llvm-objdump",
)

tool_binary(
    name = "llvm_strip_tool",
    binary = "@llvm-project//llvm:llvm-strip",
)

filegroup(
    name = "llvm_tool_files",
    srcs = [
        ":clang_headers_tool",
        ":clang_tool",
        ":ld64_lld_tool",
        ":lld_tool",
        ":llvm_ar_tool",
        ":llvm_libtool_darwin_tool",
        ":llvm_nm_tool",
        ":llvm_objdump_tool",
        ":llvm_strip_tool",
    ],
)

filegroup(name = "empty")

cc_toolchain_config(
    name = "xnu_toolchain_config",
    ar = ":llvm_libtool_darwin_tool",
    clang = ":clang_tool",
    clang_headers = ":clang_headers_tool",
    ld = ":ld64_lld_tool",
    nm = ":llvm_nm_tool",
    objdump = ":llvm_objdump_tool",
    strip = ":llvm_strip_tool",
)

