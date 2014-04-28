
import math

def scalpr(v1,v2=0):
	'''
	Rechnet das Skalarprodukt von vektor v2 und v1 aus
	'''
	if v2 == 0: v2 = v1
	result = 0
	for i in range(len(v1)):
		result += v1[i]*v2[i]
	return result

def side(a,b):
	'''
	Berechne den Vektor zwischen Punkt b und a, ergo b - a
	'''
	c = []
	for i in range(len(a)):
		c.append(b[i]-a[i])
	return c

def betr(vector):
	'''
	Laenge des Vektors vector
	'''
	return math.sqrt(scalpr(vector))

def scal(skalar,vector):
	'''gibt skalierten vektor vector mit skalar zurueck
	'''
	c = []
	for i in range(len(vector)):
		c.append(vector[i] * skalar)
	return c

def normi(vector):
	'''
	Gibt normierten Vektor zu vector zurueck
	'''
	return scal(1/betr(vector),vector)

def proj(u,v):
	'''
	Gibt die Projektion von Vektor u auf v zurueck
	'''
	norm_v = normi(v)
	return scal(scalpr(u,norm_v),norm_v)

'''def cartpr(a,b):
	
	Diese Funktion rechnet das Kreuzprodukt aus fuer 3d Vektoren
	
	c = []
	c.append(a[1]*b[2] - a[2]*b[1])
	c.append(a[2]*b[0] - a[0]*b[2])
	c.append(a[0]*b[1] - a[1]*b[0])
	return c'''

def cartpr(vectors):
	'''
	Berechnet das kartesische Produkt fuer beliebig dimensionierte Vektoren
	'''
	result = []
	vectors = matrix_rows_to_columns(vectors)
	for i in range(len(vectors)):
		result.append(determinant(vectors[:i] + vectors[i+1:]))
	return result

def matrix_rows_to_columns(input_matrix):
	'''
	Konvertiert ein Array von Spaltenvektoren in das aequivalente Array von Zeilenvektoren
	und umgekehrt
	'''
	output_matrix = []
	for i in range(len(input_matrix[0])):
		output_matrix.append([])
		for p in range(len(input_matrix)):
			output_matrix[i].append(input_matrix[p][i])
	return output_matrix

def tripr(v1,v2,v3):
	'''
	Gibt das Spatprodukt der Vektoren v1,v2 und v3 zurueck
	Nur fuer 3-dimensionale Vektoren
	'''
	return scalpr(v1,cartpr(v2,v3))

def tetrvol(v1,v2,v3):
	'''
	Gibt das Tetraedervolumen ueber dem Spat aus den Vektoren v1,v2,v3 zurueck
	Nur fuer 3-dimensionale Vektoren
	'''
	return abs(tripr(v1,v2,v3))/6

def pldist(x,n,r):
	'''
	Gibt den Abstand des Punktes X von der ebene mit Normalenvektor n und fusspunkt r
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

def determinant(input_matrix):
	'''
	Gibt die Determinante der Matrix input_matrix zurueck.
	'''
	output_matrix = 0
	if len(input_matrix) > 2:
		for j in range(len(input_matrix)):
			if input_matrix[0][j] == 0:
				continue
			elif j%2:
				output_matrix -= input_matrix[j][0] * determinant(inner_matrix(input_matrix,j))
			else:
				output_matrix += input_matrix[j][0] * determinant(inner_matrix(input_matrix,j))
		return output_matrix
	else:
		return input_matrix[0][0] * input_matrix[1][1] - input_matrix[1][0] * input_matrix[0][1]
	
def inner_matrix(input_matrix,j,i=0):
	'''
	Gibt die n-1te Matrix zurueck , durch entfernen der i. Zeile und j. Spalte
	'''
	output_matrix = []
	for current_column in input_matrix[j+1:] + input_matrix[:j]:
		output_matrix.append(current_column[i+1:] + current_column[:i])
	return output_matrix


