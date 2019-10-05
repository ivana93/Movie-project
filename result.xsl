<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:xdt="http://www.w3.org/2005/xpath-datatypes"
	xmlns:err="http://www.w3.org/2005/xqt-errors"
	exclude-result-prefixes="xs xdt err fn">

	<xsl:output method="html" indent="yes"/>
	<!-- Attribut genre, schauspieler, regie, jahr etc um die einzelnen Tabellen aufzurufen -->
	<xsl:param name="filterTyp"/>
	<!-- Wenn etwas übergeben werden soll wie zb Nachname und Vorname, oder ein Genre etc. -->
	<xsl:param name="filter1"/>
	<xsl:param name="filter2"/>
	
	<xsl:template match="/">
		<html>
			<body>
				<xsl:choose>
		<!-- When Abfrage um die jeweilge Tabelle anzeigen zulassen, dass Attribut filterTyp wird von der sitemap übergeben -->	
					<!--Tabelle Genre, zeigt die Filme zugehörig zu einem Genre  -->
					<xsl:when test="$filterTyp = 'genre'">
							<table border="2" >
								<xsl:call-template name="tabellenkopf"></xsl:call-template>
										<!-- ID des ausgewählten Genre filter1 wird herausgesucht und anschließend einem Template übergeben -->
										<xsl:for-each select="//moviemanagement/genres/genre[description=$filter1]/id">
													<xsl:call-template name="bekommeFilm">
				                    			    	<xsl:with-param name="id" select="."/>    
				                 				   </xsl:call-template>				 						
										</xsl:for-each>
							</table>
					</xsl:when>
					<xsl:when test="$filterTyp = 'actor'">
							Ergebnis für die Schauspielersuche nach <xsl:value-of select="$filter1"/>&#160;<xsl:value-of select="$filter2"/>
							<br/>
							<br/>
							Ergebnisse für die Kombination aus Vornamen und Nachnamen: 
							<table border ="2">
							<xsl:call-template name="tabellenkopf"></xsl:call-template>
								<!-- Für jeden Schauspieler mit dem eingegeben Nachnamen filter2 und Vornamen filter 1. L-->
								<xsl:for-each select="//moviemanagement/people/person[fname=$filter1 and lname=$filter2]/id">
										<xsl:call-template name="ergebnisseFilmeperSchauspieler">
												<xsl:with-param name="id" select="."/>
										</xsl:call-template>
							</xsl:for-each>
							</table>
							<br/>
							Ergebnisse für Nachnamen und Vornamen einzeln betrachtet:							
							<table border ="2">
							<xsl:call-template name="tabellenkopf"></xsl:call-template>
								<!-- Für jeden Schauspieler der den Nachnamen oder Vornamen beinhaltet, soll die ID dem Template übergeben werden -->
							<xsl:for-each select="//moviemanagement/people/person[(fname=$filter1 or lname=$filter2) and not (fname=$filter1 and lname=$filter2)]/id">
									<!-- ID des Schauspielers wird übergeben -->
									<xsl:call-template name="ergebnisseFilmeperSchauspieler">
												<xsl:with-param name="id" select="."/>
									</xsl:call-template>
							</xsl:for-each>	
						</table>
					</xsl:when>
					<xsl:when test="$filterTyp = 'jahr'">
					
						<!-- Filter1 ist das ausgewählte Jahr. Übereinstimmungen werden gezählt -->	
						<h4>Für das Jahr <xsl:value-of select="$filter1"/> wurde/n <xsl:value-of select="count(//moviemanagement/movies/movie[year=$filter1])"/> Film/e gefunden.</h4>						
						<table border="2" >
							<xsl:call-template name="tabellenkopf"></xsl:call-template>
								<!-- Jeder Film der in dem ausgwählten Jahr herausgekommen ist. -->	
							<xsl:for-each select="//moviemanagement/movies/movie[year=$filter1]">
							
							<tr>
								<!-- Anzeigen der Daten von den Ergebnissen.  -->
								
								<td> <xsl:value-of select="titel"></xsl:value-of></td>
	            						<td> <xsl:value-of select="year"/> </td>
								<td> <xsl:value-of select="duration"/> Min.</td>
								<td> <xsl:for-each select="genre">
		                        <xsl:call-template name="ergebnisseGenre">
		                              <xsl:with-param name="id" select="."/>
		                        </xsl:call-template>
	    							</xsl:for-each> </td>
			    				   	 <td><xsl:value-of select="bachdelTest/outcome"/></td>
			    				   	 <td><xsl:value-of select="bachdelTest/age"/></td>
	    				   	   	<!-- For each da es mehrere Datenträger geben kann --> 
	    		            	<td> <xsl:for-each select="dvd"> <xsl:value-of select="art"/>, <xsl:value-of select="price"/>€
	    							  <br/>
	     		 			    </xsl:for-each> </td>	
	           			 	<br/>
							</tr>
							</xsl:for-each>	
						</table>
					</xsl:when>
						<xsl:when test="$filterTyp = 'regisseur'">	
							Ergebnis für den Regisseur  <xsl:value-of select="$filter2"/>
							<br/>
							<br/>
							Ergebnisse für die Kombination aus Vornamen und Nachnamen: 
							<table border ="2">
							<xsl:call-template name="tabellenkopf"></xsl:call-template>
							<!-- Ergebnisse bei denen Nachname und Vorname übereinstimmen. ID wird dem Template übergeben -->	
							<xsl:for-each select="//moviemanagement/people/person[fname=$filter1 and lname=$filter2]/id">">
										<xsl:call-template name="ergebnisseRegieFilme">
												<xsl:with-param name="id" select="."/>
										</xsl:call-template>
							</xsl:for-each>
							</table>
							<br/>		
						Ergebnisse für Nachnamen und Vornamen einzeln betrachtet:
						<table border = "2">
						<xsl:call-template name="tabellenkopf"></xsl:call-template>
						<!-- Ergebnisse der Regisseure, die entweder den Nachnamen oder Vornamen beinhalten. Die ID der Personen die diese Kriterien haben, wird dem Template übergeben -->
						<xsl:for-each select="//moviemanagement/people/person[(fname=$filter1 or lname=$filter2) and not (fname=$filter1 and lname=$filter2)]/id">
							<xsl:call-template name="ergebnisseRegieFilme">
									<xsl:with-param name="id" select="."/>
							</xsl:call-template>
						</xsl:for-each>		
						</table>				
					</xsl:when>
					<xsl:when test="$filterTyp = 'bechdel'">
					
						<!-- Zählt die bestandenen bechdel tests und speichert diese in einem Attribut -->
						<xsl:variable name="passed" select ="count(/moviemanagement/movies/movie/bachdelTest[outcome= 'passed'])" />
						<!-- Ergebnis anzeigen lassen des attributs bestanden -->
					<h2>	Es wurden <xsl:value-of select="$passed"></xsl:value-of> Filme gefunden, die den Bechdel-Test bestanden haben </h2>		
						<table border="2" >
							<xsl:call-template name="tabellenkopf"></xsl:call-template>
						<!-- Für jeden Film der bestanden hat-->	
							<xsl:for-each select="//moviemanagement/movies/movie/bachdelTest[outcome='passed']">
							<tr>
							<!-- Daten der Filme die den bechdel test bestanden haben -->
								
								<td> <xsl:value-of select="title"></xsl:value-of></td>
	            				<td> <xsl:value-of select="year"/> </td>
								<td> <xsl:value-of select="duration"/> Min.</td>
								<td> <xsl:for-each select="genre">
				                    <xsl:call-template name="ergebnisseGenre">
				                        <xsl:with-param name="id" select="."/>
				                    </xsl:call-template>
	    						</xsl:for-each> </td>
	    						<td><xsl:value-of select="bachdelTest/outcome"/></td>
	    						<td><xsl:value-of select="bachdelTest/age"/></td>
	    						<td> <xsl:for-each select="dvd">
	       						 <xsl:value-of select="price"/>€,  <xsl:value-of select="art"/>
	    						<br/>
	     		   				</xsl:for-each> </td>	
							</tr>
							</xsl:for-each>	
							<br/>
						</table>
					</xsl:when>
					<!-- Sortierung des Mindestalters -->	
					<xsl:when test="$filterTyp = 'fsk'">
					<!-- Zählen der Treffer die das ausgewählte Mindestalter haben -->
						<h4>Für das Mindestalter <xsl:value-of select="$filter1"/> wurden <xsl:value-of select="count(//moviemanagement/movies/movie/bachdelTest[age=$filter1])"/> Filme gefunden.</h4>				
						<table border="2" >
							<xsl:call-template name="tabellenkopf"></xsl:call-template>
							<!-- Für jeden Film mit dem ausgewählten Mindestalter filter1 -->
							<xsl:for-each select="//moviemanagement/movies/movie[bachdelTest/age=$filter1]">
							<tr>
								
								<td> <xsl:value-of select="title"></xsl:value-of></td>
	            						<td> <xsl:value-of select="year"/> </td>
								<td> <xsl:value-of select="duration"/> Min.</td>
								<td> <xsl:for-each select="genre">
				                    <xsl:call-template name="ergebnisseGenre">
				                        <xsl:with-param name="id" select="."/>
				                    </xsl:call-template>
	    						</xsl:for-each> </td>
	    						<td><xsl:value-of select="bachdelTest/outcome"/></td>
	    						<td><xsl:value-of select="bachdelTest/age"/></td>
	    						<td> <xsl:for-each select="dvd">
	       						 <xsl:value-of select="price"/>€,  <xsl:value-of select="art"/>
	    						<br/>
	     		   					</xsl:for-each> </td>	
							</tr>
							</xsl:for-each>	
						</table>
					</xsl:when>	
					
				</xsl:choose>							
			</body>
		</html>
	</xsl:template>
	
	<!-- Gibt alle Filme aus in denen eine bestimmte Person Regie geführt hat anhand ihrer ID-->	
	<xsl:template name = "ergebnisseRegieFilme">
			<xsl:param name="id"/>
			<tr>
			<xsl:for-each select="//moviemanagement/movies/movie">
			<!-- Wenn die ID der ausgewählten Person in irgendeinen Film zufinden ist, soll der Film angezeigt werden -->
				<xsl:if test='(director) = ($id)'>
	            	<td> <xsl:value-of select="title"></xsl:value-of></td>
	            	<td> <xsl:value-of select="year"/> </td>
					<td> <xsl:value-of select="duration"/> Min.</td>
					<td> <xsl:for-each select="genre">
		                    <xsl:call-template name="ergebnisseGenre">
		                        <xsl:with-param name="id" select="."/>
		                    </xsl:call-template>
	    			</xsl:for-each> </td>
	    			<td><xsl:value-of select="bachdelTest/outcome"/></td>
	    			<td><xsl:value-of select="bachdelTest/age"/></td>
	    			<td> <xsl:for-each select="dvd">
	       				<xsl:value-of select="price"/>€,  <xsl:value-of select="art"/>
	    					<br/>
	     		   </xsl:for-each> </td>	
	            	<br/>
		 	   </xsl:if>
		    </xsl:for-each>
		   </tr>
	</xsl:template>
