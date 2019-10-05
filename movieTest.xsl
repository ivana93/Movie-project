<?xml version="1.0" encoding="UTF-8"?>

<!-- New document created with EditiX at Sat Dec 01 20:54:47 CET 2018 -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:dir="http://apache.org/cocoon/directory/2.0"
xmlns:xs="http://www.w3.org/2001/XMLSchema"
exclude-result-prefixes="xs">
<xsl:variable name="xsd" select="document('moviemanagement.xsd')"/>
	<xsl:output method="html"/>
		<xsl:template match="/">
		<html>
			<head>
				<title>Movie Management</title>
			</head>
			<body>
			<h1>Movie Management</h1><!-- Creating the first table -->
			<h4>Tabellarische Übersicht über alle Filme, die einen auswählbaren Gerne zugeordnet werden</h4>
			<form action="genreHTML" method="get" target="_blank">
			Genre: <select name="genre">	
				<xsl:for-each select="//moviemanagement/genres/genre">
						<!-- Name des Genres wird angezeigt -->
					  <option><xsl:value-of select="description"></xsl:value-of></option>
				</xsl:for-each>
				</select>
				<button style="margin:0px 10px" type="submit">HTML</button>			
			</form>	
			<br/>
				<h4>Tabellarische Übersicht über alle Filme, in denen eine Schauspielerin/ ein Schauspieler mitgespielt hat </h4>
			<form action="schauspielerHTML" method="get" target="_blank">
				Vorname: 
				<select name="vorname">
					<option></option>
					<xsl:for-each select="//moviemanagement/people/person">
						<xsl:sort select="fname"/>
							<option><xsl:value-of select="fname"/></option>
					</xsl:for-each>
				</select>
	 <!-- Zeigt alle Nachnamen -->
				Nachname: 
				<select name="nachname">
					<option></option>
					<xsl:for-each select="//moviemanagement/people/person">
						<xsl:sort select="lname"/>
							<option><xsl:value-of select="lname"/></option>
					</xsl:for-each>		
				</select>				
				<button style="margin:0px 10px" type="submit">HTML</button>
			</form>
			<br/>	
			<!--  Zeigt alle Erscheinungsjahre an, die die Filme der Filmbibliothek verwenden. Jedoch nicht zweimal  -->
			<h4>Tabellarische Übersicht über alle Filme, die in einem auswählbaren Jahr erschienen sind</h4>
			<form action="jahrHTML" method="get" target="_blank">
				Jahr: 
				<select name="jahr">
					<xsl:for-each select="//moviemanagement/movies/movie">
					<!-- Die Zahlen sortieren. Kleinste zuerst -->
						<xsl:sort select="year"/>
						 <!-- Alle Jahre der Filme werden aufgelistet, jedoch kein selbes Jahr zweimal -->
	    				<xsl:if test="not(year=preceding::movie/year)">
 						<option> <xsl:value-of select="year"/> </option>
 						</xsl:if>
					</xsl:for-each>
				</select>
				<button style="margin:0px 10px" type="submit">HTML</button>
			</form>
			<br/>
	
			
			<!-- mit leerem Feld Namen einzugeben -->
			<h4>Tabellarische Übersicht über alle Filme, in denen eine Person Regie geführt hat</h4>
			<form action="regisseurHTML" method="get" target="_blank">
				Regie: 
				<!-- Placeholder für die Inputfelder mit "vorname" und "nachname". Bei Mausklick in diesen Feldern verschwindet der Placeholder -->
				<input type="text" name=" first name" placeholder="first name" size="10"/>
				<input type="text" name="last name" placeholder="last name" size="10	"/>
				<button style="margin:0px 10px" type="submit">HTML</button>
			</form>
			<br/>
			
			<!-- Bachdel Test-->
			<h4>Tabellarische Übersicht über alle Filme, die den Bechdel-Test bestanden haben</h4>
			<form action="bechdelHTML" method="get"  target="_blank">
				Bechdel-Test: 
				<button style="margin:0px 10px" type="submit">HTML</button>
			</form>
			<br/>
			
			<h4>Tabellarische Übersicht über alle Filme, die für ein auswählbares Mindestalter geeignet sind</h4>			
			<form action="fskHTML" method="get" target="_blank">
			Mindestalter: 
				<select name="fsk">		
				<!-- So wird das ENUM, also die möglichen FSK werte die erlaubt sind, aus der XSD angezeigt -->			
					
<xsl:for-each select="//moviemanagement/movies/movie/bachdelTest">
					
<xsl:if test="not(age=preceding::movie/bachdelTest/age)">
					
<option><xsl:value-of select="age"/></option>
					

</xsl:if>
					
</xsl:for-each>
					
				</select>
				<button style="margin:0px 10px" type="submit">HTML</button>
			</form>
				<br/>
				
			</body>
		</html>
		
	</xsl:template>
	
	<!-- Templates for genre-->
	<xsl:template match="genre">
		<xsl:apply-templates select="/moviemanagement/genres/genre[id=current()]"/>
		<xsl:if test="position() != last()">,  </xsl:if>
	</xsl:template>
	
	<xsl:template match="/moviemanagement/genres/genre">
		<xsl:value-of select="description"/>
	</xsl:template><!-- Templates for director-->
	
	<xsl:template match="director">
		<xsl:apply-templates select="/moviemanagement/people/person[id=current()]"/>
		<xsl:if test="position() != last()">, </xsl:if>
	</xsl:template>
	
	<xsl:template match="/moviemanagement/people/person">
		<xsl:value-of select="fname"/>
		<br/>
		<xsl:value-of select="lname"/>
	</xsl:template><!-- Templates for actor-->
	
	<xsl:template match="actor">
		<xsl:apply-templates select="/moviemanagement/people/person[id=current()]"/>
		<xsl:if test="position() != last()">, </xsl:if>
	</xsl:template>
	
	<xsl:template match="/moviemanagement/people/person">
		<xsl:value-of select="fname"/>
		<br/>
		<xsl:value-of select="lname"/>
	</xsl:template>
</xsl:stylesheet>
