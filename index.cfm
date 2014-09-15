<cfset myArray = ["Bob","Sue","Sally","Noah"]>
<cfset arrayAppend(myArray,"Norm")>
<cfdump var="#myArray#" label="New Array">

<cfset twoDimArray = [["one one", "one two"],["two one", "two two"]]>
<cfdump var="#twodimArray#" label="twoDimArray">
<cfdump var="#twodimArray[2]#">

<cfset sortedArray = arraySort(myArray, "textnocase")>

<cfset myQuery = queryNew("Name, Age", "Varchar, Integer", [["Noah", 39], ["Wendy",48]])>


<cfdump var="#myQuery#" />


<cfscript>
	secondArray = ["one","two","three"];
	arrayAppend(secondArray, "four");
	writeDump(var=secondArray, label="Second Array");

	twoDimArrayScript = [["one one","one two"],["two one", "two two"]];
	writeDump(var=twoDimArrayScript, label="Two Dim Array");	
	writeDump(twoDimArrayScript[1]);
</cfscript>