<!-- Gibt alle Filme wieder in denen eine bestimmte Person Schauspieler ist anhand ihrer ID -->	
	<xsl:template name = "ergebnisseFilmeperSchauspieler">
			<xsl:param name="id"/>
			<tr>
			<xsl:for-each select="//moviemanagement/movies/movie">
			<!-- Wenn die ID der ausgewählten Person in irgendeinen Film zufinden ist, soll der Film angezeigt werden -->
			<xsl:if test='(actor) = ($id) or (director) = ($id) '>
	            	<td> <xsl:value-of select="title"></xsl:value-of></td>
	            	<td> <xsl:value-of select="year"/> </td>
					<td> <xsl:value-of select="duration"/> Min.</td>
					<td> <xsl:for-each select="genre">
		                    <xsl:call-template name="ergebnisseGenre">
		                        <xsl:with-param name="id" select="."/>
		                    </xsl:call-template>
	    			</xsl:for-each> </td>
	    			<td><xsl:value-of select="bachdelTest/outcome"/></td>
	    			<td><xsl:value-of select="bachdelTest/age"/></td>
	    			<td> <xsl:for-each select="dvd">
	       				 <xsl:value-of select="price"/>€,  <xsl:value-of select="art"/>
	    					<br/>
	     		   </xsl:for-each> </td>	
	            	<br/>
		 	   </xsl:if>
		    </xsl:for-each>
		   </tr>
	</xsl:template>
	
	<!-- Zeigt alle Filme an, die dem ausgewählten Genre zugeordnet sind. -->
	<xsl:template name = "bekommeFilm">
		<xsl:param name="id"/>
		<!-- Zählen der Filme die das ausgewählte Genre verwenden -->
			Anzahl der Ergebnisse mit dem Genre <xsl:value-of select="$filter1"/>:  <xsl:value-of select="count(//moviemanagement/movies/movie/genre)"/>
			<xsl:for-each select ="//moviemanagement/movies/movie">
			 <tr>
			 		<!-- Wenn der Film das gleiche Genre hat wie das ausgewählte, soll der Film angezeigt werden -->
					 <xsl:if test='(genre)=($id)'>
					<td> <xsl:value-of select="title"></xsl:value-of></td>
	            	<td> <xsl:value-of select="year"/> </td>
					<td> <xsl:value-of select="duration"/> Min.</td>
					<td> <xsl:for-each select="genre">
		                    <xsl:call-template name="ergebnisseGenre">
		                        <xsl:with-param name="id" select="."/>
		                    </xsl:call-template>
	    			</xsl:for-each> </td>
	    			<td><xsl:value-of select="bachdelTest/outcome"/></td>
	    			<td><xsl:value-of select="bachdelTest/age"/></td>
	    			<td> <xsl:for-each select="dvd">
	       				 <xsl:value-of select="price"/>€,  <xsl:value-of select="art"/>
	    					<br/>
	     		   </xsl:for-each> </td>	
	            	<br/>					
	        		 </xsl:if>
	        </tr>
	       </xsl:for-each>
 
	</xsl:template>
	
	<!-- Zeigt die Bezeichnung eines Genres anhand der ID an -->
	<xsl:template name="ergebnisseGenre">
		  <xsl:param name="id"/>
		  <xsl:value-of select="//moviemanagement/genres/genre[@ID=$id]/@description" />
		  <br/>
	</xsl:template>

<!-- Strukturierung der Tabelle -->
	<xsl:template name="tabellenkopf">		
			<tr>
				<th>Titel</th>
				<th>Erscheinungsjahr</th>
				<th>Länge</th>
				<th>Genre</th>
				<th>Bechdel</th>
				<th>FSK</th>
				<th>Format</th>
				
			</tr>
	</xsl:template>

	
</xsl:stylesheet>
