extends Node

func normalizeOnRange(a, b, x):
	return  ( (x - a) / (b - a) )

func linearInterpolation(a, b, x):
	return ( (1 - x)* a + x * b )

func degreesToRadians(d):
	return (d * PI / 180) 

func radiansToDegrees(r):
	return (r * 180 / PI)
