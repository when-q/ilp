# Informatics Lunch Practical 

```@contents
```
## Functions

### Position.jl
```@meta
CurrentModule = ilp.Position
```

```@docs
LongLat
Line2D
isconfined(coord::LongLat)
intersects(e::Line2D, l::Line2D)
distanceto(a::LongLat, b::LongLat)
distanceto(a::LongLat,b::LongLat, noflyzone::Vector{Vector{Line2D}})
closeto(coord::LongLat, point::LongLat)
nextPosition(coord::LongLat, theta::Int64)
```
