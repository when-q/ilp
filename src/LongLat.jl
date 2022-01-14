module Position

using Documenter

"""
Position is a module that responsible for position related calculation
"""
export LongLat,UNITMOVE

const UNITMOVE = 0.00015

"LongLat stores longitude, latitude and angle of a drone at a specific position"
struct LongLat
	longitude::Float64	
	latitude::Float64	
	angle::Int64
end


"""
	isconfined(coord)

Takes a coordinate and check whether it's in the confinement zone.
returns true if it is in the zone.
""" 
function isconfined(coord::LongLat)::Bool 
	x_confined = false
	y_confined = false
	if longitude > -3.192473 && longitude < -3.184319
			x_confined = true
	end
	if latitude > 55.942617 && latitude < 55.946233
		y_confined = true
	end
	return x_confined &&  y_confined
end



"""
	distanceto(a::LongLat, b::LongLat)::Float64

Calculate the distance between two coordinates
"""
function distanceto(a::LongLat, b::LongLat)::Float64
	x_diff = a.longitude - b.longtitude
	y_diff = a.latitude  - b.latitude
	return √(x_diff^2 + y_diff^2)
end

function distanceto(a::LongLat,b::LongLat, noflyzone::Vector{Vector{LongLat}})::Float64
end

function closeTo(coord::LongLat)::Bool
end

function nextPosition(coord::LongLat)::Int64

end

end
