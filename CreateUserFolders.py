from shutil import copyfile 

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
	infile = open("student_bio_template.html")
def createFolders(directory):
	print("hello")

def main():
	l = getStudentNames()
	for i in l:
		directory = n[0]+'/'
		for j in i:
			nameStng = i.replace(" ", "_")
			outfile = open(nameStng+".html", "w+")
			

main()