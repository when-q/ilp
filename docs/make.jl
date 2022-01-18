push!(LOAD_PATH,"../src/")
using ilp

using Documenter

Documenter.makedocs(
	build="build",
	sitename="Informatics Lunch Practical",
	clean = true,
	doctest = true,
	highlightsig = true,
	expandfirst = [],
	pages = [
			 "Index"=>"index.md",
			 ]
)
