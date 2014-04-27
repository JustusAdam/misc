
import math

def scalpr(a,b=0):
	'''Rechnet das Skalarprodukt von vektor b und a aus
	'''
	if b == 0: b = a
	c = 0
	for i in range(len(a)):
		c += a[i]*b[i]
	return c

def side(a,b):
	'''Berechne den Vektor zwischen Punkt b und a, ergo b - a
	'''
	c = []
	for i in range(len(a)):
		c.append(b[i]-a[i])
	return c

def betr(a):
	'''Laenge des Vektors a
	'''
	return math.sqrt(scalpr(a))

def scal(a,b):
	'''gibt skalierten vektor b mit skalar a zurueck
	'''
	c = []
	for i in range(len(b)):
		c.append(b[i] * a)
	return c

def normi(a):
	'''Gibt normierten vector zu a zurueck
	'''
	return scal(1/betr(a),a)

def proj(a,b):
	'''gibt die Projektion von Vektor a auf b zurueck
	'''
	c = normi(b)
	return scal(scalpr(a,c),c)

def cartpr(a,b):
	'''Diese Funktion rechnet das Kreuzprodukt aus fuer 3d Vektoren
	'''
	c = []
	c.append(a[1]*b[2] - a[2]*b[1])
	c.append(a[2]*b[0] - a[0]*b[2])
	c.append(a[0]*b[1] - a[1]*b[0])
	return c

def tripr(a,b,c):
	'''Gibt das Spatprodukt der Vektoren a,b und c zurueck
	'''
	return scalpr(a,cartpr(b,c))

def tetrvol(a,b,c):
	'''Gibt das Tetraedervolumen ueber dem Spat aus den Vektoren a,b,c zurueck
	'''
	return abs(tripr(a,b,c))/6

def pldist(x,n,r):
	'''Gibt den Abstand des Punktes X von der ebene mit Normalenvektor n und fusspunkt r
	'''
	return scalpr(normi(n),side(r,x))

def cosalpha(a,b,c):
	'''
		Gibt den cosinus eines Winkels alpha zurueck, 
		a ist die dem Winkel gegenueber liegende seite
		b, c sind die anliegenden seiten (reihenfolge egal)
		alle werte sind laengen
	'''
	return (b**2+c**2-a**2)/(2*b*c)



