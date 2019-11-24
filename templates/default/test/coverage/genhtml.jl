#!/bin/bash
#=
exec julia --color=yes --startup-file=no "${BASH_SOURCE[0]}"
=#

try
    @assert ENV["__JULIA_SPAWNED__"] == "1"
    true
catch
    @info "Spawning new Julia process"
    let file = @__FILE__
        ENV["__JULIA_SPAWNED__"] = "1"
        run(`$(Base.julia_cmd()) $file`)
        ENV["__JULIA_SPAWNED__"] = "0"
    end
    false
end && begin
    using Pkg
    Pkg.activate(@__DIR__)

    using Coverage
    cd(joinpath(@__DIR__, "..", "..")) do
        coverage = process_folder()
        infofile = joinpath(@__DIR__, "coverage-lcov.info")
        LCOV.writefile(infofile, coverage)

        outdir = joinpath(@__DIR__, "html")
        run(`genhtml $infofile --output-directory=$outdir`)
    end
end
