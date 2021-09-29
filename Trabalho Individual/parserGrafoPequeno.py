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

prolog.write("\n\n")

#código para escrever no ficheiro prolog os caminhos do circuito para os casos práticos
prolog.write('caminho(0,15805).\n')

prolog.write('caminho(15805, 15856).\n')
prolog.write('caminho(15805, 15808).\n')
prolog.write('caminho(15805, 15855).\n')

prolog.write('caminho(15856, 15887).\n')
prolog.write('caminho(15856, 15805).\n')

prolog.write('caminho(15808, 15855).\n')
prolog.write('caminho(15808, 15809).\n')
prolog.write('caminho(15808, 15805).\n')

prolog.write('caminho(15855, 15887).\n')
prolog.write('caminho(15855, 15808).\n')
prolog.write('caminho(15855, 15805).\n')
prolog.write('caminho(15855, 15890).\n')

prolog.write('caminho(15887, 15884).\n')
prolog.write('caminho(15887, 15869).\n')
prolog.write('caminho(15887, 15855).\n')

prolog.write('caminho(15884, 15869).\n')
prolog.write('caminho(15884, 15997).\n')
prolog.write('caminho(15884, 15898).\n')

prolog.write('caminho(15898, 15884).\n')
prolog.write('caminho(15898, 15869).\n')
prolog.write('caminho(15898, 15890).\n')

prolog.write('caminho(15869, 15887).\n')
prolog.write('caminho(15869, 15884).\n')
prolog.write('caminho(15869, 15898).\n')
prolog.write('caminho(15869, 15890).\n')

prolog.write('caminho(15890, 15855).\n')
prolog.write('caminho(15890, 15869).\n')
prolog.write('caminho(15890, 15898).\n')
prolog.write('caminho(15890, 15812).\n')

prolog.write('caminho(15812, 15890).\n')
prolog.write('caminho(15812, 15809).\n')
prolog.write('caminho(15812, 15810).\n')

prolog.write('caminho(15809, 15808).\n')
prolog.write('caminho(15809, 15810).\n')
prolog.write('caminho(15809, 15812).\n')

prolog.write('caminho(15810, 15812).\n')
prolog.write('caminho(15810, 15809).\n')
prolog.write('caminho(15810, 15878).\n')

prolog.write('caminho(15878, 15810).\n')
prolog.write('caminho(15878, 1).\n')

prolog.close