module Position

```@docs 
Position is a module that responsible for position related calculation
```

using ..Documenter
makedocs(
    modules = [Documenter],
)
export LongLat,UNITMOVE,Line2D

const UNITMOVE = 0.00015

```@docs LongLat stores longitude, latitude and angle of a drone at a specific position```
struct LongLat
	longitude::Float64
	latitude::Float64	
	angle::Int64
end

```@docs Line2D represents a line by its starting and ending point```
struct Line2D
	s::LongLat
	e::LongLat
end

```@docs 
	isconfined(coord)

Takes a coordinate and check whether it's in the confinement zone.
returns true if it is in the zone.
``` 
function isconfined(coord::LongLat)::Bool 
	x_confined = false
	y_confined = false
	if coord.longitude > -3.192473 && coord.longitude < -3.184319
			x_confined = true
	end
	if coord.latitude > 55.942617 && coord.latitude < 55.946233
		y_confined = true
	end
	return x_confined &&  y_confined
end

```@docs 
	(a,b)->(c,d) intersects (p, q) -> (r, s)
```
function intersects(e::Line2D, l::Line2D)
	det =  (e.e.longitude- e.s.longitude)
		*(l.e.latitude- l.s.latitude) 
		-(l.e.longitude - l.s.longitude)
		*(e.e.latitude - e.e.latitude)
	if det == 0
#	lambda = ((s - q) * (r - a) + (p - r) * (s - b)) / det

	λ = ((l.e.latitude  - l.s.latitude)
		*(l.e.longitude - e.s.longitude) 
		+(l.s.longitude - l.e.longitude)
		*(l.e.latitude  - e.s.latitude)) / det
#    gamma = ((b - d) * (r - a) + (c - a) * (s - b)) / det;
#	(a, b)->(c, d) intersects (p, q) -> (r, s)
	γ = ((e.s.latitude  - e.e.latitude)
		*(l.e.longitude - e.s.longitude)
		+(e.e.longitude - e.s.longitude)
		*(l.e.latitude  - e.s.longitude)) / det
		return (0 < λ && λ < 1) && (0 < γ && γ < 1);
	end
end

```@docs 
	distanceto(a::LongLat, b::LongLat)::Float64

Calculate the distance between two coordinates
```
function distanceto(a::LongLat, b::LongLat)::Float64
	x_diff = a.longitude - b.longitude
	y_diff = a.latitude  - b.latitude
	return √(x_diff^2 + y_diff^2)
end

```@docs 
Get the distance between two coordinates, if it intersects
the no-fly zone it will be set to a high value
```
function distanceto(a::LongLat,b::LongLat, noflyzone::Vector{Vector{Line2D}})::Float64
	xdiff = a.longitude - b.longitude
	ydiff = a.latitude  - b.latitude
	e = Line2D(a, b)	
	for z in noflyzone
		for l in z
			if intersects(l, e)
				return 15000.0
			end
		end
	end
	return √(xdiff^2 +ydiff^2)
end

```@docs check whether two points are close to each other ```
function closeTo(coord::LongLat, point::LongLat)::Bool
	return distanceto(coord, point) < UNITMOVE
end


```@docs Get the next position of the drone```
function nextPosition(coord::LongLat, θ::Int64)::LongLat
	xmove = UNITMOVE * cosd(θ)
	ymove = UNITMOVE * sind(θ)

	val = LongLat(coord.longitude + xmove, 
				  coord.latitude  + ymove,
				  θ)	
	return val		
end

end

