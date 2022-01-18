module Position
"""
Position is a module that responsible for position related calculation
"""

using ..Documenter

export LongLat,UNITMOVE,Line2D

const UNITMOVE = 0.00015

"""
	struct LongLat
A structure that stores position related property for an object

Fields
------
* `longitude`: the longitude of the position of any point
* `latitude`:  the latitude of the position of any point
* `angle`:     the angle of the drone at a specific point, in integer. It is required to be a multiple of 10.

"""
struct LongLat
	longitude::Float64
	latitude::Float64	
	angle::Int64
end

"""
	Line2D(s::LongLat, e::LongLat)

Line2D represents a line by its starting and ending point
"""
struct Line2D
	s::LongLat
	e::LongLat
end

"""
	isconfined(coord::LongLat)::Bool

Takes a coordinate and check whether it's in the confinement zone.
returns true if it is in the zone.
""" 
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

"""
	intersects(e::Line2D, l::Line2D)::Bool

`(a,b)→(c,d)` intersects `(p,q) → (r,s)`
Check whether two lines intersects
"""
function intersects(e::Line2D, l::Line2D)::Bool
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

"""
	distanceto(a::LongLat, b::LongLat)::Float64

Calculate the distance between two coordinates
"""
function distanceto(a::LongLat, b::LongLat)::Float64
	x_diff = a.longitude - b.longitude
	y_diff = a.latitude  - b.latitude
	return √(x_diff^2 + y_diff^2)
end

"""
	distanceto(a::LongLat, b::LongLat, noflyzone::Vector{Vector{Line2D}})::Float64

Get the distance between two coordinates, if it intersects
the no-fly zone it will be set to a high value
"""
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

"""
	closeto(coord::LongLat, point::LongLat)::Bool

check whether two points are close to each other
"""
function closeto(coord::LongLat, point::LongLat)::Bool
	return distanceto(coord, point) < UNITMOVE
end


"""
	nextPosition(coord::LongLat, θ::Int64)::LongLat

Get the next position of the drone
"""
function nextPosition(coord::LongLat, θ::Int64)::LongLat
	xmove = UNITMOVE * cosd(θ)
	ymove = UNITMOVE * sind(θ)
	if θ != -999
		val = LongLat(coord.longitude + xmove, 
				  coord.latitude  + ymove,
				  θ)	
	else
		val = coord
	end
	return val		
end

end

