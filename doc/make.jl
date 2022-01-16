using Documenter

Documenter.makedocs
(
	root = "/",
	build = "build",
	clean = true,
	doctest = true,
	repo = "",	
	highlightsig = true,
	pages = [
		"Index" => "index.md"	 
			 ]
)
