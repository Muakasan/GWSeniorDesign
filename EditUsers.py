#from shutil import copyfile 
from os import makedirs
from os.path import exists

def getStudentNames():
	l = [[2011],[2012],[2013],[2014],[2015]]
	infile = open("users.txt", "r")
	year = 0
	while(True):
		lineStng = infile.readline()
		if lineStng=="":
			break
		lineStng = lineStng[:len(lineStng)-1]
		if lineStng == "":
			year+=1
		else:
			l[year].append(lineStng)
	print(l)
	infile.close()
	return l

def getTemplate():
	infile = open("student_bio_template.html", 'r')
	fileStng = infile.read()
	infile.close()
	return fileStng

def main():
	template = getTemplate()
	l = getStudentNames()
	for i in l:
		directory = str(i[0])+"/"
		for j in i[1:]:
			nameStng = j.replace(" ", "_")
			studentDirectory = directory+nameStng
			outfile = open(studentDirectory+"/"+nameStng+".html", "w+")
			myTemplate = template.replace("student_name", j)
			myTemplate = myTemplate.replace("my_year", str(i[0]))
			outfile.write(myTemplate)
			outfile.close()
main()