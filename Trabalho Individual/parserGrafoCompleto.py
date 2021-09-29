from os import popen
import openpyxl
from pathlib import Path
import re

xlsx_file = Path('dataset.xlsx')
wb = openpyxl.load_workbook(xlsx_file)
sheet = wb.active

prolog = open("pontosRecolha.pl", "w")
prolog.write(":- dynamic pontoRecolha/7.\n")
prolog.write(":- dynamic caminho/2.\n\n")

prolog.write("inicial(0).\n")
prolog.write("final(1).\n\n")

prolog.write("pontoRecolha(-9.14320880914792, 38.7073787857025, 0, " + '\'Misericordia\',' + '0, \'Garagem\'' + ", 0).\n")
prolog.write("pontoRecolha(-9.142812171, 38.706265483955, 1, " + '\'Misericordia\', ' + '1, \'Deposito\'' + ", 0).\n")


stringColumns = [3,4,5,6]
usefullColumns = [0,1,2,3,4,5,9]

pontos = []

controlLine = 0
contadorAux = 0;

for row in sheet.iter_rows(max_row=420):
    if (controlLine != 0):
        string = ""
        controlColumn = 0
        for cell in row:
            if (controlColumn < 9):
                if controlColumn == 4:
                    splitRua = cell.value.split(":")
                    idRua = splitRua[0]
                    string += idRua + ", "
                    if idRua not in pontos:
                        pontos.append(idRua)
                else:
                    if controlColumn in usefullColumns:
                        if controlColumn in stringColumns:
                            first = re.sub('ó', 'o', str(cell.value))
                            normalized = re.sub('ã', 'a', first)
                            string += '\'' + normalized + '\', '
                        else:
                            string += str(cell.value) + ', '
            else:
                string += str(cell.value)
            controlColumn += 1
        prolog.write('pontoRecolha(' + string + ').\n')
    controlLine += 1

prolog.write("\n")

import re

file = open("allPaths.txt")

for line in file:
    n1 = line.split(" ")
    n2 = n1[1].split("\n")
    s = "caminho(" + n1[0] + ", " + n2[0] + ").\n"
    prolog.write(s)

prolog.write('caminho(0,15805).\n')
prolog.write('caminho(21961,1).\n')

