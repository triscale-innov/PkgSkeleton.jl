using Pkg; Pkg.activate(@__DIR__); Pkg.instantiate()
using PackageCompiler
Pkg.activate(joinpath(@__DIR__, ".."))

# List of packages to include in the sysimage

# -> option 1: include all declared dependencies (but not the package itself)
packages = Symbol.(keys(Pkg.project().dependencies))

# -> option 2: include the package itself (along with all its dependencies)
#packages = [:{PKGNAME}]

# -> option 3: include a manually specified list of packages
#packages = [:Plots, :DataFrames]


# Sysimage base name
sysimage_name = "sysimage"

# Sysimage extension
sysimage_ext = if Sys.iswindows()
    ".dll"
elseif Sys.isapple()
    ".dylib"
else
    ".so"
end

create_sysimage(
    packages,
    sysimage_path = sysimage_name * sysimage_ext,
    precompile_execution_file = joinpath(@__DIR__, "precompile.jl"),

    # Optional: generate a "portable" sysimage on x86-64 architectures
    #cpu_target = "generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1)",
)
