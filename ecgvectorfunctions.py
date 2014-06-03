'''
Mathematische Funktionen zur Berechnung einiger typscher Vektoroperationen
Vektoren sind Listen von numerischen Werten aka. [x,y,z]
Die meisten Funktionen koennen mit vektoren beliebiger Laenge umgehen.
Matritzen sind Listen von vektoren (gleicher Laenge) aka [v1,v2,v3].
Fuer beide sollten auch n-Tupel funktionieren, allerdings ist das nicht getestet.
'''
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
	return [b[i] - a[i] for i in range(len(a))]

def betr(vector):
	'''
	Laenge des Vektors vector
	'''
	return math.sqrt(scalpr(vector))

def scal(skalar,vector):
	'''
	Gibt skalierten Vektor vector mit skalar zurueck
	'''
	return [vector[i] * skalar for i in range(len(vector))]

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

def cartpr(vectors):
	'''
	Berechnet das kartesische Produkt fuer beliebig dimensionierte Vektoren.
	Der Input (vectors) ist eine Liste von Vektoren [v1,v2,v3 ...]
	'''
	vectors = matrix_rows_to_columns(vectors)
	# for i in range(len(vectors)):
	# 	result.append(determinant(vectors[:i] + vectors[i+1:]))
	return [determinant(vectors[:i] + vectors[i+1:]) for i in range(len(vectors))]

def matrix_rows_to_columns(input_matrix):
	'''
	Konvertiert ein Array von Spaltenvektoren in das aequivalente Array von Zeilenvektoren
	und umgekehrt
	# '''
	# output_matrix = []
	# for i in range(len(input_matrix[0])):
	# 	output_matrix.append([])
	# 	for p in range(len(input_matrix)):
	# 		output_matrix[i].append(input_matrix[p][i])
	# return output_matrix
	return [[input_matrix[p][i] for p in range(len(input_matrix))] for i in range(len(input_matrix[0]))]

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
	matrix_length_x = len(input_matrix)
	if not check_deter_matrix(input_matrix):
		if matrix_length_x == 1: return input_matrix[0][0]; 
		return calc_determinant(input_matrix)
	else:
		print("Input error, matrix unsuitable")
		return None

def calc_determinant(input_matrix):
	'''
	Pseudo Funktion, wird von determinant() aufgerufen,
	wenn die notwendigen Sicherheitschecks abgeschlossen sind.
	'''
	if len(input_matrix) == 2:
		return input_matrix[0][0] * input_matrix[1][1] - input_matrix[1][0] * input_matrix[0][1]
	
	output_matrix = 0
	for j in range(len(input_matrix)):
		if input_matrix[0][j] == 0: #Kuerzt die Berechnung ab, wenn der Faktor 0 ist
			continue
		elif j%2:
			output_matrix -= input_matrix[j][0] * calc_determinant(inner_matrix(input_matrix,j))
		else:
			output_matrix += input_matrix[j][0] * calc_determinant(inner_matrix(input_matrix,j))
	return output_matrix

def check_deter_matrix(input_matrix):
	'''
	Sicherheitscheck fuer Determinantenberechnung
	Returnt 1, wenn die Matrix nicht Quadratisch ist oder leer.
	'''
	matrix_length_x = len(input_matrix)
	if matrix_length_x < 1:
		return 1
	for i in [len(column) for column in input_matrix]:
		if i != matrix_length_x:
			return 1
	return 0

def inner_matrix(input_matrix,j,i=0):
	'''
	Gibt die n-1te Matrix zurueck , durch entfernen der i. Zeile und j. Spalte
	# '''
	# output_matrix = []
	# for current_column in input_matrix[j+1:] + input_matrix[:j]:
	# 	output_matrix.append(current_column[i+1:] + current_column[:i])
	# return output_matrix
	return [current_column[i+1:]+ current_column[:i] for current_column in input_matrix[j+1:] + input_matrix[:j]]


