#!/bin/bash
#=
exec julia --color=yes --startup-file=no "${BASH_SOURCE[0]}"
=#

try
    realpath(PROGRAM_FILE) == realpath(@__FILE__)
catch
    let file = @__FILE__
        println("Spawning new Julia process...")
        run(`$(Base.julia_cmd()) $file`)
        false
    end
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
