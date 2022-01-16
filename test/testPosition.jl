module testPosition

using  ilp
#using ilp:Position
#using  ilp.Position
using ilp.Position

using Test
const appletonTower= LongLat(-3.186874, 55.944494, -999)

const businessSchool = LongLat(-3.1873,55.9430, -999)

const greyfriarsKirkyard = LongLat(-3.1928,55.9469, -999)

@testset "isConfined" begin
	@test Position.isconfined(appletonTower) == true
	@test Position.isconfined(businessSchool) == true
	@test Position.isconfined(greyfriarsKirkyard) == false
end

function approxEq(d1::Float64, d2::Float64)::Bool
	return abs(d1-d2) < 1e-12
end


const calculatedDistance = 0.0015535481968716011;
@testset "distanceto" begin
	@test approxEq(Position.distanceto(appletonTower, businessSchool),calculatedDistance) == true
end

@testset "closeto" begin
	alsoAppletonTower = LongLat(-3.186767933982822, 55.94460006601717, -999)
	@test Position.closeTo(appletonTower, alsoAppletonTower) == true
	@test Position.closeTo(appletonTower, businessSchool)    == false
end

function approxEq(l1::LongLat, l2::LongLat)::Bool
	return approxEq(l1.longitude, l2.longitude) && approxEq(l1.latitude, l2.latitude)
end

@testset "nextPosition" begin
	
	nextPosition = Position.nextPosition(appletonTower, 0)
	calculatedPosition = LongLat(-3.186724, 55.944494, 0)
	@test approxEq(nextPosition, calculatedPosition) == true

	nextPosition = Position.nextPosition(appletonTower, 20)
    calculatedPosition = LongLat(-3.186733046106882, 55.9445453030215, 20)
	@test approxEq(nextPosition, calculatedPosition) == true

	nextPosition = Position.nextPosition(appletonTower, 50)
	calculatedPosition = LongLat(-3.186777581858547, 55.94460890666647,50)
	@test approxEq(nextPosition, calculatedPosition) == true

	nextPosition = Position.nextPosition(appletonTower, 90)
    calculatedPosition = LongLat(-3.186874, 55.944644, 90)
	@test approxEq(nextPosition, calculatedPosition) == true

    nextPosition = Position.nextPosition(appletonTower, 140)
    calculatedPosition = LongLat(-3.1869889066664676, 55.94459041814145, 140)
	@test approxEq(nextPosition, calculatedPosition) == true

    nextPosition = Position.nextPosition(appletonTower, 190);
    calculatedPosition = LongLat(-3.1870217211629517, 55.94446795277335,190)
    @test approxEq(nextPosition, calculatedPosition) == true

	nextPosition = Position.nextPosition(appletonTower, 260)
	calculatedPosition = LongLat(-3.18690004722665, 55.944346278837045, 260)
    @test approxEq(nextPosition, calculatedPosition) == true

	nextPosition = Position.nextPosition(appletonTower, 300)
	calculatedPosition = LongLat(-3.186799, 55.94436409618943, 300)
    @test approxEq(nextPosition, calculatedPosition) == true

	nextPosition = Position.nextPosition(appletonTower, 350)
	calculatedPosition = LongLat(-3.1867262788370483, 55.94446795277335,350)
    @test approxEq(nextPosition, calculatedPosition) == true

	a = Position.nextPosition(appletonTower, -999)
    @test approxEq(a, appletonTower) == true

end

end
